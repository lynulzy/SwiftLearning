//
//  CityCell.m
//  HouseMananger
//
//  Created by 王晗 on 15-1-9.
//  Copyright (c) 2015年 王晗. All rights reserved.
//

#import "CityCell.h"

@implementation CityCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)setCityModel:(CityModel *)cityModel{
    if (_cityModel != cityModel) {
        _cityModel = cityModel;
    }
    [self setNeedsLayout];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.cityLabel.text = _cityModel.region_name;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
