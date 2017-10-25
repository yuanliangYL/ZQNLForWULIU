//
//  YLFastLoginView.h
//  ZQNLForPackagingStation
//
//  Created by 袁亮 on 2017/8/14.
//  Copyright © 2017年 Albert Yuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YLFastLoginView : UIView
/*****手机号*****/
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
/*****验证码*****/
@property (weak, nonatomic) IBOutlet UITextField *codeTF;

//确认登陆
@property (weak, nonatomic) IBOutlet UIButton *loginConfirm;
//倒计时
@property (weak, nonatomic) IBOutlet UIButton *countdownBtn;
//注册
@property (weak, nonatomic) IBOutlet UIButton *registerNew;


@end
