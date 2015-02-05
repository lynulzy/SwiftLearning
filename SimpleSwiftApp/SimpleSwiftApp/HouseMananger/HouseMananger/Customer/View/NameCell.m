//
//  NameCell.m
//  HouseMananger
//
//  Created by 王晗 on 15/1/19.
//  Copyright (c) 2015年 王晗. All rights reserved.
//

#import "NameCell.h"
#import "UIViewExt.h"
#import "Common.h"
#import "ZJSwitch.h"
@implementation NameCell{
    UIButton * _button;
}

- (void)awakeFromNib {
    _switch2 = [[ZJSwitch alloc] initWithFrame:CGRectMake(kScreenWidth-100, _valueLabel.origin.y-3, 70, 20)];
    _switch2.backgroundColor = [UIColor clearColor];
    _switch2.tintColor = [UIColor orangeColor];
    _switch2.onText = @"女士";
    _switch2.offText = @"男士";
    [_switch2 addTarget:self action:@selector(handleSwitchEvent:) forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:_switch2];

//    //创建按钮
//    _womanButton = [UIButton  buttonWithType:UIButtonTypeCustom];
//    _womanButton.font = [UIFont systemFontOfSize:16];
//    _womanButton.frame = CGRectMake(kScreenWidth-60,_valueLabel.origin.y-3 , 40, 30);
//    [_womanButton setTitle:@"女士" forState:UIControlStateNormal];
//    [_womanButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//    [_womanButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
//    [_womanButton addTarget:self action:@selector(selectSexAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.contentView addSubview:_womanButton];
//    
//    
//    _manButton = [UIButton  buttonWithType:UIButtonTypeCustom];
//    _manButton.frame = CGRectMake(_womanButton.left-60,_valueLabel.origin.y-3, 40, 30);
//    [_manButton setTitle:@"男士" forState:UIControlStateNormal];
//    _manButton.font = [UIFont systemFontOfSize:16];
//    [_manButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//    [_manButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
//    [_manButton addTarget:self action:@selector(selectSexAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.contentView addSubview:_manButton];
    
    
    [_valueLabel addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventEditingChanged];
}
- (void)handleSwitchEvent:(id)sender
{
    ZJSwitch * switch11 = sender;
    if (switch11.on == YES) {
        _passNameBlock(@"2");
    }
    if (switch11.on == NO) {
        _passNameBlock(@"1");
    }

    NSLog(@"%d",switch11.on);
    //    NSLog(@"%s", __FUNCTION__);
}

//- (void)selectSexAction:(UIButton *)button{
//    if (_button != button) {
//        _button.selected = NO;
//    }
//    button.selected = YES;
//    _button = button;
//    if (_button == _manButton) {
//        _passNameBlock(@"1");
//    }
//    if (_button == _womanButton) {
//        _passNameBlock(@"2");
//    }
//}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
}
- (void)valueChange:(UITextField *)textField{
    NSLog(@"textField:%@",textField.text);
    _passValueBlock(textField.text);
}
@end
