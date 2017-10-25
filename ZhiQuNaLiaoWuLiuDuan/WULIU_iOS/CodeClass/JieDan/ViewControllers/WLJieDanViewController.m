//
//  WLJieDanViewController.m
//  WULIU_iOS
//
//  Created by Miaomiao Dai on 2017/8/19.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#import "WLJieDanViewController.h"
#import "YLJieDanCell.h"
//citypicker
#import "JFCityViewController.h"
#import "YLShenQingDetailController.h"
#import "YLShenQingJieDanController.h"
#import "JieDanModel.h"
#import "AppDelegate.h"
@interface WLJieDanViewController ()<UITableViewDelegate,UITableViewDataSource,JFCityViewControllerDelegate,CLLocationManagerDelegate>
{
    /***头部当前类型选择按钮***/
    UIButton *currentClickBtn;
    /***当前选择日期按钮***/
    UIButton *currentDateBtn;
    /***当前选择时间端按钮***/
    UIButton *currentTimeBtn;
    /***当前选择重量按钮***/
    UIButton *currentzhongliangBtn;
    
    NSInteger _order_type;
    CLLocationManager * locationManager;
    NSString *currentCity; //当前城市
    NSString *currentPrivance;
    NSString *pack_send_time;
    NSString *end_area_city;
    NSString *end_area_province;
}

@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (weak, nonatomic) IBOutlet UIButton *stopBtn;
@property (weak, nonatomic) IBOutlet UIButton *timeBtn;
@property (weak, nonatomic) IBOutlet UIButton *zhonglaingBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/***时间选择modal***/
@property (weak, nonatomic) IBOutlet UIView *timeSeleteView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeSelecteCons;

/***date按钮群***/
@property (weak, nonatomic) IBOutlet UIButton *dateBtn1;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong)  NSMutableDictionary *dic;

/***重量按钮群***/
@property (weak, nonatomic) IBOutlet UIView *zhinglaingView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *zhongliangCons;
@property (weak, nonatomic) IBOutlet UIButton *zhonglaingbtn;
@property (weak, nonatomic) IBOutlet UIButton *caigouBtn;

@property(nonatomic,strong)NSMutableArray *dateStrArr;
@property(nonatomic,strong)NSArray *dateArr;

@end

static int _pageNum = 0;
static int _size = 10;

@implementation WLJieDanViewController

-(NSMutableDictionary *)dic{
    
    if (!_dic) {
        
        _dic = [NSMutableDictionary new];
    }
    return _dic;
}


-(NSMutableArray *)dateStrArr{
    if (!_dateStrArr) {
        _dateStrArr = [NSMutableArray new];
    }
    return  _dateStrArr;
}

//获取当天日期零点的时间戳
-(void)getDate{
    
    // 实例化NSDateFormatter
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置日期格式
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSString *currentDateStr = [formatter stringFromDate:[NSDate date]];
    [self.dateStrArr addObject:[self dateToTimesp:currentDateStr]];
//     pack_send_time = [self dateToTimesp:currentDateStr];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = nil;
    comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitMonth fromDate:[NSDate date]];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    
    //第二天
    [adcomps setDay:1];
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:[NSDate date] options:0];
    NSString *beforDate = [formatter stringFromDate:newdate];
    [self.dateStrArr addObject:[self dateToTimesp:beforDate]];
    
    //第三天
    [adcomps setDay:2];
    NSDate *nnewdate = [calendar dateByAddingComponents:adcomps toDate:[NSDate date] options:0];
    NSString *bbeforDate = [formatter stringFromDate:nnewdate];
    
    [self.dateStrArr addObject:[self dateToTimesp:bbeforDate]];
    
    NSLog(@"%@---%@+++++%@******%@",[NSDate date],newdate,nnewdate,self.dateStrArr);
    
   
}

//时间戳
-(NSString *)dateToTimesp:(NSString *)date{
    
    // 实例化NSDateFormatter
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *today = [NSString stringWithFormat:@"%@ 00:00:00",date];
    
    NSDate *todayDate =[formatter dateFromString:today];
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[todayDate timeIntervalSince1970]];
    
    NSLog(@"timeSp:%@",timeSp); //时间戳的值
    
    return timeSp;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self networkAnomalyWithView:self.view refresh:^{
        [self refreshAllData];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _order_type = 1;
    
    [self getDate];
    
    [self locate];
    
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAllData)];
    NSMutableArray *idleImages = [NSMutableArray arrayWithCapacity:0]; ;
    UIImage *image1 = [UIImage imageNamed:@"shuaxin1"];
    [idleImages addObject:image1];
    UIImage *image2 = [UIImage imageNamed:@"shuaxin2"];
    [idleImages addObject:image2];
  
    [header setImages:idleImages forState:MJRefreshStateIdle];
    [header setImages:idleImages forState:MJRefreshStatePulling];
    [header setImages:idleImages forState:MJRefreshStateRefreshing];
    
    self.tableView.mj_header = header;
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshAllMoreData)];
    self.tableView.mj_footer.automaticallyHidden = YES;
    
    

    [self.zhonglaingBtn setTitle:@"直销" forState:UIControlStateNormal];

    [self setupUI];
}


