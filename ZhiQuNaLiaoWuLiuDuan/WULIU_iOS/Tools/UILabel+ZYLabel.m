//
//  UILabel+ZYLabel.m
//  LOG_iOS
//
//  Created by Miaomiao Dai on 2017/8/7.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#import "UILabel+ZYLabel.h"

@implementation UILabel (ZYLabel)

@dynamic setFontByDevice;
-(void)setSetFontByDevice:(CGFloat)setFontByDevice{
    
    self.font = [UIFont adjustFont:[UIFont fontWithName:@"Heiti SC" size:setFontByDevice]];
    
}
@end
