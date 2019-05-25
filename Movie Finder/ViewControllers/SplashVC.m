//
//  SplashVC.m
//  Movie Finder
//
//  Created by Bilal Doğan on 25.05.2019.
//  Copyright © 2019 Bilal Doğan. All rights reserved.
//

#import "SplashVC.h"
#import "Movie_Finder-Swift.h"

@import Firebase;

@interface SplashVC ()
@property (weak, nonatomic) IBOutlet UILabel *appTitleLabel;

@property (weak, nonatomic) FIRRemoteConfig *remoteConfig;
@end

@implementation SplashVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchRemoteConfigData];
}

- (void)fetchRemoteConfigData {
    self.remoteConfig = [FIRRemoteConfig remoteConfig];
    [self.remoteConfig fetchWithExpirationDuration:5.0 completionHandler:^(FIRRemoteConfigFetchStatus status, NSError * _Nullable error) {
        if (status == FIRRemoteConfigFetchStatusSuccess) {
            [self.remoteConfig activateFetched];
            [self updateTitleWithFadeAnimation];
            [self waitTreeSecond];
        }
    }];
}

- (void)updateTitleWithFadeAnimation {
    NSString *title = [self.remoteConfig configValueForKey:@"app_title"].stringValue;
    self.appTitleLabel.text = title;
    
    self.appTitleLabel.alpha = 0;
    [UIView animateWithDuration:0.6 animations:^{
        self.appTitleLabel.alpha = 1.0;
    }];
}

- (void)waitTreeSecond {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.coordinator splashEnded];
    });
}

@end
