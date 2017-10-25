//
//  YLDaiShouHuoCell.h
//  WULIU_iOS
//
//  Created by Miaomiao Dai on 2017/8/22.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DingDanListModel.h"
@interface YLDaiShouHuoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet UIButton *QueRenShouHuoBtn;
@property (weak, nonatomic) IBOutlet UIButton *LianXiDaBaoZhanBtn;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *qujianLabel;
@property (weak, nonatomic) IBOutlet UILabel *zhongliangLabel;
@property (weak, nonatomic) IBOutlet UILabel *baojiaLabel;
@property (weak, nonatomic) IBOutlet UILabel *riqiLabel;
@property (nonatomic,strong) DingDanListModel *model;
@end
