//
//  TalkDetailHeaderView.m
//  HouseMananger
//
//  Created by 王晗 on 15-1-5.
//  Copyright (c) 2015年 王晗. All rights reserved.
//

#import "TalkDetailHeaderView.h"

@implementation TalkDetailHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)talkAction:(id)sender {
    _talkBlock();
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    _eventPassBlock();
}
@end
