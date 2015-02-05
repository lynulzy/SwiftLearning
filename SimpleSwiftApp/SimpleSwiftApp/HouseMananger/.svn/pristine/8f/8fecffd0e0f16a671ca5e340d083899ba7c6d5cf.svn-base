//
//  CusDetailHeaderView.m
//  HouseMananger
//
//  Created by 王晗 on 15/1/21.
//  Copyright (c) 2015年 王晗. All rights reserved.
//

#import "CusDetailHeaderView.h"

@implementation CusDetailHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)setCustomerDetailModel:(CustomerDetailModel *)customerDetailModel{
    if (_customerDetailModel != customerDetailModel) {
        _customerDetailModel = customerDetailModel;
    }
    [self setNeedsLayout];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    _nameLabel.text = _customerDetailModel.customer_name;
    _phoneLabel.text = _customerDetailModel.customer_mobile;
}
- (IBAction)sendMsgAction:(id)sender {
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"确定要向%@发短信?",_customerDetailModel.customer_name] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 1000;
    [alertView show];
}

- (IBAction)phoneAction:(id)sender {
    
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"确定要向%@打电话?",_customerDetailModel.customer_name] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 2000;
    [alertView show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1000) {
        if (buttonIndex == 1) {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms://%@",_customerDetailModel.customer_mobile]]];

        }
        if (buttonIndex == 0) {
            
        }
    }
    if (alertView .tag == 2000) {
        if (buttonIndex == 1) {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_customerDetailModel.customer_mobile]]];
        }
        if (buttonIndex == 0) {
            
        }

    }
}
@end
