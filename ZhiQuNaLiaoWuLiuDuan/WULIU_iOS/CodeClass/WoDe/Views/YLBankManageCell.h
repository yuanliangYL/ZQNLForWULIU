//
//  YLBankManageCell.h
//  ZQNLForPackagingStation
//
//  Created by 袁亮 on 2017/8/4.
//  Copyright © 2017年 Albert Yuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLbankCardModel.h"

@interface YLBankManageCell : UITableViewCell
@property(nonatomic,strong)YLbankCardModel *model;

@property (weak, nonatomic) IBOutlet UIButton *editBtn;

@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@property (weak, nonatomic) IBOutlet UIButton *defaultBtn;
@end
