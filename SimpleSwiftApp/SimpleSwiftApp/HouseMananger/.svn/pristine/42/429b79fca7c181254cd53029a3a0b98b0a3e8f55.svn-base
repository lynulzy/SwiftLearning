//
//  TalkingDetailDataController.h
//  HouseMananger
//
//  Created by ZXH on 15/1/16.
//  Copyright (c) 2015年 ZSXJ. All rights reserved.
//

#import "BaseDataController.h"

@protocol TalkingDetailDataControllerDelegate <NSObject>

// 动态详情
- (void)onGetTalkingDetailReceiveData:(NSDictionary *)receiveDict withReqTag:(NSInteger)tag;
- (void)onGetTalkingDetailFailedWithError:(NSError *)error withReqTag:(NSInteger)tag;

@end

@interface TalkingDetailDataController : BaseDataController

@property (nonatomic, assign) id<TalkingDetailDataControllerDelegate>delegate;

- (void)mrTalkingDetail:(NSDictionary *)theParams;

@end
