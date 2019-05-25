//
//  AppDelegate.m
//  Movie Finder
//
//  Created by Bilal Doğan on 25.05.2019.
//  Copyright © 2019 Bilal Doğan. All rights reserved.
//

#import "AppDelegate.h"
#import "Movie_Finder-Swift.h"

@import Firebase;
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self confiureFirebase];
    [self startApp];
    return YES;
}

- (void)startApp {
    UINavigationController *nav = [[UINavigationController alloc] init];
    AppCoordinator *coordinator = [[AppCoordinator alloc ] initWithNavigationController:nav];
    self.appCoordinator = coordinator;
    [coordinator start];
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
}


- (void)confiureFirebase {
    [FIRApp configure];
    FIRRemoteConfig *remoteConfig = [FIRRemoteConfig remoteConfig];
    [remoteConfig setDefaultsFromPlistFileName:@"RemoteConfigDefaults"];
    FIRRemoteConfigSettings *debugSettings = [[FIRRemoteConfigSettings alloc] initWithDeveloperModeEnabled:true];
    remoteConfig.configSettings = debugSettings;
}

@end
