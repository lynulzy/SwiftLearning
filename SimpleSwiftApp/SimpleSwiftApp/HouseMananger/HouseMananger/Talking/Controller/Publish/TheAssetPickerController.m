//
//  TheAssetPickerController.m
//  MiShiClient-Pro
//
//  Created by ZXH on 14/10/27.
//  Copyright (c) 2014年 zsxj. All rights reserved.
//

#import "TheAssetPickerController.h"

#define IS_IOS7             ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending)
#define kThumbnailLength    78.0f
#define kThumbnailSize      CGSizeMake(kThumbnailLength, kThumbnailLength)
#define kPopoverContentSize CGSizeMake(320, 480)

#pragma mark -
@interface NSDate (TimeInterval)
+ (NSDateComponents *)componetsWithTimeInterval:(NSTimeInterval)timeInterval;
+ (NSString *)timeDescriptionOfTimeInterval:(NSTimeInterval)timeInterval;
@end

@implementation NSDate (TimeInterval)
+ (NSDateComponents *)componetsWithTimeInterval:(NSTimeInterval)timeInterval {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDate *date1 = [[NSDate alloc] init];
    NSDate *date2 = [[NSDate alloc] initWithTimeInterval:timeInterval sinceDate:date1];
    
    unsigned int unitFlags = NSSecondCalendarUnit |
    NSMinuteCalendarUnit |
    NSHourCalendarUnit |
    NSDayCalendarUnit |
    NSMonthCalendarUnit |
    NSYearCalendarUnit;
    
    return [calendar components:unitFlags
                       fromDate:date1
                         toDate:date2
                        options:0];
}

+ (NSString *)timeDescriptionOfTimeInterval:(NSTimeInterval)timeInterval {
    NSDateComponents *components = [self.class componetsWithTimeInterval:timeInterval];
    NSInteger roundedSeconds = lround(timeInterval - (components.hour * 60) - (components.minute * 60 * 60));
    
    if (components.hour > 0)
    {
        return [NSString stringWithFormat:@"%ld:%02ld:%02ld", (long)components.hour, (long)components.minute, (long)roundedSeconds];
    }
    
    else
    {
        return [NSString stringWithFormat:@"%ld:%02ld", (long)components.minute, (long)roundedSeconds];
    }
}
@end

#pragma mark - TheAssetPickerController
@interface TheAssetPickerController ()
@property (nonatomic, copy) NSArray *indexPathsForSelectedItems;
@end

#pragma mark - TheVideoTitleView
@implementation TheVideoTitleView

-(void)drawRect:(CGRect)rect{
    CGFloat colors [] = {
        0.0, 0.0, 0.0, 0.0,
        0.0, 0.0, 0.0, 0.8,
        0.0, 0.0, 0.0, 1.0
    };
    
    CGFloat locations [] = {0.0, 0.75, 1.0};
    
    CGColorSpaceRef baseSpace   = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient      = CGGradientCreateWithColorComponents(baseSpace, colors, locations, 2);
    
    CGContextRef context    = UIGraphicsGetCurrentContext();
    
    CGFloat height          = rect.size.height;
    CGPoint startPoint      = CGPointMake(CGRectGetMidX(rect), height);
    CGPoint endPoint        = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, kCGGradientDrawsBeforeStartLocation);
    
    CGSize titleSize        = [self.text sizeWithFont:self.font];
    [self.textColor set];
    [self.text drawAtPoint:CGPointMake(rect.size.width - titleSize.width - 2 , (height - 12) / 2)
                  forWidth:kThumbnailLength
                  withFont:self.font
                  fontSize:12
             lineBreakMode:NSLineBreakByTruncatingTail
        baselineAdjustment:UIBaselineAdjustmentAlignCenters];
    
    UIImage *videoIcon=[UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"TheAssetPicker.Bundle/Images/AssetsPickerVideo@2x.png"]];
    
    [videoIcon drawAtPoint:CGPointMake(2, (height - videoIcon.size.height) / 2)];
}
@end

/*----------------TheTapAssetView----UIView-------触摸放大层-------*/
#pragma mark - TheTapCheckAssetView
@interface TheTapCheckAssetView ()
@end

@implementation TheTapCheckAssetView

-(id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    DDLog(@"点击放大")
    [_delegate touchCheck];
}

@end


/*----------------TheTapAssetView----UIView------选择 对勾 图片-------*/
#pragma mark - TheTapAssetView
@interface TheTapAssetView ()
@property(nonatomic, strong) UIImageView *selectView;
@end

@implementation TheTapAssetView
static UIImage *selectedIcon;
static UIImage *deSelectedIcon;
- (void)dealloc {
    self.selectView = nil;
}

+ (void)initialize {
    
    selectedIcon    = [UIImage imageNamed:@"PicturesSelectedIcon.png"];
    deSelectedIcon  = [UIImage imageNamed:@"PicturesDeselectedIcon.png"];
}

