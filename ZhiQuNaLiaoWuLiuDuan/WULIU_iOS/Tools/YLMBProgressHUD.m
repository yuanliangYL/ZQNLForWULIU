//
//  YLMBProgressHUD.m
//  WULIU_iOS
//
//  Created by 袁亮 on 2017/8/30.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#import "YLMBProgressHUD.h"

@implementation YLMBProgressHUD

+(instancetype)initWithString:(NSString *)titleStr inSuperView:(UIView *)view afterDelay:(NSInteger)time{
    
    //提示框
    YLMBProgressHUD *hud=[YLMBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = titleStr;
    hud.margin = 10.f;
    hud.yOffset = 150.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:time];
    
    return hud;
}

+(instancetype)initProgressInView:(UIView *)view{
    
    //1提示框
    YLMBProgressHUD *hud=[[YLMBProgressHUD alloc]init];
    hud.mode = MBProgressHUDModeIndeterminate;
    
    //2,设置背景框的背景颜色和透明度， 设置背景颜色之后opacity属性的设置将会失效
    hud.color = [UIColor lightGrayColor];
    hud.color = [hud.color colorWithAlphaComponent:0.7];
    
    //3,设置背景框的圆角值，默认是10
    hud.cornerRadius = 10.0;
    
    //4,设置提示信息 信息颜色，字体
    hud.labelColor = [UIColor yl_toUIColorByStr:@"#666666"];
    hud.labelFont = [UIFont systemFontOfSize:14];
    hud.labelText = @"请稍等";
    //5,设置提示信息详情 详情颜色，字体
    hud.detailsLabelColor = [UIColor yl_toUIColorByStr:@"#666666"];
    hud.detailsLabelFont = [UIFont systemFontOfSize:14];
    hud.detailsLabelText = @"图片正在上传中...";
    
    //6设置隐藏的时候是否从父视图中移除，默认是NO
    hud.removeFromSuperViewOnHide =NO;

    [view addSubview:hud];
    return hud;
}


+(instancetype)initProgressInViewbystateShow:(UIView *)view{
    
    //1提示框
    YLMBProgressHUD *hud=[[YLMBProgressHUD alloc]init];
    hud.mode = MBProgressHUDModeIndeterminate;
    
    //2,设置背景框的背景颜色和透明度， 设置背景颜色之后opacity属性的设置将会失效
    hud.color = [UIColor lightGrayColor];
    hud.color = [hud.color colorWithAlphaComponent:0.5];
    
    //3,设置背景框的圆角值，默认是10
    hud.cornerRadius = 10.0;
    
    //4,设置提示信息 信息颜色，字体
    hud.labelColor = [UIColor yl_toUIColorByStr:@"#666666"];
    hud.labelFont = [UIFont systemFontOfSize:14];
    hud.labelText = @"请稍等";
    
    //5,设置提示信息详情 详情颜色，字体
    hud.detailsLabelColor = [UIColor yl_toUIColorByStr:@"#666666"];
    hud.detailsLabelFont = [UIFont systemFontOfSize:14];
    hud.detailsLabelText = @"数据正在处理中...";
    
    //6设置隐藏的时候是否从父视图中移除，默认是NO
    hud.removeFromSuperViewOnHide =NO;
    
    [view addSubview:hud];
    return hud;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
