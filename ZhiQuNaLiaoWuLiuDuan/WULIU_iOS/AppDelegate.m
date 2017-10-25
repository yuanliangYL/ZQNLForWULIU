//
//  AppDelegate.m
//  WULIU_iOS
//
//  Created by Miaomiao Dai on 2017/8/19.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#import "AppDelegate.h"
#import "LBTabBarController.h"
#import "WLDengLuViewController.h"
#import "LBNavigationController.h"
#import "WoDeModel.h"
#import "YLSQDetailController.h"
#import "YLDingDanDetailViewController.h"

// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#import <CoreLocation/CoreLocation.h>
#endif

@interface AppDelegate ()<JPUSHRegisterDelegate,CLLocationManagerDelegate>{
    CLLocationManager * locationManager;
}

@end

@implementation AppDelegate

//网络判断
- (void)toDetermineWhetherPhoneNetwork{
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
            case AFNetworkReachabilityStatusUnknown: // 未知网络
                NSLog(@"未知网络");
                break;
            case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
            {
                //没有网络
                UIAlertView * alertV = [[UIAlertView alloc] initWithTitle:@"请打开网络" message:@"手机没有网络,会导致数据无法获取" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
                
                alertV.delegate=self;
                [alertV show];
                
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
                NSLog(@"手机自带网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
                NSLog(@"WIFI");
                break;
        }
    }];
    [mgr startMonitoring];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSLog(@"%ld",(long)buttonIndex);
    
    if(buttonIndex==1){
        NSURL *url = [NSURL URLWithString:@"App-Prefs:root=WIFI"];
        
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
            //iOS10.0以上  使用的操作
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        } else
        {
            //iOS10.0以下  使用的操作
            [[UIApplication sharedApplication] openURL:url];
            
            
        }
    }
}

//初始启动页面
-(void)startPageChoose{
    //本地存储：用户表
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    // 用户id信息处理
    WoDeModel *mineModel = [WoDeModel sharedWoDeModel];
    mineModel.user_id = [user objectForKey:@"uid"];
    mineModel.user_phone = [user objectForKey:@"phone"];
    
    
    if ((mineModel.user_id == NULL) && (mineModel.user_phone == NULL)) {
        
        //跳转登录页面
        self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
        
        LBNavigationController *nav = [[LBNavigationController alloc] initWithRootViewController:[[NSClassFromString(@"WLDengLuViewController") alloc] init]];
        self.window.rootViewController = nav;
        
    }else{
        
        NSString *alias = [NSString stringWithFormat:@"%@",mineModel.user_id];
        [JPUSHService setAlias:alias completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
            NSLog(@"%ld----%@----%ld",iResCode,iAlias,seq);
        } seq:100];
        
        //跳转主页面
        self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
        LBTabBarController * LBTBC = [[LBTabBarController alloc] init];
        self.window.rootViewController = LBTBC;
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self locate];
    [self startPageChoose];
  
    [self toDetermineWhetherPhoneNetwork];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [self.window makeKeyAndVisible];
    
    
    
    /**
     * 推送处理1
     */
    /*****************************************************注册通知******************************************/

    
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    
    entity.types = JPAuthorizationOptionAlert | JPAuthorizationOptionBadge | JPAuthorizationOptionSound;
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    //[JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    //收到消息非APNS
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    //登录成功
    //    [defaultCenter addObserver:self selector:@selector(requestGetSetRegistID) name:kJPFNetworkDidLoginNotification object:nil];
    
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        NSLog(@"resCode : %d,registrationID: %@",resCode,registrationID);
        
    }];
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            NSLog(@"registrationID获取成功：%@",registrationID);
            
        }
        else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [JPUSHService setBadge:0];
    
//    如不需要使用IDFA，advertisingIdentifier 可为nil  0b5b4c6112b92ecf4bf40d0c
//    test:77f17be1560951cfcce62925
    [JPUSHService setupWithOption:launchOptions appKey:@"0b5b4c6112b92ecf4bf40d0c"
                          channel:@"Publish channel"
                 apsForProduction:YES
            advertisingIdentifier:nil];
    
    /************************************************apn 内容获取：******************************************/
    NSDictionary *remoteNotification = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
    
    /*****************************这个判断是在程序没有运行的情况下收到通知，点击通知跳转页面**********************************/
    
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];

    
    return YES;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    //    [APService stopLogPageView:@"aa"];
    // Sent when the application is about to move from active to inactive state.
    // This can occur for certain types of temporary interruptions (such as an
    // incoming phone call or SMS message) or when the user quits the application
    // and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down
    // OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate
    // timers, and store enough application state information to restore your
    // application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called
    // instead of applicationWillTerminate: when the user quits.
    
    //[[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    [JPUSHService setBadge:0];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [JPUSHService setBadge:0];
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the
    // application was inactive. If the application was previously in the
    // background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if
    // appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    [UIColor colorWithRed:0.0 / 255
                    green:122.0 / 255
                     blue:255.0 / 255
                    alpha:1];
    NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:
