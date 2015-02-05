//
//  CommissionDetailDataController.h
//  HouseMananger
//
//  Created by ZXH on 15/1/14.
//  Copyright (c) 2015年 ZSXJ. All rights reserved.
//

#import "BaseDataController.h"

@protocol CommissionDetailDataControllerDelegate <NSObject>

// 佣金详情
- (void)onGetCommissionDetailReceiveData:(NSDictionary *)receiveDict withReqTag:(NSInteger)tag;
- (void)onGetCommissionDetailFailedWithError:(NSError *)error withReqTag:(NSInteger)tag;

@end

@interface CommissionDetailDataController : BaseDataController
@property (nonatomic, assign) id<CommissionDetailDataControllerDelegate>delegate;

- (void)mrCommissionDetail:(NSDictionary *)theParams;

@end
