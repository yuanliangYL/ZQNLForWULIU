//
//  SDNetAPIClient.m
//  LZSTestDemo
//
//  Created by  ltf on 16/10/11.
//  Copyright © 2016年 ltf. All rights reserved.
//

#import "SDNetAPIClient.h"

@implementation SDNetAPIClient

+ (SDNetAPIClient *)sharedSDNetAPIClient {
    
    static SDNetAPIClient *_sharedNetAPIClient = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        //主机的host地址
        _sharedNetAPIClient = [[SDNetAPIClient alloc] initWithBaseURL:[NSURL URLWithString:kBase_URL]];
        
    });
    return _sharedNetAPIClient;
}
/**
 * 初始化主URL  头信息
 */
- (id)initWithBaseURL:(NSURL *)Base_URL {
    
    self = [super initWithBaseURL:Base_URL];
    
    if (!self) {
        
        return nil;
    }
    
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    //[self.requestSerializer setHTTPShouldHandleCookies:NO];
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
    
    [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [self.requestSerializer setValue:@"Keep-Alive" forHTTPHeaderField:@"connect"];
    
    //设置请求时间
    [self.requestSerializer setTimeoutInterval:15];  //Time out after 25 seconds
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    [securityPolicy setValidatesDomainName:NO];
    self.securityPolicy = securityPolicy;
    
    return self;
}

- (void)requestJsonDataWithPath:(NSString *)aPath
                     withParams:(NSDictionary *)params
                 withMethodType:(NetworkMethod)NetworkMethod
                       andBlock:(ResponseBlock)block
                     isWithSign:(BOOL)isWithSign{
    
    aPath = [aPath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    __weak typeof(self) weakSelf = self;
    
    NSMutableDictionary *MDic = [params mutableCopy];
    
    if (isWithSign) {
        MDic[@"sign"] = [self signByDic:MDic];
        
        NSLog(@"%@",MDic[@"sign"]);
    }
    
    params = [MDic copy];
    
    NSLog(@"%@",params);
    
    switch (NetworkMethod) {
            
        case Get: {
            
            [weakSelf GET:aPath parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                block(responseObject,nil,nil);
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                block(nil,error,nil);
                
            }];
            
            break;
        }
            
        case Post: {
            
            
            [weakSelf POST:aPath parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
                
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                block(responseObject,nil,nil);
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                block(nil,error,nil);
                
            }];
            
            break;
        }
            
        case Put: {
            
            [weakSelf PUT:aPath parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                block(responseObject,nil,nil);
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                block(nil,error,nil);
                
            }];
            
            break;
        }
            
        case Delete: {
            
            [weakSelf DELETE:aPath parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                block(responseObject,nil,nil);
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                block(nil,error,nil);
                
                
            }];
            break;
        }
        default:
            break;
    }
    
}


/**
 根据字典Key设置签名

 @param dic 数据字典
 @return 签名字段
 */
- (NSString *)signByDic:(NSDictionary *)dic{
    
    __block NSString *sign = @"";
    
    NSArray *keyArray = [dic allKeys];
    if (dic.count <= 0) {
        return sign;
    }
    
    //数组排序
    [[keyArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        return [obj1 compare:obj2 options:NSNumericSearch];
        
    }] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        sign = [sign stringByAppendingString:[NSString stringWithFormat:@"%@=%@&",obj,dic[obj]]];
        
        
//        NSLog(@"%@",sign);
    }];
    
    NSLog(@"%@",[sign stringByAppendingString:@"key=pass4zhiqunale"]);

    
    return [[sign stringByAppendingString:@"key=pass4zhiqunale"] MD5];
    
}

-(void)loadUpImage:(NSData *)imageData errorBlock:(ResponseBlock)block andSucceseeBlock:(ResponseBlock)successblock{
    
    if (imageData) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:kLoadupImage_URL]];
            
            //如果用POST方式需要
            //    设置请求方式  默认为GET
            [request setHTTPMethod:@"POST"];
            
            //把参数添加到请求体里面
            [request setHTTPBody:imageData];
            
            NSURLSession *session = [NSURLSession sharedSession];
            NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                
                if (response) {
                    
                    successblock(dic,nil,nil);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //刷新界面
                    });
                    
                    
                }else{
                    
                    block(error,nil,nil);
                }
                
                
            }];
            
            [task resume];
            
        });
        
    }
}
//- (NSString *)parametersWithDictionary:(NSDictionary *)dic {
//    
//    NSArray *allkey = [dic allKeys];
//    NSArray *newArr = [allkey sortedArrayUsingSelector:@selector(compare:)];
//    NSMutableString *string = [NSMutableString string];
//    
//    for (NSString *re in newArr) {
//        
//        [string appendFormat:@"%@=%@&",re,dic[re]] ;
//    }
//    [string appendString:@"key=pass4zhiqunale"];
//    return string;
//}
@end
