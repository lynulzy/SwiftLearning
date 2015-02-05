//
//  MyNewsCell.m
//  HouseMananger
//
//  Created by ZXH on 15/1/12.
//  Copyright (c) 2015年 ZSXJ. All rights reserved.
//

#import "MyNewsCell.h"

#define INFO_LABEL_FONT     15.0F
#define LINE_VIEW_HEIGHT    0.5F

@interface MyNewsCell ()

@property(nonatomic, strong) UIView *backView;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *timeLabel;
@property(nonatomic, strong) UIView *lineView;
@property(nonatomic, strong) UILabel *infoLabel;

@end

@implementation MyNewsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self loadCellSubViews];
    }
    return self;
}

// Reload cell with data
- (void)reloadCellSubViewsWithData:(NSDictionary *)dataDic forRow:(NSInteger)row {
    
    // 标题
    self.titleLabel.text = dataDic[@"title"];
    self.titleLabel.frame = CGRectMake(15, 5, size_width - 60, 25);
    
    // 时间
    self.timeLabel.text = dataDic[@"create_time"];
    self.timeLabel.frame = CGRectMake(15, self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height, size_width - 60, 20);
    
    // 横线
    self.lineView.frame = CGRectMake(15, self.timeLabel.frame.origin.y + self.timeLabel.frame.size.height, size_width - 60, LINE_VIEW_HEIGHT);
    
    // 消息内容
    self.infoLabel.text = dataDic[@"content"];
    CGSize labelSize = [dataDic[@"content"] boundingRectWithSize:CGSizeMake(size_width - 60, 1000)
                                                  options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:INFO_LABEL_FONT]} context:nil].size;
    self.infoLabel.frame = CGRectMake(15, self.lineView.frame.origin.y + LINE_VIEW_HEIGHT + 10, size_width - 60, labelSize.height);
    
    // 背景
    self.backView.frame = CGRectMake(15, 10, size_width - 30, self.infoLabel.frame.origin.y + self.infoLabel.frame.size.height + 10);
//    NSInteger hhh = 5+25+20+10+labelSize.height+20+5
}

// Load base view
- (void)loadCellSubViews {

    self.backView = [[UIView alloc] init];
    self.backView.backgroundColor = [UIColor whiteColor];
    self.backView.layer.cornerRadius = 3;
    self.backView.layer.masksToBounds = YES;
    self.backView.layer.borderColor = [[UIColor colorWithWhite:0.5 alpha:1] CGColor];
    self.backView.layer.borderWidth = 0.2;
    [self.contentView addSubview:self.backView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:17.0F];
    [self.backView addSubview:self.titleLabel];
    
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.font = [UIFont systemFontOfSize:13.0F];
    self.timeLabel.textColor = [UIColor lightGrayColor];
    [self.backView addSubview:self.timeLabel];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor lightGrayColor];
    [self.backView addSubview:self.lineView];
    
    self.infoLabel = [[UILabel alloc] init];
    self.infoLabel.font = [UIFont systemFontOfSize:INFO_LABEL_FONT];
    self.infoLabel.numberOfLines = 0;
    [self.backView addSubview:self.infoLabel];
}




- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
