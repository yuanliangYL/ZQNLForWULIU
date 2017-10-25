//
//  UIFont+YLFont.h
//  ZQNLForPackagingStation
//
//  Created by 袁亮 on 2017/8/1.
//  Copyright © 2017年 Albert Yuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (YLFont)


/**
 方法的作用是传入一个UIFont对象，然后根据当前设备，将UIFont的字号做相应的调整，然后返回一个新的UIFont对象
 @param font 原来字体
 @return 新字体
 */
+(UIFont *)adjustFont:(UIFont *)font;


/**
 @param fontSize 原来字体大小
 @return 新字体大小
 */
+(CGFloat )adjustFontsize:(CGFloat)fontSize;

@end
