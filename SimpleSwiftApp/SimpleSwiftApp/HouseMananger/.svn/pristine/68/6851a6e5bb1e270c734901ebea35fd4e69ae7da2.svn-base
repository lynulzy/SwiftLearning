//
//  LoginDataController.h
//  HouseMananger
//
//  Created by ZXH on 15/1/5.
//  Copyright (c) 2015年 ZSXJ. All rights reserved.
//

#import "BaseDataController.h"

@protocol LoginDataControllerDelegate <NSObject>

- (void)onGetLoginReceiveData:(NSDictionary *)receiveDict withReqTag:(NSInteger)tag;

- (void)onGetLoginFailedWithError:(NSError *)error withReqTag:(NSInteger)tag;

@end


@interface LoginDataController : BaseDataController

@property (nonatomic, assign) id<LoginDataControllerDelegate>delegate;

- (void)makeLoginRequest:(NSDictionary *)theParams;

@end
