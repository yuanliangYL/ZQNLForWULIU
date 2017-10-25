//
//  YLTopPromptCell.h
//  WULIU_iOS
//
//  Created by 袁亮 on 2017/8/22.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YLTopPromptCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImg;

@property (weak, nonatomic) IBOutlet UILabel *stepLabel;

@property (weak, nonatomic) IBOutlet UILabel *indecatorLabel;

@property(nonatomic,strong)NSArray *infoArr;

@end
