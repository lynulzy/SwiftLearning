//
//  CustomerAFDataController.h
//  HouseMananger
//
//  Created by ZXH on 15/1/26.
//  Copyright (c) 2015年 ZSXJ. All rights reserved.
//

#import "BaseDataController.h"

@protocol CustomerAFDataControllerDelegate <NSObject>

// 已报备客户列表
- (void)onGetCustomerAFReceiveData:(NSDictionary *)receiveDict withReqTag:(NSInteger)tag;
- (void)onGetCustomerAFFailedWithError:(NSError *)error withReqTag:(NSInteger)tag;

@end

@interface CustomerAFDataController : BaseDataController

@property (nonatomic, assign) id<CustomerAFDataControllerDelegate>delegate;

// 已报备客户列表
- (void)mrCustomerAF:(NSDictionary*)theParams;

@end