(UIUserNotificationSettings *)notificationSettings {
}

// Called when your app has been activated by the user selecting an action from
// a local notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forLocalNotification:(UILocalNotification *)notification
  completionHandler:(void (^)())completionHandler {
}

// Called when your app has been activated by the user selecting an action from
// a remote notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forRemoteNotification:(NSDictionary *)userInfo
  completionHandler:(void (^)())completionHandler {
}
#endif

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"iOS6及以下系统，收到通知:%@", [self logDic:userInfo]);
    
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"iOS7及以上系统，收到通知:%@", [self logDic:userInfo]);
    
    if ([[UIDevice currentDevice].systemVersion floatValue]<10.0 || application.applicationState>0) {
        
    }
    
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
}

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- JPUSHRegisterDelegate
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        
        
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        
        NSLog(@"iOS10 收到远程通知:%@", [self logDic:userInfo]);
        
         [self pushToViewControllerWhenClickPushMessageWith:userInfo];
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    
    completionHandler();  // 系统要求执行这个方法
}


#pragma mark -- 极光程序跳转方法
-(void)pushToViewControllerWhenClickPushMessageWith:(NSDictionary*)msgDic{
    //将字段存入本地，因为要在你要跳转的页面用它来判断
    //NSUserDefaults *pushJudge = [NSUserDefaults standardUserDefaults];
    NSLog(@"%@",msgDic);
    
    //[pushJudge setObject:@"push"forKey:@"push"];
    //判断后台传送的标示（用于跳转哪一个页面的判断）

    //物流申请详情
    if ([[msgDic objectForKey:@"url"] isEqualToString:@"/api/driver/driverapplylogistics"]){
        //得到根部控制器
        LBTabBarController *hxl=(LBTabBarController *)self.window.rootViewController;
        //得到控制器中的导航栏
        UINavigationController *nav= hxl.selectedViewController;
        //得到导航栏对应的控制器
        UIViewController  *controller=(UIViewController *)nav.visibleViewController;
        //进行跳转页面
        YLSQDetailController *sqvc = [[YLSQDetailController alloc]init];
        
        //我的申请
        sqvc.pushDic = [NSDictionary dictionaryWithObjectsAndKeys:
                        msgDic[@"pack_id"],@"pack_id",
                        msgDic[@"handle"],@"handle",
                        msgDic[@"slug"],@"slug",
                        msgDic[@"id"], @"id",
                        [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"uid",
                        nil];
        NSLog(@"%@",sqvc.pushDic);
        [controller.navigationController pushViewController:sqvc animated:YES];
    
    }else{
        //其他页面跳转
        
        //得到根部控制器
        LBTabBarController *hxl=(LBTabBarController *)self.window.rootViewController;
        //得到控制器中的导航栏
        UINavigationController *nav= hxl.selectedViewController;
        //得到导航栏对应的控制器
        UIViewController  *controller=(UIViewController *)nav.visibleViewController;
        //进行跳转页面
        YLDingDanDetailViewController *sqvc = [[YLDingDanDetailViewController alloc]init];
        sqvc.type = @"推送";
        sqvc.pack_id = msgDic[@"pack_id"];
        sqvc.plor_id = msgDic[@"plor_id"];
        sqvc.slug = msgDic[@"slug"];
        [controller.navigationController pushViewController:sqvc animated:YES];
 
    }
    
    
}


#endif

// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}
- (void)locate {
    // 判断定位操作是否被允许
    if([CLLocationManager locationServicesEnabled])
    {
        locationManager = [[CLLocationManager alloc]init];
        locationManager.delegate = self;
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        //        locationManager.distanceFilter = 10;
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)
        {
            [locationManager  requestWhenInUseAuthorization];//添加这句
//                        [locationManager requestAlwaysAuthorization];
        }else{
            [locationManager stopUpdatingLocation];
        }

    }
    else
    {
        //提示用户无法进行定位操作
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:
                                  @"提示" message:@"定位不成功 ,请确认已开启定位" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
        
        
    }
    
}

#pragma mark CoreLocation delegate
//定位成功
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    CLLocation *currentLocation = [locations lastObject];
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    
    //反编码
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count > 0) {
            CLPlacemark *placeMark = placemarks[0];
            self.currentCity = placeMark.locality;
            self.currentPrivance =  placeMark.administrativeArea;
            NSLog(@"城市%@",self.currentCity);
            if (!self.currentCity) {
                self.currentCity = @"无法定位当前城市";
                self.currentPrivance = @"无法定位当前城市";
            }
            NSLog(@"%@",self.currentCity);
            NSLog(@"%@",placeMark.name);
            
            
        }
        else if (error == nil && placemarks.count == 0) {
            NSLog(@"No location and error return");
        }
        else if (error) {
            NSLog(@"location error: %@ ",error);
        }
        
    }];
    [locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [locationManager startUpdatingLocation];
    }
}

@end
