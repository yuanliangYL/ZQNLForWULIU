//
//  YLMBProgressHUD.h
//  WULIU_iOS
//
//  Created by 袁亮 on 2017/8/30.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface YLMBProgressHUD : MBProgressHUD

+(instancetype)initWithString:(NSString *)titleStr inSuperView:(UIView *)view afterDelay:(NSInteger)time;

//图片提示
+(instancetype)initProgressInView:(UIView *)view;


+(instancetype)initProgressInViewbystateShow:(UIView *)view;

@end
