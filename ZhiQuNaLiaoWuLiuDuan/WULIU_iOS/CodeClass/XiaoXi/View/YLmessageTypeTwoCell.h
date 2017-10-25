//
//  YLmessageTypeTwoCell.h
//  ZQNLForPackagingStation
//
//  Created by 袁亮 on 2017/9/13.
//  Copyright © 2017年 Albert Yuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLMessageModel.h"


@interface YLmessageTypeTwoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (strong, nonatomic) YLMessageModel *model;

@end
