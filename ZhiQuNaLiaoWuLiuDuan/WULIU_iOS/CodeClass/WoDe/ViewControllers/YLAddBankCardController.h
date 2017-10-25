//
//  YLAddBankCardController.h
//  ZQNLForPackagingStation
//
//  Created by 袁亮 on 2017/8/4.
//  Copyright © 2017年 Albert Yuan. All rights reserved.
//

#import "WLBaseViewController.h"

@interface YLAddBankCardController : WLBaseViewController
//页面类型
@property(nonatomic,strong)NSString *actionType;

//持卡人
@property (weak, nonatomic) NSString *cardOwner;

//银行卡号
@property (weak, nonatomic)  NSString *cardNumber;
//银行卡开户行
@property (weak, nonatomic)  NSString *cardName;
//手机号码
@property (weak, nonatomic)  NSString *ownerPhone;

@property(nonatomic,strong)NSString *isdefault;

@property(nonatomic,strong)NSString *cardid;

@end
