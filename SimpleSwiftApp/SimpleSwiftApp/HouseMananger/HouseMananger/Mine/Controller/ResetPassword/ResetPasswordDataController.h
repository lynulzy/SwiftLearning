//
//  ResetPasswordDataController.h
//  HouseMananger
//
//  Created by ZXH on 15/1/9.
//  Copyright (c) 2015年 ZSXJ. All rights reserved.
//

#import "BaseDataController.h"

@protocol ResetPasswordDataControllerDelegate <NSObject>

- (void)onGetResetPSWRequest:(NSDictionary *)receiveData withTag:(NSInteger)tag;

- (void)failedGetResetPSWRequest:(NSError *)error withTag:(NSInteger)tag;

@end

@interface ResetPasswordDataController : BaseDataController

@property(nonatomic,assign) id<ResetPasswordDataControllerDelegate> delegate;

- (void)mrResetPassword:(NSDictionary *)theParams;

@end
