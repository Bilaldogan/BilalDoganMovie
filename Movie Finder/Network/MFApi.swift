//
//  MFApi.swift
//  Movie Finder
//
//  Created by Bilal Doğan on 25.05.2019.
//  Copyright © 2019 Bilal Doğan. All rights reserved.
//

import Foundation
import Alamofire

enum MFEndPoint: String {
    //Mark: -EnpPointStrings
    case searchWithKey = "GET /?s=<search_key>&apikey=<api_key>"
    
}

public class MFApi {
    //Mark: Acess Id's
    private var clientId = "IUAZEDZPHEHFDXSDTCU3UZY2J4P1LNYLPSE0TTWUJQ3FEZS4"
    private var clientSecret = "EXXIMBWG1AAVIT13SICEY05IM101M2GE5BSJGEXRCKGC3UUZ"
    
    
    //Mark - Foursquare api tokens
    
    public static let sharedInstance : MFApi = MFApi()
    private var sessionManager  = SessionManager()
    private var currentAccessToken      : String?
    
    private let baseUrl = "http://www.omdbapi.com"
    private let oMDBApiKey = "dcc4e71a"
    
    private func call<T:Decodable>(endPoint: MFEndPoint,
                         parameters: [String : Any],
                         encoding: ParameterEncoding = URLEncoding.default,
                         completionHandler: @escaping (Swift.Result<T, NetworkError>) -> Void){

        var params = parameters
        params["api_key"] = oMDBApiKey
        
        let endPoint = Endpoint.buildURL(baseURL: baseUrl,endPoint: endPoint.rawValue, values: params as [String : AnyObject])
        //print(endPoint)
        
        sessionManager.request(endPoint.URL.absoluteString!,
                               method: endPoint.method,
                               parameters: endPoint.otherValues,
                               encoding:encoding)
            .validate()
            .responseString { (response) in
                let result = response.result
                switch result {
                case .success(let value):
                    guard let data = value.data(using: .utf8) else {
                        return
                    }
                    do {
                        let decoder = JSONDecoder()
                        let decodedData = try decoder.decode(T.self, from: data)
                        completionHandler(.success(decodedData))
                    } catch let jsonErr {
                        completionHandler(.failure(.invalidResponse))
                        print("Failed to serialize json:", jsonErr)
                    }
                    
                case .failure(let err):
                    if let networkError = err as? NetworkError {
                        completionHandler(.failure(networkError))
                    } else {
                        completionHandler(.failure(.unknown))
                    }
 
                }
        }
    }

    func getMoviesWith(searchKey: String,
                              completionHandler: @escaping (Swift.Result<SearchResponseModel, NetworkError>) -> Void) {
        call(endPoint: .searchWithKey,
             parameters: ["search_key" : searchKey],
             completionHandler: completionHandler)
        
    }
    // MARK: -Request Methods
//    public func getVenuesNearBy(city:String,date:String,keyword:String,
//                                success: @escaping SuccessHandler<VenuesDataModel>,
//                                error: @escaping (ErrorHandler)){
//
//        call(endPoint: PlacesEndPoint.SearchVenuesWithNearBy,
//             parameters: ["location_name":city, "formatted_date":date, "query_string": keyword,
//                          "client_id": self.clientId,"client_secret": self.clientSecret],
//             encoding: JSONEncoding.default,
//             success: success,
//             error: error)
//    }
//
//    public func getVenuesWith(lat:String,lng: String,date:String,keyword:String,
//                              success: @escaping SuccessHandler<VenuesDataModel>,
//                              error: @escaping (ErrorHandler)){
//
//        call(endPoint: PlacesEndPoint.SearchVenuesWithCurrentLocation,
//             parameters: ["lat":lat,"lng":lng, "formatted_date":date, "query_string": keyword,
//                          "client_id": self.clientId,"client_secret": self.clientSecret],
//             encoding: JSONEncoding.default,
//             success: success,
//             error: error)
//    }
//
//    public func getVenuesDetail(venueId:String,date: String,
//                                success: @escaping SuccessHandler<VenueDetailDataModel>,
//                                error: @escaping (ErrorHandler)){
//
//        call(endPoint: PlacesEndPoint.GetDetailOfVenue,
//             parameters: ["venue_id":venueId, "formatted_date":date,
//                          "client_id": self.clientId,"client_secret": self.clientSecret],
//             encoding: JSONEncoding.default,
//             success: success,
//             error: error)
//    }
    
}
