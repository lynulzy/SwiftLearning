//
//  TheAssetPickerController.h
//  MiShiClient-Pro
//
//  Created by ZXH on 14/10/27.
//  Copyright (c) 2014年 zsxj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

#pragma mark - TheAssetPickerController
@protocol TheAssetPickerControllerDelegate;

@interface TheAssetPickerController : UINavigationController

@property (nonatomic, weak) id <UINavigationControllerDelegate, TheAssetPickerControllerDelegate> delegate;
@property (nonatomic, strong) ALAssetsFilter *assetsFilter;
@property (nonatomic, copy, readonly) NSArray *indexPathsForSelectedItems;
@property (nonatomic, assign) NSInteger maximumNumberOfSelection;
@property (nonatomic, assign) NSInteger minimumNumberOfSelection;
@property (nonatomic, strong) NSPredicate *selectionFilter;
@property (nonatomic, assign) BOOL showCancelButton;
@property (nonatomic, assign) BOOL showEmptyGroups;
@property (nonatomic, assign) BOOL isFinishDismissViewController;

@end

@protocol TheAssetPickerControllerDelegate <NSObject>
//点击 完成按钮 之后的回调
-(void)assetPickerController:(TheAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets;
@optional
-(void)assetPickerControllerDidCancel:(TheAssetPickerController *)picker;//相册列表取消按钮点击后调用
-(void)assetPickerController:(TheAssetPickerController *)picker didSelectAsset:(ALAsset*)asset;//每选一张照片后
-(void)assetPickerController:(TheAssetPickerController *)picker didDeselectAsset:(ALAsset*)asset;//每去掉选择一张照片
-(void)assetPickerControllerDidMaximum:(TheAssetPickerController *)picker;//选择照片超过最大值时
-(void)assetPickerControllerDidMinimum:(TheAssetPickerController *)picker;//选择照片不够最小值时
@end

#pragma mark - TheAssetViewController
@interface TheAssetViewController : UITableViewController
@property (nonatomic, strong) ALAssetsGroup *assetsGroup;
@property (nonatomic, strong) NSMutableArray *indexPathsForSelectedItems;
@end

#pragma mark - TheVideoTitleView
@interface TheVideoTitleView : UILabel
@end

#pragma mark - TheTapCheckAssetView
@protocol TheTapCheckAssetViewDelegate <NSObject>
-(void)touchCheck;
@end

@interface TheTapCheckAssetView : UIView
@property (nonatomic, weak) id<TheTapCheckAssetViewDelegate> delegate;
@end

#pragma mark - TheTapAssetView
@protocol TheTapAssetViewDelegate <NSObject>
-(void)touchSelect:(BOOL)select;
-(BOOL)shouldTap:(BOOL)isSelect;
@end

@interface TheTapAssetView : UIView
@property (nonatomic, weak) id<TheTapAssetViewDelegate> delegate;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) BOOL disabled;
@end

#pragma mark - TheAssetView
@protocol TheAssetViewDelegate <NSObject>
-(BOOL)shouldSelectAsset:(ALAsset*)asset isSelect:(BOOL)isSeldeted;
-(void)tapSelectHandle:(BOOL)select asset:(ALAsset*)asset;
@end

@interface TheAssetView : UIView
- (void)viewBind:(ALAsset *)asset selectionFilter:(NSPredicate*)selectionFilter isSeleced:(BOOL)isSeleced;
@end

#pragma mark - TheAssetViewCell
@protocol TheAssetViewCellDelegate;

@interface TheAssetViewCell : UITableViewCell
@property (nonatomic, weak) id<TheAssetViewCellDelegate> delegate;
- (void)cellBind:(NSArray *)assets selectionFilter:(NSPredicate*)selectionFilter
minimumInteritemSpacing:(float)minimumInteritemSpacing
minimumLineSpacing:(float)minimumLineSpacing
         columns:(int)columns
      assetViewX:(float)assetViewX;
@end

@protocol TheAssetViewCellDelegate <NSObject>
- (BOOL)shouldSelectAsset:(ALAsset*)asset isSelect:(BOOL)isSeldeted;
- (void)didSelectAsset:(ALAsset*)asset;
- (void)didDeselectAsset:(ALAsset*)asset;
@end

#pragma mark - TheAssetGroupViewCell
@interface TheAssetGroupViewCell : UITableViewCell
- (void)groupCellBind:(ALAssetsGroup *)assetsGroup;
@end

#pragma mark - TheAssetGroupViewController
@interface TheAssetGroupViewController : UITableViewController

@end
