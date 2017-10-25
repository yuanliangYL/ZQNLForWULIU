//
//  YLChangePayPassController.m
//  WULIU_iOS
//
//  Created by 袁亮 on 2017/8/24.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#import "YLSettingPayPassController.h"
#import "YLChangePayPassController.h"

@interface YLSettingPayPassController ()<UITextFieldDelegate>
//手机第一步验证
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property(nonatomic,strong)NSString *code_id;
@property(nonatomic,strong)NSString *code;

//手机第二步验证
@property (weak, nonatomic) IBOutlet UITextField *loginPassTF;


//密码设置
@property (weak, nonatomic) IBOutlet UITextField *passTF;

@property (weak, nonatomic) IBOutlet UITextField *repassTF;


//视图约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nextTopcons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *codeFaildCons;

@end

@implementation YLSettingPayPassController

- (IBAction)getCodeAction:(UIButton *)sender {
    
    if (self.phoneTF.text.length>0) {
        [self openCountdown:sender];
        [SD_NetAPIClient_CONFIG requestJsonDataWithPath:KGetcode withParams:@{@"nc_phone":self.phoneTF.text} withMethodType:Post andBlock:^(id data, NSError *error, NSString *errorMsg) {
            
            NSDictionary *dic = data[@"data"];
            NSLog(@"%@",dic);
            
            self.code_id = [dic objectForKey:@"code_id"];
            self.code = [dic objectForKey:@"code"];
            
            [self openCountdown:sender];
        } isWithSign:YES];
        
    }else{
        [YLMBProgressHUD initWithString:@"请输入手机号" inSuperView:self.view afterDelay:1];
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


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置支付密码";
    self.nextTopcons.constant = SCREEN_HEIGHT;
    self.codeFaildCons.constant = SCREEN_HEIGHT;
    self.phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    self.codeTF.keyboardType = UIKeyboardTypeNumberPad;
    self.loginPassTF.secureTextEntry = YES;
    self.passTF.secureTextEntry = YES;
    self.repassTF.secureTextEntry =YES;
   
}


/**
 设置支付密码:第一步验证手机验证通过

 @param sender btn
 */
- (IBAction)nextBtnAction:(UIButton *)sender {
    [self.view endEditing:YES];
    if (self.phoneTF.text.length>0 && self.codeTF.text.length>0) {
       
        NSDictionary *dic =@{@"uid":@(([WoDeModel sharedWoDeModel].user_id).intValue),
                             @"code":self.codeTF.text,
                             @"code_id":self.code_id,
                             @"phone":self.phoneTF.text,
                             @"handle":@(4)};

        [[SDNetAPIClient sharedSDNetAPIClient] requestJsonDataWithPath:KSetting_URL withParams:dic withMethodType:Post andBlock:^(id data, NSError *error, NSString *errorMsg) {
            NSLog(@"%@",data);
            if (data && [data [@"status_code"] integerValue] == 10000) {
//18256325356
                if ([data[@"data"] isEqual:[NSNull null]]) {
//                    第一次设置
                    NSLog(@"第一次设置");
                    //变更页面
                    [UIView animateWithDuration:1.0 animations:^{
                        self.nextTopcons.constant = 0;
                        self.codeFaildCons.constant = SCREEN_HEIGHT;
                    }];

                }else{
//                    修改操作
                    NSLog(@"修改操作");
                    YLChangePayPassController *c = [YLChangePayPassController new];
                    c.settingvc = self.settingvc;
                    [self.navigationController pushViewController:c animated:YES];
                    
                }
                
                
           
            }else{
                //提示框
                [YLMBProgressHUD initWithString:data[@"msg"] inSuperView:self.view afterDelay:1.5];
            }

        } isWithSign:YES];

    }else{
        //提示框
        [YLMBProgressHUD initWithString:@"信息填写不完整" inSuperView:self.view afterDelay:1.5];
    }
}


/**
 第二部验证登陆密码验证
 @param sender btn
 */
- (IBAction)loginConfirmAction:(UIButton *)sender {
    
    if (self.loginPassTF.text.length > 0) {
        
        NSDictionary *dic =@{@"uid":@(([WoDeModel sharedWoDeModel].user_id).intValue),
                             @"login_pwd":self.loginPassTF.text,
                             @"handle":@(2),
                             @"type":@(2),
                             };
        
        [[SDNetAPIClient sharedSDNetAPIClient] requestJsonDataWithPath:KSetting_URL withParams:dic withMethodType:Post andBlock:^(id data, NSError *error, NSString *errorMsg) {
            NSLog(@"%@",data);
            
            if (data && [data [@"status_code"] integerValue] == 10000) {
          
                //18256325356
                if ([data[@"data"] isEqual:[NSNull null]]) {
                    //第一次设置
                    NSLog(@"第一次设置");
                    //变更页面
                    [UIView animateWithDuration:1.0 animations:^{
                        self.nextTopcons.constant = 0;
                        self.codeFaildCons.constant = SCREEN_HEIGHT;
                    }];
                    
                }else{
                    //修改操作
                    NSLog(@"修改操作");
                    YLChangePayPassController *c = [YLChangePayPassController new];
                     c.settingvc = self.settingvc;
                    [self.navigationController pushViewController:c animated:YES];
                    
                }
                
            }else{
                //提示框
                [YLMBProgressHUD initWithString:data[@"msg"] inSuperView:self.view afterDelay:1.5];
            }
            
        } isWithSign:YES];
        
    }else{
        //提示框
        [YLMBProgressHUD initWithString:@"信息填写不完整" inSuperView:self.view afterDelay:1.5];
    }
}




/**
 密码设置

 @param sender sender
 */
- (IBAction)passwordShettingAction:(UIButton *)sender {
    
    if (self.passTF.text.length>0 && self.repassTF.text.length>0) {
        
        NSDictionary *dic =@{@"uid":@(([WoDeModel sharedWoDeModel].user_id).intValue),
                             @"first_pay_pwd":self.passTF.text,
                             @"second_pay_pwd":self.repassTF.text,
                             @"handle":@(5),
                             @"type":@(2)};
        
        [[SDNetAPIClient sharedSDNetAPIClient] requestJsonDataWithPath:KSetting_URL withParams:dic withMethodType:Post andBlock:^(id data, NSError *error, NSString *errorMsg) {
            
            NSLog(@"%@",data);
            
            if (data && [data [@"status_code"] integerValue] == 10000) {
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }else{
                //提示框
                [YLMBProgressHUD initWithString:data[@"msg"] inSuperView:self.view afterDelay:1.5];
            }
            
        } isWithSign:YES];
        
    }else{
        
        //提示框
        [YLMBProgressHUD initWithString:@"信息填写不完整" inSuperView:self.view afterDelay:1.5];
        
    }
    
}


- (IBAction)codeFiledAction:(id)sender {
    
    [UIView animateWithDuration:1.0 animations:^{
        self.codeFaildCons.constant = 0;
    }];
    
}

#pragma mark - UITextFieldDelegatex
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string; {
    
    NSInteger newlength = textField.text.length + string.length - range.length;
    
    return  newlength <= 6;
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
