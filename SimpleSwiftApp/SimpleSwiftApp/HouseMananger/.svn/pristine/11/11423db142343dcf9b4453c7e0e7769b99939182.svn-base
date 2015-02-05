//
//  MyNewsDataController.h
//  HouseMananger
//
//  Created by ZXH on 15/1/12.
//  Copyright (c) 2015年 ZSXJ. All rights reserved.
//

#import "BaseDataController.h"

@protocol MyNewsDataControllerDelegate <NSObject>

// 我的消息
- (void)onGetMyNewsReceiveData:(NSDictionary *)receiveDict withReqTag:(NSInteger)tag;
- (void)onGetMyNewsFailedWithError:(NSError *)error withReqTag:(NSInteger)tag;

@end


@interface MyNewsDataController : BaseDataController

@property (nonatomic, assign) id<MyNewsDataControllerDelegate>delegate;

- (void)mrMyNews:(NSDictionary *)theParams;

@end
