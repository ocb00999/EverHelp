//
//  AppDelegate.m
//  EverHelp
//
//  Created by Chubin OU on 3/27/15.
//  Copyright (c) 2015 Chubin OU. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "Common.h"
#import "CongratViewController.h"
#import "MapViewController.h"
#import "CurrentTaskViewController.h"
#import "CongratViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [Parse enableLocalDatastore];
    
    // Initialize Parse.
    [Parse setApplicationId:@"tOQcWFtNOQpSExXFPOAyRfdWw6HUw5tC4gxSiCib"
                  clientKey:@"LuF39tIzvqAcKTefakqDd7xPSr6r2YqPs86rzQPJ"];
    
    // [Optional] Track statistics around application opens.
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                    UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                             categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
    //[application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound];
    glb_user = [[User alloc]init];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    currentInstallation.channels = @[ @"global" ];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
    if([userInfo[@"aps"][@"content-available"] intValue]== 1) //it's the silent notification
    {
        //Task posted, should update map
        /*
        id currentViewController = ((UINavigationController *)self.window.rootViewController).visibleViewController;
        if ([currentViewController isKindOfClass:[MapViewController class]]){
            [currentViewController updateNearbyNote];
        }*/
    } else if ([userInfo[@"aps"][@"content-available"] intValue]== 2){
        //Task accepted, should push to currentTaskView
        /*
        id currentViewController = ((UINavigationController *)self.window.rootViewController).visibleViewController;
        if ([currentViewController isKindOfClass:[MapViewController class]]){
            [currentViewController presentProfileView];
        }*/
        
    } else if ([userInfo[@"aps"][@"content-available"] intValue]== 3){
        //Task completed, should push to congratView
        /*
        id currentViewController = ((UINavigationController *)self.window.rootViewController).visibleViewController;
        CongratViewController *congratView = [[CongratViewController alloc]init];
        [currentViewController pushViewController:congratView animated:YES];*/
    }
}

@end
