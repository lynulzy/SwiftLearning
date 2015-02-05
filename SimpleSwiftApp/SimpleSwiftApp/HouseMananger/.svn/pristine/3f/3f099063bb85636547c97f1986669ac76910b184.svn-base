//
//  ButtonCell.m
//  HouseMananger
//
//  Created by 王晗 on 15/1/20.
//  Copyright (c) 2015年 王晗. All rights reserved.
//

#import "ButtonCell.h"
#import "Common.h"
#import "UIViewExt.h"
@implementation ButtonCell{
    int _x;
    NSMutableArray * _buttonArray;
    NSString * _value;
}



- (void)awakeFromNib {
    // Initialization code
}
- (void)setArray:(NSArray *)array{
    if (_array != array) {
        _array = array;
    }
    [self _creatViews];
}
- (void)_creatViews{
//    _value = [NSString string];
    
    _buttonArray = [NSMutableArray array];
    if (_buttonLabel == nil) {
        _buttonLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, 251, 22)];
        _buttonLabel.numberOfLines = 0;
        [_buttonLabel adjustsFontSizeToFitWidth];
        _buttonLabel.textColor = [UIColor grayColor];
        _buttonLabel.font = [UIFont systemFontOfSize:14];
        _buttonLabel.text = [NSString stringWithFormat:@"区域:%@",[_spertaeArray componentsJoinedByString:@"/"]];
    }
    [self.contentView addSubview:_buttonLabel];
    int i ;
    _x = 0;
    int count = _array.count+1;
    if (count%3==0 && count/3 != 0) {
        i = count/3;
    }else{
        i = count/3+1;
    }
    for (int j = 0; j<3; j++) {
        for (int z = 0; z<i; z++) {
            _x++;
            if (_x>count) {
                return;
            }
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(20+j*((kScreenWidth-80)/3+20), _buttonLabel.bottom+10+z*(30+10), (kScreenWidth-80)/3, 30);
            button.tag = _x+300;
            [button addTarget:self action:@selector(regionAction:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
            button.font  =[UIFont systemFontOfSize:12];
            if (j==0 && z==0) {
                [button setTitle:[NSString stringWithFormat:@"%@",@"不限"] forState:UIControlStateNormal];
            }else{
                [button setTitle:[NSString stringWithFormat:@"%@",_array[_x-2]] forState:UIControlStateNormal];
            }
            if (_x == 1) {
                NSLog(@"%@",button);
            }
            for (NSString * titile in _spertaeArray) {
                if ([[button titleForState:UIControlStateNormal] isEqual:titile]) {
                    button.selected = YES;
                }
            }
            button.backgroundColor =  [UIColor redColor];
            [_buttonArray addObject:button];
            [self.contentView addSubview:button];
        }
    }
    UILabel * spareLabel =[[UILabel alloc] initWithFrame:CGRectMake(_buttonLabel.origin.x, self.contentView.height-1, kScreenWidth-7-_buttonLabel.left, 1)];
    spareLabel.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    [self.contentView addSubview:spareLabel];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//0x7a08c830
- (void)regionAction:(UIButton *)button{
    _buttonLabel.text = @"区域";
    if (button.tag == 301 && button.selected == NO) {
        for (UIButton * button in _buttonArray) {
            if (button.tag == 301) {
                button.selected = YES;
            }else {
                button.selected = NO;
            }
        }
    }else {
        UIButton * firButton = _buttonArray[0];
        if (button.tag != 301 && firButton.selected == YES) {
            firButton.selected = NO;
        }
        button.selected = !button.selected;
        NSLog(@"Last:%d",firButton.selected);
    }
    NSMutableArray * arrayStr = [NSMutableArray  array];
    for (UIButton * button in _buttonArray) {
        if (button.selected == YES) {
            [arrayStr addObject:[button titleForState:UIControlStateSelected]];
        }
    }
    _value = [arrayStr componentsJoinedByString:@"/"];
     NSLog(@"value %@",_value);
    _passValue(_value);
    _buttonLabel.text =[NSString stringWithFormat:@"区域:%@",_value];
}
@end
