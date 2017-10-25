//
//  YLAddFaBuController.m
//  WULIU_iOS
//
//  Created by 袁亮 on 2017/8/23.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#import "YLAddFaBuController.h"
#import "YLAddressGuanLiController.h"

@interface YLAddFaBuController ()<UIPickerViewDelegate,UIPickerViewDataSource,AddressGuanLiDelegate>{
    NSString *selectedDate;
    NSString *seletedTime;
}
//picker相关
@property(nonatomic,strong)NSMutableArray *dateArr;
@property(nonatomic,strong)NSMutableArray *dateStrArr;

@property(nonatomic,strong)NSMutableArray *timeArr;
@property (weak, nonatomic) IBOutlet UIView *dateModalView;
@property (weak, nonatomic) IBOutlet UIPickerView *datepicker;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topCons;
//地址选择
@property(nonatomic,assign)BOOL isFirstAddress;

//弹窗视图
@property (strong, nonatomic) UIView *contentView;
@property (nonatomic, copy) NSString *starSheng;
@property (nonatomic, copy) NSString *startShi;
@property (nonatomic, copy) NSString *startQu;

@property (nonatomic, copy) NSString *desSheng;
@property (nonatomic, copy) NSString *desShi;
@property (nonatomic, copy) NSString *desQu;

@end

@implementation YLAddFaBuController

-(NSMutableArray *)dateArr{
    if (!_dateArr) {
        _dateArr = [NSMutableArray new];
    }
    return _dateArr;
}

-(NSMutableArray *)dateStrArr{
    if (!_dateStrArr) {
        _dateStrArr = [NSMutableArray new];
    }
    return _dateStrArr;
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
    [self.dateArr addObject:currentDateStr];
    [self.dateStrArr addObject:[self dateToTimesp:currentDateStr]];

    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = nil;
    comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitMonth fromDate:[NSDate date]];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    
    //第二天
    [adcomps setDay:1];
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:[NSDate date] options:0];
    NSString *beforDate = [formatter stringFromDate:newdate];
    [self.dateArr addObject:beforDate];
    [self.dateStrArr addObject:[self dateToTimesp:beforDate]];
    
    //第三天
    [adcomps setDay:2];
    NSDate *nnewdate = [calendar dateByAddingComponents:adcomps toDate:[NSDate date] options:0];
    NSString *bbeforDate = [formatter stringFromDate:nnewdate];
    [self.dateArr addObject:bbeforDate];
    [self.dateStrArr addObject:[self dateToTimesp:bbeforDate]];
    
//    NSLog(@"%@---%@+++++%@******%@",[NSDate date],newdate,nnewdate,self.dateStrArr);
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.pagesouce isEqualToString:@"编辑"]) {
        
        self.title = @"编辑可接单路线";
        self.startLabel.text = self.model.depart_address;
        self.stopLabel.text = self.model.dest_address;
        [self.dateBtn setTitle:self.model.ldr_can_tack_date forState:UIControlStateNormal];
        self.zhongliangTF.text = [NSString stringWithFormat:@"%@",self.model.ldr_capacity];
        self.startLabel.textColor = [UIColor yl_toUIColorByStr:@"#666666"];
        self.stopLabel.textColor = [UIColor yl_toUIColorByStr:@"#666666"];
        self.zhongliangTF.textColor = [UIColor yl_toUIColorByStr:@"#666666"];
        [self.dateBtn setTitleColor:[UIColor yl_toUIColorByStr:@"#666666"] forState:UIControlStateNormal];
        
    }else{
        
       self.title = @"发布可接单路线";
    }
    
    
    self.topCons.constant = SCREEN_HEIGHT;
    
    [self getDate];
    
    self.zhongliangTF.keyboardType = UIKeyboardTypeDecimalPad;
    
    //是否为第一个地址选择按钮
    self.isFirstAddress = YES;
    
    [self setupPicker];
}

-(void)setupPicker{
    self.datepicker.showsSelectionIndicator = YES;
    self.datepicker.alpha = 0.7;
}

// 返回多少列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
// 返回每列的行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{

    return self.dateArr.count;

}

