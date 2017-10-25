//
//  YLRefreshHeader.h
//  ZQNLForPackagingStation
//
//  Created by 袁亮 on 2017/7/28.
//  Copyright © 2017年 Albert Yuan. All rights reserved.
//

#import <MJRefresh/MJRefresh.h>

//刷新事件回调
typedef void (^RefreshBlock) ();

@interface YLRefreshHeader : MJRefreshHeader

+(instancetype)initRefreshViewForTableView:(UITableView *)tableView withBlock:(RefreshBlock)refresh;

@end
