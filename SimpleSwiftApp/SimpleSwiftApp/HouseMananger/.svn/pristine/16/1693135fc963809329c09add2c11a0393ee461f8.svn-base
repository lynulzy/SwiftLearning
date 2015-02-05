//
//  SaleCell.m
//  HouseMananger
//
//  Created by 王晗 on 15/1/27.
//  Copyright (c) 2015年 王晗. All rights reserved.
//

#import "SaleCell.h"

@implementation SaleCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setSalePoint:(NSDictionary *)salePoint{
    if (_salePoint != salePoint ) {
        _salePoint = salePoint;
    }
    [self setNeedsLayout];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    _valueLabel.text = [_salePoint objectForKey:@"point_content"];
}

@end