- (void)locate {
    // 判断定位操作是否被允许
    if([CLLocationManager locationServicesEnabled])
    {
        locationManager = [[CLLocationManager alloc]init];
        locationManager.delegate = self;

        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)
        {
       
            [locationManager requestAlwaysAuthorization];
        }else{
            [locationManager stopUpdatingLocation];
        }
        
    }else{
        //提示用户无法进行定位操作
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:
                                  @"提示" message:@"定位不成功 ,请确认已开启定位" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
        
        
    }
    
}

#pragma mark CoreLocation delegate
//定位成功
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    CLLocation *currentLocation = [locations lastObject];
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    
    //反编码
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count > 0) {
            CLPlacemark *placeMark = placemarks[0];
            currentCity = placeMark.locality;
            currentPrivance =  placeMark.administrativeArea;
            NSLog(@"城市%@",currentCity);
            if (!currentCity) {
                currentCity = @"无法定位当前城市";
                currentPrivance = @"无法定位当前城市";
            }else {
                WoDeModel *mine = [WoDeModel sharedWoDeModel];
                
                    self.dic = [@{@"uid":mine.user_id,
                                  @"order_type":@(_order_type),
                                  @"pageNum":@(_pageNum),
                                  @"size":@(_size),
                                  @"city":currentCity} mutableCopy];
                
                [self refreshAllData];
            }
            [self.startBtn setTitle:currentCity forState:UIControlStateNormal];
            NSLog(@"%@",currentCity);
            NSLog(@"%@",placeMark.name);
            
            
        }
        else if (error == nil && placemarks.count == 0) {
            NSLog(@"No location and error return");
        }
        else if (error) {
            NSLog(@"location error: %@ ",error);
        }
        
    }];
    [locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [locationManager startUpdatingLocation];
    }
}



- (void)refreshAllData{
    
    _pageNum = 0;
    _size = 10;
    
    //个人信息
    [[SDNetAPIClient sharedSDNetAPIClient] requestJsonDataWithPath:KGetorderlogisticlist_URL withParams:self.dic withMethodType:Post andBlock:^(id data, NSError *error, NSString *errorMsg) {
        NSLog(@"接单列表%@%@",data,error);
        
        if (_pageNum == 0) {
            [self.dataArray removeAllObjects];
            [self.tableView.mj_footer endRefreshing];
        }
        
        if (data && [data[@"status_code"] integerValue] == 10000) {
            
            NSMutableArray *array = data[@"data"];
            
            for (NSDictionary *modelDic in array) {
                
                if (_order_type==1) {
                    
                    JieDanModel *zhixiaoModel = [JieDanModel mj_objectWithKeyValues:modelDic];
                    
                    [self.dataArray addObject:zhixiaoModel];
                    
                    NSLog(@"%@",self.dataArray);
                    
                    
                    
                }else {
                    
//                    CaiGouModel *caigouModel = [CaiGouModel mj_objectWithKeyValues:modelDic];
//                    [self.dataArray addObject:caigouModel];
                    
                    JieDanModel *zhixiaoModel = [JieDanModel mj_objectWithKeyValues:modelDic];
                    [self.dataArray addObject:zhixiaoModel];
                }
            }
            
             [self.view bringSubviewToFront:self.tableView];
            
        }else {
            
//            [YLMBProgressHUD initWithString:data[@"msg"] inSuperView:self.view afterDelay:2];
        }
        
        //有无数据
        if (self.dataArray.count==0) {
            
            Reachability *netWorkReachable = [Reachability reachabilityWithHostName:@"www.baidu.com"];
           
            if ([netWorkReachable currentReachabilityStatus] == NotReachable) {
                
                [self hasOrderViewWithView:self.view];
                
            }else {
                
                [self nullOrderViewWithView:self.view withFrame:CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT-108) type:ORDER];
            }
        }else {

            [self hasOrderViewWithView:self.view];

        }
     
        //加载数据完毕
        [self loadSuccessDataWithView:self.view];
        
        [self.tableView.mj_header endRefreshing];
        
        [self.tableView reloadData];
        
    } isWithSign:YES];
    
}

