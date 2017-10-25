//
//  YLMyTopCell.h
//  WULIU_iOS
//
//  Created by 袁亮 on 2017/8/22.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YLMyTopCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *renzhengStatus;
@property(nonatomic,strong)WoDeModel *model;

@end
