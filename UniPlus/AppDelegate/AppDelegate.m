//
//  AppDelegate.m
//  UniPlus
//
//  Created by Jiahe Li on 06/09/2016.
//  Copyright © 2016 Quicky Studio. All rights reserved.
//

#import "AppDelegate.h"
#import "MainScreen.h"
#import "ReviewProfileTableViewController.h"
#import "UPLeftMenuTableViewController.h"
#import "MainPageViewController.h"
#import "SWRevealViewController.h"
#import <Parse/Parse.h>
#import "APIKey.h"

#include "TargetConditionals.h"

#import <ifaddrs.h>
#import <arpa/inet.h>
#import <GKFadeNavigationController/GKFadeNavigationController.h>

#define COLOR_SCHEME [UIColor colorWithRed:53/255.0 green:111/255.0 blue:177/255.0 alpha:1.0]

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //set the topicFilter if user is launching the app for the very first time
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"topicFilter" : @"Computer Science", @"majorArray" : @[@"Computer Science"]}];
    NSMutableArray *topicArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"majorArray"];
    
    [Parse initializeWithConfiguration:[ParseClientConfiguration
        configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {
            configuration.applicationId = PRODUCTION_APP_ID;
            configuration.clientKey     = PRODUCTION_CLIENT_KEY;
            configuration.server        = PRODUCTION_SERVER_URL;
    }]];
        
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                    UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
    
//    ReviewProfileTableViewController *RPVC = [[ReviewProfileTableViewController alloc]initWithNibName:@"ReviewProfileTableViewController" bundle:nil];
//    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:RPVC];
//    RPVC.isFromSignUp = NO;

    //MainScreen *MS = [[MainScreen alloc]initWithNibName:@"MainScreen" bundle:nil];
    
    //retrieve the majorArray from NSUserDefaults
    MainPageViewController *MPVC = [[MainPageViewController alloc]initWithTopic:[topicArray objectAtIndex:0] ParseClass:@"Questions"];
    GKFadeNavigationController *nav2 = [[GKFadeNavigationController alloc]initWithRootViewController:MPVC];
    //UINavigationController *nav3 = [[UINavigationController alloc]initWithRootViewController:MPVC];
    
    UPLeftMenuTableViewController *leftMenuVC = [[UPLeftMenuTableViewController alloc]init];
    leftMenuVC.menuMajorArray = topicArray;
    SWRevealViewController *revealController = [[SWRevealViewController alloc]initWithRearViewController:leftMenuVC frontViewController:nav2];
    revealController.frontViewShadowColor = [UIColor colorWithWhite:0.4 alpha:1].CGColor;
    revealController.frontViewShadowOpacity = 0.3;
    revealController.frontViewShadowOffset = CGSizeMake(0.0, 0.0);
    revealController.frontViewShadowRadius = 2.0;
    revealController.delegate = self;
    
    self.window.rootViewController = revealController;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
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

// Get IP Address
- (NSString *)getIPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}

- (NSString *)getLocalHostAddressFromMobileIP:(NSString *)ip {
    NSString *networkID = [ip substringToIndex:ip.length - 2];
    int hostID = [ip substringFromIndex:ip.length - 2].intValue - 1;
    
    return [NSString stringWithFormat:@"http://%@%d:%@/parse",networkID,hostID,LOCAL_SERVER_PORT];
}

@end
