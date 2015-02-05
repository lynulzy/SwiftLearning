//
//  MessageFullView.m
//  JiayuanIPad
//
//  Created by TONG YU on 11-9-14.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "MessageFullView.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

#define kTopGapHeight           30.0F
#define kContentViewWidth       160.0F
#define kContentViewHeight      140.0F
#define kMsgImageWidth          40.0F

#define CONTENT_VIEW_BACK_COLOR   [UIColor colorWithWhite:0 alpha:0.8]
#define SELF_BACK_COLOR           [UIColor colorWithWhite:0 alpha:0.1]
@interface MessageFullView () {
    
    UIView *_contentView;
    NSInteger type;
    NSString *_message;
}
@end

@implementation MessageFullView
#pragma mark Init
- (void)initSubViews {
	
	// Content view
	_contentView = [[UIView alloc] init];
    _contentView.bounds = CGRectMake(0, 0, kContentViewWidth, kContentViewHeight);
    _contentView.center = self.center;
	_contentView.backgroundColor = CONTENT_VIEW_BACK_COLOR;
	_contentView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
	_contentView.layer.cornerRadius = 20.0F;
	[self addSubview:_contentView];
	
	// Image 
	UIImageView *msgImage = [[UIImageView alloc] init];
    msgImage.frame = CGRectMake((kContentViewWidth - kMsgImageWidth) / 2, kTopGapHeight, kMsgImageWidth, kMsgImageWidth);
    [_contentView addSubview:msgImage];
    
	// Activity indicator view 
	UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicatorView.hidesWhenStopped = YES;
    [activityIndicatorView stopAnimating];
	activityIndicatorView.frame =  CGRectMake((kContentViewWidth - kMsgImageWidth) / 2, kTopGapHeight, kMsgImageWidth, kMsgImageWidth);
    [_contentView addSubview:activityIndicatorView];
	
	if (MESSAGE_TYPE_OK == type) {
		[msgImage setHidden:NO];
		[msgImage setImage:[UIImage imageNamed:@"message_ok.png"]];
        self.backgroundColor = [UIColor clearColor];
		[activityIndicatorView stopAnimating];
	} else if (MESSAGE_TYPE_ERROR == type) {
		[msgImage setHidden:NO];
		[msgImage setImage:[UIImage imageNamed:@"message_error.png"]];
        self.backgroundColor = [UIColor clearColor];
		[activityIndicatorView stopAnimating];
	} else if (MESSAGE_TYPE_WAITING == type) {
		[msgImage setHidden:YES];
		[msgImage setImage:[UIImage imageNamed:@"message_error.png"]];
		[activityIndicatorView startAnimating];
	} else {
		[msgImage setHidden:YES];
		[msgImage setImage:nil];
		[activityIndicatorView stopAnimating];
	}
    
	UILabel *msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0F, kTopGapHeight + kMsgImageWidth + 10, 160.0F - 15.0F, 50.0F)];
	msgLabel.backgroundColor = [UIColor clearColor];
	msgLabel.textColor = [UIColor whiteColor];
	msgLabel.font = [UIFont systemFontOfSize:15.0F];
	msgLabel.text = _message;
	msgLabel.textAlignment = NSTextAlignmentCenter;
	msgLabel.lineBreakMode = NSLineBreakByWordWrapping;
	msgLabel.numberOfLines = 10;
	[_contentView addSubview:msgLabel];
}

- (id)initWithType:(NSInteger)aType withMessage:(NSString *)aMessage {
	
	if ((self = [super init])) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;

        CGRect bgRect = [window bounds];
        self.frame = bgRect;
		self.superview.autoresizesSubviews = YES;
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		type = aType;
		_message = aMessage;
		[self initSubViews];
        if(MESSAGE_TYPE_WAITING ==  type) {
            self.backgroundColor = SELF_BACK_COLOR;
        } else {
            self.backgroundColor = [UIColor clearColor];
        }
	}
	
	return self;
}

- (void)dealloc {
	
	_contentView = nil;
	_message = nil;
}

@end
