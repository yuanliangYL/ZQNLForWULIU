//
//  YLGongSiAddPhotonsViewController.m
//  ZQNLForPackagingStation
//
//  Created by Miaomiao Dai on 2017/9/8.
//  Copyright © 2017年 Albert Yuan. All rights reserved.
//

#import "YLGongSiAddPhotonsViewController.h"
#import "YLJinJingCollectionViewCell.h"

@interface YLGongSiAddPhotonsViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,TZImagePickerControllerDelegate>{
    CGFloat _itemWH;
    CGFloat _margin;
}

@property (nonatomic ,strong) UICollectionView *collectionView;
@property (nonatomic ,strong) NSMutableArray *photosArray;
@property (nonatomic ,strong) NSMutableArray *assestArray;
@property BOOL isSelectOriginalPhoto;

//新的图片路径
@property(nonatomic,strong)NSString *carstrPath;


@property(nonatomic,strong)YLMBProgressHUD *hud;


@end

@implementation YLGongSiAddPhotonsViewController

-(YLMBProgressHUD *)hud{
    
    if (!_hud) {
        
        _hud = [YLMBProgressHUD initProgressInView:self.view];
    }
    
    return _hud;
}


- (NSMutableArray *)photosArray{
    if (!_photosArray) {
        self.photosArray = [NSMutableArray array];
    }
    return _photosArray;
}

- (NSMutableArray *)assestArray{
    if (!_assestArray) {
        self.assestArray = [NSMutableArray array];
    }
    return _assestArray;
}

-(UICollectionView *)collectionView{
    
    if (!_collectionView) {
        
        _margin = 20;
        _itemWH = (self.view.bounds.size.width - 3 * _margin ) / 2 ;
        UICollectionViewFlowLayout *flowLayOut = [[UICollectionViewFlowLayout alloc] init];
        flowLayOut.itemSize = CGSizeMake((SCREEN_WIDTH - 60)/ 2, (SCREEN_WIDTH - 60)/ 2);
        flowLayOut.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT -64) collectionViewLayout:flowLayOut];
        
        _collectionView.backgroundColor = [UIColor whiteColor];
        
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([YLJinJingCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:@"collection"];
        self.collectionView.scrollEnabled = NO;
    }
    return _collectionView;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.title = @"添加图片";
    
    if (![self.carPhotosStr isEqualToString:@"暂无图片数据"]) {
        
        self.carstrPath = self.carPhotosStr;

    }
    
    [self.view addSubview:self.collectionView];
    
}

#pragma mark ------------------collectionView ---------------------
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _photosArray.count+1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    YLJinJingCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collection" forIndexPath:indexPath];
    
    if (indexPath.row == _photosArray.count) {
        
        cell.imageView.image = [UIImage imageNamed:@"renzheng_shangchuan"];
      
        cell.deletBtn.hidden = YES;
        
    }else if (indexPath.row>=9) {
        
        cell.imageView.hidden = YES;
        cell.deletBtn.hidden = YES;
        
    }else{
        
        cell.imageView.image = _photosArray[indexPath.row];
        cell.deletBtn.hidden = YES;
        
    }
//    cell.deletBtn.tag = 100 + indexPath.row;
//    [cell.deletBtn addTarget:self action:@selector(deletePhotos:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == _photosArray.count) {
        
        [self checkLocalPhoto];
        
    }else{
        
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:_assestArray selectedPhotos:_photosArray index:indexPath.row];
        imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
        
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            _photosArray = [NSMutableArray arrayWithArray:photos];
            _assestArray = [NSMutableArray arrayWithArray:assets];
            _isSelectOriginalPhoto = isSelectOriginalPhoto;
            [_collectionView reloadData];
            _collectionView.contentSize = CGSizeMake(0, ((_photosArray.count + 2) / 2 ) * (_margin + _itemWH));
        }];
        
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    }
}


- (void)deletePhotos:(UIButton *)sender{
    
    [_photosArray removeObjectAtIndex:sender.tag - 100];
    [_assestArray removeObjectAtIndex:sender.tag - 100];
    [_collectionView performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag-100 inSection:0];
        [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
        [_collectionView reloadData];
    } completion:^(BOOL finished) {
        [_collectionView reloadData];
    }];
}

#pragma mark-----------------选择图片---------
- (void)checkLocalPhoto{
    
    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    [imagePicker setSortAscendingByModificationDate:NO];
    imagePicker.isSelectOriginalPhoto = _isSelectOriginalPhoto;
    imagePicker.selectedAssets = _assestArray;
    imagePicker.allowPickingVideo = NO;
    imagePicker.cancelBtnTitleStr = @"取消";
    imagePicker.doneBtnTitleStr = @"完成";
    imagePicker.previewBtnTitleStr = @"预览";
    imagePicker.fullImageBtnTitleStr = @"原图";
    imagePicker.naviBgColor = YLNaviColor;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}


- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
    
    [self.hud show:YES];
    
    self.photosArray = [NSMutableArray arrayWithArray:photos];
    self.assestArray = [NSMutableArray arrayWithArray:assets];
    _isSelectOriginalPhoto = isSelectOriginalPhoto;
    
    //创建一个串行队列
     dispatch_queue_t queue = dispatch_queue_create("loadimage.queue", DISPATCH_QUEUE_SERIAL);
    
     for (int i = 0; i < self.photosArray.count; i ++) {
        
        //异步执行:开启一个新线程
        dispatch_async(queue, ^{
            
            //NSLog(@"%d:------%@",i,[NSThread currentThread]);
    
            [self loadImageToServe:self.photosArray[i] withIndex:(i+1)];
        });
    }

    [_collectionView reloadData];
}


-(void)loadImageToServe:(UIImage *)image withIndex:(int)i{

    @synchronized(self){
        
        NSData *imagedata = UIImageJPEGRepresentation(image, 0.6);
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:kLoadupImage_URL]];
        //如果用POST方式需要
        //设置请求方式默认为GET
        [request setHTTPMethod:@"POST"];
        //把参数添加到请求体里面
        [request setHTTPBody:imagedata];
        
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
             NSLog(@"_______%@______",dic);
            
            if([dic[@"code"] integerValue] == 10000) {
                //主线程UI操作
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    //第一次上传
                    if (self.carstrPath.length == 0) {
                        
                        self.carstrPath = dic[@"data"];
                        
                    }else{
                        
                        //之前有图片地址
                        self.carstrPath = [NSString stringWithFormat:@"%@,%@",self.carstrPath,dic[@"data"]];
                    }
                    
                    NSLog(@"%@",self.carstrPath);
                    
                    if (i == self.photosArray.count) {
                        
                        [self loadImagePath];
                        
                        [self.hud hide:YES];
                    }
                });
            }
        }];
        
        [task resume];
    
    }
}

-(void)loadImagePath{
    
    if (self.carstrPath) {
        
         NSDictionary *dic =  dic =@{@"uid":@(([WoDeModel sharedWoDeModel].user_id).intValue),@"type":@(2),@"car_photos":self.carstrPath};
        
        [[SDNetAPIClient sharedSDNetAPIClient] requestJsonDataWithPath:KUserInfo_URL withParams:dic withMethodType:Post andBlock:^(id data, NSError *error, NSString *errorMsg) {
            
            NSLog(@"33%@",data);
            
            if (data && [data [@"status_code"] integerValue] == 10000) {
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }else{
                
                //提示框
                [YLMBProgressHUD initWithString:data[@"msg"] inSuperView:self.view afterDelay:2];
                
            }
            
        } isWithSign:YES];
        
    }else{
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}


@end
