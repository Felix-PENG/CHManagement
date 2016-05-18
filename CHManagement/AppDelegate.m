//
//  AppDelegate.m
//  CHManagement
//
//  Created by Peng, Troy on 4/26/16.
//  Copyright © 2016 楚淮集团. All rights reserved.
//

#import "AppDelegate.h"
#import "NetworkManager.h"
#import "ResultVO.h"
#import "SignInResultVO.h"
#import "NetworkManager.h"
#import "UserInfo.h"
#import "PushNotification.h"

@interface AppDelegate ()
@property (nonatomic, assign) NSInteger notificationType;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
#ifdef __IPHONE_8_0
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    } else {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
#else
    UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
#endif
    
    NSDictionary *notificationInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (notificationInfo) {
        self.notificationType = [[PushNotification alloc] initWithDictionary:notificationInfo error:nil].code;
    }
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *tokenStr = [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<" withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"Device token: %@", tokenStr);
    // 已登录且token不同或没有时，设置token
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:DEVICE_TOKEN_KEY] isEqualToString:tokenStr] && [UserInfo sharedInstance]) {
        [[NetworkManager sharedInstance] setDeviceToken:[UserInfo sharedInstance].id token:tokenStr completionHandler:^(NSDictionary *response) {
            NSLog(@"%@", response);
        }];
    }
    [[NSUserDefaults standardUserDefaults] setObject:tokenStr forKey:DEVICE_TOKEN_KEY];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"Receive notification: %@", userInfo);
    PushNotification *notification = [[PushNotification alloc] initWithDictionary:userInfo error:nil];
    
    if (application.applicationState == UIApplicationStateActive) { // 应用在前台时收到通知
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"通知" message:notification.aps.alert delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
        [alertView show];
    } else { // 应用在后台收到通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PushNotification" object:self userInfo:@{NOTIFICATION_TYPE : @(notification.code)}];
    }
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Register fail: %@", error);
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
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0; // 清空消息数
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
