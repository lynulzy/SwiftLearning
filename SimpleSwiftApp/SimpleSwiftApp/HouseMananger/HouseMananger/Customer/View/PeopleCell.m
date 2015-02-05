//
//  PeopleCell.m
//  HouseMananger
//
//  Created by 王晗 on 15/1/19.
//  Copyright (c) 2015年 王晗. All rights reserved.
//

#import "PeopleCell.h"

@implementation PeopleCell

- (void)awakeFromNib {

    [self.selectButton setBackgroundImage:[UIImage imageNamed:@"playing_btn_in_myfavor_h.png"] forState:UIControlStateNormal];
//    [self.selectButton setImage:[UIImage imageNamed:@"playing_btn_in_myfavor@2x.png"] forState:UIControlStateSelected];
    [self.selectButton setBackgroundImage:[UIImage imageNamed:@"playing_btn_in_myfavor.png"] forState:UIControlStateSelected];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setCustomerModel:(CustomerModel *)customerModel{
    if (_customerModel != customerModel) {
        _customerModel = customerModel ;
    }
    [self setNeedsLayout];
}
- (void)setTkAdressBook:(TKAddressBook *)tkAdressBook{
    if (_tkAdressBook != tkAdressBook) {
        _tkAdressBook = tkAdressBook;
    }
    [self setNeedsLayout];
}
- (void)setSelectCellArray:(NSArray *)selectCellArray{
    if (_selectCellArray != selectCellArray) {
        _selectCellArray = selectCellArray;
    }
    [self setNeedsLayout];
}
- (void)layoutSubviews{
    if (_selectCellArray.count >0) {
        _selectButton.hidden = NO;
        self.selectButton.selected = NO;
        for (NSString * customer_id in _selectCellArray) {
            if ([_customerModel.customer_id isEqualToString:customer_id]) {
                self.selectButton.selected = YES;
            }
        }
    }
    if (_customerModel != nil) {
        _nameLabel.text = _customerModel.customer_name;
        _phoneLabel.text = _customerModel.customer_mobile;
        switch ([_customerModel.customer_status integerValue]) {
            case 1:
                _statusImgView.image = [UIImage imageNamed:@"无效客户.png"];
                _statusImgView.hidden = NO;
                _addCustomerButton.hidden = YES;
                break;
            case 2:
                _statusImgView.image = [UIImage imageNamed:@"未报备.png"];
                _statusImgView.hidden = YES;
                _addCustomerButton.hidden = NO;
                break;
            case 3:
                _statusImgView.image = [UIImage imageNamed:@"已报备.png"];
                _statusImgView.hidden = NO;
                _addCustomerButton.hidden = YES;
                break;
            case 4:
                _statusImgView.image = [UIImage imageNamed:@"已带看.png"];
                _statusImgView.hidden = NO;
                _addCustomerButton.hidden = YES;
                break;
            case 5:
                _statusImgView.image = [UIImage imageNamed:@"已预约.png"];
                _statusImgView.hidden = NO;
                _addCustomerButton.hidden = YES;
                break;
            case 6:
                _statusImgView.image = [UIImage imageNamed:@"已认购.png"];
                _statusImgView.hidden = NO;
                _addCustomerButton.hidden = YES;
                break;
            case 7:
                _statusImgView.image = [UIImage imageNamed:@"已结佣.png"];
                _statusImgView.hidden = NO;
                _addCustomerButton.hidden = YES;
                break;
        }
        return;
    }
    if (_tkAdressBook != nil) {
        _statusImgView.hidden = YES;
        _selectButton.hidden = YES;
        _addCustomerButton.hidden = YES;
        _nameLabel.text = _tkAdressBook.name;
        _phoneLabel.text = _tkAdressBook.tel;
        return;
    }
    if (_tkAdressBook == nil && _customerModel == nil) {
        _statusImgView.hidden = YES;
        _addCustomerButton.hidden = YES;
        _selectButton.hidden = YES;
        _nameLabel.text = @"";
        _phoneLabel.text = @"";
        return;
    }
}
- (IBAction)addCustomerAction:(id)sender {
    
    _passEvent();
}
@end
