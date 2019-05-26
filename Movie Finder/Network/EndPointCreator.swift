//
//  EndPointCreator.swift
//  Movie Finder
//
//  Created by Bilal Doğan on 25.05.2019.
//  Copyright © 2019 Bilal Doğan. All rights reserved.
//

import Foundation
import Alamofire

public class Endpoint {
    
    public static func buildURL(baseURL: String, endPoint: String, values: [String: AnyObject]? = nil) -> (method: HTTPMethod,
        URL: NSURL,
        otherValues: [String: AnyObject]?) {
            let method: HTTPMethod
            var path: String
            // e.g. "GET /me" -> ["GET", "/me"]
            let whitespace = NSCharacterSet.whitespaces
            let components = endPoint.components(separatedBy: whitespace).filter { !$0.isEmpty }
            if components.count > 1 {
                method = HTTPMethod(rawValue: components[0]) ?? .get
                path = components[1]
            } else {
                method = .get
                path = components[0]
            }
            
            var placeholders = [String]()
            
            // replace `<key>` with `value`
            for (key, value) in values ?? [:] {
                let pattern = "<" + key + ">" // 3x faster than "<\(key)>"
                let replacement = value as? String ?? String(describing: value)
                
                if path.contains(pattern) {
                    path = path.replacingOccurrences(of: pattern, with: replacement)
                    placeholders.append(key)
                }
            }
            
            var otherValues = values
            for key in placeholders {
                otherValues?.removeValue(forKey: key) // remove URL placeholder values
            }
            
            let myurl = baseURL + path
            guard NSURL(string: myurl) != nil  else{
                let encoded = myurl.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
                let url = NSURL(string: encoded!)
                
                return (method, url!, otherValues)
            }
            return (method, NSURL(string: baseURL + path)!, otherValues)
    }
    
}
