//
//  TalkDetailCell.h
//  HouseMananger
//
//  Created by 王晗 on 15-1-5.
//  Copyright (c) 2015年 王晗. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^TalkBlock)();
@interface TalkDetailCell : UITableViewCell
- (IBAction)talkAction:(id)sender;
@property (nonatomic,copy)TalkBlock talkBlock;
@property (weak, nonatomic) IBOutlet UIButton *comentButton;
@end
