//
//  YLShenQingDetailController.h
//  WULIU_iOS
//
//  Created by 袁亮 on 2017/8/25.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#import "WLBaseViewController.h"
#import "JieDanModel.h"
#import "YLShenQingModel.h"

@interface YLShenQingDetailController : WLBaseViewController
@property(nonatomic,assign)NSInteger  jdid;
@property (nonatomic, strong) JieDanModel *zhixiaoModel;
@property (nonatomic, strong) CaiGouModel *caigouModel;

//重新申请页面跳转操作
@property (nonatomic, strong) YLShenQingModel *shenQingModel;

@end
