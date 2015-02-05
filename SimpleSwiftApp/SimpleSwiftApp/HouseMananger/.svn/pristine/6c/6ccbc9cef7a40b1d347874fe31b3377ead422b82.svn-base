//
//  CustomerDetailCell.m
//  HouseMananger
//
//  Created by 王晗 on 15/1/22.
//  Copyright (c) 2015年 王晗. All rights reserved.
//

#import "CustomerDetailCell.h"

@implementation CustomerDetailCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setCustomerDetailModel:(CustomerDetailModel *)customerDetailModel{
    if (_customerDetailModel != customerDetailModel) {
        _customerDetailModel  = customerDetailModel;
    }
    [self setNeedsLayout];
}
- (void)layoutSubviews{
    [super layoutSubviews ];
    _purchasAttLabel.adjustsFontSizeToFitWidth = YES;
    if ([_customerDetailModel.purchase_intentions isEqualToString:@"(null)"]) {
        _purchasAttLabel.text = @"暂无设置客户意向,点击编辑进行设置";
        return;
    }
    _purchasAttLabel.text  = _customerDetailModel.purchase_intentions;
}
@end
