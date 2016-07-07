//
//  AppDelegate.m
//  DrawPicApp
//
//  Created by 野村和也 on 2015/08/14.
//  Copyright (c) 2015年 野村和也. All rights reserved.
//

#import "AppDelegate.h"
#import "NCMB.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // APIキーの設定とSDK初期化
    [NCMB setApplicationKey:@"c34447c13130e1aa4dfced92fa928d834e60692e71a8f187abe01d9a47e2458b" clientKey:@"4026d49984f7cb9de05f2bbaf55a2dbc7494f7346921e455e3d56de1fae704f4"];
        
    NCMBQuery *query = [NCMBQuery queryWithClassName:@"TestClass"];
    [query whereKey:@"message" equalTo:@"test"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error == nil) {
            if ([objects count] > 0) {
                NSLog(@"[FIND] %@", [[objects objectAtIndex:0] objectForKey:@"message"]);
            } else {
                NSError *saveError = nil;
                NCMBObject *obj = [NCMBObject objectWithClassName:@"TestClass"];
                [obj setObject:@"Hello, NCMB!" forKey:@"message"];
                [obj save:&saveError];
                if (saveError == nil) {
                    NSLog(@"[SAVE] Done");
                } else {
                    NSLog(@"[SAVE-ERROR] %@", saveError);
                }
            }
        } else {
            NSLog(@"[ERROR] %@", error);
        }
    }];
    
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

@end
