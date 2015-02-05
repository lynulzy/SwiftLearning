//
//  BuildingDataController.h
//  HouseMananger
//
//  Created by 王晗 on 15/1/27.
//  Copyright (c) 2015年 王晗. All rights reserved.
//

#import "BaseDataController.h"
@protocol BuildingDataControllerDelegate <NSObject>

// 
- (void)onGetBuildingReceiveData:(NSDictionary *)receiveDict withReqTag:(NSInteger)tag;
- (void)onGetBuildingFailedWithError:(NSError *)error withReqTag:(NSInteger)tag;

@end

@interface BuildingDataController : BaseDataController

@property (nonatomic, assign) id<BuildingDataControllerDelegate>delegate;

- (void)mrBuilding:(NSDictionary *)theParams;

@end
