//
//  YLCountLoginView.m
//  ZQNLForPackagingStation
//
//  Created by 袁亮 on 2017/8/14.
//  Copyright © 2017年 Albert Yuan. All rights reserved.
//

#import "YLCountLoginView.h"

@implementation YLCountLoginView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.passTF.secureTextEntry = YES;
}
@end
