//
//  UIButton+ZYButton.m
//  LOG_iOS
//
//  Created by Miaomiao Dai on 2017/8/7.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#import "UIButton+ZYButton.h"

@implementation UIButton (ZYButton)

@dynamic setFontByDevice;

-(void)setSetFontByDevice:(CGFloat)setFontByDevice{
    
    self.titleLabel.font = [UIFont adjustFont:[UIFont fontWithName:@"Heiti SC" size:setFontByDevice]];
    
}
@end
