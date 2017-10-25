//
//  YLAddressModal.h
//  WULIU_iOS
//
//  Created by 袁亮 on 2017/8/23.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLAddressModal : NSObject

/** 省份*/
@property (nonatomic, copy) NSString *lda_province;
/**城市 */
@property (nonatomic, strong) NSString *lda_city;
/**分区 */
@property (nonatomic, strong) NSString *lda_dist;
/**默认地址 */
@property (nonatomic, assign) int  lda_is_default;
/**地址ID */
@property (nonatomic, assign) int  lda_id;


@end
