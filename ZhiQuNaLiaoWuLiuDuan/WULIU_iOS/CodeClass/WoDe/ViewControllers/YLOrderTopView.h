//
//  YLOrderTopView.h
//  ZQNLForPackagingStation
//
//  Created by 袁亮 on 2017/8/1.
//  Copyright © 2017年 Albert Yuan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^showTopBlock)(NSInteger tag);

@interface YLOrderTopView : UIView

@property(nonatomic,copy)showTopBlock block;

//渲染订单头部按钮
-(instancetype)initWiteFrame:(CGRect)frame;

@end
