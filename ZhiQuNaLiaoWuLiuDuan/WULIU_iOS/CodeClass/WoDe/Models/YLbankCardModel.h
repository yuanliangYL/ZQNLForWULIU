//
//  YLbankCardModel.h
//  WULIU_iOS
//
//  Created by 袁亮 on 2017/9/25.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLbankCardModel : NSObject

@property(nonatomic,strong)NSString *ldb_bank;

@property(nonatomic,strong)NSString *ldb_bankcard_code;

@property(nonatomic,strong)NSString *ldb_cardholder;

@property(nonatomic,strong)NSString *ldb_id;

@property(nonatomic,strong)NSString *ldb_is_default;

@property(nonatomic,strong)NSString *ldb_phone;

@end


//"ldb_bank" = "\U4e2d\U56fd\U5efa\U8bbe\U94f6\U884c";
//"ldb_bankcard_code" = 3656989865653232254;
//"ldb_cardholder" = "\U8881\U4eae";
//"ldb_id" = 5;
//"ldb_is_default" = 0;
//"ldb_phone" = 18256970599;

