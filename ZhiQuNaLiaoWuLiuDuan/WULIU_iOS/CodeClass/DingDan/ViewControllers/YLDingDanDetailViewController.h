//
//  YLDingDanDetailViewController.h
//  WULIU_iOS
//
//  Created by Miaomiao Dai on 2017/8/22.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#import "WLBaseViewController.h"
#import "DingDanListModel.h"
@interface YLDingDanDetailViewController : WLBaseViewController
@property (nonatomic, assign) NSUInteger index;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, strong) NSNumber *plor_id;
@property (nonatomic, strong) NSNumber *pack_id;
@property (nonatomic, strong) NSNumber *slug;
@property (nonatomic, strong) DingDanListModel *model;
@end
