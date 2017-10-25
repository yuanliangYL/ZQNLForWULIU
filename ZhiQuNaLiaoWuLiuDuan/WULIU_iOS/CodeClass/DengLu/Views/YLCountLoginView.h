//
//  YLCountLoginView.h
//  ZQNLForPackagingStation
//
//  Created by 袁亮 on 2017/8/14.
//  Copyright © 2017年 Albert Yuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YLCountLoginView : UIView

@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *passTF;

//确认登陆
@property (weak, nonatomic) IBOutlet UIButton *countLoginConfirm;
//忘记密码
@property (weak, nonatomic) IBOutlet UIButton *forgetpasswordBtn;
//注册
@property (weak, nonatomic) IBOutlet UIButton *registerNew;

@end
