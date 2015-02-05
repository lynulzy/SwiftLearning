//
//  HouseCell.m
//  HouseMananger
//
//  Created by 王晗 on 15/1/20.
//  Copyright (c) 2015年 王晗. All rights reserved.
//

#import "HouseCell.h"
#import "Common.h"
#import "UIViewExt.h"

@implementation HouseCell{
    int _x;
    NSMutableArray * _buttonArray;
    NSString * _value;
    NSInteger _index;
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
    _index = 0;
    _buttonArray = [NSMutableArray array];
    if (_buttonLabel == nil) {
        _buttonLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, 251, 22)];
        _buttonLabel.textColor = [UIColor grayColor];
        _buttonLabel.text = [NSString stringWithFormat:@"户型:%@",[_spertaeArray componentsJoinedByString:@"/"]];
        _buttonLabel.font=  [UIFont systemFontOfSize:14];
    }
    [self.contentView addSubview:_buttonLabel];
    int i ;
    _x = 0;
    int count = _array.count;
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
            [button addTarget:self action:@selector(houseAction:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = _x+100;
            button.font  =[UIFont systemFontOfSize:12];
            [button setTitle:[NSString stringWithFormat:@"%@",_array[_x-1]] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
            button.backgroundColor =  [UIColor redColor];
            for (NSString * titile in _spertaeArray) {
                if ([[button titleForState:UIControlStateNormal] isEqual:titile]) {
                    button.selected = YES;
                }
            }
            [self.contentView addSubview:button];
            [_buttonArray addObject:button];
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)houseAction:(UIButton *)button{
    _index ++;
    if (button.tag == 101 && button.selected == NO) {
        for (UIButton * button in _buttonArray) {
            if (button.tag == 101) {
                button.selected = YES;
            }else {
                button.selected = NO;
            }
        }
    }else {
        UIButton * firButton = _buttonArray[0];
        if (button.tag != 101 && firButton.selected == YES) {
            firButton.selected = NO;
        }
        button.selected = !button.selected;
    }
    NSMutableArray * arrayStr = [NSMutableArray  array];
    for (UIButton * button in _buttonArray) {
        if (button.selected == YES) {
            [arrayStr addObject:[button titleForState:UIControlStateSelected]];
        }
    }
    _value = [arrayStr componentsJoinedByString:@"/"];
    NSLog(@"value %@",_value);
    _passBlock(_value);
    _buttonLabel.text =[NSString stringWithFormat:@"户型:%@",_value];

}
@end
