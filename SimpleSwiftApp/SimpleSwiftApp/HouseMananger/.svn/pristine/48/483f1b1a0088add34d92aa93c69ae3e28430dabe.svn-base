//
//  BuildRankDataController.h
//  HouseMananger
//
//  Created by ZXH on 15/2/3.
//  Copyright (c) 2015年 ZSXJ. All rights reserved.
//

#import "BaseDataController.h"

@protocol BuildRankDataControllerDelegate <NSObject>

- (void)onGetBuildRankListReceiveData:(NSDictionary *)receiveDict withReqTag:(NSInteger)tag;
- (void)onGetBuildRankListFailedWithError:(NSError *)error withReqTag:(NSInteger)tag;

@end


@interface BuildRankDataController : BaseDataController

@property (nonatomic, assign) id<BuildRankDataControllerDelegate>delegate;

- (void)mrBuildRankList:(NSDictionary *)theParams;

@end
