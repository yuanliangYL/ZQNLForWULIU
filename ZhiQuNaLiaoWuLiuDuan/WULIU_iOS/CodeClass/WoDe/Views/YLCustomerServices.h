//
//  YLCustomerServices.h
//  ZQNLForPackagingStation
//
//  Created by 袁亮 on 2017/8/7.
//  Copyright © 2017年 Albert Yuan. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^CloseBlock)();
typedef void(^CallPhoneBlock)();

@interface YLCustomerServices : UIView

@property(nonatomic,copy)CloseBlock closeblock;
@property(nonatomic,copy)CallPhoneBlock callphoneblock;

@end
