//
//  YLDingDanDetailViewController.m
//  WULIU_iOS
//
//  Created by Miaomiao Dai on 2017/8/22.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#import "YLDingDanDetailViewController.h"
#import "YLStatusCell.h"
#import "YLLabelCell.h"
#import "YLDaBaoZhanCell.h"
#import "YLDingDanListCell.h"
#import "YLDingDanDetailModel.h"

@interface YLDingDanDetailViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (weak, nonatomic) IBOutlet UIView *footerView;

@property (nonatomic, strong) YLDingDanDetailModel *detailModel;
@end

@implementation YLDingDanDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"订单详情";
    [self requestData];
    [self registerXIBCell];
    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"daohang_kefu"] style:UIBarButtonItemStylePlain target:self action:@selector(kefuClick)];
     [self createFooterView];
   
}

- (void)createFooterView {
    if ([self.model.plor_order_state integerValue]== 1) {
         self.myTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 50-64);
        UIButton *querentihuo = [self BtnViewWithTitle:@"确认提货" backgroundColor:@"#46C01B" titleColor:@"#ffffff" X:0 width:SCREEN_WIDTH imageNamed:@"order_btn_queren"];
        [querentihuo layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:10];
        [[querentihuo rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            WoDeModel *wode = [WoDeModel sharedWoDeModel];
            NSDictionary *dic = @{@"uid":wode.user_id,@"plor_id":self.plor_id};
            [SD_NetAPIClient_CONFIG requestJsonDataWithPath:KDriversuretotake withParams:dic withMethodType:Post andBlock:^(id data, NSError *error, NSString *errorMsg) {
                if ([data[@"status_code"] integerValue] ==10000) {
                    [YLMBProgressHUD initWithString:data[@"msg"] inSuperView:self.view afterDelay:1.5];
                }else {
                    [YLMBProgressHUD initWithString:data[@"msg"] inSuperView:self.view afterDelay:1.5];
                }
                
            } isWithSign:YES];
        }];
    } else if ([self.model.plor_order_state integerValue]== 2) {
        self.myTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 50-64);
        UIButton *querendaohuo = [self BtnViewWithTitle:@"确认到货" backgroundColor:@"#46C01B" titleColor:@"#ffffff" X:0 width:SCREEN_WIDTH imageNamed:@"order_btn_queren"];
          [querendaohuo layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:10];
        [[querendaohuo rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            
        WoDeModel *mine = [WoDeModel sharedWoDeModel];
        NSDictionary *dic = @{@"uid":mine.user_id,@"handle":@(2),@"plor_id":_model.plor_id,@"order_id":_model.order_id,@"order_type":_model.order_type,@"pack_id":_model.pack_id,@"logistics_order_number":_model.plor_number};
        [SD_NetAPIClient_CONFIG requestJsonDataWithPath:KGetlogisticorderlist_URL withParams:dic withMethodType:Post andBlock:^(id data, NSError *error, NSString *errorMsg) {
            NSLog(@"确认到货%@%@",data,error);
            if ([data[@"status_code"] integerValue] == 10000) {
                [YLMBProgressHUD initWithString:data[@"msg"] inSuperView:self.view afterDelay:2];
            }else {
                [YLMBProgressHUD initWithString:data[@"msg"] inSuperView:self.view afterDelay:2];
            }
        } isWithSign:YES];
            
    }];
    }else{
        self.myTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }
}
- (UIButton *)BtnViewWithTitle:(NSString *)title backgroundColor:(NSString *)color titleColor:(NSString *)titleColor X:(CGFloat)x width:(CGFloat)width imageNamed:(NSString *)imageNamed{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(x,0, width, 50)];
    button.backgroundColor = [UIColor colorWithHexString:color];
    //    [button setTintColor:[UIColor colorWithHexString:titleColor]];
    [button setTitleColor:[UIColor colorWithHexString:titleColor] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:imageNamed] forState:UIControlStateNormal
     ];
    [self.footerView addSubview:button];
    [self.footerView bringSubviewToFront:button];
    [button layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:5];
    [self.view addSubview:self.footerView];
    return button;
}
- (void)requestData {
    WoDeModel *mine = [WoDeModel sharedWoDeModel];
    NSDictionary *dic = nil;
    if ([self.type isEqualToString:@"推送"]) {
        dic = @{@"uid":mine.user_id,@"handle":@(4),@"plor_id":self.plor_id,@"pack_id":self.pack_id,@"slug":self.slug};
    } else {
        dic = @{@"uid":mine.user_id,@"handle":@(4),@"plor_id":self.model.plor_id,@"pack_id":self.model.pack_id};
    }
    
    [SD_NetAPIClient_CONFIG requestJsonDataWithPath:KGetlogisticorderlist_URL withParams:dic withMethodType:Post andBlock:^(id data, NSError *error, NSString *errorMsg) {
        NSLog(@"订单详情%@,%@",data,error);
        
        if ([data[@"status_code"] integerValue] == 10000) {
            self.detailModel = [YLDingDanDetailModel mj_objectWithKeyValues:data];
             if ([self.type isEqualToString:@"推送"]) {
            self.model = [DingDanListModel mj_objectWithKeyValues:data[@"detail_of_orders"][0]];
             }
            
        }
        [self.myTableView reloadData];
    } isWithSign:YES];
    
    
}



