//
//  TalkingListCell.m
//  HouseMananger
//
//  Created by ZXH on 15/1/15.
//  Copyright (c) 2015年 ZSXJ. All rights reserved.
//

#import "TalkingListCell.h"

#import "UIImageView+WebCache.h"

#define kBackViewWidth      (size_width - 26)

#define kTopGapHeight       10.0F                                           // Top留白
#define kIconWidth          ((size_width - 26) - 30) * 0.16                 // 头像宽度
#define kUserNameHeight     ((size_width - 26) - 30) * 0.16/2               // 姓名Lab   头像宽度的一半
#define kQuestionWidth      ((size_width - 26) - 30) * 0.84                 // 问题Label宽度
#define kImageWidth         (((size_width - 26) - 30) * 0.84 - 40) / 3      // 图片宽度
#define kTimeLabHeight      20.0F                                           // 时间高度

#define BUILD_NAME_COLOR    [UIColor colorWithRed:0/255.0F green:119/255.0F blue:80/255.0F alpha:1]

@interface TalkingListCell ()

@property(nonatomic, strong) UIView *backView;
// 头像
@property(nonatomic, strong) UIImageView *headIconIV;
// 昵称
@property(nonatomic, strong) UILabel *userNameLab;
// 时间
@property(nonatomic, strong) UILabel *timeLab;
// 评论数
@property(nonatomic, strong) UILabel *replyCount;
// 问题
@property(nonatomic, strong) UILabel *contentLab;
// 楼盘名称
@property(nonatomic, strong) UILabel *buildNameLab;
// 小横线
@property(nonatomic, strong) UIView *lineView;

@property(nonatomic, strong) NSMutableArray *imageArr;

@end


@implementation TalkingListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.imageArr = [[NSMutableArray alloc] initWithCapacity:0];
        [self loadCellSubViews];
    }
    return self;
}

// Reload cell with data
- (void)reloadCellSubViewsWithData:(NSDictionary *)dataDic forRow:(NSInteger)row {
    
    // 头像
    self.headIconIV.frame = CGRectMake(10, kTopGapHeight, kIconWidth, kIconWidth);
    self.headIconIV.image = nil;
    [self.headIconIV sd_setImageWithURL:[NSURL URLWithString:dataDic[@"portrait"]] placeholderImage:[UIImage imageNamed:@"headIcon.png"]];
    
    // 昵称(用户名)
    self.userNameLab.text = dataDic[@"username"];
    self.userNameLab.frame = CGRectMake(kIconWidth + 20, kTopGapHeight, 150, kIconWidth/2);
    
    // 楼盘名称
    if ([dataDic[@"name"] isEqual:[NSNull null]]) {
        self.buildNameLab.frame = CGRectMake(kIconWidth + 20,
                                             self.userNameLab.frame.origin.y + self.userNameLab.frame.size.height,
                                             0,
                                             0);
        self.buildNameLab.text = @"";
    } else {
        self.buildNameLab.frame = CGRectMake(kIconWidth + 20,
                                             self.userNameLab.frame.origin.y + self.userNameLab.frame.size.height,
                                             200,
                                             kIconWidth/2);
        NSString *completeStr = [NSString stringWithFormat:@"来自「%@」",dataDic[@"name"]];
        NSMutableAttributedString* aStr = [[NSMutableAttributedString alloc] initWithString:completeStr];
        
        [aStr addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                             [UIFont boldSystemFontOfSize:13.5F], NSFontAttributeName,
                             BUILD_NAME_COLOR, NSForegroundColorAttributeName, nil]
                      range:[completeStr rangeOfString:dataDic[@"name"]]];
        self.buildNameLab.attributedText = aStr;
    }
    
    // 内容Label
    CGSize qLabelSize = CGSizeMake(0, 0);
    if (IOS7Later) {
        // 计算Label高度
        qLabelSize = [dataDic[@"content"] boundingRectWithSize:CGSizeMake(kQuestionWidth, 1000)
                                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0F]} context:nil].size;
    } else {
        qLabelSize = [dataDic[@"content"] sizeWithFont:[UIFont systemFontOfSize:15.0F] constrainedToSize:CGSizeMake(kQuestionWidth, 1000)];
    }
    self.contentLab.frame = CGRectMake(kIconWidth + 20,
                                       self.buildNameLab.frame.origin.y + self.buildNameLab.frame.size.height,
                                       kQuestionWidth,
                                       qLabelSize.height);
    self.contentLab.text = dataDic[@"content"];
    
    // 图片
    NSArray *picArr = dataDic[@"pic"];
    
    NSInteger imageCount = picArr.count;
    for (NSInteger i = 0; i < 9; i++) {
        UIImageView *imageView = self.imageArr[i];
        if (imageCount > i) {
            imageView.hidden = NO;
            imageView.frame = CGRectMake((kIconWidth + 20) + i % 3 * (kImageWidth + 5),
                                         self.contentLab.frame.origin.y + self.contentLab.frame.size.height + 5 + i/3*(kImageWidth + 5),
                                         kImageWidth,
                                         kImageWidth);
            imageView.tag = (row + 1) * 10000 + i;
            imageView.image = nil;
            
            [imageView sd_setImageWithURL:[NSURL URLWithString:picArr[i]] placeholderImage:[UIImage imageNamed:@"placeholderPic.png"]];
        } else {
            imageView.image = nil;
            imageView.hidden = YES;
        }
    }
    
    // 图片行数
    NSInteger imageLineCount = (0 != imageCount %3 ? imageCount / 3 + 1 : imageCount / 3);
    
    // 发表时间 && 评论数
    if (0 != imageCount) {
        self.timeLab.frame = CGRectMake(kIconWidth + 20,
                                        self.contentLab.frame.origin.y + self.contentLab.frame.size.height + 5 + imageLineCount * (kImageWidth + 5),
                                        kQuestionWidth - 80,
                                        kTimeLabHeight);
        
        self.replyCount.frame = CGRectMake(kIconWidth + 20 + kQuestionWidth - 80,
                                           self.contentLab.frame.origin.y + self.contentLab.frame.size.height + 5 + imageLineCount * (kImageWidth + 5),
                                           80,
                                           kTimeLabHeight);
    } else {
        self.timeLab.frame = CGRectMake(kIconWidth + 20,
                                        self.contentLab.frame.origin.y + self.contentLab.frame.size.height + 5,
                                        kQuestionWidth - 80,
                                        kTimeLabHeight);
        self.replyCount.frame = CGRectMake(kIconWidth + 20 + kQuestionWidth - 80,
                                           self.contentLab.frame.origin.y + self.contentLab.frame.size.height + 5,
                                           80,
                                           kTimeLabHeight);
    }
    self.timeLab.text = dataDic[@"create_time"];
    self.replyCount.text = [NSString stringWithFormat:@"评论（%@）", dataDic[@"CommentCount"]];
    
    // 底部 横线
    self.lineView.frame = CGRectMake(10,
                                     self.timeLab.frame.origin.y + self.timeLab.frame.size.height + 4.5,
                                     size_width - 20,
                                     0.5);
    
    
    CGFloat backViewHight = kTopGapHeight + kUserNameHeight + self.buildNameLab.frame.size.height + qLabelSize.height + 5 + imageLineCount * (kImageWidth + 5) + kTimeLabHeight + 5;
    self.backView.frame = CGRectMake(13, 3, kBackViewWidth, backViewHight);
}

