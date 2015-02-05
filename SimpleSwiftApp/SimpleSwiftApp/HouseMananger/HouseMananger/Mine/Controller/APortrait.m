//
//  APortrait.m
//  HouseMananger
//
//  Created by ZXH on 15/1/21.
//  Copyright (c) 2015年 ZSXJ. All rights reserved.
//

#import "APortrait.h"
#import "MD5.h"
#import "UserTmpParam.h"

@interface APortrait ()

@end

@implementation APortrait

// 判断头像文件是否存在本地
+ (BOOL)isExist {
    
    BOOL isExist;
    if ([UserTmpParam getPortraitUrl].length == 0 || nil == [UserTmpParam getPortraitUrl] || [[UserTmpParam getPortraitUrl] isEqual:[NSNull null]]) {
        isExist = NO;
        return isExist;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *picName = [NSString stringWithFormat:@"%@.jpg", [MD5 md5:[UserTmpParam getPortraitUrl]]];
    NSString *imageFilePath = [documentsDirectory stringByAppendingPathComponent:picName];
    isExist = [fileManager fileExistsAtPath:imageFilePath];
    return isExist;
}

// 读取本地头像文件
+ (UIImage *)getThePortrait {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *picName = [NSString stringWithFormat:@"%@.jpg", [MD5 md5:[UserTmpParam getPortraitUrl]]];
    NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:picName];
    UIImage *portraitImage = [UIImage imageWithContentsOfFile:imagePath];
    
    return portraitImage;
}

// 保存头像文件
+ (BOOL)saveThePortrait:(NSData *)imageData {
    
    BOOL isExist;
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *picName = [NSString stringWithFormat:@"%@.jpg", [MD5 md5:[UserTmpParam getPortraitUrl]]];
    NSString *imageFilePath = [documentsDirectory stringByAppendingPathComponent:picName];
    isExist = [fileManager fileExistsAtPath:imageFilePath];
    if (isExist) {
        isExist = [fileManager removeItemAtPath:imageFilePath error:&error];
    }
    BOOL result = [imageData writeToFile:imageFilePath atomically:YES];// 写入本地
    
    return result;
}

@end