#pragma mark UIPickerViewDelegate 代理方法 
// 返回每行的标题
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {

    return self.dateArr[row];
}

// 选中行显示在label上
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {

    selectedDate = self.dateStrArr[row];
    
}

-(void)closeAction{
    self.topCons.constant = SCREEN_HEIGHT;
}


- (IBAction)pickerAction:(UIButton *)sender {
    if (sender.tag == 1) {
        
        if ( !selectedDate) {
            
            [_dateBtn setTitle:[NSString stringWithFormat:@"%@",self.dateArr[0]] forState:UIControlStateNormal];
        }else{
            
           [_dateBtn setTitle:[NSString stringWithFormat:@"%@",selectedDate] forState:UIControlStateNormal];
        }
        
        [_dateBtn setTitleColor:[UIColor yl_toUIColorByStr:@"#33333"] forState:UIControlStateNormal];
    }
    
    [self closeAction];
}


//出发地选择
- (IBAction)ChuFaDiXuanZhe:(UITapGestureRecognizer *)sender {
    self.isFirstAddress = YES;
    
    YLAddressGuanLiController *avc = [YLAddressGuanLiController new];
    avc.pageSource = @"发布";
    avc.delegate = self;
    [self.navigationController pushViewController:avc animated:YES];
}

//目的地选择
- (IBAction)MuDiDiXuanZhe:(UITapGestureRecognizer *)sender {
    
    self.isFirstAddress = NO;
    
    YLAddressGuanLiController *avc = [YLAddressGuanLiController new];
    avc.pageSource = @"发布";
    avc.delegate = self;
    [self.navigationController pushViewController:avc animated:YES];
    
}

//日期选择
- (IBAction)dateChoose:(UIButton *)sender {
    self.topCons.constant = 0;

}

