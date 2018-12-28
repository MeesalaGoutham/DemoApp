//
//  MyAppDelegate.m
//  SFMobilePushDemo
//  Created by Meesala, Goutham on 09/6/18.
//

#import "SFMobilePushDemo.h"
#import <IBMMobileFirstPlatformFoundationHybrid/IBMMobileFirstPlatformFoundationHybrid.h>
#import "Cordova/CDVViewController.h"
#import <MarketingCloudSDK/MarketingCloudSDK.h>

@implementation MyAppDelegate
    
static NSString * const CURRENT_CORDOVA_VERSION_NAME = @"MC_Cordova_v1.1.0";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
{
    
    NSLog(@"When we click on notifcation%@",launchOptions);
	BOOL result = [super application:application didFinishLaunchingWithOptions:launchOptions];
    
    // A root view controller must be created in application:didFinishLaunchingWithOptions:  
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UIViewController* rootViewController = [[UIViewController alloc] init];     
    
    [self.window setRootViewController:rootViewController];
    [self.window makeKeyAndVisible];
   
    [[WL sharedInstance] showSplashScreen];
    // By default splash screen will be automatically hidden once Worklight JavaScript framework is complete. 
	// To override this behaviour set autoHideSplash property in initOptions.js to false and use WL.App.hideSplashScreen() API.

    [[WL sharedInstance] initializeWebFrameworkWithDelegate:self];
    
    [self initMarketingCloudSDK];

    return result;
}

// This method is called after the WL web framework initialization is complete and web resources are ready to be used.
-(void)wlInitWebFrameworkDidCompleteWithResult:(WLWebFrameworkInitResult *)result
{
    if ([result statusCode] == WLWebFrameworkInitResultSuccess) {
        [self wlInitDidCompleteSuccessfully];
    } else {
        [self wlInitDidFailWithResult:result];
    }
}

-(void)wlInitDidCompleteSuccessfully
{
    UIViewController* rootViewController = self.window.rootViewController;

    // Create a Cordova View Controller
    CDVViewController* cordovaViewController = [[CDVViewController alloc] init] ;

    cordovaViewController.startPage = [[WL sharedInstance] mainHtmlFilePath];
     
    // Adjust the Cordova view controller view frame to match its parent view bounds
    cordovaViewController.view.frame = rootViewController.view.bounds;

	// Display the Cordova view
    [rootViewController addChildViewController:cordovaViewController];  
    [rootViewController.view addSubview:cordovaViewController.view];
    [cordovaViewController didMoveToParentViewController:rootViewController];  
}

-(void)wlInitDidFailWithResult:(WLWebFrameworkInitResult *)result
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"ERROR"
                                                  message:[result message]
                                                  delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
    [alertView show];
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
    
-(void) initMarketingCloudSDK {
    NSError *error = nil;
    BOOL success = [[MarketingCloudSDK sharedInstance] sfmc_configure:&error];
    
    if (success == YES) {
        [[MarketingCloudSDK sharedInstance] sfmc_setDebugLoggingEnabled:YES];
        
       /* dispatch_async(dispatch_get_main_queue(), ^{
            if (@available(iOS 10, *)) {
                [UNUserNotificationCenter currentNotificationCenter].delegate = self;
                
                [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:
                 UNAuthorizationOptionAlert |
                 UNAuthorizationOptionSound |
                 UNAuthorizationOptionBadge
                                                                                    completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                                                                        if (error == nil && granted == YES) {
                                                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                                                [[UIApplication sharedApplication] registerForRemoteNotifications];
                                                                                            });
                                                                                        }
                                                                                    }];
            
            } else {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 100000
                UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:
                                                        UIUserNotificationTypeBadge |
                                                        UIUserNotificationTypeBadge |
                                                        UIUserNotificationTypeSound |
                                                        UIUserNotificationTypeAlert
                                                                                         categories:nil];
                [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
#endif
                [[UIApplication sharedApplication] registerForRemoteNotifications];
                
                [self setDefaultTag];
            }
        });*/
    } else {
        os_log_debug(OS_LOG_DEFAULT, "MarketingCloudSDK sfmc_configure failed with error = %@", error);
    }
}
    
-(void) setDefaultTag {
    NSSet *tagSet = [[MarketingCloudSDK sharedInstance] sfmc_tags];
    
    for (NSString* tag in tagSet) {
        NSRange range = [tag rangeOfString:@"MC_Cordova_v"];
        
        if (range.location != NSNotFound && range.location == 0) {
            [[MarketingCloudSDK sharedInstance] sfmc_removeTag:tag];
        }
    }
    
    [[MarketingCloudSDK sharedInstance] sfmc_addTag:CURRENT_CORDOVA_VERSION_NAME];
}
    
