//
//  CommissionDataController.h
//  HouseMananger
//
//  Created by ZXH on 15/1/13.
//  Copyright (c) 2015年 ZSXJ. All rights reserved.
//

#import "BaseDataController.h"

@protocol CommissionDataControllerDelegate <NSObject>

@optional
// 已结佣金
- (void)onGetFinishCommissionReceiveData:(NSDictionary *)receiveDict withReqTag:(NSInteger)tag;
- (void)onGetFinishCommissionFailedWithError:(NSError *)error withReqTag:(NSInteger)tag;

// 待结佣金
- (void)onGetCommissionReceiveData:(NSDictionary *)receiveDict withReqTag:(NSInteger)tag;
- (void)onGetCommissionFailedWithError:(NSError *)error withReqTag:(NSInteger)tag;

@end

@interface CommissionDataController : BaseDataController

@property (nonatomic, assign) id<CommissionDataControllerDelegate>delegate;

- (void)mrFinishCommission:(NSDictionary *)theParams;

- (void)mrCommission:(NSDictionary *)theParams;

@end