- (void)registerXIBCell {
    [self.myTableView  registerNib:[UINib nibWithNibName:NSStringFromClass([YLStatusCell class])  bundle:nil] forCellReuseIdentifier:NSStringFromClass([YLStatusCell class])
     ];
    [self.myTableView  registerNib:[UINib nibWithNibName:NSStringFromClass([YLLabelCell class])  bundle:nil] forCellReuseIdentifier:NSStringFromClass([YLLabelCell class])
     ];
    [self.myTableView  registerNib:[UINib nibWithNibName:NSStringFromClass([YLDaBaoZhanCell class])  bundle:nil] forCellReuseIdentifier:NSStringFromClass([YLDaBaoZhanCell class])
     ];
    self.myTableView.separatorColor = [UIColor clearColor];
   
}

- (void)kefuClick {
    NSURL *url = [NSURL URLWithString:[[NSMutableString alloc] initWithFormat:@"tel:%@",@"18256970599"]];
    
    //版本判断，兼容
    if([UIDevice currentDevice].systemVersion.doubleValue >= 10.0){
        
        [[UIApplication sharedApplication]  openURL:url options:@{} completionHandler:^(BOOL success) {
            
        }];
        
    }else{
        
        [[UIApplication sharedApplication] openURL:url];
    }

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (0==section) {
        return 8;
    }else {
        if (1==section) {
            return 2;
        } else {
//            if (3==self.index) {
//                return 6;
//            }
            return 4;
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 7;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (0==indexPath.section) {
        if (0==indexPath.row) {
            return 97*MLHeight;
        }else if (3<indexPath.row){
            return 20;
        }else {
            return 55;
        }
    }else if (1==indexPath.section) {
        if (0==indexPath.row) {
            return 80;
        }else {
            return 55;
        }
    }else {
        return 20;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    if (0==indexPath.section) {
        if (0==indexPath.row) {
            YLStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YLStatusCell class]) forIndexPath:indexPath];
            cell.selectionStyle = 0;
            //待提货
            if ([self.model.plor_order_state integerValue]==1) {
                cell.statusImageView.image = [UIImage imageNamed:@"icon_daitihuo"];
                cell.statusLabel.text = @"待提货";
                cell.statusDeitalLabel.text = @"发货前，请确认打包站是否及时支付物流费用，如未支付则会影响平台结算";
            }else if ([self.model.plor_order_state integerValue] == 2) {
                cell.statusImageView.image = [UIImage imageNamed:@"icon_daishouhuo"];
                cell.statusLabel.text = @"待收货";
                cell.statusDeitalLabel.text = @"打包站已经支付物流费用，业务员确认接车以后，费用将自动打到您的账户";
//            }else if (2==self.index) {
//                cell.statusImageView.image = [UIImage imageNamed:@"icon_daijiesuan"];
//                cell.statusLabel.text = @"待结算";
//                cell.statusDeitalLabel.text = @"请耐心等待平台结算，如有疑问，请联系客服";
            }else {
                
                cell.statusImageView.image = [UIImage imageNamed:@"icon_yiwancheng"];
                cell.statusLabel.text = @"已完成";
                cell.statusDeitalLabel.text = @"行程结束，费用已经转入您的账户";
            }
            
            return cell;

        }else if (5==indexPath.row||6==indexPath.row){
           YLLabelCell *cell = (YLLabelCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YLLabelCell class]) forIndexPath:indexPath];
            cell.selectionStyle = 0;
            NSArray *titleArr = nil;
            if (self.detailModel.detail_of_orders.count > 0) {
                Detail_of_orders *detailorder = self.detailModel.detail_of_orders[0];
                NSString *zhongliang = [NSString stringWithFormat:@"重量：%.2f吨",[detailorder.plor_weight floatValue]];
                NSString *baojia = [NSString stringWithFormat:@"报价：%.2f元",[detailorder.plor_total floatValue]];
                titleArr = @[zhongliang,baojia];

            }

            cell.myLabel.text = titleArr[indexPath.row-5];
            cell.bottomView.hidden = YES;
                        return cell;
        }else if (indexPath.row < 4){
            YLLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YLLabelCell class]) forIndexPath:indexPath];
             if (self.detailModel.detail_of_orders.count > 0) {
                 Detail_of_orders *detailorder = self.detailModel.detail_of_orders[0];
            NSString *qishi = [NSString stringWithFormat:@"起始：%@",self.model.plor_send_address];
            NSString *mudi = [NSString stringWithFormat:@"目的：%@",detailorder.plor_take_address];
                 NSString *riqi = @"";
                 if ([self.model.plor_order_state integerValue]==1) {
                    riqi = [NSString stringWithFormat:@"出发日期：%@",@"暂无"];
                 }else {
                     riqi = [NSString stringWithFormat:@"出发日期：%@",[self getdatefromstp:detailorder.plor_pay_date]];
                 }
            NSArray *titleArr = @[qishi,mudi,riqi];
            cell.myLabel.text = titleArr[indexPath.row-1];
             }
            cell.selectionStyle = 0;
            return cell;
            
        }else {
            YLLabelCell *cell = (YLLabelCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YLLabelCell class]) forIndexPath:indexPath];
            cell.selectionStyle = 0;
            cell.myLabel.text = @"";
            cell.bottomView.hidden = YES;
            return cell;

        }
    }else if (1==indexPath.section) {
        if (0==indexPath.row) {
          
            YLDaBaoZhanCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YLDaBaoZhanCell class]) forIndexPath:indexPath];
            if (self.detailModel.pack_info.count >0) {
                Pack_info *pack = self.detailModel.pack_info[0];
                cell.model = self.model;
                cell.fenshulabel.text =[NSString stringWithFormat:@"%@分",pack.pk_credit_score];
            }
            cell.selectionStyle = 0;
            return cell;
        
        }else{
           
           YLLabelCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YLLabelCell class]) forIndexPath:indexPath];
            if (self.detailModel.pack_info.count >0) {
                Pack_info *pack = self.detailModel.pack_info[0];
                cell.myLabel.text = [NSString stringWithFormat:@"地址：%@",pack.pk_address];
            }
            cell.selectionStyle = 0;
            return cell;
        }
}else {
        YLLabelCell *cell = (YLLabelCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YLLabelCell class]) forIndexPath:indexPath];
        cell.bottomView.hidden = YES;
