//
//  DetailCell.m
//  HouseMananger
//
//  Created by 王晗 on 15-1-4.
//  Copyright (c) 2015年 王晗. All rights reserved.
//

#import "DetailCell.h"
#import "UIViewExt.h"
@implementation DetailCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//- (void)setSalePoint:(NSString *)salePoint{
//    if (_salePoint != salePoint) {
//        _salePoint = salePoint;
//    }
//    [self setNeedsLayout];
//}
- (void)setSalePoint:(NSDictionary *)salePoint{
    if (_salePoint != salePoint ) {
        _salePoint = salePoint;
    }
    [self setNeedsLayout];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    if (_isSale == YES) {
        _imgView.left = _valueLabel.left;
        _valueLabel.text = [_salePoint objectForKey:@"point_content"];
    }
}
@end