-(id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _selectView = [[UIImageView alloc] initWithFrame:
                       CGRectMake(0,
                                  0,
                                  frame.size.width,
                                  frame.size.height)];
        [self addSubview:_selectView];
    }
    return self;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (_disabled) {
        return;
    }
    
    if (nil != _delegate && [_delegate respondsToSelector:@selector(shouldTap:)]) {
        if (![_delegate shouldTap:_selected] && !_selected) {
            return;
        }
    }
    
    if ((_selected = !_selected)) {
        [_selectView setImage:selectedIcon];
    } else {
        [_selectView setImage:deSelectedIcon];
    }
    
    if (nil != _delegate && [_delegate respondsToSelector:@selector(touchSelect:)]) {
        [_delegate touchSelect:_selected];
    }
}
//这两个也没用到

//- (void)setDisabled:(BOOL)disabled {
//    _disabled = disabled;
//    if (_disabled) {
//
//    } else {
//
//        self.backgroundColor = [UIColor clearColor];
//    }
//}
//
//- (void)setSelected:(BOOL)selected {
//    if (_disabled) {
//        [_selectView setImage:deSelectedIcon];
//        return;
//    }
//
//    _selected = selected;
//    if (_selected) {
//        [_selectView setImage:selectedIcon];
//    } else {
//
//        self.backgroundColor = [UIColor clearColor];
//        [_selectView setImage:deSelectedIcon];
//    }
//}

@end

/*----------------TheAssetView----UIView-------相册里每一张照片-------*/
#pragma mark - TheAssetView
@interface TheAssetView ()<TheTapAssetViewDelegate, TheTapCheckAssetViewDelegate>
@property (nonatomic, strong) ALAsset *asset;
@property (nonatomic, weak) id<TheAssetViewDelegate> delegate;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) TheVideoTitleView *videoTitle;
@property (nonatomic, strong) TheTapCheckAssetView *tapCheckAssetView;
@property (nonatomic, strong) TheTapAssetView *tapAssetView;
@end

@implementation TheAssetView

static UIFont *titleFont = nil;
static CGFloat titleHeight;
static UIColor *titleColor;

- (void)dealloc {
    self.asset = nil;
    self.imageView = nil;
    self.videoTitle = nil;
    self.tapCheckAssetView = nil;
    self.tapCheckAssetView = nil;
}

+ (void)initialize {
    titleFont       = [UIFont systemFontOfSize:12];
    titleHeight     = 20.0f;
    titleColor      = [UIColor whiteColor];
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.opaque                     = YES;
        self.isAccessibilityElement     = YES;
        self.accessibilityTraits        = UIAccessibilityTraitImage;
        
        _imageView = [[UIImageView alloc]
                      initWithFrame:CGRectMake(0,
                                               0,
                                               kThumbnailSize.width,
                                               kThumbnailSize.height)];
        [self addSubview:_imageView];
        
        _videoTitle = [[TheVideoTitleView alloc]
                       initWithFrame:CGRectMake(0,
                                                kThumbnailSize.height-titleHeight,
                                                kThumbnailSize.width,
                                                titleHeight)];
        _videoTitle.hidden = YES;
        _videoTitle.font = titleFont;
        _videoTitle.textColor = titleColor;
        _videoTitle.textAlignment = NSTextAlignmentRight;
        _videoTitle.backgroundColor = [UIColor clearColor];
        [self addSubview:_videoTitle];
        
        //触摸放大层
        _tapCheckAssetView = [[TheTapCheckAssetView alloc] initWithFrame:CGRectMake(0, 0, kThumbnailLength, kThumbnailLength)];
        _tapCheckAssetView.delegate = self;
        [self addSubview:_tapCheckAssetView];
        
        
        //触摸选取层
        _tapAssetView = [[TheTapAssetView alloc]
                         initWithFrame:CGRectMake(frame.size.width - 30,
                                                  frame.size.height - 30,
                                                  30,
                                                  30)];
        _tapAssetView.delegate = self;
        [self addSubview:_tapAssetView];
        
    }
    return self;
}