- (void)refreshAllMoreData{
    
    _pageNum ++;
    [self.dic setValue:@(_pageNum) forKey:@"pageNum"];
    
    [[SDNetAPIClient sharedSDNetAPIClient] requestJsonDataWithPath:KGetorderlogisticlist_URL withParams:self.dic withMethodType:Post andBlock:^(id data, NSError *error, NSString *errorMsg) {
        NSLog(@"加载更多%@%@",data,error);
        
        if (data && [data[@"status_code"] integerValue] == 10000) {
        
            NSMutableArray *array = data[@"data"];
            for (NSDictionary *modelDic in array) {
                if (_order_type==1) {
                    JieDanModel *zhixiaoModel = [JieDanModel mj_objectWithKeyValues:modelDic];
                    [self.dataArray addObject:zhixiaoModel];
                }else {
//                    CaiGouModel *caigouModel = [CaiGouModel mj_objectWithKeyValues:modelDic];
//                    [self.dataArray addObject:caigouModel];
                    JieDanModel *zhixiaoModel = [JieDanModel mj_objectWithKeyValues:modelDic];
                    [self.dataArray addObject:zhixiaoModel];
                }
            }
            [self.tableView.mj_footer endRefreshing];
        }else{
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        [self.tableView reloadData];
    } isWithSign:YES];
    
}

- (void)setupUI{
    
    self.title = @"接单";
     self.dateArr = [NSArray arrayWithObjects:@"今天",@"明天",@"后天", nil];
    
    currentClickBtn = self.startBtn;
    currentClickBtn.selected = YES;

    currentDateBtn = self.dateBtn1;
    currentDateBtn.selected = YES;

    currentzhongliangBtn = self.zhonglaingbtn;
    currentzhongliangBtn.selected = YES;
    
    //控制器根据所在界面的status bar，navigationbar，与tabbar的高度，自动调整scrollview的inset
    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.tableView.bounces = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;   //取消cell中的线
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YLJieDanCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([YLJieDanCell class])];
    
    //初始位置
    self.zhongliangCons.constant = self.timeSelecteCons.constant  = SCREEN_HEIGHT;
}

//近3天日期选择事件
- (IBAction)deteSelectedAction:(UIButton *)sender {
    
    currentDateBtn.selected = NO;
    currentDateBtn = sender;
    currentDateBtn.selected = YES;
    [self.timeBtn setTitle:self.dateArr[sender.tag] forState:UIControlStateNormal];
    [self.timeBtn setTitle:self.dateArr[sender.tag] forState:UIControlStateSelected];
    
    pack_send_time = self.dateStrArr[sender.tag];
    
//    self.dic = [@{@"uid":[WoDeModel sharedWoDeModel].user_id,
//                  @"order_type":@(_order_type),
//                  @"pageNum":@(_pageNum),
//                  @"size":@(_size),
//                  @"pack_send_time":pack_send_time,
//                  @"city":currentCity} mutableCopy];
    
    [self.dic setValue:pack_send_time forKey:@"pack_send_time"];
    
    self.timeSelecteCons.constant  = SCREEN_HEIGHT;
    
    [self refreshAllData];
}

//重量点击事件
- (IBAction)zhonglaingClickAction:(UIButton *)sender {
    
    currentzhongliangBtn.selected = NO;
    currentzhongliangBtn = sender;
    currentzhongliangBtn.selected = YES;
    
    [self.zhonglaingBtn setTitle:currentzhongliangBtn.titleLabel.text forState:UIControlStateNormal];
    self.zhongliangCons.constant  = SCREEN_HEIGHT;
    switch (sender.tag) {
        case 1:
            _order_type = 1;
            
//            self.dic[@"order_type"] = @(_order_type);
            
            [self.dic setValue:@(1) forKey:@"order_type"];
            
             [self refreshAllData];
            break;
        case 2:
            _order_type = 2;
            
//            self.dic[@"order_type"] = @(_order_type);
            [self.dic setValue:@(2) forKey:@"order_type"];
            
            [self refreshAllData];
            break;
        default:
            break;
    }
}

/**
 头部按钮点击事件

 @param sender Btn
 */
