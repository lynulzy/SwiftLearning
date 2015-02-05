//
//  PriceCell.m
//  HouseMananger
//
//  Created by 王晗 on 15/1/20.
//  Copyright (c) 2015年 王晗. All rights reserved.
//

#import "PriceCell.h"
#import "UIViewExt.h"
#import "Common.h"
@implementation PriceCell

- (void)awakeFromNib {
    _sliderView = [[NMRangeSlider alloc] initWithFrame:CGRectMake(20, _priceLabel.bottom+5, kScreenWidth-40, 30)];
    [_sliderView addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
    _sliderView.minimumValue = 0;
    _sliderView.maximumValue = 100;
    _sliderView.lowerValue = 0;
    _sliderView.upperValue = 100;
    [self.contentView addSubview:_sliderView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setMaxValue:(CGFloat)maxValue{
    if (_maxValue != maxValue) {
        _maxValue  = maxValue;
    }
    [self setNeedsLayout];
}
//100-0,0-100,100-200,
- (void)sliderAction:(id)sender {
    if (_sliderView.lowerValue == 0) {
        _priceLabel.text = [NSString stringWithFormat:@"价格区间:%.0f万以下",_sliderView.upperValue*10];
        _passValue([NSString stringWithFormat:@"%.0f万以下",_sliderView.upperValue*10],0,_sliderView.upperValue*10);
    }
    if (_sliderView.upperValue == 100) {
        _priceLabel.text = [NSString stringWithFormat:@"价格区间:%.0f万以上",_sliderView.lowerValue*10];
        _passValue([NSString stringWithFormat:@"%.0f万以上",_sliderView.lowerValue*10],_sliderView.lowerValue*10,0);
    }
    if (_sliderView.lowerValue != 0 && _sliderView.upperValue != 100) {
        _priceLabel.text = [NSString stringWithFormat:@"价格区间:%.0f万-%.0f万",_sliderView.lowerValue*10,_sliderView.upperValue*10];
        _passValue([NSString stringWithFormat:@"%.0f万-%.0f万",_sliderView.lowerValue*10,_sliderView.upperValue*10],_sliderView.lowerValue*10,_sliderView.upperValue*10);
    }
    if (_sliderView.lowerValue == 0&&_sliderView.upperValue ==100) {
        _priceLabel.text = [NSString stringWithFormat:@"价格区间:不限"];
        _passValue([NSString stringWithFormat:@"不限"],0,0);
    }
}
- (void)layoutSubviews{
    [super layoutSubviews];
//    _sliderView.value = _sliderValue;
    [_sliderView setLowerValue:_minValue];
    [_sliderView setUpperValue:_maxValue];
}
@end
