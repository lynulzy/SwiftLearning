//
//  EditMyInfoDataController.h
//  HouseMananger
//
//  Created by ZXH on 15/1/14.
//  Copyright (c) 2015年 王晗. All rights reserved.
//

#import "BaseDataController.h"

@protocol EditMyInfoDataControllerDelegate <NSObject>

// 修改头像
- (void)onGetEditPortraitReceiveData:(NSDictionary *)receiveDict withReqTag:(NSInteger)tag;
- (void)onGetEditPortraitFailedWithError:(NSError *)error withReqTag:(NSInteger)tag;

// 修改姓名
- (void)onGetEditUserReceiveData:(NSDictionary *)receiveDict withReqTag:(NSInteger)tag;
- (void)onGetEditUserFailedWithError:(NSError *)error withReqTag:(NSInteger)tag;

// 退出登录
- (void)onGetSignOutReceiveData:(NSDictionary *)receiveDict withReqTag:(NSInteger)tag;
- (void)onGetSignOutFailedWithError:(NSError *)error withReqTag:(NSInteger)tag;

@end


@interface EditMyInfoDataController : BaseDataController

@property (nonatomic, assign) id<EditMyInfoDataControllerDelegate>delegate;

- (void)mrEditPortrait:(NSDictionary *)theParams;
- (void)mrEditUser:(NSDictionary *)theParams;

// 退出登录
- (void)mrSignOut;
@end