- (void)viewBind:(ALAsset *)asset selectionFilter:(NSPredicate*)selectionFilter isSeleced:(BOOL)isSeleced {
    self.asset = asset;
    //取Asset里的CGImage
    [_imageView setImage:[UIImage imageWithCGImage:asset.thumbnail]];
    
    if ([[asset valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
        _videoTitle.hidden = NO;
        _videoTitle.text = [NSDate timeDescriptionOfTimeInterval:[[asset valueForProperty:ALAssetPropertyDuration] doubleValue]];
    } else {
        _videoTitle.hidden=YES;
    }
    
    _tapAssetView.disabled = ![selectionFilter evaluateWithObject:asset];
    _tapAssetView.selected = isSeleced;
    _tapAssetView.selectView.image = [UIImage imageNamed:@"PicturesDeselectedIcon.png"];
}

#pragma mark - TheTapAssetView Delegate
-(BOOL)shouldTap:(BOOL)isSelect {
    if (_delegate != nil && [_delegate respondsToSelector:@selector(shouldSelectAsset:isSelect:)]) {
        //触发TheAssetView的代理
        return [_delegate shouldSelectAsset:_asset isSelect:isSelect];
    }
    return YES;
}

-(void)touchSelect:(BOOL)select{
    if (_delegate != nil && [_delegate respondsToSelector:@selector(tapSelectHandle:asset:)]) {
        [_delegate tapSelectHandle:select asset:_asset];
    }
}

#pragma mark - TheTapCheckAssetViewDelegate
- (void)touchCheck {//点击放大
    UIImage *theImage = [UIImage imageWithCGImage:_asset.defaultRepresentation.fullScreenImage];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0,
                                                                     0,
                                                                     [UIScreen mainScreen].bounds.size.width,
                                                                     [UIScreen mainScreen].bounds.size.height)];
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0;
    
    //取 照片 相对于window的位置
    CGRect originRect = [self convertRect:self.frame toView:window];
    UIImageView *picIV = [[UIImageView alloc] initWithFrame:CGRectMake(originRect.origin.x / 2, originRect.origin.y, originRect.size.width, originRect.size.height)];
    DDLog(@"x = %f, y = %f, w = %f, h = %f",originRect.origin.x / 2, originRect.origin.y, originRect.size.width, originRect.size.height)
    
    picIV.image = theImage;
    picIV.tag = 1;
    [backgroundView addSubview:picIV];
    [window addSubview:backgroundView];
    
    [UIView animateWithDuration:0.3 animations:^{
        picIV.frame = CGRectMake(0,
                                ([UIScreen mainScreen].bounds.size.height-
                                 theImage.size.height / theImage.size.width *
                                 [UIScreen mainScreen].bounds.size.width )  /2,
                                [UIScreen mainScreen].bounds.size.width,
                                theImage.size.height / theImage.size.width * [UIScreen mainScreen].bounds.size.width);
        backgroundView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    [backgroundView addGestureRecognizer:tap];
}

- (void)hideImage:(UITapGestureRecognizer*)tap{
    UIView *backgroundView = tap.view;
    UIImageView *im = (UIImageView*)[tap.view viewWithTag:1];
    [UIView animateWithDuration:0.3 animations:^{
        
        //        imageView.frame = oldframe;
        backgroundView.alpha = 0;
        
    } completion:^(BOOL finished) {
        [im removeFromSuperview];
        [backgroundView removeFromSuperview];
        
    }];
}

@end

/*----------------TheAssetViewCell----UITableViewCell-------相册所有图片每一行Cell--------*/
#pragma mark - TheAssetViewCell
@interface TheAssetViewCell ()<TheAssetViewDelegate>
@end

@class TheAssetViewController;

@implementation TheAssetViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}
//设置一个一个的照片
- (void)cellBind:(NSArray *)assets selectionFilter:(NSPredicate*)selectionFilter
                           minimumInteritemSpacing:(float)minimumInteritemSpacing
                                minimumLineSpacing:(float)minimumLineSpacing
                                           columns:(int)columns
                                        assetViewX:(float)assetViewX {
    
    if (self.contentView.subviews.count < assets.count) {
        for(NSInteger i = 0; i < assets.count; i++) {
            //为何要判断呢？？？diseasedness？？？
            if (i > ((NSInteger)self.contentView.subviews.count - 1)) {
                TheAssetView *assetView = [[TheAssetView alloc] initWithFrame:
                                           CGRectMake(assetViewX + (kThumbnailSize.width + minimumInteritemSpacing) * i,
                                                      minimumLineSpacing-1,
                                                      kThumbnailSize.width,
                                                      kThumbnailSize.height)];
                
                [assetView viewBind:assets[i]
                    selectionFilter:selectionFilter
                          isSeleced:/*判断选中状态*/
                 [((TheAssetViewController*)_delegate).indexPathsForSelectedItems containsObject:assets[i]]];
                assetView.delegate = self;
                [self.contentView addSubview:assetView];
                
            } else {
                //这段没有用到
                ((TheAssetView*)self.contentView.subviews[i]).frame =
                CGRectMake(assetViewX + (kThumbnailSize.width + minimumInteritemSpacing) * i,
                           minimumLineSpacing-1,
                           kThumbnailSize.width,
                           kThumbnailSize.height);
                
                [(TheAssetView*)self.contentView.subviews[i] viewBind:assets[i] selectionFilter:selectionFilter isSeleced:[((TheAssetViewController*)_delegate).indexPathsForSelectedItems containsObject:assets[i]]];
            }
        }
    } else {
        //这段貌似也多余
        for (NSUInteger i = self.contentView.subviews.count; i > 0; i--) {
            if (i > assets.count) {
                [((TheAssetView*)self.contentView.subviews[i-1]) removeFromSuperview];
            } else {
                ((TheAssetView*)self.contentView.subviews[i-1]).frame =
                CGRectMake(assetViewX + (kThumbnailSize.width+minimumInteritemSpacing) * (i-1),
                           minimumLineSpacing-1,
                           kThumbnailSize.width,
                           kThumbnailSize.height);
                [(TheAssetView*)self.contentView.subviews[i-1] viewBind:assets[i-1] selectionFilter:selectionFilter isSeleced:[((TheAssetViewController*)_delegate).indexPathsForSelectedItems containsObject:assets[i-1]]];
            }
        }
    }
}

#pragma mark - TheAssetView Delegate
-(BOOL)shouldSelectAsset:(ALAsset *)asset isSelect:(BOOL)isSeldeted{
    if (nil != _delegate && [_delegate respondsToSelector:@selector(shouldSelectAsset:isSelect:)]) {
        //触发TheAssetViewCell的代理
        return [_delegate shouldSelectAsset:asset isSelect:isSeldeted];
    }
    return YES;
}

-(void)tapSelectHandle:(BOOL)select asset:(ALAsset *)asset{
    if (select) {
        if (nil != _delegate && [_delegate respondsToSelector:@selector(didSelectAsset:)]) {
            [_delegate didSelectAsset:asset];
        }
    } else {
        if (nil != _delegate && [_delegate respondsToSelector:@selector(didDeselectAsset:)]) {
            [_delegate didDeselectAsset:asset];
        }
    }
}

@end

/*----------------TheAssetViewController----UITableViewController-------相册图片网格列表--------*/
#pragma mark - TheAssetViewController
@interface TheAssetViewController ()<TheAssetViewCellDelegate>{
    int columns;//列
    BOOL unFirst;
    float minimumInteritemSpacing;//相片与相片之间的空隙
    float minimumLineSpacing;//每一行Cell之间的空隙
}

@property (nonatomic, strong) NSMutableArray *assets;
@property (nonatomic, assign) NSInteger numberOfPhotos;
@property (nonatomic, assign) NSInteger numberOfVideos;
@end

#define kAssetViewCellIdentifier           @"AssetViewCellIdentifier"

@implementation TheAssetViewController
- (void)dealloc {
    self.assetsGroup = nil;
    self.indexPathsForSelectedItems = nil;
    self.assets = nil;
}

- (id)init {
    _indexPathsForSelectedItems = [[NSMutableArray alloc] init];
    
    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {//如果是横屏
        self.tableView.contentInset = UIEdgeInsetsMake(9.0, 2.0, 0, 2.0);
        
        minimumInteritemSpacing=3;
        minimumLineSpacing=3;
    } else {//如果是竖屏
        self.tableView.contentInset=UIEdgeInsetsMake(9.0, 0, 0, 0);
        
        minimumInteritemSpacing = 2;
        minimumLineSpacing = 2;
    }
    
    if (self = [super init]) {
        if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
            [self setEdgesForExtendedLayout:UIRectEdgeNone];//关闭自动布局
        }
        
        if ([self respondsToSelector:@selector(setContentSizeForViewInPopover:)]) {
            [self setContentSizeForViewInPopover:kPopoverContentSize];
        }
    }
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];/**************/
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViews];
    [self setupButtons];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!unFirst) {
        //floor取整数部分
        // 一行Cell可以放几张图片
        columns = floor(self.view.frame.size.width/(kThumbnailSize.width + minimumInteritemSpacing));
        [self setupAssets];
        unFirst = YES;
    }
}

