//
//  TalkDetailHeaderView.h
//  HouseMananger
//
//  Created by 王晗 on 15-1-5.
//  Copyright (c) 2015年 王晗. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^TalkBlock)();
typedef void (^EventPassBlock)();
@interface TalkDetailHeaderView : UIView

- (IBAction)talkAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *workLabel;
@property (weak, nonatomic) IBOutlet UILabel *timelabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photoImgView;
@property (nonatomic,copy)TalkBlock talkBlock;
@property (nonatomic,copy)EventPassBlock eventPassBlock;
@end
