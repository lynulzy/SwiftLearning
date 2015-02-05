//
//  TalkCell.m
//  HouseMananger
//
//  Created by 王晗 on 15-1-4.
//  Copyright (c) 2015年 王晗. All rights reserved.
//

#import "TalkCell.h"

@implementation TalkCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setComentModel:(ComentModel *)comentModel{
    if (_comentModel != comentModel) {
        _comentModel = comentModel;
    }
    [self setNeedsLayout];
}
- (void)layoutSubviews{
    _companyLabel.text = [NSString stringWithFormat:@"/%@",_comentModel.company];
    _nameLabel.text = [NSString stringWithFormat:@"%@",_comentModel.name];
    [_nameLabel sizeThatFits:CGSizeMake(48, 21)];
    _contentLabel.text = [NSString stringWithFormat:@"%@",_comentModel.content];
    _timeLabel.text = [[NSString stringWithFormat:@"%@",_comentModel.create_time] substringToIndex:10];
    _comentLabelCount.text = [NSString stringWithFormat:@"评论数量:%@",_comentModel.CommentCount];
}
@end
