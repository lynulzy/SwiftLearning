//
//  PublishDataController.h
//  MiShiClient-Pro
//
//  Created by ZXH on 14/11/10.
//  Copyright (c) 2014年 zsxj. All rights reserved.
//

#import "BaseDataController.h"

@protocol PublishDataControllerDelegate <NSObject>

- (void)onGetPublishData:(NSInteger)tag receiveData:(NSMutableDictionary *)data;
- (void)onGetPublishRequestError:(NSInteger)tag error:(NSError *)error;

@end


@interface PublishDataController : BaseDataController<ReqManagerDelegate>

@property(nonatomic, strong) id<PublishDataControllerDelegate> delegate;
@property(nonatomic, copy) NSString *interfaceString;//接口

- (void)mrPublishQuestion:(NSDictionary *)theParams;

@end
