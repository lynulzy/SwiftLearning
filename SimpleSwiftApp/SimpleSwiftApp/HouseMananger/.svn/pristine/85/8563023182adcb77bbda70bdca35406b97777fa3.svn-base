//
//  VerifyPhoneDataController.h
//  MiShiClient-Pro
//
//  Created by ZXH on 14-10-16.
//  Copyright (c) 2014年 ZSXJ. All rights reserved.
//

#import "BaseDataController.h"

@protocol VerifyPhoneDataControllerDelegate <NSObject>

- (void)onGetReSendSMSData:(NSDictionary *)receiveData withRequestTag:(NSInteger)tag;
- (void)failedGetResendSMSData:(NSError *)error withRequestTag:(NSInteger)tag;

@end


@interface VerifyPhoneDataController : BaseDataController<ReqManagerDelegate>;

@property(nonatomic,assign)id<VerifyPhoneDataControllerDelegate> delegate;
//重新发送短信验证码请求
- (void)makeReSendSMSCodeRequest:(NSDictionary *)theParams;

@end
