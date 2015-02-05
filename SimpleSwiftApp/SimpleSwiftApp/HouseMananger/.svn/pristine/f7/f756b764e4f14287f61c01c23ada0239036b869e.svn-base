//
//  SelectBuildCell.m
//  HouseMananger
//
//  Created by 王晗 on 15/1/26.
//  Copyright (c) 2015年 王晗. All rights reserved.
//

#import "SelectBuildCell.h"

@implementation SelectBuildCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setSelectModel:(SelectModel *)selectModel{
    if (_selectModel != selectModel) {
        _selectModel = selectModel;
    }
    [self setNeedsLayout];
}
- (void)layoutSubviews{
    _nameLabel.text = _selectModel.name;
    _regionLabel.text  =_selectModel.region_name;
    if ([_selectModel.is_report integerValue] == 0) {
        _statusLabel.hidden = YES;
    }else {
        _statusLabel.hidden = NO;
        _statusLabel.textColor = [UIColor grayColor];
        _nameLabel.textColor = [UIColor grayColor];
        _regionLabel.textColor = [UIColor grayColor];
    }
}
@end