- (void)loadCellSubViews {
    // Back View
    self.backView = [[UIView alloc] init];
    self.backView.backgroundColor = [UIColor whiteColor];
    self.backView.layer.cornerRadius = 3;
    self.backView.layer.masksToBounds = YES;
    self.backView.layer.borderColor = [[UIColor colorWithWhite:0.5 alpha:1] CGColor];
    self.backView.layer.borderWidth = 0.3;
    [self.contentView addSubview:self.backView];
    
    // 头像
    self.headIconIV = [[UIImageView alloc] init];
    self.headIconIV.backgroundColor = [UIColor clearColor];
    self.headIconIV.layer.masksToBounds = YES;
    self.headIconIV.layer.cornerRadius = kIconWidth/2;
    self.headIconIV.layer.borderColor = [[UIColor colorWithWhite:0.2 alpha:0.8] CGColor];
    self.headIconIV.layer.borderWidth = 0.2;
    
    [self.backView addSubview:self.headIconIV];
    
    // 昵称(用户名)
    self.userNameLab = [[UILabel alloc] init];
    self.userNameLab.font = [UIFont boldSystemFontOfSize:15.0F];
    self.userNameLab.textColor = [UIColor colorWithRed:51.0/255.0
                                                 green:85.0/255.0
                                                  blue:139.0/255.0
                                                 alpha:1.0F];
    [self.backView addSubview:self.userNameLab];
    
    // 楼盘名称
    self.buildNameLab = [[UILabel alloc] init];
    self.buildNameLab.font = [UIFont systemFontOfSize:13.5F];
    self.buildNameLab.textColor = [UIColor darkGrayColor];
    [self.backView addSubview:self.buildNameLab];
    
    // 内容Label
    self.contentLab = [[UILabel alloc] init];
    self.contentLab.font = [UIFont systemFontOfSize:15.0F];
    self.contentLab.numberOfLines = 0;
//    self.contentLab.backgroundColor = [UIColor brownColor];
    [self.backView addSubview:self.contentLab];
    
    // 图片
    for (NSInteger i = 0; i < 9; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.backgroundColor = BACK_COLOR;
        [self.imageArr addObject:imageView];
        [self.backView addSubview:imageView];
        
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *enlargeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchEnlarge:)];
        [imageView addGestureRecognizer:enlargeTap];
    }
    
    // 发表时间
    self.timeLab = [[UILabel alloc] init];
    self.timeLab.textColor = [UIColor grayColor];
//    self.timeLab.backgroundColor = [UIColor blueColor];
    self.timeLab.font = [UIFont systemFontOfSize:13.5F];
    [self.backView addSubview:self.timeLab];
    
    // 评论数
    self.replyCount = [[UILabel alloc] init];
    self.replyCount.textColor = [UIColor grayColor];
    self.replyCount.font = [UIFont systemFontOfSize:13.5F];
    self.replyCount.textAlignment = NSTextAlignmentRight;
    [self.backView addSubview:self.replyCount];
    
    // 底部 横线
    self.lineView = [[UIView alloc] init];
//    self.lineView.backgroundColor = [UIColor redColor];
    [self.backView addSubview:self.lineView];
}

- (void)touchEnlarge:(UITapGestureRecognizer*)tap {
    NSInteger tag = tap.view.tag;
    NSInteger row = tag / 10000 - 1;
    NSInteger currPage = tag % 10000 + 1;
    
    [self.delegate imageViewTouchEnlargeWithRow:row andCurrentPage:currPage];
    
    DDLog(@"row = %ld, currPage = %ld", (long)row, (long)currPage)
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
