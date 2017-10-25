//
//  YLSQDetailController.h
//  WULIU_iOS
//
//  Created by 袁亮 on 2017/9/23.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#import "WLBaseViewController.h"
#import "YLShenQingModel.h"

@interface YLSQDetailController : WLBaseViewController

@property(nonatomic,assign)int orderType;

@property(nonatomic,strong)YLShenQingModel *model;

//机关跳转字典
@property(nonatomic,strong)NSDictionary *pushDic;

@end
