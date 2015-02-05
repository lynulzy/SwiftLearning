//
//  BuildingCell.h
//  HouseMananger
//
//  Created by 王晗 on 14-12-30.
//  Copyright (c) 2014年 王晗. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BuildingModel.h"
typedef void (^PassValue)(NSString *);
@interface BuildingCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *managerLabel;
@property (weak, nonatomic) IBOutlet UILabel *customerLabel;
@property (weak, nonatomic) IBOutlet UIImageView *logoImgView;
- (IBAction)addCustomer:(id)sender;
@property (nonatomic,strong)BuildingModel * buildingModel;

@property (nonatomic,copy)PassValue passValueBlock;
@end
