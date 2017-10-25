//
//  YLpackInfoCell.h
//  WULIU_iOS
//
//  Created by 袁亮 on 2017/9/23.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YLpackInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (weak, nonatomic) IBOutlet UILabel *namelabel;

@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@property (weak, nonatomic) IBOutlet UILabel *adressLable;

@property (weak, nonatomic) IBOutlet UIButton *actionBtn;

@end
