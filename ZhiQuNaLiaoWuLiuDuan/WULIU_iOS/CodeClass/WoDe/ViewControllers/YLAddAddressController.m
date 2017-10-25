//
//  YLAddAddressController.m
//  WULIU_iOS
//
//  Created by 袁亮 on 2017/8/23.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#import "YLAddAddressController.h"
#import "YLAddressGuanLiController.h"
#import "PSCityPickerView.h"
#import <ActionSheetCustomPicker.h>
#import <MJExtension.h>

@interface YLAddAddressController ()<PSCityPickerViewDelegate,ActionSheetCustomPickerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *adressName;
@property (weak, nonatomic) IBOutlet UISwitch *setDefault;

@property (nonatomic ,strong) PSCityPickerView * cityPicker;
@property(nonatomic,strong)NSString *province;
@property(nonatomic,strong)NSString *city;
@property(nonatomic,strong)NSString *district;

//address Selected
@property (nonatomic,strong) NSArray *addressArr; // 解析出来的最外层数组
@property (nonatomic,strong) NSArray *provinceArr; // 省
@property (nonatomic,strong) NSArray *countryArr; // 市
@property (nonatomic,strong) NSArray *districtArr; // 区
@property (nonatomic,assign) NSInteger index1; // 省下标
@property (nonatomic,assign) NSInteger index2; // 市下标
@property (nonatomic,assign) NSInteger index3; // 区下标
@property (nonatomic,strong) ActionSheetCustomPicker *picker; // 选择器
@end

@implementation YLAddAddressController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    NSLog(@"%@",self.model);
    
    if (self.model) {
        
        self.title = @"编辑地址";
        self.province = self.model.lda_province;
        self.city = self.model.lda_city;
        self.district = self.model.lda_dist;
        self.setDefault.on = self.model.lda_is_default;
        self.adressName.text = [NSString stringWithFormat:@"%@ %@ %@",self.province,self.city,self.district];
        
    }else{
        
        self.title = @"添加新地址";
        self.setDefault.on = NO;
    }
    
    // 一定要先加载出这三个数组，不然就蹦了
    [self calculateFirstData];
    
//    [self.view addSubview:self.cityPicker];
    
}


- (IBAction)openCityPicker:(id)sender {
    
    self.picker = [[ActionSheetCustomPicker alloc]initWithTitle:@"选择地区" delegate:self showCancelButton:YES origin:self.view initialSelections:@[@(self.index1),@(self.index2),@(self.index3)]];
    self.picker.tapDismissAction  = TapActionSuccess;
    
    // 可以自定义左边和右边的按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 44, 44);
    [button setTitle:@"取消" forState:UIControlStateNormal];
    [self.picker setCancelButton:[[UIBarButtonItem alloc] initWithCustomView:button]];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    button1.frame = CGRectMake(0, 0, 44, 44);
    [button1 setTitle:@"确定" forState:UIControlStateNormal];
    [self.picker setDoneButton:[[UIBarButtonItem alloc] initWithCustomView:button1]];
    
    
    [self.picker showActionSheetPicker];
    
}



- (void)loadFirstData{
    // 注意JSON后缀的东西和Plist不同，Plist可以直接通过contentOfFile抓取，Json要先打成字符串，然后用工具转换
    NSString *path = [[NSBundle mainBundle] pathForResource:@"address" ofType:@"json"];
    
    NSLog(@"%@",path);
    
    NSString *jsonStr = [NSString stringWithContentsOfFile:path usedEncoding:nil error:nil];
    
    self.addressArr = [jsonStr mj_JSONObject];
    
    NSMutableArray *firstName = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in self.addressArr)
    {
        NSString *name = dict.allKeys.firstObject;
        [firstName addObject:name];
    }
    // 第一层是省份 分解出整个省份数组
    self.provinceArr = firstName;
}

// 根据传进来的下标数组计算对应的三个数组
- (void)calculateFirstData
{
    // 拿出省的数组
    [self loadFirstData];
    
    NSMutableArray *cityNameArr = [[NSMutableArray alloc] init];
    // 根据省的index1，默认是0，拿出对应省下面的市
    for (NSDictionary *cityName in [self.addressArr[self.index1] allValues].firstObject) {
        
        NSString *name1 = cityName.allKeys.firstObject;
        [cityNameArr addObject:name1];
    }
    // 组装对应省下面的市
    self.countryArr = cityNameArr;
    //                             index1对应省的字典         市的数组 index2市的字典   对应市的数组
    // 这里的allValue是取出来的大数组，取第0个就是需要的内容
    self.districtArr = [[self.addressArr[self.index1] allValues][0][self.index2] allValues][0];
}

#pragma mark - UIPickerViewDataSource Implementation
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    // Returns
    switch (component)
    {
        case 0: return self.provinceArr.count;
        case 1: return self.countryArr.count;
        case 2:return self.districtArr.count;
        default:break;
    }
    return 0;
}
#pragma mark UIPickerViewDelegate Implementation
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component)
    {
        case 0: return self.provinceArr[row];break;
        case 1: return self.countryArr[row];break;
        case 2:return self.districtArr[row];break;
        default:break;
    }
    return nil;
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* label = (UILabel*)view;
    if (!label)
    {
        label = [[UILabel alloc] init];
        [label setFont:[UIFont systemFontOfSize:14]];
    }
    
    NSString * title = @"";
    switch (component)
    {
        case 0: title =   self.provinceArr[row];break;
        case 1: title =   self.countryArr[row];break;
        case 2: title =   self.districtArr[row];break;
        default:break;
    }
    label.textAlignment = NSTextAlignmentCenter;
    label.text=title;
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (component)
    {
        case 0:
        {
            self.index1 = row;
            self.index2 = 0;
            self.index3 = 0;
            //            [self calculateData];
            // 滚动的时候都要进行一次数组的刷新
            [self calculateFirstData];
            [pickerView reloadComponent:1];
            [pickerView reloadComponent:2];
            [pickerView selectRow:0 inComponent:1 animated:YES];
            [pickerView selectRow:0 inComponent:2 animated:YES];
        }
            break;
            
        case 1:
        {
            self.index2 = row;
            self.index3 = 0;
            //            [self calculateData];
            [self calculateFirstData];
            [pickerView selectRow:0 inComponent:2 animated:YES];
            [pickerView reloadComponent:2];
        }
            break;
        case 2:
            self.index3 = row;
            break;
        default:break;
    }
}

