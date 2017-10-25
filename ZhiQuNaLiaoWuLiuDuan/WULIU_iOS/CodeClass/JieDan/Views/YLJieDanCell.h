//
//  YLJieDanCell.h
//  WULIU_iOS
//
//  Created by 袁亮 on 2017/8/25.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JieDanModel.h"
@interface YLJieDanCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *jieDanCell;
@property (weak, nonatomic) IBOutlet UIButton *jieDanBtn;
@property (nonatomic, strong) JieDanModel *zhixiaoModel;
@property (nonatomic, strong) CaiGouModel *caigouModel;
@end
