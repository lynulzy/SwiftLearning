//
//  ImageFormat.m
//  JiayuanIPad
//
//  Created by TONG YU on 11-8-3.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ImageFormat.h"

@implementation ImageFormat

// Crop image
+ (UIImage *)CropImage:(UIImage*)photoimage cropRatioW:(CGFloat)cropRatioW cropRatioH:(CGFloat)cropRatioH {
	
    CGImageRef imgRef =photoimage.CGImage;
    CGFloat _width = CGImageGetWidth(imgRef);
    CGFloat _height = CGImageGetHeight(imgRef);
	
    CGFloat bounds_size;
	CGImageRef finalImgRef;
	
	// _width		/	_height
	// cropRatioW	/	cropRatioH
	
	if (_width / _height > cropRatioW / cropRatioH) {
		
		// _width > _height
		bounds_size = _height * cropRatioW / cropRatioH;
		
		finalImgRef=CGImageCreateWithImageInRect(imgRef, 
												 CGRectMake((_width - bounds_size)/2, 
															0.0F, 
															bounds_size, 
															_height));
		
	} else {
		
		// _height > _width
		bounds_size = _width * cropRatioH / cropRatioW;
		
		finalImgRef=CGImageCreateWithImageInRect(imgRef, 
												 CGRectMake(0.0F, 
															0.0F, 
															_width, 
															bounds_size));
		
	}
	
	
	
	
	
	
	/*
	// Get UIImage from CGImageRef 
	UIImage *sourceImage = [UIImage imageWithCGImage:finalImgRef];
	CGImageRelease(finalImgRef);
	UIImage *newImage = nil;
	
	CGSize targetSize = CGSizeMake(300.0F, 400.0F);
	
	CGSize imageSize = sourceImage.size;
	CGFloat width = imageSize.width;
	CGFloat height = imageSize.height;
	
	CGFloat targetWidth = targetSize.width;
	CGFloat targetHeight = targetSize.height;
	
	CGFloat scaleFactor = 0.0;
	CGFloat scaledWidth = targetWidth;
	CGFloat scaledHeight = targetHeight;
	
	CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
	
	if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
		
		CGFloat widthFactor = targetWidth / width;
		CGFloat heightFactor = targetHeight / height;
		
		if (widthFactor < heightFactor)
			scaleFactor = widthFactor;
		else
			scaleFactor = heightFactor;
		
		scaledWidth  = width * scaleFactor;
		scaledHeight = height * scaleFactor;
		
		// center the image
		
		if (widthFactor < heightFactor) {
			thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
		} else if (widthFactor > heightFactor) {
			thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
		}
	}
	
	// this is actually the interesting part:
	
	UIGraphicsBeginImageContext(targetSize);
	
	CGRect thumbnailRect = CGRectZero;
	thumbnailRect.origin = thumbnailPoint;
	thumbnailRect.size.width  = scaledWidth;
	thumbnailRect.size.height = scaledHeight;
	
	[sourceImage drawInRect:thumbnailRect];
	
	newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	if (newImage == nil) DLOG(@"could not scale image");
	
	
	return newImage ;
	*/
	
	
	
	
	///*
	// Get UIImage from CGImageRef 
	UIImage *image = [UIImage imageWithCGImage:finalImgRef];
	CGImageRelease(finalImgRef);
	
	// Resize 
	UIImage *newImage = nil;
	UIGraphicsBeginImageContext(CGSizeMake(cropRatioW, cropRatioH));
	[image drawInRect:CGRectMake(0.0F, 0.0F, cropRatioW, cropRatioH)];
	newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return newImage;
	 
	// */
}

+ (UIImage *)mergeImages:(NSArray *)theImgArr withDir:(MergeImageDir)theDir cropRatioW:(CGFloat)cropRatioW cropRatioH:(CGFloat)cropRatioH {
	
	CGFloat mergedWidth = 0.0F;
	CGFloat mergedHeight = 0.0F;
	for (UIImage *_img in theImgArr) {
		if ([_img isKindOfClass:[UIImage class]]) {
			if (MergeImageDir_horizontal == theDir) {
				mergedWidth += _img.size.width;
				if (_img.size.height > mergedHeight)
					mergedHeight = _img.size.height;
			} else {
				if (_img.size.width > mergedWidth)
					mergedWidth = _img.size.width;
				mergedHeight += _img.size.height;
			}
		}
	}
	
	// Resize 
	UIImage *newImage = nil;
	UIGraphicsBeginImageContext(CGSizeMake(mergedWidth, mergedHeight));
	// 
	CGFloat origin_x = 0.0F;
	CGFloat origin_y = 0.0F;
	for (UIImage *_img in theImgArr) {
		if ([_img isKindOfClass:[UIImage class]]) {
			[_img drawInRect:CGRectMake(origin_x, origin_y, _img.size.width, _img.size.height)];
			if (MergeImageDir_horizontal == theDir)
				origin_x += _img.size.width;
			else
				origin_y += _img.size.height;
		}
	}
	
	newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return newImage;
}

@end
