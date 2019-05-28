//
//  AppDelegate.m
//  Movie Finder
//
//  Created by Bilal Doğan on 25.05.2019.
//  Copyright © 2019 Bilal Doğan. All rights reserved.
//

#import "AppDelegate.h"
#import "Movie_Finder-Swift.h"

@interface AppDelegate ()

#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self confiureFirebase];
    [self startApp];
    
    NSDictionary *notification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (notification) {
        NSLog(@"app recieved notification from remote%@",notification);
        [self application:application didReceiveRemoteNotification:notification];
    }
    
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
    [FIRMessaging messaging].delegate = self;
    [FIRMessaging messaging].autoInitEnabled = NO;


}

#pragma mark - UNUserNotificationCenter Delegate // >= iOS 10

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    
    NSLog(@"User Info = %@",notification.request.content.userInfo);
    
    completionHandler(UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler{
    
    NSLog(@"User Info = %@",response.notification.request.content.userInfo);
    completionHandler();
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    [FIRMessaging messaging].APNSToken = deviceToken;
    
}

#pragma mark - Class Methods

- (void)registerForRemoteNotification {
    if(SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"10.0")) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
            if( !error ){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[UIApplication sharedApplication] registerForRemoteNotifications];
                });
            }
        }];
    }
    else {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
}

- (void)messaging:(FIRMessaging *)messaging didReceiveRegistrationToken:(NSString *)fcmToken {
    NSLog(@"FCM registration token: %@", fcmToken);
    // Notify about received token.
    NSDictionary *dataDict = [NSDictionary dictionaryWithObject:fcmToken forKey:@"token"];
    [[NSNotificationCenter defaultCenter] postNotificationName:
     @"FCMToken" object:nil userInfo:dataDict];
    // TODO: If necessary send token to application server.
    // Note: This callback is fired at each app startup and whenever a new token is generated.
}


@end

