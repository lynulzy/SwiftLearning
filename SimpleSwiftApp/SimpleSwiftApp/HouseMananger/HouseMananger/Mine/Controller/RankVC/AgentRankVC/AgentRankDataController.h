//
//  AgentRankDataController.h
//  HouseMananger
//
//  Created by ZXH on 15/2/3.
//  Copyright (c) 2015年 ZSXJ. All rights reserved.
//

#import "BaseDataController.h"

@protocol AgentRankDataControllerDelegate <NSObject>

- (void)onGetAgentRankListReceiveData:(NSDictionary *)receiveDict withReqTag:(NSInteger)tag;
- (void)onGetAgentRankListFailedWithError:(NSError *)error withReqTag:(NSInteger)tag;

@end


@interface AgentRankDataController : BaseDataController

@property (nonatomic, assign) id<AgentRankDataControllerDelegate>delegate;

- (void)mrAgentRankList:(NSDictionary *)theParams;

@end
