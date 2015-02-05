//
//  MessageModel.h
//  HouseMananger
//
//  Created by 王晗 on 15-1-8.
//  Copyright (c) 2015年 王晗. All rights reserved.
//

#import "WXBaseModel.h"

@interface MessageModel : WXBaseModel
@property (nonatomic,copy)NSString * agent_id;
@property (nonatomic,copy)NSString * content;
@property (nonatomic,copy)NSString * create_time;
@property (nonatomic,copy)NSString * msgId;
@property (nonatomic,copy)NSString * title;

@end
