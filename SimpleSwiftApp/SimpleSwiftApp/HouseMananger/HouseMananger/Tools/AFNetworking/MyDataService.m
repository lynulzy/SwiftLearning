//
//  MyDataService.m
//  01 NavigationTask
//
//  Created by wei.chen on 14-9-5.
//  Copyright (c) 2014年 . All rights reserved.
//

#import "MyDataService.h"

#import "MD5.h"
#import "Common.h"

@implementation MyDataService




//NSData
- (AFHTTPRequestOperation *)requestAFURL:(NSString *)urlstring
                              httpMethod:(NSString *)method
                                  params:(NSMutableDictionary *)params
                                    data:(NSMutableDictionary *)datas
                                actValue:(NSString *)actValue
                               timeStamp:(NSString *)timeStamp
                             complection:(void(^)(id result))block; {

//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];

    [params setObject:actValue forKey:@"act"];

    [params setObject:timeStamp forKey:@"timestamp"];
    
    [params setObject:@"666669" forKey:@"app_id"];
    [params setObject:@"a5537b0f0b0438dbedf7eaa8372d4f85" forKey:@"app_secret"];
    [params setObject:@"u2fsdgvkX18" forKey:@"session_key"];
    
    //签名参数
    NSString *str =[NSString stringWithFormat:@"%@%@%@%@%@%@%@",
                    actValue,
                    [params objectForKey:@"app_id"],
                    [params objectForKey:@"app_secret"],
                    [params objectForKey:@"session_key"],
                    timeStamp,
                    [params objectForKey:@"data"],
                    @"*)8.~1`@X=^7!%#K;_$-"
                    ];
    NSString * sigStr = [[MD5 md5:str] lowercaseString];
    [params setObject:sigStr forKey:@"sig"];
//    act+app_id+ app_secret + session_key + timestamp +content+key
    

    NSLog(@"%@",params);
    
    //将token添加到请求参数中
//    [params setObject:accessToken forKey:@"access_token"];
    
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    AFHTTPRequestOperation *operation = nil;
    
    if ([method isEqualToString:@"GET"]) {
        
        operation = [manager GET:urlstring parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            block(responseObject);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"网络请求失败:%@",error);
            
        }];
    }
    else if([method isEqualToString:@"POST"]) {
        
        if (datas != nil) { //判断是否有文件需要上传
        
            //上传文件的POST请求
            operation = [manager POST:urlstring parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                
                //将需要上传的文件数据添加到formData
                
                //循环遍历需要上的文件数据
                for (NSString *name in datas) {
                    NSData *data = datas[name];
                    [formData appendPartWithFileData:data name:name fileName:name mimeType:@"image/jpeg"];
                    
                }
                
            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                block(responseObject);
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
                NSLog(@"网络请求失败：%@",error);
            }];
            
            //设置上传的进度监听
            /**
             *
             *  @param bytesWritten              一个数据包的大小
             *  @param totalBytesWritten         已经上传的数据大小
             *  @param totalBytesExpectedToWrite 文件总大小
             *
             *  @return <#return value description#>
             */
//            [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
//               
//                CGFloat progress = totalBytesWritten/(CGFloat)totalBytesExpectedToWrite;
//                NSLog(@"进度：%.1f",progress);
//                
//            }];
            
        } else {
            
            operation = [manager POST:urlstring parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                block(responseObject);
//                NSLog(@"%@",self);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
//                [[NSNotificationCenter defaultCenter] postNotificationName:REQDATA_ERROR_NOTIFI object:self userInfo:nil];
                _failureBlock();
                NSLog(@"网络请求失败：%@",error);
                
            }];            
        }
    }
    return operation;
}
//网络链接改变时会调用的方法
-(void)reachabilityChanged:(NSNotification *)note
{
    Reachability *currReach = [note object];
    NSParameterAssert([currReach isKindOfClass:[Reachability class]]);
    
    //对连接改变做出响应处理动作
    NetworkStatus status = [currReach currentReachabilityStatus];
    NSLog(@"%ld",status);
    //如果没有连接到网络就弹出提醒实况
    if(status == NotReachable)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络连接异常" message:@"暂无法访问书城信息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络连接信息" message:@"网络连接正常" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}

@end
