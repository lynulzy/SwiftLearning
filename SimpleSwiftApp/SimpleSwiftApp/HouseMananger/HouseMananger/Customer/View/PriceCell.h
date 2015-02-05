//
//  PriceCell.h
//  HouseMananger
//
//  Created by 王晗 on 15/1/20.
//  Copyright (c) 2015年 王晗. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NMRangeSlider.h"
typedef void (^PassValue)(NSString * value,CGFloat minValue,CGFloat maxValue);
@interface PriceCell : UITableViewCell
- (IBAction)sliderAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (nonatomic,copy)PassValue passValue;
@property (nonatomic,assign)CGFloat sliderValue;
@property (nonatomic,strong)NMRangeSlider * sliderView;
@property (nonatomic,assign)CGFloat minValue;
@property (nonatomic,assign)CGFloat maxValue;

@end
