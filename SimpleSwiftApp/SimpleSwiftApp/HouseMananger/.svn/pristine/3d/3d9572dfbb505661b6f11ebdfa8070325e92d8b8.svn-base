//
//  ResetCodeDataController.h
//  MiShiClient-Pro
//
//  Created by ZSXJ on 14/10/21.
//  Copyright (c) 2014年 zsxj. All rights reserved.
//

#import "BaseDataController.h"

@protocol ResetCodeDataControllerDelegate <NSObject>

- (void)onGetResetRequest:(NSDictionary *)receiveData andTag:(NSInteger)tag;

- (void)failedResetRequest:(NSError *)error andTag:(NSInteger)tag;

@end


@interface ResetCodeDataController : BaseDataController<ReqManagerDelegate>

@property(nonatomic,assign) id<ResetCodeDataControllerDelegate>  delegate;

- (void)makeResetCodeRequest:(NSDictionary *)theParams;


@end
