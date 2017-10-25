//
//  YLChangeLoginpassController.m
//  WULIU_iOS
//
//  Created by 袁亮 on 2017/8/24.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#import "YLChangeLoginpassController.h"

@interface YLChangeLoginpassController ()
@property (weak, nonatomic) IBOutlet UITextField *oldPassTF;

@property (weak, nonatomic) IBOutlet UITextField *resetPassTF;

@property (weak, nonatomic) IBOutlet UITextField *reresetpassTF;

@property (weak, nonatomic) IBOutlet UITextField *phoneTF;

@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property(nonatomic,strong)NSString *code_id;

@end

@implementation YLChangeLoginpassController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"修改登陆密码";
    self.oldPassTF.secureTextEntry = YES;
    self.resetPassTF.secureTextEntry = YES;
    self.reresetpassTF.secureTextEntry = YES;
    self.codeTF.keyboardType = UIKeyboardTypeNumberPad;
}
- (IBAction)didChangeAction:(id)sender {
    
    if (self.oldPassTF.text.length > 0 && self.resetPassTF.text.length > 0 && self.reresetpassTF.text.length > 0 && self.codeTF.text.length > 0 && self.phoneTF.text.length > 0) {
        
        NSDictionary *dic =@{@"uid":@(([WoDeModel sharedWoDeModel].user_id).intValue),
                             @"first_login_pwd":self.reresetpassTF.text,
                             @"second_login_pwd":self.resetPassTF.text,
                             @"handle":@(3),
                             @"code":self.codeTF.text,
                             @"code_id":self.code_id,
                             @"phone":self.phoneTF.text};
        
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

- (IBAction)getCodeAction:(UIButton *)sender {
    
    if (self.phoneTF.text.length>0) {
        
        [self openCountdown:sender];
        [SD_NetAPIClient_CONFIG requestJsonDataWithPath:KGetcode withParams:@{@"nc_phone":self.phoneTF.text} withMethodType:Post andBlock:^(id data, NSError *error, NSString *errorMsg) {
            NSLog(@"data%@",data);
            NSDictionary *dic = data[@"data"];
            self.code_id = [dic objectForKey:@"code_id"];
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
@end
