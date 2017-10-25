//
//  SDNetAPIClient.h
//  LZSTestDemo
//
//  Created by  ltf on 16/10/11.
//  Copyright © 2016年 ltf. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef enum {
    Get = 0,
    Post,
    Put,
    Delete
} NetworkMethod;
@interface SDNetAPIClient : AFHTTPSessionManager
+ (SDNetAPIClient *)sharedSDNetAPIClient;

typedef void (^ResponseBlock) ( id  data, NSError *error, NSString *errorMsg);

- (void)requestJsonDataWithPath:(NSString *)aPath
                     withParams:(NSDictionary *)params
                 withMethodType:(NetworkMethod)NetworkMethod
                       andBlock:(ResponseBlock)block
                     isWithSign:(BOOL)isWithSign;
-(void)loadUpImage:(NSData *)imageData errorBlock:(ResponseBlock)block andSucceseeBlock:(ResponseBlock)successblock;
#define SD_NetAPIClient_CONFIG [SDNetAPIClient sharedSDNetAPIClient]
@end



