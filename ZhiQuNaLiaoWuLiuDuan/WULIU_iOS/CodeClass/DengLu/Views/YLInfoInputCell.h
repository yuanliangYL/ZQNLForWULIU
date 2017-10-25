//
//  YLInfoInputCell.h
//  WULIU_iOS
//
//  Created by 袁亮 on 2017/8/22.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YLInfoInputCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UITextField *InfoTF;

@property(nonatomic,strong)NSArray *infoArr;

@property(nonatomic,strong)NSArray *haveinfoArr;

@end
