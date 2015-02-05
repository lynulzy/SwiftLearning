//
//  MyDataService.h
//  01 NavigationTask
//
//  Created by wei.chen on 14-9-5.
//  Copyright (c) 2014年  All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "Reachability.h"
typedef void (^Failure)();
@interface MyDataService : NSObject
@property (nonatomic,copy)Failure failureBlock;
@property (nonatomic,strong)Reachability * hostReach;

//普通的请求
//+ (void)requestURL:(NSString *)urlstring
//        httpMethod:(NSString *)method
//            params:(NSMutableDictionary *)params
//       complection:(void(^)(id result))block;

//上传文件的请求
- (AFHTTPRequestOperation *)requestAFURL:(NSString *)urlstring
                              httpMethod:(NSString *)method
                                  params:(NSMutableDictionary *)params
                                    data:(NSMutableDictionary *)datas
                                actValue:(NSString *)actValue
                               timeStamp:(NSString *)timeStamp
                             complection:(void(^)(id result))block;
@end
