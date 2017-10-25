//
//  YLChangeNameController.m
//  WULIU_iOS
//
//  Created by 袁亮 on 2017/9/1.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#import "YLChangeNameController.h"

@interface YLChangeNameController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTF;

@end

@implementation YLChangeNameController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"姓名";
    
}

- (IBAction)ConfirmAction:(UIButton *)sender {
    
    if (self.nameTF.text.length > 0) {
        
        NSDictionary *dic =@{@"uid":@(([WoDeModel sharedWoDeModel].user_id).intValue),@"type":@(4),@"realname":self.nameTF.text};
        
        [[SDNetAPIClient sharedSDNetAPIClient] requestJsonDataWithPath:KUserInfo_URL withParams:dic withMethodType:Post andBlock:^(id data, NSError *error, NSString *errorMsg) {
            
            NSLog(@"33%@",data);
            
            if (data && [data [@"status_code"] integerValue] == 10000) {
                
                //本地存储：用户表
                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                [user setObject:self.nameTF.text forKey:@"ld_realname"];
                
                //修改成功，执行代理设置
                [self.delegate didChangeName:self.nameTF.text];
            
                
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                
                //提示框
                [YLMBProgressHUD initWithString:data[@"msg"] inSuperView:self.view afterDelay:2];
            }
        } isWithSign:YES];

    }else{
        
        [YLMBProgressHUD initWithString:@"信息填写不完整" inSuperView:self.view afterDelay:1.5];
    }
  
}

@end
