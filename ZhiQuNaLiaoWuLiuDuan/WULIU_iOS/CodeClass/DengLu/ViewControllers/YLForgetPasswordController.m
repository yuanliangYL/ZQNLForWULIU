//
//  YLForgetPasswordController.m
//  ZQNLForPackagingStation
//
//  Created by 袁亮 on 2017/8/14.
//  Copyright © 2017年 Albert Yuan. All rights reserved.
//
// 引入JPush功能所需头文件
#import "JPUSHService.h"

#import "YLForgetPasswordController.h"
#import "YLCheZhuController.h"
#import "WoDeModel.h"

@interface YLForgetPasswordController ()<UITextFieldDelegate,UIAlertViewDelegate>{
    NSNumber *code_id;
}

//确认按钮
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *repasswordTF;

//弹窗视图
@property (strong, nonatomic) UIView *contentView;
@property(nonatomic,assign)BOOL isRegisterView;

//是否注册成功
@property(nonatomic,assign)BOOL isRegisterSuccess;

@end

@implementation YLForgetPasswordController

- (void)viewWillAppear:(BOOL)animated {
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    [self initData];
}

-(void)setupUI{
    
    if ([self.pageTyep isEqualToString:@"忘记密码"]) {
        
        self.title = @"忘记密码";
        
    }else{
        
        self.title = @"注册";
    }
    
}


/**
 RAC应用TF，监听按钮使用状态
 */
-(void)initData{
    
    //设置代理
    self.phoneTF.delegate = self;
    self.codeTF.delegate = self;
    self.passwordTF.delegate = self;
    self.repasswordTF.delegate = self;
    self.passwordTF.secureTextEntry = YES;
    self.repasswordTF.secureTextEntry = YES;

    //创建有效状态信号
    RACSignal* validPhoneSignal= [self.phoneTF.rac_textSignal map:^id(NSString*text){
        
        return@(text.length == 11);
        
    }];
    RACSignal* validCodeSignal= [self.codeTF.rac_textSignal map:^id(NSString*text){
        
        return@(text.length == 6);
        
    }];
    RACSignal* validPasswSignal= [self.passwordTF.rac_textSignal map:^id(NSString*text){
       
        return@(text.length > 0);
        
    }];
    RACSignal* validRepasswSignal= [self.repasswordTF.rac_textSignal map:^id(NSString*text){
        
        return@(text.length > 0);
        
    }];
    
    //转换这些信号,进行相关设置
    RAC(self.phoneTF,backgroundColor) = [validPhoneSignal map:^id(NSNumber*phoneValid){
        
        return[phoneValid boolValue] ? [UIColor clearColor]: [UIColor yl_toUIColorByStr:@"#f2f2f2"];
        
    }];
    RAC(self.codeTF,backgroundColor) = [validCodeSignal map:^id(NSNumber*codeValid){
        
        return[codeValid boolValue] ? [UIColor clearColor]: [UIColor yl_toUIColorByStr:@"#f2f2f2"];
        
    }];
    RAC(self.passwordTF,backgroundColor) = [validPasswSignal map:^id(NSNumber*passwordValid){
        
        return[passwordValid boolValue] ? [UIColor clearColor]: [UIColor yl_toUIColorByStr:@"#f2f2f2"];
        
    }];
    RAC(self.repasswordTF,backgroundColor) = [validRepasswSignal map:^id(NSNumber*repasswordValid){
        
        return[repasswordValid boolValue] ? [UIColor clearColor]: [UIColor yl_toUIColorByStr:@"#f2f2f2"];
    }];
    
    //聚合信号
    RACSignal* signUpActiveSignal= [RACSignal combineLatest:@[validPhoneSignal,validCodeSignal,validPasswSignal,validRepasswSignal] reduce:^id(NSNumber*phoneValid,NSNumber*codeValid,NSNumber*passwordValid,NSNumber*repasswordValid){
        
        return@([phoneValid boolValue]&&[codeValid boolValue]&&[passwordValid boolValue]&&[repasswordValid boolValue]);
        
    }];
    
    [signUpActiveSignal subscribeNext:^(NSNumber*signupActive){
        //按钮是否可用
        self.confirmBtn.enabled= [signupActive boolValue];
        
    }];
    
    
}

//倒计时Action
- (IBAction)countDownBtn:(UIButton *)sender {
    
    if (self.phoneTF.text.length > 0) {
        
        [SD_NetAPIClient_CONFIG requestJsonDataWithPath:KGetcode withParams:@{@"nc_phone":self.phoneTF.text} withMethodType:Post andBlock:^(id data, NSError *error, NSString *errorMsg) {
            NSLog(@"data%@",data);
            NSDictionary *dic = data[@"data"];
            code_id = [dic objectForKey:@"code_id"];
            [self openCountdown:sender];
        } isWithSign:YES];
        
    }else{
        
        [YLMBProgressHUD initWithString:@"请填写手机号" inSuperView:self.view afterDelay:2];
        
    }
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

#pragma mark - HWPopTool
//确认点击事件
- (IBAction)confirmAction:(UIButton *)sender {
    
    //判断两次密码输入是否一致
    if (![self.passwordTF.text isEqualToString:self.repasswordTF.text]) {
    
        UIAlertController *alert = [UIAlertController  alertControllerWithTitle:@"温馨提示" message:@"请确保两次密码输入一致!" preferredStyle:UIAlertControllerStyleAlert];
        //添加确定到UIAlertController中
        UIAlertAction *
        OKAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:OKAction];
        [self presentViewController:alert animated:YES completion:nil];
        
        
    }else{
        
        //注册或者修改密码操作
        [self RegisterOrChangePassAction];
        
    
    }
}

