//
//  YLBankCardManageController.h
//  ZQNLForPackagingStation
//
//  Created by 袁亮 on 2017/8/4.
//  Copyright © 2017年 Albert Yuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLbankCardModel.h"
@class YLBankCardManageController;

@protocol YLBankCardManageControllerDelegate

-(void)didSelectedCaed:(YLbankCardModel *)card;

@end

@interface YLBankCardManageController : UIViewController

@property(nonatomic,strong)NSString *selected;

@property(nonatomic,strong)  id <YLBankCardManageControllerDelegate>delegate;

@end
