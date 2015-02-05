//
//  MessageCell.m
//  HouseMananger
//
//  Created by 王晗 on 15-1-8.
//  Copyright (c) 2015年 王晗. All rights reserved.
//

#import "MessageCell.h"

@implementation MessageCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setMsgModel:(MessageModel *)msgModel{
    if (_msgModel != msgModel) {
        _msgModel  = msgModel;
        [self setNeedsLayout];
    }
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.timeLabel.text = _msgModel.create_time;
    [self.timeLabel sizeToFit];
    self.titleLabel.text = _msgModel.title;
    [self.titleLabel sizeToFit];
    self.contentLabel.text = _msgModel.content;
    [self.contentLabel sizeToFit];
}
@end
