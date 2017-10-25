//
//  WLBaseViewController.m
//  WULIU_iOS
//
//  Created by Miaomiao Dai on 2017/8/19.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#import "WLBaseViewController.h"

@interface WLBaseViewController ()

@end

@implementation WLBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

//网络验证
- (void)networkAnomalyWithView:(UIView *)view refresh:(RefreshWifi)refresh {
    
    //检测网络
    Reachability *netWorkReachable = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    
    if ([netWorkReachable currentReachabilityStatus] == NotReachable) {
        
        if (self.wifibugView==nil) {
            
            self.wifibugView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ZYWifiBugView class]) owner:nil options:nil].firstObject;
            
            self.wifibugView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        }
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        
        [self.wifibugView addGestureRecognizer:tap];
        
        self.nullOrderView.hidden = YES;
        self.loadingFialdView.hidden = YES;
        self.refreshWifi = refresh;
        
        [view addSubview:self.wifibugView];
        
    }else {
        
        self.wifibugView.hidden = YES;
        
        [self.wifibugView removeFromSuperview];
    }
}
- (void)tap:(UITapGestureRecognizer *)tap {
    
    Reachability *netWorkReachable = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    
    if ([netWorkReachable currentReachabilityStatus] == NotReachable) {
        
        self.wifibugView.hidden = NO;
        //        [self loadingDataWithView:self.view];
        
    }else {
        [self timerAction];
        self.wifibugView.hidden = YES;
        [self.wifibugView removeFromSuperview];
    }
    self.refreshWifi();
}

- (void)nullOrderViewWithView:(UIView *)view withFrame:(CGRect)frame type:(TYPE )type {
    
    self.nullOrderView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ZYNUllOrderView class]) owner:nil options:nil].firstObject;
    
    self.nullOrderView.frame = frame;
    
    [view addSubview:self.nullOrderView];
    
    if (type == ORDER) {
        
        
    }else if (type == SHENHE) {
        
        self.nullOrderView.tishiLabel.text = @"暂无待审核打包站";
        
        
    }else if(type == XIAOXI) {
        
        self.nullOrderView.tishiLabel.text = @"您还没有任何消息";
        
    }else if(type == SHENQING) {
        
        self.nullOrderView.tishiLabel.text = @"您还没有任何物流申请信息";
        
    }else {
        
        self.nullOrderView.tishiLabel.text = @"您还没有发布任何接单路线";
    }
    
}

- (void)hasOrderViewWithView:(UIView *)view{
    
    self.nullOrderView.hidden = YES;
    [self.nullOrderView removeFromSuperview];
    
}

- (void)loadingDataWithView:(UIView *)view {
    
    if (self.loadingdataView == nil) {
        self.loadingdataView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ZYLoadingDataView class]) owner:nil options:nil].firstObject;
        self.loadingdataView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        
    }
    [view addSubview:self.loadingdataView];
    NSTimer *timer = [NSTimer timerWithTimeInterval:3 target:self selector:@selector(timerAction) userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}


- (void)timerAction {
    self.loadingdataView = nil;
    [self.loadingdataView removeFromSuperview];
    
}
- (void)loadSuccessDataWithView:(UIView *)view {
    self.loadingFialdView.hidden = YES;
    self.loadingdataView.hidden = YES;
    [self.loadingdataView removeFromSuperview];
    [self.loadingFialdView removeFromSuperview];
}

- (void)loadingFialdWithView:(UIView *)view refresh:(RefreshLoad)refresh{
    self.refreshLoad = refresh;
    if (self.loadingFialdView == nil) {
        self.loadingFialdView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ZYLoadingDataView class]) owner:nil options:nil].firstObject;
        self.loadingFialdView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(refreshtap:)];
    [self.loadingFialdView addGestureRecognizer:tap];
    [view addSubview:self.loadingFialdView];
}
- (void)refreshtap:(UITapGestureRecognizer *)tap {
    self.refreshLoad();
}

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
