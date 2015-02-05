//
//  ReplyDataController.h
//  HouseMananger
//
//  Created by ZXH on 15/1/19.
//  Copyright (c) 2015年 ZSXJ. All rights reserved.
//

#import "BaseDataController.h"

@protocol ReplyDataControllerDelegate <NSObject>

// 论坛回复
- (void)onGetReplyReceiveData:(NSDictionary *)receiveDict withReqTag:(NSInteger)tag;
- (void)onGetReplyFailedWithError:(NSError *)error withReqTag:(NSInteger)tag;

@end

@interface ReplyDataController : BaseDataController

@property (nonatomic, assign) id<ReplyDataControllerDelegate>delegate;

- (void)mrReply:(NSDictionary *)theParams;

@end
