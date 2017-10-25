//
//  YLCheLiangController.h
//  WULIU_iOS
//
//  Created by 袁亮 on 2017/8/22.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WLBaseViewController.h"
#import "YLRenZhengList.h"

@interface YLCheLiangController :WLBaseViewController

//页面来源
@property(nonatomic,strong)NSString *pageType;

@property(nonatomic,strong)YLXingShiZhengList *model;

@end
