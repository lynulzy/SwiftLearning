//
//  AgentRankCell.m
//  HouseMananger
//
//  Created by ZXH on 15/2/3.
//  Copyright (c) 2015年 ZSXJ. All rights reserved.
//

#import "AgentRankCell.h"

#define kRankingLabWidth            50.0F
#define kNameLabWidth               100.0F
#define kCompanyLabWidth            150.0F

#define NAME_COLOR          [UIColor colorWithRed:51.0/255.0 green:85.0/255.0 blue:139.0/255.0 alpha:1.0F]

@interface AgentRankCell ()
{
    UILabel *_rankingNum;
    UILabel *_agentName;
    UILabel *_agentCompany;
    UILabel *_agentPhoneNum;
}

@end
@implementation AgentRankCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self loadCellSubViews];
    }
    return self;
}

- (void)reloadCellSubViewsWithData:(NSDictionary *)dataDic withRow:(NSInteger)row {
    
    _rankingNum.text = [NSString stringWithFormat:@"%ld", row + 100];
    
    _agentName.text = dataDic[@"username"];
    
    _agentCompany.text = dataDic[@"company"];
    
    _agentPhoneNum.text = dataDic[@"mobile"];
    
}

- (void)loadCellSubViews {
    _rankingNum = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kRankingLabWidth, kRankingLabWidth)];
    _rankingNum.textAlignment = NSTextAlignmentCenter;
    _rankingNum.backgroundColor = [UIColor brownColor];
    _rankingNum.font = [UIFont boldSystemFontOfSize:24.0F];
    [self.contentView addSubview:_rankingNum];
    
    _agentName = [[UILabel alloc] initWithFrame:CGRectMake(kRankingLabWidth, 0, kNameLabWidth, kRankingLabWidth)];
    _agentName.textAlignment = NSTextAlignmentCenter;
    _agentName.textColor = NAME_COLOR;
    _agentName.font = [UIFont boldSystemFontOfSize:17.0F];
    _agentName.numberOfLines = 0;
    [self.contentView addSubview:_agentName];
    
    _agentCompany = [[UILabel alloc] initWithFrame:CGRectMake(kRankingLabWidth + kNameLabWidth, 0, kCompanyLabWidth, kRankingLabWidth/2)];
    _agentCompany.textAlignment = NSTextAlignmentLeft;
    _agentCompany.font = [UIFont boldSystemFontOfSize:16.0F];
    [self.contentView addSubview:_agentCompany];
    
    _agentPhoneNum = [[UILabel alloc] initWithFrame:CGRectMake(kRankingLabWidth + kNameLabWidth, kRankingLabWidth/2, kCompanyLabWidth, kRankingLabWidth/2)];
    _agentPhoneNum.textAlignment = NSTextAlignmentLeft;
    _agentPhoneNum.font = [UIFont boldSystemFontOfSize:16.0F];
    [self.contentView addSubview:_agentPhoneNum];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
