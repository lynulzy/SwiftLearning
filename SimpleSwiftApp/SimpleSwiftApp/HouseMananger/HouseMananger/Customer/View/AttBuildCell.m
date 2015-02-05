//
//  AttBuildCell.m
//  HouseMananger
//
//  Created by 王晗 on 15/2/3.
//  Copyright (c) 2015年 王晗. All rights reserved.
//

#import "AttBuildCell.h"

@implementation AttBuildCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setAttBuildModel:(AttentBuildModel *)attBuildModel{
    if (_attBuildModel != attBuildModel) {
        _attBuildModel = attBuildModel;
    }
    [self setNeedsLayout];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    switch ([_attBuildModel.order_status integerValue]) {
        case 0:
           _statusLabel.text = @"所有";
            break;
        case 1:
            _statusLabel.text = @"无效客户";
            break;
        case 2:
            _statusLabel.text = @"未报备";
            break;
        case 3:
            _statusLabel.text = @"已报备";
            break;
        case 4:
            _statusLabel.text = @"已带看";
            break;
        case 5:
            _statusLabel.text = @"已预约";
            break;
        case 6:
            _statusLabel.text = @"已认购";
            break;
        case 7:
            _statusLabel.text = @"已结佣";
            break;
        case 8:
            _statusLabel.text = @"报备取消(经纪人自己取消)";
            break;
        case 9:
            _statusLabel.text = @"报备取消(销售取消)";
            break;
        case 10:
            _statusLabel.text = @"报备过期(报备后一直没带看,系统自动取消)";
            break;
        case 11:
            _statusLabel.text = @"报备过期(带看后一直没成交,系统自动取消)";
            break;
        case 12:
            _statusLabel.text = @"已评价";
            break;
    }
    _buildNameLabel.text = _attBuildModel.name;
}
@end