//提交数据
- (IBAction)confirmAction:(UIButton *)sender {
    NSLog(@"%@_______%@______%@______%@",self.startLabel.text ,self.stopLabel.text ,self.dateBtn.titleLabel.text, self.zhongliangTF.text);
    
    
    if (self.dateBtn.titleLabel.text.length > 0 && self.zhongliangTF.text.length > 0) {
        
        if ([self.startLabel.text isEqualToString:@"请设置出发地址"] || [self.stopLabel.text isEqualToString:@"请设置目的地"] ) {
            
             [YLMBProgressHUD initWithString:@"信息填写不完整" inSuperView:self.view afterDelay:1.5];
            
            return;
        }
   
    }else{
        
        [YLMBProgressHUD initWithString:@"信息填写不完整" inSuperView:self.view afterDelay:1.5];
        return;
    }

    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH * 0.75, SCREEN_HEIGHT * 0.25)];
    _contentView.layer.cornerRadius = 5;
    _contentView.layer.masksToBounds = YES;
    _contentView.backgroundColor = [UIColor whiteColor];
    
    WoDeModel *mine = [WoDeModel sharedWoDeModel];
    NSArray *starArr= [self.startLabel.text componentsSeparatedByString:@" "];
    NSArray *desArr= [self.stopLabel.text componentsSeparatedByString:@" "];
    
    
    if ([self.pagesouce isEqualToString:@"编辑"]) {
     
        NSDictionary *dic = @{@"uid":mine.user_id,
                              @"handle":@(4),
                              @"depart_address":self.startLabel.text,
                              @"dest_address":self.stopLabel.text,
                              @"depart_province":starArr[0],
                              @"depart_city":starArr[1],
                              @"depart_dist":starArr[2],
                              @"dest_province":desArr[0],
                              @"dest_city":desArr[1],
                              @"dest_dist":desArr[2],
                              @"id":self.model.ldr_id,
                              @"ldr_can_tack_date":self.dateBtn.titleLabel.text,
                              @"ldr_capacity":self.zhongliangTF.text};
        
        [SD_NetAPIClient_CONFIG requestJsonDataWithPath:KSendlogisticrequire_URL withParams:dic withMethodType:Post andBlock:^(id data, NSError *error, NSString *errorMsg) {
            NSLog(@"%@%@",data,error);
            
            if ([data[@"status_code"] integerValue] == 10000) {
                UIView *AddSuccessView = [[NSBundle mainBundle] loadNibNamed:@"FaBuAddSuccess" owner:nil options:nil].lastObject;
                AddSuccessView.frame = CGRectMake(0, 0, SCREEN_WIDTH * 0.75, SCREEN_HEIGHT * 0.25);
                
                [_contentView addSubview:AddSuccessView];
                
                [HWPopTool sharedInstance].shadeBackgroundType = ShadeBackgroundTypeSolid;
                
                [HWPopTool sharedInstance].closeButtonType = ButtonPositionTypeRight;
                
                [[HWPopTool sharedInstance] showWithPresentView:_contentView animated:NO];
                
                [self closeAndBack];
            }else{
                
                [YLMBProgressHUD initWithString:data[@"msg"] inSuperView:self.view afterDelay:1];
            }
        } isWithSign:YES];
        
    }else {
        
        if (self.startLabel.text.length > 0 && self.stopLabel.text.length > 0 && self.dateBtn.titleLabel.text > 0  && self.zhongliangTF.text > 0 && starArr.count > 0 && desArr.count > 0 ) {
            
            NSDictionary *dic = @{@"uid":mine.user_id,
                                  @"handle":@(1),
                                  @"depart_address":self.startLabel.text,
                                  @"dest_address":self.stopLabel.text,
                                  @"depart_province":starArr[0],
                                  @"depart_city":starArr[1],
                                  @"depart_dist":starArr[2],
                                  @"dest_province":desArr[0],
                                  @"dest_city":desArr[1],
                                  @"dest_dist":desArr[2],
                                  @"ldr_can_tack_date":self.dateBtn.titleLabel.text,
                                  @"ldr_capacity":self.zhongliangTF.text};
            
            [SD_NetAPIClient_CONFIG requestJsonDataWithPath:KSendlogisticrequire_URL withParams:dic withMethodType:Post andBlock:^(id data, NSError *error, NSString *errorMsg) {
                NSLog(@"%@%@",data,error);
                if ([data[@"status_code"] integerValue] == 10000) {
                    UIView *AddSuccessView = [[NSBundle mainBundle] loadNibNamed:@"FaBuAddSuccess" owner:nil options:nil].lastObject;
                    AddSuccessView.frame = CGRectMake(0, 0, SCREEN_WIDTH * 0.75, SCREEN_HEIGHT * 0.25);
                    [_contentView addSubview:AddSuccessView];
                    
                    [HWPopTool sharedInstance].shadeBackgroundType = ShadeBackgroundTypeSolid;
                    
                    [HWPopTool sharedInstance].closeButtonType = ButtonPositionTypeRight;
                    
                    [[HWPopTool sharedInstance] showWithPresentView:_contentView animated:NO];
                    
                    [self closeAndBack];
                }else{
                    
                    [YLMBProgressHUD initWithString:data[@"msg"] inSuperView:self.view afterDelay:1];
                }
            } isWithSign:YES];
            
        }else{
            
            [YLMBProgressHUD initWithString:@"信息填写不完整" inSuperView:self.view afterDelay:1];
        }
        

    }
}

- (void)closeAndBack{
    //避免循环强引用
    __weak typeof(self) weakSelf = self;
    
    [[HWPopTool sharedInstance] closeWithBlcok:^{
        
        sleep(0.5);
        
        //注册成功跳转认证
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        
    }];
}

#pragma mark - AddressGuanLiDelegate
-(void)didFinishClickAdress:(YLAddressModal *)resultAddress{
  
    if (self.isFirstAddress) {
        
//        self.startLabel.text = nil;
        
                self.startLabel.text = [NSString stringWithFormat:@"%@ %@ %@",resultAddress.lda_province,resultAddress.lda_city,resultAddress.lda_dist];

        self.startLabel.textColor = [UIColor yl_toUIColorByStr:@"#666666"];
        
    }else{
       
        self.stopLabel.text = [NSString stringWithFormat:@"%@ %@ %@",resultAddress.lda_province,resultAddress.lda_city,resultAddress.lda_dist];
        self.stopLabel.textColor = [UIColor yl_toUIColorByStr:@"#666666"];
        
    }
}



@end
