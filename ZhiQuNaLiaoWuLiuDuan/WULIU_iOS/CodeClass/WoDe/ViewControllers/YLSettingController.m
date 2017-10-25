
//
//  YLSettingController.m
//  ZQNLForPackagingStation
//
//  Created by 袁亮 on 2017/8/7.
//  Copyright © 2017年 Albert Yuan. All rights reserved.
//
// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#import <CoreLocation/CoreLocation.h>
#endif

#import "YLSettingController.h"
#import "LBNavigationController.h"
#import "YLBindPhoneController.h"
#import "YLAboutUsController.h"
#import "AppDelegate.h"
#import "WLDengLuViewController.h"
#import "YLChangeLoginpassController.h"
#import "YLSettingPayPassController.h"
#import "YLChangePayPassController.h"

@interface YLSettingController ()
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

//是否为第一次设置支付密码
@property (weak, nonatomic) IBOutlet UILabel *zhifuLabel;

@property (weak, nonatomic) IBOutlet UILabel *CacheMBLabel;

@end

@implementation YLSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
    self.zhifuLabel.text = @"设置支付密码";
    
    NSString *cache = [NSString stringWithFormat:@"%.2fMB",[self getSDWebImageCache] / 1024 / 1024];
    self.CacheMBLabel.text = cache;
}

-(void)viewWillAppear:(BOOL)animated{
    
     self.phoneLabel.text = [WoDeModel sharedWoDeModel].user_phone;
}

- (IBAction)bindPhoneAction:(UITapGestureRecognizer *)sender {
    
    YLBindPhoneController *bpvc = [[YLBindPhoneController alloc]init];
    
    [self.navigationController pushViewController:bpvc animated:YES];
}

- (IBAction)aboutUsAction:(id)sender {
    
    YLAboutUsController *auvc = [[YLAboutUsController alloc]init];
    
    [self.navigationController pushViewController:auvc animated:YES];
}

- (IBAction)changLoginPassword:(id)sender {
    
    YLChangeLoginpassController *cvc = [YLChangeLoginpassController new];
    
    [self.navigationController pushViewController:cvc animated:YES];
}

- (IBAction)settingPayPass:(id)sender {
    
    YLSettingPayPassController *pvc = [YLSettingPayPassController new];
    pvc.settingvc = self;
    [self.navigationController pushViewController:pvc animated:YES];
    
}

- (IBAction)clearAction:(UITapGestureRecognizer *)sender {
    
#warning 清除缓存
    //    self.refreshCacheSize();
    NSString *cache = [NSString stringWithFormat:@"%.2fMB",[self getSDWebImageCache] / 1024 / 1024];
    self.CacheMBLabel.text = cache;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:cache message:@"是否清除" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *actionN = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    UIAlertAction *actionY = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [self clearSDWebImageCache];
        //        self.refreshCacheSize();
        [alert dismissViewControllerAnimated:YES completion:nil];
        //            NSLog(@"清除缓存成功");
        self.CacheMBLabel.text = @"0.0M";
        [self showlabel:@"清除缓存成功"];
        
    }];
    
    [alert addAction:actionN];
    [alert addAction:actionY];
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void) showlabel:(NSString *)string {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH,SCREEN_HEIGHT / 5 , SCREEN_WIDTH * 0.8, 50)];
    label.backgroundColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:20];
    label.layer.masksToBounds = YES;
    label.layer.cornerRadius = 20;
    label.textAlignment = NSTextAlignmentCenter;
    label.center = CGPointMake(SCREEN_WIDTH/ 2.0f, SCREEN_HEIGHT/ 5.0f);
    label.text = string;
    label.alpha = 0;
    [self.view addSubview:label];
    [UIView animateWithDuration:1.0 animations:^{
        label.alpha = 1.0f;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.0 animations:^{
            label.alpha = 0.0f;
        } completion:^(BOOL finished) {
            
            [label removeFromSuperview];
        }];
    }];
}


//退出登录
- (IBAction)logout:(UIButton *)sender {
    
    //本地存储：用户表
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user removeObjectForKey:@"uid"];
    [user removeObjectForKey:@"phone"];
    
    
    //极光退出，不要忘了在登出之后将别名置空
    [JPUSHService setAlias:@"" completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        NSLog(@"%ld----%@----%ld",iResCode,iAlias,seq);
    } seq:100];
    
    [UIApplication sharedApplication].delegate.window.rootViewController = [[LBNavigationController alloc]initWithRootViewController:[NSClassFromString(@"WLDengLuViewController") new]];
    
    [self.view removeFromSuperview];
}


//清除网络图片
- (BOOL)clearSDWebImageCache {
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
    [[SDImageCache sharedImageCache] clearMemory];
    return YES;
}

//得到网络图片的缓存数量，单位是MB
- (CGFloat)getSDWebImageCache {
    return [[SDImageCache sharedImageCache] getSize];
}


//- (IBAction)changePayPass:(UITapGestureRecognizer *)sender {
//
//    YLChangePayPassController *vc = [YLChangePayPassController new];
//    [self.navigationController pushViewController:vc animated:YES];
//}

@end
