//
//  YLImageSlecteCell.h
//  WULIU_iOS
//
//  Created by 袁亮 on 2017/8/22.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YLImageSlecteCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *indecatorLabel;

@property(nonatomic,strong)NSDictionary *itemArr;

@property(nonatomic,strong)NSDictionary *haveinfoArr;

@end
