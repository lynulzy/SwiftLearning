//
//  ShowMsgCell.m
//  HouseMananger
//
//  Created by 王晗 on 15/1/21.
//  Copyright (c) 2015年 王晗. All rights reserved.
//

#import "ShowMsgCell.h"
#import "UIViewExt.h"
#import "Common.h"
@implementation ShowMsgCell

- (void)awakeFromNib {
}
- (void)setMsgStr:(NSString *)msgStr{
    if (_msgStr != msgStr) {
        _msgStr = msgStr;
    }
    [self setNeedsLayout];
    [self _creatView];
}
- (void)setIsUp:(BOOL)isUp{
    if (_isUp != isUp) {
        _isUp =isUp;
    }
    if (_isUp == YES) {
        _imgView.image =[UIImage imageNamed:@"向上.png"];
    }else{
        _imgView.image =[UIImage imageNamed:@"向下.png"];
    }
}
- (void)layoutSubviews{
    if (_msgStr != nil) {
        _msgLabel.adjustsFontSizeToFitWidth = YES;
        _msgLabel.text = _msgStr;
    }
}
- (void)_creatView{
    if (_imgView == nil ) {
        _imgView = [[UIImageView alloc] init];
        _imgView.frame = CGRectMake(kScreenWidth-60, (self.contentView.height-20)/2, 20, 10);
       _imgView.image =[UIImage imageNamed:@"向下.png"];
//        [_imgView setImage:[UIImage imageNamed:@"向上.png"] forState:UIControlStateSelected];
        [self.contentView addSubview:_imgView];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
