//
//  TalkingDetailCell.m
//  HouseMananger
//
//  Created by ZXH on 15/1/16.
//  Copyright (c) 2015年 ZSXJ. All rights reserved.
//

#import "TalkingDetailCell.h"

#import "UIImageView+WebCache.h"

#define kBackViewWidth      (size_width - 20)

#define kTopGapHeight       10.0F                                           // Top留白
#define kIconWidth          /*((size_width - 20) - 30) * 0.14 */ 40                // 头像宽度
#define kQuestionWidth      ((size_width - 20) - 30) * 0.86                 // 内容Label宽度
#define kTimeLabHeight      20.0F                                           // 时间高度

#define NAME_COLOR          [UIColor colorWithRed:51.0/255.0 green:85.0/255.0 blue:139.0/255.0 alpha:1.0F]

@interface TalkingDetailCell ()

@property(nonatomic, strong) UIView *backView;
// 头像
@property(nonatomic, strong) UIImageView *headIconIV;
// 问题
@property(nonatomic, strong) UILabel *contentLab;
// 时间
@property(nonatomic, strong) UILabel *timeLab;
// 回复按钮
@property(nonatomic, strong) UIButton *replayBtn;
// 小横线
@property(nonatomic, strong) UIView *lineView;

@end


@implementation TalkingDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self loadCellSubViews];
    }
    return self;
}

- (void)reloadCellSubViewsWithData:(NSDictionary *)dataDic forRow:(NSInteger)row {

    // Head Icon
    self.headIconIV.frame = CGRectMake(8, kTopGapHeight, kIconWidth, kIconWidth);
    self.headIconIV.image = nil;
    [self.headIconIV sd_setImageWithURL:[NSURL URLWithString:dataDic[@"portrait"]] placeholderImage:[UIImage imageNamed:@"headIcon.png"]];
    
    // Username and Content Label
    NSString *completeStr;
    NSString *usernameStr = dataDic[@"username"];
    NSString *replaynameStr = dataDic[@"reply_name"];
    NSString *contentStr = dataDic[@"content"];
    
    if ([usernameStr isEqualToString:replaynameStr]) {
        completeStr = [NSString stringWithFormat:@"%@：%@", usernameStr, contentStr];
    } else {
        completeStr = [NSString stringWithFormat:@"%@回复%@：%@", usernameStr, replaynameStr, contentStr];
    }
    NSMutableAttributedString* aStr = [[NSMutableAttributedString alloc] initWithString:completeStr];
    
    [aStr addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                         [UIFont boldSystemFontOfSize:14.0F], NSFontAttributeName,
                         NAME_COLOR, NSForegroundColorAttributeName, nil]
                  range:[completeStr rangeOfString:dataDic[@"username"]]];
    
    [aStr addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                         [UIFont boldSystemFontOfSize:14.0F], NSFontAttributeName,
                         NAME_COLOR, NSForegroundColorAttributeName, nil]
                  range:[completeStr rangeOfString:dataDic[@"reply_name"]]];
    
    CGSize qLabelSize = [self calculateLabelSizeWith:completeStr andTheSize:CGSizeMake(kQuestionWidth, 1000) andTheFont:[UIFont systemFontOfSize:14.0F]];
    
    self.contentLab.frame = CGRectMake(kIconWidth + 20,
                                       kTopGapHeight,
                                       kQuestionWidth,
                                       qLabelSize.height);
    self.contentLab.attributedText = aStr;
    
    // Time
    self.timeLab.frame = CGRectMake(kIconWidth + 20,
                                    self.contentLab.frame.origin.y + self.contentLab.frame.size.height + 5,
                                    kQuestionWidth - 50,
                                    kTimeLabHeight);
    self.timeLab.text = dataDic[@"create_time"];
    
    // Replay button
    self.replayBtn.frame = CGRectMake(20 + kIconWidth + kQuestionWidth - 50, self.contentLab.frame.origin.y + self.contentLab.frame.size.height + 5, 50, kTimeLabHeight);
    
    // Bottom line
    self.lineView.frame = CGRectMake(5,
                                     self.timeLab.frame.origin.y + self.timeLab.frame.size.height + 4.4F,
                                     kBackViewWidth - 10,
                                     0.3F);
    
    // Back view
    CGFloat backViewHight = kTopGapHeight + qLabelSize.height + kTimeLabHeight + 10;
    self.backView.frame = CGRectMake(15, 0, kBackViewWidth, backViewHight);

}

- (void)loadCellSubViews {

    // Back View
    self.backView = [[UIView alloc] init];
    self.backView.backgroundColor = BACK_COLOR;
    [self.contentView addSubview:self.backView];
    
    // 头像
    self.headIconIV = [[UIImageView alloc] init];
    self.headIconIV.backgroundColor = [UIColor clearColor];
    self.headIconIV.layer.masksToBounds = YES;
    self.headIconIV.layer.cornerRadius = kIconWidth/2;
    self.headIconIV.layer.borderColor = [[UIColor colorWithWhite:0.2 alpha:0.8] CGColor];
    self.headIconIV.layer.borderWidth = 0.2;
    [self.backView addSubview:self.headIconIV];
    
    // 内容Label
    self.contentLab = [[UILabel alloc] init];
    self.contentLab.font = [UIFont systemFontOfSize:14.0F];
    self.contentLab.numberOfLines = 0;
    [self.backView addSubview:self.contentLab];
    
    // 发表时间
    self.timeLab = [[UILabel alloc] init];
    self.timeLab.textColor = [UIColor grayColor];
    self.timeLab.backgroundColor = [UIColor clearColor];
    self.timeLab.font = [UIFont systemFontOfSize:13.5F];
    [self.backView addSubview:self.timeLab];
    
    // 回复按钮
    self.replayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.replayBtn setTitle:@"回复" forState:UIControlStateNormal];
    self.replayBtn.titleLabel.font = [UIFont systemFontOfSize:13.0F];
    self.replayBtn.backgroundColor = [UIColor redColor];
//    [self.backView addSubview:self.replayBtn];
    
    // 底部 横线
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor lightGrayColor];
    [self.backView addSubview:self.lineView];
}

- (CGSize)calculateLabelSizeWith:(NSString *)theStr andTheSize:(CGSize)theSize andTheFont:(UIFont*)theFont {
 
    CGSize size;
    if (IOS7Later) {
        // Calculate label height
        size = [theStr boundingRectWithSize:theSize
                                    options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                 attributes:@{NSFontAttributeName:theFont} context:nil].size;
    } else {
        size = [theStr sizeWithFont:theFont constrainedToSize:theSize];
    }

    return size;
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
    
}

@end