#pragma mark - Rotation
//系统方法 屏幕旋转
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
        
        self.tableView.contentInset=UIEdgeInsetsMake(9.0, 0, 0, 0);
        minimumInteritemSpacing = 3;
        minimumLineSpacing = 3;
    } else {
        self.tableView.contentInset=UIEdgeInsetsMake(9.0, 0, 0, 0);
        minimumInteritemSpacing = 2;
        minimumLineSpacing = 2;
    }
    
    columns = floor(self.view.frame.size.width / (kThumbnailSize.width + minimumInteritemSpacing));
    [self.tableView reloadData];
}

#pragma mark - Setup
//相册详情背景
- (void)setupViews {
    self.tableView.backgroundColor = [UIColor whiteColor];/**********color***/
}
//完成按钮
- (void)setupButtons {
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"完成", nil)
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(finishPickingAssets:)];
}

- (void)setupAssets {
    self.title = [self.assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    self.numberOfPhotos = 0;
    self.numberOfVideos = 0;
    
    if (!self.assets) {
        self.assets = [[NSMutableArray alloc] init];
    } else {
        [self.assets removeAllObjects];
    }
    //遍历所以项目
    ALAssetsGroupEnumerationResultsBlock resultsBlock = ^(ALAsset *asset, NSUInteger index, BOOL *stop) {
        
        if (asset) {
            [self.assets addObject:asset];
            
            NSString *type = [asset valueForProperty:ALAssetPropertyType];
            
            if ([type isEqual:ALAssetTypePhoto])
                self.numberOfPhotos ++;
            if ([type isEqual:ALAssetTypeVideo])
                self.numberOfVideos ++;
            
        } else if (self.assets.count > 0) {
            [self.tableView reloadData];
            
            [self.tableView scrollToRowAtIndexPath:
             [NSIndexPath indexPathForRow:ceil(self.assets.count*1.0/columns) inSection:0]
                                  atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    };
    
    [self.assetsGroup enumerateAssetsUsingBlock:resultsBlock];
}

#pragma mark - UITableView DataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //最下面的Label "共 几 张照片"
    if (indexPath.row == ceil(self.assets.count * 1.0 / columns)) {
        
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cellFooter"];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellFooter"];
            cell.textLabel.font=[UIFont systemFontOfSize:18];
            cell.textLabel.backgroundColor=[UIColor yellowColor];/********color*********/
            cell.textLabel.textAlignment=NSTextAlignmentCenter;
            cell.textLabel.textColor=[UIColor blackColor];
            cell.backgroundColor=[UIColor clearColor];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        
        NSString *title;
        
        if (0 == _numberOfVideos)
            title = [NSString stringWithFormat:NSLocalizedString(@"共 %ld 张照片", nil), (long)_numberOfPhotos];
        else if (0 == _numberOfPhotos)
            title = [NSString stringWithFormat:NSLocalizedString(@"共 %ld 部视频", nil), (long)_numberOfVideos];
        else
            title = [NSString stringWithFormat:NSLocalizedString(@"共 %ld 张照片, %ld 部视频", nil), (long)_numberOfPhotos, (long)_numberOfVideos];
        
        cell.textLabel.text = title;
        return cell;
    }
    //找到一行cell要码的图片
    NSMutableArray *tempAssets=[[NSMutableArray alloc] init];
    for (int i = 0; i < columns; i++) {
        if ((indexPath.row * columns + i) < self.assets.count) {
            [tempAssets addObject:[self.assets objectAtIndex:indexPath.row * columns + i]];
        }
    }
    //
    static NSString *CellIdentifier = kAssetViewCellIdentifier;
    TheAssetPickerController *picker = (TheAssetPickerController *)self.navigationController;
    
    TheAssetViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (nil == cell) {
        cell = [[TheAssetViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.delegate=self;
    
    [cell cellBind:tempAssets selectionFilter:picker.selectionFilter
                      minimumInteritemSpacing:minimumInteritemSpacing
                           minimumLineSpacing:minimumLineSpacing
                                      columns:columns
                                   assetViewX:1.0f];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ceil(self.assets.count*1.0/columns) + 1;
}

#pragma mark - UITableView Delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Footer44
    if (ceil(self.assets.count * 1.0 / columns == indexPath.row)) {
        return 44;
    }
    // 照片一行 高度 78 + 2
    return kThumbnailSize.height + minimumLineSpacing;
}

#pragma mark - TheAssetViewCell Delegate
//返回值表示 是否可以继续添加照片
- (BOOL)shouldSelectAsset:(ALAsset *)asset isSelect:(BOOL)isSeldeted{
    TheAssetPickerController *picker = (TheAssetPickerController *)self.navigationController;
    //判断是否是ALAasset类型
    BOOL selectable = [picker.selectionFilter evaluateWithObject:asset];
    //判断已选个数是否大于等于最大值
    if (_indexPathsForSelectedItems.count >= picker.maximumNumberOfSelection) {
        if (nil != picker.delegate &&
            [picker.delegate respondsToSelector:@selector(assetPickerControllerDidMaximum:)] &&
            !isSeldeted) {
            //如果已选个数大于或者等于最大值
            //且此图片未被选中
            //那么再点击就出发代理
            [picker.delegate assetPickerControllerDidMaximum:picker];
        }
    }
    return (selectable && (_indexPathsForSelectedItems.count < picker.maximumNumberOfSelection));
}
// 选择一张照片
- (void)didSelectAsset:(ALAsset *)asset {
    // TheAssetViewController的
    [_indexPathsForSelectedItems addObject:asset];
    
    TheAssetPickerController *picker = (TheAssetPickerController *)self.navigationController;
    // TheAssetPickerController的
    picker.indexPathsForSelectedItems = _indexPathsForSelectedItems;
    // 点击选择照片之后 触发 代理
    if (nil != picker.delegate && [picker.delegate respondsToSelector:@selector(assetPickerController:didSelectAsset:)]) {
        [picker.delegate assetPickerController:picker didSelectAsset:asset];
    }
    //设置导航条标题
    [self setTitleWithSelectedIndexPaths:_indexPathsForSelectedItems];
}
// 去掉选择 一张照片
- (void)didDeselectAsset:(ALAsset *)asset {
    [_indexPathsForSelectedItems removeObject:asset];
    
    TheAssetPickerController *picker = (TheAssetPickerController *)self.navigationController;
    picker.indexPathsForSelectedItems = _indexPathsForSelectedItems;
    
    if (nil != picker.delegate && [picker.delegate respondsToSelector:@selector(assetPickerController:didDeselectAsset:)]) {
        [picker.delegate assetPickerController:picker didDeselectAsset:asset];
    }
    //设置导航条标题
    [self setTitleWithSelectedIndexPaths:_indexPathsForSelectedItems];
}

#pragma mark - Title
//每选择一张照片后  改变一下 导航条的标题
- (void)setTitleWithSelectedIndexPaths:(NSArray *)indexPaths {
    // Reset title to group name
    if (indexPaths.count == 0) {
        self.title = [self.assetsGroup valueForProperty:ALAssetsGroupPropertyName];
        return;
    }
    
    BOOL photosSelected = NO;
    BOOL videoSelected  = NO;
    
    for (int i = 0; i < indexPaths.count; i++) {
        ALAsset *asset = indexPaths[i];
        
        if ([[asset valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypePhoto])
            photosSelected  = YES;
        
        if ([[asset valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo])
            videoSelected   = YES;
        
        if (photosSelected && videoSelected)
            break;
    }
    
    NSString *format;
    
    if (photosSelected && videoSelected)
        format = NSLocalizedString(@"已选择 %ld 个项目", nil);
    
    else if (photosSelected)
        format = (indexPaths.count > 1) ? NSLocalizedString(@"已选择 %ld 张照片", nil) : NSLocalizedString(@"已选择 %ld 张照片 ", nil);
    
    else if (videoSelected)
        format = (indexPaths.count > 1) ? NSLocalizedString(@"已选择 %ld 部视频", nil) : NSLocalizedString(@"已选择 %ld 部视频 ", nil);
    
    self.title = [NSString stringWithFormat:format, (long)indexPaths.count];
}


#pragma mark - Actions
//完成按钮点击事件
- (void)finishPickingAssets:(id)sender {
    
    TheAssetPickerController *picker = (TheAssetPickerController *)self.navigationController;
    
    if (_indexPathsForSelectedItems.count < picker.minimumNumberOfSelection) {
        if (nil != picker.delegate && [picker.delegate respondsToSelector:@selector(assetPickerControllerDidMaximum:)]) {
            [picker.delegate assetPickerControllerDidMaximum:picker];
        }
    }
    
    
    if ([picker.delegate respondsToSelector:@selector(assetPickerController:didFinishPickingAssets:)])
        [picker.delegate assetPickerController:picker didFinishPickingAssets:_indexPathsForSelectedItems];
    //
    if (picker.isFinishDismissViewController) {
        [picker.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
    }
}

@end

/*----------------TheAssetGroupViewCell----UITableViewCell-------分组页面每个Cell视图--------*/
#pragma mark - TheAssetGroupViewCell
@interface TheAssetGroupViewCell ()
@property (nonatomic, strong) ALAssetsGroup *assetsGroup;
@end

@implementation TheAssetGroupViewCell
- (void)dealloc {
    self.assetsGroup = nil;
}
//相册分组Cell
- (void)groupCellBind:(ALAssetsGroup *)assetsGroup {
    self.assetsGroup            = assetsGroup;
    //posterImage组封面
    CGImageRef posterImage      = assetsGroup.posterImage;
    //封面图高度
    size_t height               = CGImageGetHeight(posterImage);
    //比例
    float scale                 = height / kThumbnailLength;
    //设置分组图片
    self.imageView.image        = [UIImage imageWithCGImage:posterImage
                                                      scale:scale
                                                orientation:UIImageOrientationUp];//头朝上
    //相册 标题
    self.textLabel.text         = [assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    //相册 副标题(相片个数)
    //    self.detailTextLabel.text   = [NSString stringWithFormat:@"%ld", (long)[assetsGroup numberOfAssets]];
    self.detailTextLabel.text   = [NSString stringWithFormat:@"%@", [self accessibilityLabel]];
    self.accessoryType          = UITableViewCellAccessoryDisclosureIndicator;
}
//返回 相册名+共几张照片
- (NSString *)accessibilityLabel {
    
    NSString *label = [self.assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    
    return [label stringByAppendingFormat:NSLocalizedString(@"共%ld 张照片", nil), (long)[self.assetsGroup numberOfAssets]];
}

@end

/*----------------TheAssetGroupViewController----UITableViewController-----分组页面TableView视图--------*/
#pragma mark - TheAssetGroupViewController
@interface TheAssetGroupViewController()
@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;
@property (nonatomic, strong) NSMutableArray *groups;
@end

@implementation TheAssetGroupViewController
- (void)dealloc {
    self.assetsLibrary = nil;
    self.groups = nil;
}

- (id)init {
    if (self = [super initWithStyle:UITableViewStylePlain])
    {
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_7_0
        self.preferredContentSize = kPopoverContentSize;
#else
        if ([self respondsToSelector:@selector(setContentSizeForViewInPopover:)])
            [self setContentSizeForViewInPopover:kPopoverContentSize];
#endif
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    [self setupButtons];
    [self localize];
    [self setupGroup];
}

#pragma mark - Rotation
- (BOOL)shouldAutorotate {
    //自转
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    //支持所有方向  除了底朝上
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

#pragma mark - Setup
- (void)setupViews {
    //78.0 + 12
    self.tableView.rowHeight = kThumbnailLength + 12;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)setupButtons {
    TheAssetPickerController *picker = (TheAssetPickerController *)self.navigationController;
    //相册列表 导航条上的取消按钮
    if (picker.showCancelButton) {
        self.navigationItem.rightBarButtonItem =
        [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"取消", nil)
                                         style:UIBarButtonItemStylePlain
                                        target:self
                                        action:@selector(dismiss:)];
    }
}

- (void)localize {
    
    self.title = NSLocalizedString(@"相簿", nil);
}

- (void)setupGroup {
    if (!self.assetsLibrary) {
        self.assetsLibrary = [self.class defaultAssetsLibrary];
    }
    
    if (!self.groups) {
        self.groups = [[NSMutableArray alloc] init];
    } else {
        [self.groups removeAllObjects];
    }
    
    TheAssetPickerController *picker = (TheAssetPickerController *)self.navigationController;
    ALAssetsFilter *assetsFilter = picker.assetsFilter;
    
    ALAssetsLibraryGroupsEnumerationResultsBlock resultsBlock = ^(ALAssetsGroup *group, BOOL *stop) {
        
        if (group)
        {
            [group setAssetsFilter:assetsFilter];
            if (group.numberOfAssets > 0 || picker.showEmptyGroups)
                [self.groups addObject:group];
        }
        else
        {
            [self reloadData];
        }
    };
    
    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error) {
        //不允许访问系统相册时 调用 给用户提示如何设置
        [self showNotAllowed];
    };
    
    // Enumerate Camera roll first
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                                      usingBlock:resultsBlock
                                    failureBlock:failureBlock];
    
    // Then all other groups
    NSUInteger type = ALAssetsGroupLibrary | ALAssetsGroupAlbum |
    ALAssetsGroupEvent | ALAssetsGroupFaces |
    ALAssetsGroupPhotoStream;
    
    [self.assetsLibrary enumerateGroupsWithTypes:type
                                      usingBlock:resultsBlock
                                    failureBlock:failureBlock];
}

#pragma mark - Reload Data
- (void)reloadData {
    if (self.groups.count == 0) {
        //没有相册的时候  显示一个提示页面
        [self showNoAssets];
    }
    [self.tableView reloadData];
}

#pragma mark - ALAssetsLibrary
//- (void)setupGroup 后调用
+ (ALAssetsLibrary *)defaultAssetsLibrary {
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}

#pragma mark - Not allowed / No assets
//不允许访问相册 给出的提示
- (void)showNotAllowed {
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
        [self setEdgesForExtendedLayout:UIRectEdgeLeft | UIRectEdgeRight | UIRectEdgeBottom];
    
    self.title              = nil;
    
    UIImageView *padlock    = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"TheAssetPicker.Bundle/Images/AssetsPickerLocked@2x.png"]]];
    padlock.translatesAutoresizingMaskIntoConstraints = NO;
    
    UILabel *title          = [UILabel new];
    title.translatesAutoresizingMaskIntoConstraints = NO;
    title.preferredMaxLayoutWidth = 304.0f;
    
    UILabel *message        = [UILabel new];
    message.translatesAutoresizingMaskIntoConstraints = NO;
    message.preferredMaxLayoutWidth = 304.0f;
    
    title.text              = NSLocalizedString(@"此应用无法使用您的照片或视频。", nil);
    title.font              = [UIFont boldSystemFontOfSize:17.0];
    title.textColor         = [UIColor colorWithRed:129.0/255.0 green:136.0/255.0 blue:148.0/255.0 alpha:1];
    title.textAlignment     = NSTextAlignmentCenter;
    title.numberOfLines     = 5;
    
    message.text            = NSLocalizedString(@"你可以在「隐私设置」中启用存取。", nil);
    message.font            = [UIFont systemFontOfSize:14.0];
    message.textColor       = [UIColor colorWithRed:129.0/255.0 green:136.0/255.0 blue:148.0/255.0 alpha:1];
    message.textAlignment   = NSTextAlignmentCenter;
    message.numberOfLines   = 5;
    
    [title sizeToFit];
    [message sizeToFit];
    
    UIView *centerView = [UIView new];
    centerView.translatesAutoresizingMaskIntoConstraints = NO;
    [centerView addSubview:padlock];
    [centerView addSubview:title];
    [centerView addSubview:message];
    
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(padlock, title, message);
    
    [centerView addConstraint:[NSLayoutConstraint constraintWithItem:padlock attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:centerView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    [centerView addConstraint:[NSLayoutConstraint constraintWithItem:title attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:padlock attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    [centerView addConstraint:[NSLayoutConstraint constraintWithItem:message attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:padlock attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    [centerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[padlock]-[title]-[message]|" options:0 metrics:nil views:viewsDictionary]];
    
    UIView *backgroundView = [UIView new];
    [backgroundView addSubview:centerView];
    [backgroundView addConstraint:[NSLayoutConstraint constraintWithItem:centerView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:backgroundView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    [backgroundView addConstraint:[NSLayoutConstraint constraintWithItem:centerView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:backgroundView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
    
    self.tableView.backgroundView = backgroundView;
}
//显示空相册
- (void)showNoAssets {
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
        [self setEdgesForExtendedLayout:UIRectEdgeLeft | UIRectEdgeRight | UIRectEdgeBottom];
    
    UILabel *title          = [UILabel new];
    title.translatesAutoresizingMaskIntoConstraints = NO;
    title.preferredMaxLayoutWidth = 304.0f;
    UILabel *message        = [UILabel new];
    message.translatesAutoresizingMaskIntoConstraints = NO;
    message.preferredMaxLayoutWidth = 304.0f;
    
    title.text              = NSLocalizedString(@"无照片或视频。", nil);
    title.font              = [UIFont systemFontOfSize:26.0];
    title.textColor         = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1];
    title.textAlignment     = NSTextAlignmentCenter;
    title.numberOfLines     = 5;
    
    message.text            = NSLocalizedString(@"您可以使用 iTunes 将照片和视频\n同步到 iPhone。", nil);
    message.font            = [UIFont systemFontOfSize:18.0];
    message.textColor       = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1];
    message.textAlignment   = NSTextAlignmentCenter;
    message.numberOfLines   = 5;
    
    [title sizeToFit];
    [message sizeToFit];
    
    UIView *centerView = [UIView new];
    centerView.translatesAutoresizingMaskIntoConstraints = NO;
    [centerView addSubview:title];
    [centerView addSubview:message];
    
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(title, message);
    
    [centerView addConstraint:[NSLayoutConstraint constraintWithItem:title attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:centerView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    [centerView addConstraint:[NSLayoutConstraint constraintWithItem:message attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:title attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    [centerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[title]-[message]|" options:0 metrics:nil views:viewsDictionary]];
    
    UIView *backgroundView = [UIView new];
    [backgroundView addSubview:centerView];
    [backgroundView addConstraint:[NSLayoutConstraint constraintWithItem:centerView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:backgroundView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    [backgroundView addConstraint:[NSLayoutConstraint constraintWithItem:centerView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:backgroundView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
    
    self.tableView.backgroundView = backgroundView;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
//相册分组数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.groups.count;
}
//相册分组
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    TheAssetGroupViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[TheAssetGroupViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    [cell groupCellBind:[self.groups objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark - UITableView Delegate
// 相册分组Cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //78.0 + 12
    return kThumbnailLength + 12;
}
// 点击选择某个相册
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TheAssetViewController *vc = [[TheAssetViewController alloc] init];
    
    vc.assetsGroup = [self.groups objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Actions
//相册列表 取消按钮 点击后执行
- (void)dismiss:(id)sender {
    TheAssetPickerController *picker = (TheAssetPickerController *)self.navigationController;
    
    if ([picker.delegate respondsToSelector:@selector(assetPickerControllerDidCancel:)])
        [picker.delegate assetPickerControllerDidCancel:picker];
    
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}
@end

/*-------------------TheAssetPickerController----UINavigationController-----------------*/
#pragma mark - TheAssetPickerController
@implementation TheAssetPickerController
- (void)dealloc {
    self.assetsFilter = nil;
    self.selectionFilter = nil;
    self.indexPathsForSelectedItems = nil;
}

- (id)init
{//初始化分组页面
    TheAssetGroupViewController *groupViewController = [[TheAssetGroupViewController alloc] init];
    
    if (self = [super initWithRootViewController:groupViewController])
    {
        //默认值
        _maximumNumberOfSelection      = 10;
        _minimumNumberOfSelection      = 0;
        _assetsFilter                  = [ALAssetsFilter allAssets];
        _showCancelButton              = YES;
        _showEmptyGroups               = YES;
        _selectionFilter               = [NSPredicate predicateWithValue:YES];
        _isFinishDismissViewController = YES;
        
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_7_0
        self.preferredContentSize = kPopoverContentSize;
#else
        if ([self respondsToSelector:@selector(setContentSizeForViewInPopover:)])
            [self setContentSizeForViewInPopover:kPopoverContentSize];
#endif
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
