//
//  YLUserInfoController.m
//  WULIU_iOS
//
//  Created by 袁亮 on 2017/8/25.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#import "YLUserInfoController.h"
#import "YLChangeNameController.h"
#import "YLGongSiJinJingrViewController.h"

@interface YLUserInfoController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,YLChangeNameControllerDelegate>

@property(nonatomic,strong)YLMBProgressHUD *hud;

//姓名
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

//头像
@property (weak, nonatomic) IBOutlet UIImageView *user_imageview;
@property(nonatomic,strong)UIImage *user_image;
@property(nonatomic,strong)NSString *userimage_path;

//车辆照片组
@property(nonatomic,strong)NSString *cars_imageStr;


@end

@implementation YLUserInfoController

-(YLMBProgressHUD *)hud{
    if (!_hud) {
        
        _hud = [YLMBProgressHUD initProgressInView:self.view];
    }
    
    return _hud;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title  = @"编辑个人中心";
    
    self.user_imageview.layer.cornerRadius = self.user_imageview.height * 0.5;
    self.user_imageview.layer.masksToBounds = YES;
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self initData];
}

-(void)initData{
    
    //个人信息
    NSDictionary *dic =@{@"uid":@(([WoDeModel sharedWoDeModel].user_id).intValue),@"type":@(6)};
    [[SDNetAPIClient sharedSDNetAPIClient] requestJsonDataWithPath:KUserInfo_URL withParams:dic withMethodType:Post andBlock:^(id data, NSError *error, NSString *errorMsg) {
        
        NSLog(@"33%@",data);
        
        if (data && [data [@"status_code"] integerValue] == 10000) {
          
            
            //名称
            if ( data[@"data"][@"ld_realname"] != [NSNull null]) {
                self.nameLabel.text = data[@"data"][@"ld_realname"];
            }else{
                self.nameLabel.text = @"姓名";
            }
            
            //头像
            if ( data[@"data"][@"ld_headurl"] != [NSNull null]) {
                [self.user_imageview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",kDownImage_URL,data[@"data"][@"ld_headurl"]]] placeholderImage:[UIImage imageNamed:@"login_logo"]];
            }else{
                self.user_imageview.image = [UIImage imageNamed:@"login_logo"];
            }
            
            //车照片
            if( data[@"data"][@"ld_truck_photo"] == [NSNull null]) {
                
                self.cars_imageStr = @"暂无图片数据";
                
                
            }
//            else if (data[@"data"][@"ld_truck_photo"] isEqualToString:<#(nonnull NSString *)#> ){
//             
//                
//            }
            else{
                
                self.cars_imageStr = data[@"data"][@"ld_truck_photo"];
            }
            
            
        
        }else{
            //提示框
            [YLMBProgressHUD initWithString:data[@"msg"] inSuperView:self.view afterDelay:1.5];
        }
    } isWithSign:YES];
}


//修改用户头像
- (IBAction)changeUserNameAction:(UITapGestureRecognizer *)sender {
    
    [self openAlertSheet];
}

#pragma mark - imagePickerDelegate
-(void)openAlertSheet{
    
    //避免循环强引用
    __weak typeof(self) weakSelf = self;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    //取消:style:UIAlertActionStyleCancel
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    
    [alertController addAction:cancelAction];
    //了解更多:style:UIAlertActionStyleDestructive
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"从相册中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [weakSelf selectImage:UIImagePickerControllerSourceTypePhotoLibrary];
        
    }];
    
    [alertController addAction:moreAction];
    
    //原来如此:style:UIAlertActionStyleDefault
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"打开相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [weakSelf selectImage:UIImagePickerControllerSourceTypeCamera];
        
    }];
    
    [alertController addAction:OKAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


- (void)selectImage:(UIImagePickerControllerSourceType)SourceType{
    //调用系统相册的类
    UIImagePickerController *pickerController = [[UIImagePickerController alloc]init];
    //设置选取的照片是否可编辑
    pickerController.allowsEditing = YES;
    
    //设置相册呈现的样式
    pickerController.sourceType = SourceType;
    
    //选择完成图片或者点击取消按钮都是通过代理来操作我们所需要的逻辑过程
    pickerController.delegate = self;
    //使用模态呈现相册
    [self.navigationController presentViewController:pickerController animated:YES completion:nil];
}

#pragma mark -  选择照片完成之后的代理方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    self.user_image = image;
    
    NSData *imagedata = UIImageJPEGRepresentation(image, 0.5);
    
    [self loadImageToServer:imagedata];
    
    //使用模态返回到软件界面
    [self dismissViewControllerAnimated:YES completion:nil];
}

//上传图片至服务器
-(void)loadImageToServer:(NSData *)imagedata{
    if (imagedata) {
        
        [self.hud show:YES];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:kLoadupImage_URL]];
            
            //如果用POST方式需要
            //设置请求方式  默认为GET
            [request setHTTPMethod:@"POST"];
            //把参数添加到请求体里面
            [request setHTTPBody:imagedata];
            
            NSURLSession *session = [NSURLSession sharedSession];
            NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                //NSLog(@"%@-----%@------%@",dic,response,error);
                
                if (response) {
                    
                    //主线程UI操作
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@"________%@",dic[@"data"]);
                        
                        self.userimage_path = dic[@"data"];
                        
                        //本地存储：用户表
                        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                        [user setObject:dic[@"data"] forKey:@"ld_headurl"];
                        
                        [self loadImagePath];
                        
                    });
                }
            }];
            [task resume];
        });
    }
}

-(void)loadImagePath{
    
    //照片路径上传
        NSDictionary *dic =@{@"uid":@(([WoDeModel sharedWoDeModel].user_id).intValue),@"type":@(3),@"headurl":self.userimage_path};
        [[SDNetAPIClient sharedSDNetAPIClient] requestJsonDataWithPath:KUserInfo_URL withParams:dic withMethodType:Post andBlock:^(id data, NSError *error, NSString *errorMsg) {
    
            NSLog(@"33%@",data);
    
            if (data && [data [@"status_code"] integerValue] == 10000) {
    
                 [self.user_imageview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kDownImage_URL,self.userimage_path]]];
    
            }else{
                //提示框
                [YLMBProgressHUD initWithString:data[@"msg"] inSuperView:self.view afterDelay:2];
                
            }
            
            [self.hud hide:YES];
            
        } isWithSign:YES];
}



//修改姓名
- (IBAction)changeNameAction:(UITapGestureRecognizer *)sender {
    
    YLChangeNameController *cvc = [YLChangeNameController new];
    cvc.delegate = self;
    
    [self.navigationController pushViewController:cvc animated:YES];
}

//修改货车照片
- (IBAction)changeCarImage:(UITapGestureRecognizer *)sender {
    
    YLGongSiJinJingrViewController *cvc = [YLGongSiJinJingrViewController new];
    
    [self.navigationController pushViewController:cvc animated:YES];
    
}


#pragma mark - YLChangeNameControllerDelegate
-(void)didChangeName:(NSString *)newName{
    
    self.nameLabel.text = newName;
    
}


@end
