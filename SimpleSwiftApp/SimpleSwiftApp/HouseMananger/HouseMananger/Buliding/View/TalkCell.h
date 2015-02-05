//
//  TalkCell.h
//  HouseMananger
//
//  Created by 王晗 on 15-1-4.
//  Copyright (c) 2015年 王晗. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComentModel.h"
@interface TalkCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photoImg;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *comentLabelCount;
@property (nonatomic,strong)ComentModel * comentModel;
@end