//        if (3==self.index) {
//            if (self.detailModel.detail_of_orders.count > 0) {
//                Detail_of_orders *detailorder = self.detailModel.detail_of_orders[0];
//            NSString *dingdanhao = [NSString stringWithFormat:@"订单号：%@",self.model.plor_number];
//                NSString *chuangjian = [NSString stringWithFormat:@"订单创建时间：%@",[self getdatefromstp:detailorder.created_at]];
//                NSString *dakuan = [NSString stringWithFormat:@"打款时间 ：%@",[self getdatefromstp:detailorder.plor_pay_date]];
//            NSString *liushui = [NSString stringWithFormat:@"打款流水号：%@",self.model.plor_pay_number];
//            NSArray *titleArr = @[@"",dingdanhao,liushui,chuangjian,dakuan,@""];
//            cell.myLabel.text = titleArr[indexPath.row];
//            }
//
//        }else {
            if (self.detailModel.detail_of_orders.count > 0) {
                Detail_of_orders *detailorder = self.detailModel.detail_of_orders[0];
                NSString *dingdanhao = [NSString stringWithFormat:@"订单号：%@",self.model.plor_number];
                NSString *chuangjian = [NSString stringWithFormat:@"订单创建时间：%@",[self getdatefromstp:detailorder.created_at]];
            NSArray *titleArr = @[@"",dingdanhao,chuangjian,@""];
            cell.myLabel.text = titleArr[indexPath.row];
            }
//        }
        cell.selectionStyle = 0;
        return cell;
        
    }
}
-(NSString *)getdatefromstp:(NSString *)strip{
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:strip.integerValue];
    return  [formatter stringFromDate:confromTimesp];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