- (IBAction)btnclickAction:(UIButton *)sender {
    
    currentClickBtn.selected = NO;
    currentClickBtn = sender;
    currentClickBtn.selected = YES;
    
    switch (sender.tag) {
        case 0:
             self.zhongliangCons.constant  = SCREEN_HEIGHT;
             self.timeSelecteCons.constant  = SCREEN_HEIGHT;
             [self goToCityPickerView:sender];
            
             break;
            
        case 1:
            self.zhongliangCons.constant  = SCREEN_HEIGHT;
            self.timeSelecteCons.constant  = SCREEN_HEIGHT;
            [self goToCityPickerView:sender];
            break;
            
        case 2:
            
            [self.view bringSubviewToFront:self.timeSeleteView];
            self.zhongliangCons.constant  = SCREEN_HEIGHT;
            self.timeSelecteCons.constant  = 45;
            break;
            
        case 3:
            
            [self.view bringSubviewToFront:self.zhinglaingView];
            self.zhongliangCons.constant  = 45;
            self.timeSelecteCons.constant  = SCREEN_HEIGHT;
            break;
            
        default:
            break;
    }
    
}
- (void)goToCityPickerView:(UIButton *)btn{
    
    JFCityViewController *cityViewController = [[JFCityViewController alloc] init];
    cityViewController.delegate = self;
    
    cityViewController.title = @"城市选择";
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:cityViewController];
    
    [self presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark - JFCityViewControllerDelegate
- (void)cityName:(NSString *)name{
    CLGeocoder *myGeocoder = [[CLGeocoder alloc] init];
    [myGeocoder geocodeAddressString:name completionHandler:^(NSArray *placemarks, NSError *error) {
        if ([placemarks count] > 0 && error == nil) {
            NSLog(@"Found %lu placemark(s).", (unsigned long)[placemarks count]);
             [self shenfen:placemarks];
            
            if (self.startBtn == currentClickBtn) {
                
                currentCity = name;
                [currentClickBtn setTitle:name forState:UIControlStateNormal];
                
                [self.dic setValue:name forKey:@"city"];
                
//                [self.stopBtn setTitle:@"目的地" forState:UIControlStateNormal];
                
            }else {
                
                [currentClickBtn setTitle:name forState:UIControlStateNormal];
                
                [self.dic setObject:name forKey:@"end_area_city"];

            }
            
            [self refreshAllData];
        }
        else if ([placemarks count] == 0 && error == nil) {
            NSLog(@"Found no placemarks.");
        } else if (error != nil) {
            NSLog(@"An error occurred = %@", error);
        }
    }];
}

- (void)shenfen:(NSArray*)placemarks{
    
    CLPlacemark *firstPlacemark = [placemarks objectAtIndex:0];
    NSLog(@"Longitude = %f", firstPlacemark.location.coordinate.longitude);
    NSLog(@"Latitude = %f", firstPlacemark.location.coordinate.latitude);
         CLGeocoder *clGeoCoder = [[CLGeocoder alloc] init];
         CLLocation *cl = [[CLLocation alloc] initWithLatitude:firstPlacemark.location.coordinate.latitude  longitude:firstPlacemark.location.coordinate.longitude];
    
        [clGeoCoder reverseGeocodeLocation:cl completionHandler: ^(NSArray *placemarks,NSError *error) {
                for (CLPlacemark *placeMark in placemarks) {
                    if (currentClickBtn == self.startBtn) {
                        currentPrivance = placeMark.administrativeArea;
                    }else {
                        end_area_province = placeMark.administrativeArea;
                    }
                    
                    [locationManager stopUpdatingLocation] ;                  }
             }];

}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    YLJieDanCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YLJieDanCell class]) forIndexPath:indexPath];
//    if (_order_type == 1) {
        JieDanModel *model = self.dataArray[indexPath.row];
        cell.zhixiaoModel = model;
//    }else {
//        CaiGouModel *model = self.dataArray[indexPath.row];
//        cell.caigouModel = model;
//    }
    
    
    //避免循环强引用
    __weak typeof(self) weakSelf = self;
    
    [[[cell.jieDanCell rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(UIButton *btn) {
        
        YLShenQingDetailController *svc = [[YLShenQingDetailController alloc]init];
//        if (_order_type == 1) {
            JieDanModel *model = self.dataArray[indexPath.row];
//            cell.zhixiaoModel = model;
            svc.zhixiaoModel = model;
//        }else {
//            CaiGouModel *model = self.dataArray[indexPath.row];
//            cell.caigouModel = model;
            
//             svc.caigouModel= model;
//        }
        
        
        [weakSelf.navigationController pushViewController:svc animated:YES];
        
    }];
    
    cell.selectionStyle = 0;
   
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YLShenQingJieDanController *svc = [[YLShenQingJieDanController alloc]init];
//    if (_order_type == 1) {
        JieDanModel *model = self.dataArray[indexPath.row];
        svc.zhixiaoModel = model;
//    }else {
//        CaiGouModel *model = self.dataArray[indexPath.row];
//        svc.caigouModel = model;
//    }
    [self.navigationController pushViewController:svc animated:YES];

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return SCREEN_HEIGHT * 0.35;
}


@end
