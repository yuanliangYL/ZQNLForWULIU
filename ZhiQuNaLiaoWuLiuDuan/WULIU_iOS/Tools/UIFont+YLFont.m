//
//  UIFont+YLFont.m
//  ZQNLForPackagingStation
//
//  Created by 袁亮 on 2017/8/1.
//  Copyright © 2017年 Albert Yuan. All rights reserved.
//

#import "UIFont+YLFont.h"


@implementation UIFont (YLFont)

//方法的作用是传入一个UIFont对象，然后根据当前设备，将UIFont的字号做相应的调整，然后返回一个新的UIFont对象
+(UIFont *)adjustFont:(UIFont *)font{
    
    UIFont *newFont=nil;
    
    if (inch_4){
        
        newFont = [UIFont fontWithName:font.fontName size:font.pointSize - inch4_INCREMENT];
        
    }else if (inch_55){
        
        newFont = [UIFont fontWithName:font.fontName size:font.pointSize + inch55_INCREMENT];
        
    }else{
        
        newFont = font;
    }
    
    return newFont;
}


//得到对应屏幕大小的字体
+(CGFloat)adjustFontsize:(CGFloat)fontSize{
    
    CGFloat newFontSize = fontSize;
    
    if (inch_4){
        
        newFontSize = newFontSize - inch4_INCREMENT;
        
    }else if (inch_55){
        
        newFontSize = newFontSize + inch55_INCREMENT;
        
    }else{
        
        newFontSize = fontSize;
    }
    
    return newFontSize;
}

@end
