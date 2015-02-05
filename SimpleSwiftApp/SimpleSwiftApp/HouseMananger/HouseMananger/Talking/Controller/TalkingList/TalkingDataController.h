//
//  TalkingDataController.h
//  HouseMananger
//
//  Created by ZXH on 15/1/15.
//  Copyright (c) 2015年 ZSXJ. All rights reserved.
//

#import "BaseDataController.h"

@protocol TalkingDataControllerDelegate <NSObject>

// 论坛列表
- (void)onGetTalkingListReceiveData:(NSDictionary *)receiveDict withReqTag:(NSInteger)tag;
- (void)onGetTalkingListFailedWithError:(NSError *)error withReqTag:(NSInteger)tag;

@end

@interface TalkingDataController : BaseDataController

@property (nonatomic, assign) id<TalkingDataControllerDelegate>delegate;

- (void)mrTalkingList:(NSDictionary *)theParams;

@end
