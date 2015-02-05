//
//  UserSuggestDataController.h
//  MiShiClient-Pro
//
//  Created by ZXH on 14/12/23.
//  Copyright (c) 2014年 ZSXJ. All rights reserved.
//

#import "BaseDataController.h"

@protocol UserSuggestDataControllerDelegate <NSObject>

- (void)onSendUserSuggestData:(NSInteger)tag receiveData:(NSMutableDictionary *)data;
- (void)onSendUserSuggestRequestError:(NSInteger)tag error:(NSError *)error;

@end

@interface UserSuggestDataController : BaseDataController

@property(nonatomic, strong) id<UserSuggestDataControllerDelegate> delegate;

- (void)mrUserSuggest:(NSDictionary *)theParams;

@end
