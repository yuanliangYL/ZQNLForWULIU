//
//  YLRefreshHeader.m
//  ZQNLForPackagingStation
//
//  Created by 袁亮 on 2017/7/28.
//  Copyright © 2017年 Albert Yuan. All rights reserved.
//

#import "YLRefreshHeader.h"

@implementation YLRefreshHeader

+(instancetype)initRefreshViewForTableView:(UITableView *)tableView withBlock:(RefreshBlock)refresh{
    
      //设置刷新状态的动画图片
        NSMutableArray *idleImages = [NSMutableArray array];
        for (NSUInteger i = 1; i < 3; ++i) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"shuaxin%zd",i]];
            [idleImages addObject:image];
        }
    
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        
        //block中执行刷新事件
        refresh();
        
    }];
    
        //3.设置正在刷新状态的动画图片
        [header setImages:idleImages forState:MJRefreshStateRefreshing];
        
        tableView.mj_header = header;
        
#pragma mark --- 下面两个设置根据各自需求设置
        //隐藏更新时间
        header.lastUpdatedTimeLabel.hidden = NO;
        
        //隐藏刷新状态
        header.stateLabel.hidden = NO;
        
#pragma mark --- 自定义刷新状态和刷新时间文字【当然了，对应的Label不能隐藏】
        // Set title
        [header setTitle:@"下拉刷新数据" forState:MJRefreshStateIdle];
        [header setTitle:@"松开即可刷新" forState:MJRefreshStatePulling];
        [header setTitle:@"数据努力加载中..." forState:MJRefreshStateRefreshing];
        
        // Set font
        header.stateLabel.font = [UIFont systemFontOfSize:15];
        header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:14];
        // Set textColor
        header.stateLabel.textColor = [UIColor yl_toUIColorByStr:@"#333333"];
        header.lastUpdatedTimeLabel.textColor = [UIColor yl_toUIColorByStr:@"#333333"];
        

    return (YLRefreshHeader *)header;
}

@end
