//
//  RegistDataController.h
//  MiShiClient-Pro
//
//  Created by ZXH on 14-10-16.
//  Copyright (c) 2014年 ZSXJ. All rights reserved.
//

#import "BaseDataController.h"

@protocol RegistDataControllerDelegate <NSObject>
// 注册请求回调
- (void)onGetRegistData:(NSDictionary *)receiveDict withReqTag:(NSInteger)tag;
- (void)onFailedGetRegistData:(NSError *)error witReqTag:(NSInteger)tag;
@end


@interface RegistDataController : BaseDataController<ReqManagerDelegate>

@property (nonatomic,assign)id<RegistDataControllerDelegate> delegate;
// 注册
- (void)makeRegistRequest:(NSDictionary *)theParams;

@end
