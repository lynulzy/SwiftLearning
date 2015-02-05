//
//  ImageFormat.h
//  JiayuanIPad
//
//  Created by TONG YU on 11-8-3.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef enum {
	MergeImageDir_vertical,		// 垂直方向 0 
	MergeImageDir_horizontal	// 水平方向 1 
}MergeImageDir;

@interface ImageFormat : NSObject {
    
}

// Crop image 
+ (UIImage *)CropImage:(UIImage*)photoimage cropRatioW:(CGFloat)cropRatioW cropRatioH:(CGFloat)cropRatioH;

// Merge images 
+ (UIImage *)mergeImages:(NSArray *)theImgArr withDir:(MergeImageDir)theDir cropRatioW:(CGFloat)cropRatioW cropRatioH:(CGFloat)cropRatioH;

@end
