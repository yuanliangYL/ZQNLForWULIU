//
//  WLDengLuViewController.m
//  WULIU_iOS
//
//  Created by Miaomiao Dai on 2017/8/19.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//
// 引入JPush功能所需头文件
#import "JPUSHService.h"

#import "WLDengLuViewController.h"
#import "AppDelegate.h"
#import "YLFastLoginView.h"
#import "YLCountLoginView.h"
#import "LBTabBarController.h"
#import "YLForgetPasswordController.h"
#import "WoDeModel.h"
@interface WLDengLuViewController (){
    //当前选择的登陆按钮类型
    UIButton *currentClickBtn;
    //当前登录页面
    UIView *currentLoginView;
    NSNumber *code_id;
}

@property (weak, nonatomic) IBOutlet UIButton *fastLoginBtn;
@property (weak, nonatomic) IBOutlet UIButton *countLogin;
@property (weak, nonatomic) IBOutlet UIView *loginStatusSlideView;
@property(nonatomic,strong)YLFastLoginView *fastView;
@property(nonatomic,strong)YLCountLoginView *countView;

//登录视图容器
@property (weak, nonatomic) IBOutlet UIView *loginTypeView;

@end

@implementation WLDengLuViewController

/**
 隐藏导航，无黑色bug
 
 @param animated 动画效果
 */
- (void)viewWillAppear:(BOOL)animated {
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];


     [self initnialViewStatus];
}


/**
 登陆视图判断初始化
 */
-(void)initnialViewStatus{
    
    currentClickBtn = self.fastLoginBtn;
    
    [self renderLoginView];
}

#pragma mark - lazyload

/**
 快捷登录
 @return YLFastLoginView
 */