/*-(void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"Push notification information:%@",userInfo);
    if (@available(iOS 10, *)) {
        UNMutableNotificationContent *silentPushContent = [[UNMutableNotificationContent alloc] init];
        silentPushContent.userInfo = userInfo;
        UNNotificationRequest *silentPushRequest = [UNNotificationRequest requestWithIdentifier:[NSUUID UUID].UUIDString content:silentPushContent trigger:nil];
        
        [[MarketingCloudSDK sharedInstance] sfmc_setNotificationRequest:silentPushRequest];
    } else {
        [[MarketingCloudSDK sharedInstance] sfmc_setNotificationUserInfo:userInfo];
    }
    
    completionHandler(UIBackgroundFetchResultNewData);
}}*/
    
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Send Device Token to Salesforce
    [[MarketingCloudSDK sharedInstance] sfmc_setDeviceToken:deviceToken];
    
    // Send Device TOken to MobileFirst
    [[ NSNotificationCenter defaultCenter ] postNotificationName :WLapplicationDidRegisterForRemoteNotificationsWithDeviceToken object:deviceToken];
}

-(void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"Push notification information:%@",userInfo);
    
    //
    
    BOOL isMarketingCloudNotification = [self checkIsMarketingCloudNotification:userInfo];
    if (isMarketingCloudNotification) {
        //[[WL sharedInstance] subscribe:@"props" :userInfo :self];
        // Salesforce Marketing Cloud Notification Processing
        if (@available(iOS 10, *)) { //Checking iS iOS 10 or not
            
            UNMutableNotificationContent *silentPushContent = [[UNMutableNotificationContent alloc] init];
            silentPushContent.userInfo = userInfo;
            UNNotificationRequest *silentPushRequest = [UNNotificationRequest requestWithIdentifier:[NSUUID UUID].UUIDString content:silentPushContent trigger:nil];
            
            if (isMarketingCloudNotification){
                [[MarketingCloudSDK sharedInstance] sfmc_setNotificationRequest:silentPushRequest];
            }
            
        } else {
            //[[WL sharedInstance] subscribe:@"props" :userInfo :self];
            
            if (isMarketingCloudNotification){
                [[MarketingCloudSDK sharedInstance] sfmc_setNotificationUserInfo:userInfo];
            }
        }
    } else {
        // MobileFirst Notification Processing
        [[ NSNotificationCenter defaultCenter ] postNotificationName :WLapplicationDidReceiveRemoteNotification object:userInfo];
    }
    
    completionHandler(UIBackgroundFetchResultNewData);
}
    
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    os_log_debug(OS_LOG_DEFAULT, "didFailToRegisterForRemoteNotificationsWithError = %@", error);
}
    
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler {
    
    NSLog(@"Called didReceiveNotificationResponse: %@", response);
    
    // tell the MarketingCloudSDK about the notification
    [[MarketingCloudSDK sharedInstance] sfmc_setNotificationRequest:response.notification.request];
    
    if (completionHandler != nil) {
        completionHandler();
    }
}

/*- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler {
    
    NSLog(@"Called didReceiveNotificationResponse: %@", response);
    
    [[WL sharedInstance] subscribe:@"props" :response :self];
    // tell the MarketingCloudSDK about the notification
    [[MarketingCloudSDK sharedInstance] sfmc_setNotificationRequest:response.notification.request];
    
    if (completionHandler != nil) {
        completionHandler();
    }
}*/

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
    
    NSLog(@"Called willPresentNotification: %@", notification);
    
    // tell the MarketingCloudSDK about the notification
    [[MarketingCloudSDK sharedInstance] sfmc_setNotificationRequest:notification.request];
    
    if (completionHandler != nil) {
        completionHandler(UNNotificationPresentationOptionAlert);
    }
}
    
#pragma mark - Custom message handlers
    
- (void)notificationReceivedWithUserInfo:(NSDictionary *)userInfo messageType:(NSString *)messageType alertText:(NSString *)alertText
    {
        NSLog(@"### USERINFO: %@", userInfo);
        NSLog(@"### alertText: %@", alertText);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kCDVPushReceivedNotification"
                                                            object:self
                                                          userInfo:nil];
    }
#pragma mark - Helper Methods
/**
 * Here checking the notification payload contains special tags like _r, _m, _x etc,
 * Based on the tags we can conclude like it is a SalesForceCloudNotification or not.
 */
- (BOOL)checkIsMarketingCloudNotification:(NSDictionary *)dictionary {
    
    BOOL flag = NO;
    
    if (dictionary){
        NSArray *allKeys = dictionary.allKeys;
        for (int i = 0; i < allKeys.count; i++) {
            id obj = allKeys[i];
            if ([obj isKindOfClass:[NSString class]]){
                NSString *key = (NSString *)obj;
                if ([key isEqualToString:@"_h"] || [key isEqualToString:@"_m"]||[key isEqualToString:@"_mt"]
                    ||[key isEqualToString:@"_r"]||[key isEqualToString:@"_sid"]||[key isEqualToString:@"_x"]){
                    flag = YES;
                    break;
                }
            }
        }
    }
    
    return flag;
}
@end