//打开pop视图
-(void)popShow{
    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH * 0.75, SCREEN_HEIGHT * 0.35)];
    _contentView.layer.cornerRadius = 5;
    _contentView.layer.masksToBounds = YES;
    _contentView.backgroundColor = [UIColor whiteColor];
    
    if ([self.pageTyep isEqualToString:@"忘记密码"]) {
        
        UIView *passChangeView = [[NSBundle mainBundle] loadNibNamed:@"PasswordSettingSuccessView" owner:nil options:nil].lastObject;
        passChangeView.frame = CGRectMake(0, 0, SCREEN_WIDTH * 0.75, SCREEN_HEIGHT * 0.35);
        [_contentView addSubview:passChangeView];
        
    }else{
        
        //用户注册成功
        self.isRegisterSuccess = YES;
        UIView *registerView = [[NSBundle mainBundle] loadNibNamed:@"RegisterSuccessView" owner:nil options:nil].lastObject;
        registerView.frame = CGRectMake(0, 0, SCREEN_WIDTH * 0.75, SCREEN_HEIGHT * 0.35);
        [_contentView addSubview:registerView];
        
    }
    
    [HWPopTool sharedInstance].shadeBackgroundType = ShadeBackgroundTypeSolid;
    
    [HWPopTool sharedInstance].closeButtonType = ButtonPositionTypeRight;
    
    [[HWPopTool sharedInstance] showWithPresentView:_contentView animated:NO];
    
    
    //返回操作
    [self closeAndBack];
    

}

- (void)closeAndBack {
    
    //避免循环强引用
    __weak typeof(self) weakSelf = self;
    
    [[HWPopTool sharedInstance] closeWithBlcok:^{
        
        sleep(0.5);
        
        if (self.isRegisterSuccess) {
            
            //注册成功跳转认证
            YLCheZhuController *zvc = [YLCheZhuController new];
            zvc.pageType = @"注册";
            [weakSelf.navigationController pushViewController:zvc animated:YES];
        
        }else{
            
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }

    }];
}

#pragma mark - UITextFieldDelegatex
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string; {
    
    NSInteger newlength = textField.text.length + string.length - range.length;
    
    if (textField == self.phoneTF) {
        
        return  newlength <= 11;
        
    }else if (textField == self.codeTF) {
        
        return  newlength <= 6;
        
    }else {
        return 20;
    }
}

- (void)RegisterOrChangePassAction{
    
   //页面状态判断
    if ([self.pageTyep isEqualToString:@"忘记密码"]) {
        
        NSDictionary *dic =@{@"phone":self.phoneTF.text,@"code":self.codeTF.text,@"code_id":code_id,@"first_pwd":self.passwordTF.text,@"second_pwd":self.repasswordTF.text};
        
        [[SDNetAPIClient sharedSDNetAPIClient] requestJsonDataWithPath:KForgetpwd_URL withParams:dic withMethodType:Post andBlock:^(id data, NSError *error, NSString *errorMsg) {
            
            NSLog(@"%@",data);
            NSLog(@"%@",error);
            
            if (data && [data [@"status_code"] integerValue] == 10000) {
                
                // 用户id信息处理
//                WoDeModel *mineModel = [WoDeModel sharedWoDeModel];
                //mineModel.user_pwd = self.repasswordTF.text;
                //本地存储：用户表
//                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//                [user setObject:self.repasswordTF.text forKey:@"password"];
                
                //显示成功popview
                [self popShow];
                
            }else{
                
                [YLMBProgressHUD initWithString:data[@"msg"] inSuperView:self.view afterDelay:2.0];
        
            }
        } isWithSign:YES];

        
    }else{
        
        NSDictionary *dic =@{@"phone":self.phoneTF.text,@"code":self.codeTF.text,@"code_id":code_id,@"first_pwd":self.passwordTF.text,@"second_pwd":self.repasswordTF.text};
        
        [[SDNetAPIClient sharedSDNetAPIClient] requestJsonDataWithPath:kRegister_URL withParams:dic withMethodType:Post andBlock:^(id data, NSError *error, NSString *errorMsg) {
            
            NSLog(@"%@",data);
            NSLog(@"%@",error);
            
            if (data && [data [@"status_code"] integerValue] == 10000) {
                // 用户id信息处理
                WoDeModel *mineModel = [WoDeModel sharedWoDeModel];
                mineModel.user_id = data[@"data"];
                mineModel.user_phone = self.phoneTF.text;
                
                NSString *alias = [NSString stringWithFormat:@"%@",mineModel.user_id];
                [JPUSHService setAlias:alias completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                    NSLog(@"%ld----%@----%ld",iResCode,iAlias,seq);
                } seq:100];
                
                //本地存储：用户表
                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                [user setObject:data[@"data"] forKey:@"uid"];
                [user setObject:self.phoneTF.text forKey:@"phone"];
        
                //显示成功popview
                [self popShow];
                
            }else{
                
                //提示框
                [YLMBProgressHUD initWithString:data[@"msg"] inSuperView:self.view afterDelay:1];
            }
        } isWithSign:YES];
    
    }
}

@end
