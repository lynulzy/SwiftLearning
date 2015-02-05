//
//  CommissionDetailCell.m
//  HouseMananger
//
//  Created by ZXH on 15/1/14.
//  Copyright (c) 2015年 ZSXJ. All rights reserved.
//

#import "CommissionDetailCell.h"

@interface CommissionDetailCell ()

@property(nonatomic, strong) UILabel *nameLab;
@property(nonatomic, strong) UILabel *totalpriceLab;
@property(nonatomic, strong) UILabel *commissionLab;

@end

@implementation CommissionDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self loadCellSubViews];
    }
    return self;
}

- (void)reloadCellSubViewsWithData:(NSDictionary *)dataDic forRow:(NSInteger)row withType:(NSString *)type{

    self.nameLab.text = dataDic[@"customer_name"];
    
    self.totalpriceLab.text = [NSString stringWithFormat:@"总价:￥%@万", dataDic[@"total_price"]];
    
    if ([type isEqualToString:@"1"]) {
        self.commissionLab.text = [NSString stringWithFormat:@"已结佣金:￥%@", dataDic[@"commission"]];
    }
    if ([type isEqualToString:@"2"]) {
        self.commissionLab.text = [NSString stringWithFormat:@"待结佣金:￥%@", dataDic[@"commission"]];
    }
}

- (void)loadCellSubViews {

    CGFloat backWidth = size_width - 20;
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(10, 8, size_width - 20, 5+25+5+20+10)];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.cornerRadius = 3;
    backView.layer.masksToBounds = YES;
    backView.layer.borderColor = [[UIColor colorWithWhite:0.5 alpha:1] CGColor];
    backView.layer.borderWidth = 0.2;
    [self.contentView addSubview:backView];
    
    self.nameLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, backWidth - 20, 25)];
    self.nameLab.font = [UIFont boldSystemFontOfSize:16.0F];
    [backView addSubview:self.nameLab];
    
    self.totalpriceLab = [[UILabel alloc] initWithFrame:CGRectMake(10, self.nameLab.frame.origin.y + self.nameLab.frame.size.height + 5, 100, 20)];
    self.totalpriceLab.font = [UIFont systemFontOfSize:15.0F];
    [backView addSubview:self.totalpriceLab];
    
    self.commissionLab = [[UILabel alloc] initWithFrame:CGRectMake(backWidth - 8 - 150, self.nameLab.frame.origin.y + self.nameLab.frame.size.height + 5, 140, 20)];
    self.commissionLab.textAlignment = NSTextAlignmentRight;
    self.commissionLab.font = [UIFont systemFontOfSize:15.0];
    [backView addSubview:self.commissionLab];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
