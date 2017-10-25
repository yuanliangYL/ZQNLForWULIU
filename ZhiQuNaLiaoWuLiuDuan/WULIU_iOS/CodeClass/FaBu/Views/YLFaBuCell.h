//
//  YLFaBuCell.h
//  WULIU_iOS
//
//  Created by 袁亮 on 2017/8/23.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FaBuModel.h"

@interface YLFaBuCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *qujianLabel;
@property (weak, nonatomic) IBOutlet UILabel *riqiLabel;
@property (weak, nonatomic) IBOutlet UILabel *zhongliangLabel;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@property(nonatomic,strong) FaBuModel *model;

@end
