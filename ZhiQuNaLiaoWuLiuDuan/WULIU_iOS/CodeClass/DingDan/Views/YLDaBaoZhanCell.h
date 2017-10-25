//
//  YLDaBaoZhanCell.h
//  WULIU_iOS
//
//  Created by Miaomiao Dai on 2017/8/22.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DingDanListModel.h"
@interface YLDaBaoZhanCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *fenshulabel;
@property (weak, nonatomic) IBOutlet UIButton *lianXiDanBaoZhanBtn;
@property (nonatomic, strong) DingDanListModel *model;

@end