-(YLFastLoginView *)fastView{
    if (!_fastView) {
        
        _fastView = [[NSBundle mainBundle] loadNibNamed:@"YLFastLoginView" owner:nil options:nil].lastObject;
        
        //倒计时
        [[[_fastView.countdownBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:self.view.rac_willDeallocSignal]subscribeNext:^(UIButton *x) {
            [SD_NetAPIClient_CONFIG requestJsonDataWithPath:KGetcode withParams:@{@"nc_phone":self.fastView.phoneTF.text} withMethodType:Post andBlock:^(id data, NSError *error, NSString *errorMsg) {
                NSLog(@"data%@%@",data,error);
                NSDictionary *dic = data[@"data"];
                code_id = [dic objectForKey:@"code_id"];
            } isWithSign:YES];
            [self openCountdown:_fastView.countdownBtn];
            
        }];
        
        //reactiveCocoa按钮事件
        [[[_fastView.loginConfirm rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:self.view.rac_willDeallocSignal]subscribeNext:^(UIButton *x) {
            
            [self loginSuccessedPhone:_fastView.phoneTF.text code:_fastView.codeTF.text codeID:@"1" passWord:nil type:2];
            
        }];
        
        //注册用户
        [[[_fastView.registerNew rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:self.view.rac_willDeallocSignal]subscribeNext:^(UIButton *x) {
            
            YLForgetPasswordController *fpvc = [[YLForgetPasswordController alloc]init];
            
            fpvc.pageTyep = @"Ô";
            
            [self.navigationController pushViewController:fpvc animated:YES];
    
        }];
        
    }
    return _fastView;
}

/**
 账号登录
 
 @return YLCountLoginView
 */
-(YLCountLoginView *)countView{
    if (!_countView) {
        
        _countView = [[NSBundle mainBundle] loadNibNamed:@"YLCountLoginView" owner:nil options:nil].lastObject;
        //确认登陆
        [[[_countView.countLoginConfirm rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:self.view.rac_willDeallocSignal]subscribeNext:^(UIButton *x) {
            
            [self loginSuccessedPhone:_countView.phoneTF.text code:nil codeID:@"1" passWord:_countView.passTF.text type:1];
           
        }];
        //忘记密码
        [[[_countView.forgetpasswordBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:self.view.rac_willDeallocSignal]subscribeNext:^(UIButton *x) {
            YLForgetPasswordController *fpvc = [[YLForgetPasswordController alloc]init];
            fpvc.pageTyep = @"忘记密码";
            
            [self.navigationController pushViewController:fpvc animated:YES];
        
        }];
        
        //注册用户
        [[[_countView.registerNew rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:self.view.rac_willDeallocSignal]subscribeNext:^(UIButton *x) {
         
            YLForgetPasswordController *fpvc = [[YLForgetPasswordController alloc]init];
            
            fpvc.pageTyep = @"注册";
            
            [self.navigationController pushViewController:fpvc animated:YES];
            
        }];
        
    }
    return _countView;
}

/**
 根据判断渲染不同的登录页面
 
 @return UIView
 */
-(UIView *)renderLoginView{
    
    if (currentClickBtn.tag == 0) {
        
        currentLoginView = self.fastView;
        
    }else{
        
        currentLoginView = self.countView;
    }
    
    [self.loginTypeView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    currentLoginView.frame = CGRectMake(0, 0, self.loginTypeView.width, self.loginTypeView.height);
    
    [self.loginTypeView addSubview:currentLoginView];
    
    return currentLoginView;
}

/**
 登陆状态选择
 
 @param sender  tag:0快速登陆    1:账号登陆
 */
- (IBAction)lofinTypeSelect:(UIButton *)sender {
    
    currentClickBtn = sender;
    
    //变更页面
    [self renderLoginView];
    
    //动画移动视图
//    [UIView animateWithDuration:0.3 animations:^{
//
//        self.loginStatusSlideView.centerX = sender.centerX - 25;
//
//    } completion:nil];
}


// 开启倒计时效果
-(void)openCountdown:(UIButton *)btn{
    __block NSInteger time = 59;
    
    //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0);
    
    //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        
        if(time <= 0){
            //倒计时结束，关闭
            dispatch_source_cancel(_timer); dispatch_async(dispatch_get_main_queue(), ^{
                //设置按钮的样式
                [btn setTitle:@"重新发送" forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor yl_toUIColorByStr:@"#ff5000"] forState:UIControlStateNormal];
                
                btn.userInteractionEnabled = YES;
            });
            
        }else{
            
            int seconds = time % 60;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮显示读秒效果
                [btn setTitle:[NSString stringWithFormat:@"重新发送(%.2d)", seconds] forState:UIControlStateNormal];
                
                [btn setTitleColor:[UIColor yl_toUIColorByStr:@"#666666"] forState:UIControlStateNormal];
                
                btn.userInteractionEnabled = NO;
            });
            
            time--;
        }
    });
    
    dispatch_resume(_timer);
}


/**
 登陆成功

 @param
 phone 手机号
 code  验证码
 codeID 验证ID
 passWord 密码
 type 登录类型: 1为密码登录，2为快捷登录
 */

-(void)loginSuccessedPhone:(NSString *)phone code:(NSString *)code codeID:(NSString *)codeid passWord:(NSString *)pwd  type:(NSInteger)type{
    
    if (type == 2) {
        if ((phone.length > 0) && (code.length > 0) && code_id) {
            
            //密码登录
            NSDictionary *dic =@{@"phone":phone,@"code":code,@"code_id":code_id,@"type":@(type)};
            
            [[SDNetAPIClient sharedSDNetAPIClient] requestJsonDataWithPath:kLogin_URL withParams:dic withMethodType:Post andBlock:^(id data, NSError *error, NSString *errorMsg) {
                
                NSLog(@"%@",data);
                //NSLog(@"%@",error);
                
                if (data && [data [@"status_code"] integerValue] == 10000) {
                    
                    // 用户id信息处理
                    WoDeModel *mineModel = [WoDeModel sharedWoDeModel];
                    mineModel.user_id = data[@"data"];
                    mineModel.user_phone = phone;
                    
    
                    NSString *alias = [NSString stringWithFormat:@"%@",mineModel.user_id];
                    [JPUSHService setAlias:alias completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                        NSLog(@"%ld----%@----%ld",iResCode,iAlias,seq);
                    } seq:100];
                    
                    //本地存储：用户表
                    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                    if (([user objectForKey:@"uid"] == NULL) && ([user objectForKey:@"phone"] == NULL)) {
                        [user setObject:data[@"data"] forKey:@"uid"];
                        [user setObject:phone forKey:@"phone"];
                    }
                    
                    //登陆成功跳转页面
                    AppDelegate *appdelegate = (id)[[UIApplication sharedApplication] delegate];
                    appdelegate.window.rootViewController = [[LBTabBarController alloc]init];
                    
                }else{
                    
                    //提示框
                    [YLMBProgressHUD initWithString:data[@"msg"] inSuperView:self.view afterDelay:2];
                   
                }
            } isWithSign:YES];

            
        }else{
            
            //提示框
            MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"信息填写不完整";
            hud.margin = 10.f;
            hud.yOffset = 150.f;
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:0.5];
            
        }
        
    }else{
        
        if ((phone.length > 0) && (pwd.length > 0)) {
            //密码登录
            NSDictionary *dic =@{@"phone":phone,@"password":pwd,@"type":@(type)};
            
            [[SDNetAPIClient sharedSDNetAPIClient] requestJsonDataWithPath:kLogin_URL withParams:dic withMethodType:Post andBlock:^(id data, NSError *error, NSString *errorMsg) {
                
                NSLog(@"%@",data);
                //NSLog(@"%@",error);
                
                if (data && [data [@"status_code"] integerValue] == 10000) {
                    
                    // 用户id信息处理
                    WoDeModel *mineModel = [WoDeModel sharedWoDeModel];
                    mineModel.user_id = data[@"data"];
                    mineModel.user_phone = phone;
                    
                    NSString *alias = [NSString stringWithFormat:@"%@",mineModel.user_id];
                    [JPUSHService setAlias:alias completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                        NSLog(@"%ld----%@----%ld",iResCode,iAlias,seq);
                    } seq:100];
                    
                    //本地存储：用户表
                    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                    
                    if (([user objectForKey:@"uid"] == NULL) && ([user objectForKey:@"phone"] == NULL)) {
                        
                        [user setObject:data[@"data"] forKey:@"uid"];
                        [user setObject:phone forKey:@"phone"];
                        
                    }
                    
                    //登陆成功跳转页面
                    AppDelegate *appdelegate = (id)[[UIApplication sharedApplication] delegate];
                    appdelegate.window.rootViewController = [[LBTabBarController alloc]init];
                    
                }else{
                    
                    //提示框
                    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    hud.mode = MBProgressHUDModeText;
                    hud.labelText = data[@"msg"];
                    hud.margin = 10.f;
                    hud.yOffset = 150.f;
                    hud.removeFromSuperViewOnHide = YES;
                    [hud hide:YES afterDelay:0.5];
                    
                }
            } isWithSign:YES];
            
        }else{
            
            //提示框
            MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"信息填写不完整";
            hud.margin = 10.f;
            hud.yOffset = 150.f;
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:2];
            
        }
    }
}

@end
