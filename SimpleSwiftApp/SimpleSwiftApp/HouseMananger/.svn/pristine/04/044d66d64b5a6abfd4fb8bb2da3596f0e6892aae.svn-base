//
//  MineDataController.h
//  HouseMananger
//
//  Created by ZXH on 15/1/5.
//  Copyright (c) 2015年 ZSXJ. All rights reserved.
//

#import "BaseDataController.h"

@protocol MineDataControllerDelegate <NSObject>

// 版本升级
- (void)onGetSoftUpgradeReceiveData:(NSDictionary *)receiveDict withReqTag:(NSInteger)tag;
- (void)onGetSoftUpgradeFailedWithError:(NSError *)error withReqTag:(NSInteger)tag;

@end

@interface MineDataController : BaseDataController

@property (nonatomic, assign) id<MineDataControllerDelegate>delegate;

// 版本升级 soft_upgrade
- (void)mrSoftUpgrade;

@end
