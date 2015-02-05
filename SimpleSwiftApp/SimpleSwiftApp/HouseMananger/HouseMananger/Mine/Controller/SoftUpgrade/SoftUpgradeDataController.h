//
//  SoftUpgradeDataController.h
//  HouseMananger
//
//  Created by ZXH on 15/1/21.
//  Copyright (c) 2015年 ZSXJ. All rights reserved.
//

#import "BaseDataController.h"

@protocol SoftUpgradeDataControllerDelegate <NSObject>

// 版本升级
- (void)onGetSoftUpgradeReceiveData:(NSDictionary *)receiveDict withReqTag:(NSInteger)tag;
- (void)onGetSoftUpgradeFailedWithError:(NSError *)error withReqTag:(NSInteger)tag;

@end


@interface SoftUpgradeDataController : BaseDataController

@property (nonatomic, assign) id<SoftUpgradeDataControllerDelegate>delegate;

// 版本升级 soft_upgrade
- (void)mrSoftUpgrade;

@end
