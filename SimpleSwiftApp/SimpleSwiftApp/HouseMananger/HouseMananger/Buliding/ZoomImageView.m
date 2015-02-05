//
//  ZoomImageView.m
//  WXWeibo
//

#import "ZoomImageView.h"
#import "MBProgressHUD.h"
//屏幕的宽、高
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#import "UIImageView+WebCache.h"
@implementation ZoomImageView {
    
    NSMutableArray * _array;
    UILabel * _label;
    UIButton * _saveButton;
    UIButton * _shareButton;
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//http://img.vpubao.com/upload/images/201412/tmp_upload/img_1419791295139762653.jpg
//http://img.vpubao.com/upload/images/201412/tmp_upload/img_1419791295689553133.jpg
//http://img.vpubao.com/upload/images/201412/tmp_upload/img_1419791297676925465.jpg
//        _array = [NSMutableArray arrayWithObjects:@"http://img.vpubao.com/upload/images/201412/tmp_upload/img_1419791295139762653.jpg",@"http://img.vpubao.com/upload/images/201412/tmp_upload/img_1419791295689553133.jpg",@"http://img.vpubao.com/upload/images/201412/tmp_upload/img_1419791297676925465.jpg",@"http://img.vpubao.com/upload/images/201412/tmp_upload/img_1419791297676925465.jpg",@"http://img.vpubao.com/upload/images/201412/tmp_upload/img_1419791297676925465.jpg",@"http://img.vpubao.com/upload/images/201412/tmp_upload/img_1419791297676925465.jpg",@"http://img.vpubao.com/upload/images/201412/tmp_upload/img_1419791297676925465.jpg",@"http://img.vpubao.com/upload/images/201412/tmp_upload/img_1419791297676925465.jpg",@"http://img.vpubao.com/upload/images/201412/tmp_upload/img_1419791297676925465.jpg",@"http://img.vpubao.com/upload/images/201412/tmp_upload/img_1419791297676925465.jpg", nil];
        [self _initTap];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
        [self _initTap];
        
    }
    return self;
}

- (id)initWithImage:(UIImage *)image {
    
    self = [super initWithImage:image];
    
    if (self) {
        
        [self _initTap];
        
    }
    return self;
    
}


- (void)_initTap {
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomIn)];
    [self addGestureRecognizer:tap];
    
    //开启触摸事件
    self.userInteractionEnabled = YES;
    
    //设置内容的模式：
    // UIViewContentModeScaleAspectFit 等比例放大
//    self.contentMode = UIViewContentModeScaleAspectFit;
    
}

//创建放大之后，显示的子视图
- (void)_createView {
    
    if (_scrollView == nil) {
        //1.创建滚动视图
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _scrollView.contentSize = CGSizeMake(kScreenWidth*_array.count, kScreenHeight);
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        [self.window addSubview:_scrollView];
        
        
        for (int i =0; i<_array.count; i++) {
            UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake(i*kScreenWidth, 0, kScreenWidth, kScreenHeight)];
            [imgView setImageWithURL:[NSURL URLWithString:[_array[i] objectForKey:@"img_url"]] placeholderImage:[UIImage imageNamed:@"loadImg.jpg"]];
            imgView.tag = i +100;

            if (i == 0) {
                _fullImageView  = imgView;
                NSLog(@"%@",_array[i]);
            }
            imgView.contentMode =UIViewContentModeScaleAspectFit;
            [_scrollView addSubview:imgView];
        }
        //4.创建单击手势，用于缩小放大之后的图片
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomOut)];
        [_scrollView addGestureRecognizer:tap];
        
        
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, kScreenWidth, 20)];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.text = [NSString stringWithFormat:@"1/%lu",(unsigned long)_array.count];
        _label.textColor = [UIColor whiteColor];
        [self.window addSubview:_label];
        
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _saveButton.frame = CGRectMake(10, kScreenHeight-100, 50, 30);
        [_saveButton addTarget:self action:@selector(savePhoto:) forControlEvents:UIControlEventTouchUpInside];
        [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
        [self.window addSubview:_saveButton];
        
        _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _shareButton.frame = CGRectMake(kScreenWidth-60, kScreenHeight-100, 50, 30);
        [_shareButton setTitle:@"分享" forState:UIControlStateNormal];
        [self.window addSubview:_shareButton];
    }
}

//1、放大图片
- (void)zoomIn {
    
//#warning 将要放大
    //调用代理对象将要放大的协议方法
    if (_array == nil || _array.count == 0) {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"抱歉,此楼盘暂时没有图片!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    if ([self.delegate respondsToSelector:@selector(imageWillZoomIn:)]) {
        [self.delegate imageWillZoomIn:self];
    }
    
    //隐藏缩略图
    self.hidden = YES;
    
    //1.创建放大的子视图
    [self _createView];
    
//    2.放大图片
    //坐标转换：当前视图的坐标 ----> 在window上显示的坐标
    CGRect frame = [self convertRect:self.bounds toView:self.window];
    _fullImageView.frame = frame;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        _fullImageView.frame = _scrollView.bounds;
        _scrollView.backgroundColor = [UIColor blackColor];
        
    } completion:^(BOOL finished) {
        
//#warning 将要放大
        //调用代理对象将要放大的协议方法
        if ([self.delegate respondsToSelector:@selector(imageDidZoomIn:)]) {
            [self.delegate imageDidZoomIn:self];
        }
        
    }];
    
}

//2.缩小图片
- (void)zoomOut {
    
    
//#warning 将要缩小
    //调用代理对象将要放大的协议方法
    if ([self.delegate respondsToSelector:@selector(imageWillZoomOut:)]) {
        [self.delegate imageWillZoomOut:self];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.alpha = 0;
        
//#warning 将要缩小
        //调用代理对象将要放大的协议方法
        if ([self.delegate respondsToSelector:@selector(imageDidZoomOut:)]) {
            [self.delegate imageDidZoomOut:self];
        }
        
    } completion:^(BOOL finished) {
        
        //2.缩小之后，显示缩略图
        self.hidden = NO;
        
        //3.移除_scrollView
        [_scrollView removeFromSuperview];
        _scrollView = nil;
        _fullImageView = nil;
        [_label removeFromSuperview];
        [_shareButton removeFromSuperview];
        [_saveButton removeFromSuperview];
    }];
    
}


//保存图片到相册
- (void)savePhoto:(UIButton *)button {
    
        UIImageView * imgView =(UIImageView *) [_scrollView viewWithTag:_scrollView.contentOffset.x/kScreenWidth+100];
        UIImage *img = imgView.image;
        if (img != nil) {
            
//            1.提示保存
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
            hud.labelText = @"正在保存";
            hud.dimBackground = YES;
            
            //2.将大图图片保存到相册
            UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)(hud));
            
    }
    
}

//保存图片到相册成功之后调用的方法
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
//    [[[UIAlertView alloc] initWithTitle:@"GG" message:@"GG" delegate:nil cancelButtonTitle:@"gg" otherButtonTitles:nil, nil] show];
//    提示保存成功
    MBProgressHUD *hud = (__bridge MBProgressHUD *)(contextInfo);
    
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    //显示模式改为：自定义视图模式
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = @"保存成功";
    
//    延迟隐藏
    [hud hide:YES afterDelay:1.5];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"GG");
    if (scrollView.contentOffset.x/kScreenWidth<0) {
        _label.text = [NSString stringWithFormat:@"1/%lu",(unsigned long)_array.count];
    }else{
    _label.text = [NSString stringWithFormat:@"%0.0f/%lu",scrollView.contentOffset.x/kScreenWidth+1,(unsigned long)_array.count];
    }
    
}

@end
