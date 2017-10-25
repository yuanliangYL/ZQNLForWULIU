//
//  YLDiZhiGuanLiCell.h
//  WULIU_iOS
//
//  Created by 袁亮 on 2017/8/23.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLAddressModal.h"

@interface YLDiZhiGuanLiCell : UITableViewCell
@property(nonatomic,strong)YLAddressModal *model;
@property (weak, nonatomic) IBOutlet UILabel *adressLabel;

@property (weak, nonatomic) IBOutlet UIButton *defaultBtn;

@property (weak, nonatomic) IBOutlet UIButton *editBtn;

@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;


@end