- (void)configurePickerView:(UIPickerView *)pickerView{
    
    pickerView.showsSelectionIndicator = NO;
}

// 点击done的时候回调
- (void)actionSheetPickerDidSucceed:(ActionSheetCustomPicker *)actionSheetPicker origin:(id)origin
{
    
    if (self.index1 < self.provinceArr.count) {
        NSString *firstAddress = self.provinceArr[self.index1];
        
        self.province = firstAddress;
    }
    if (self.index2 < self.countryArr.count) {
        NSString *secondAddress = self.countryArr[self.index2];
        
        self.city = secondAddress;
    }
    if (self.index3 < self.districtArr.count) {
        NSString *thirfAddress = self.districtArr[self.index3];
        
        self.district = thirfAddress;
    }
    
    self.adressName.text = [NSString stringWithFormat:@"%@ %@ %@",self.province,self.city,self.district];
}


- (NSArray *)provinceArr{
    if (_provinceArr == nil) {
        _provinceArr = [[NSArray alloc] init];
    }
    return _provinceArr;
}

-(NSArray *)countryArr{
    if(_countryArr == nil)
    {
        _countryArr = [[NSArray alloc] init];
    }
    return _countryArr;
}

- (NSArray *)districtArr{
    if (_districtArr == nil) {
        _districtArr = [[NSArray alloc] init];
    }
    return _districtArr;
}

-(NSArray *)addressArr{
    if (_addressArr == nil) {
        _addressArr = [[NSArray alloc] init];
    }
    return _addressArr;
}


//#pragma mark - PSCityPickerViewDelegate
//- (void)cityPickerView:(PSCityPickerView *)picker finishPickProvince:(NSString *)province city:(NSString *)city district:(NSString *)district{
//
//    self.province = province;
//
//    self.city = city;
//
//    self.district = district;
//}
//
//-(void)didClickedCancle{
//
//    [UIView animateWithDuration:0.5 animations:^{
//
//        self.cityPicker.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT * 0.45);
//
//    }];
//
//}
//
//-(void)didClickedConfirm{
//
//    [UIView animateWithDuration:0.5 animations:^{
//
//        self.cityPicker.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT * 0.45);
//
//    }];
//
//    if (self.province && self.city && self.district) {
//        //设置日期
//        self.adressName.text = [NSString stringWithFormat:@"%@ %@ %@",self.province,self.city,self.district];
//    }
//}
//#pragma mark - Getter and Setter
//- (PSCityPickerView *)cityPicker
//{
//    if (!_cityPicker)
//    {
//        _cityPicker = [[PSCityPickerView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT * 0.45)];
//        _cityPicker.cityPickerDelegate = self;
//
//    }
//    return _cityPicker;
//}


/**
 添加新地址

 @param sender 确定action
 */
- (IBAction)saveAction:(id)sender {
    
    NSString *uid = [WoDeModel sharedWoDeModel].user_id;
    int isdefault = self.setDefault.on ? 1 : 0;
    
    
    if (self.model) {
        //编辑
        NSDictionary *dic =@{@"uid":uid,@"type":@(5),@"province":self.province,@"city":self.city,@"dist":self.district,@"default":@(isdefault),@"id":@(self.model.lda_id)};
        
        [[SDNetAPIClient sharedSDNetAPIClient] requestJsonDataWithPath:KAddress_URL withParams:dic withMethodType:Post andBlock:^(id data, NSError *error, NSString *errorMsg) {
            
            NSLog(@"%@",data);
            
            if (data && [data [@"status_code"] integerValue] == 10000) {
                

                [self.navigationController popViewControllerAnimated:YES];

            }else{
                
                //提示框
                [YLMBProgressHUD initWithString:data[@"msg"] inSuperView:self.view afterDelay:2];
                
            }
        } isWithSign:YES];

    }else{
       
        //新增
        if (self.province || self.city || self.district) {
            
            NSDictionary *dic =@{@"uid":uid,@"type":@(2),@"province":self.province,@"city":self.city,@"dist":self.district,@"default":@(isdefault)};
            
            [[SDNetAPIClient sharedSDNetAPIClient] requestJsonDataWithPath:KAddress_URL withParams:dic withMethodType:Post andBlock:^(id data, NSError *error, NSString *errorMsg) {
                
                NSLog(@"%@",data);
                
                if (data && [data [@"status_code"] integerValue] == 10000) {
                
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }else{
                    
                    //提示框
                    [YLMBProgressHUD initWithString:data[@"msg"] inSuperView:self.view afterDelay:2];
    
                }
            } isWithSign:YES];
            
        }else{

            [YLMBProgressHUD initWithString:@"信息填写不完整" inSuperView:self.view afterDelay:2];
        }
    }
}

@end
