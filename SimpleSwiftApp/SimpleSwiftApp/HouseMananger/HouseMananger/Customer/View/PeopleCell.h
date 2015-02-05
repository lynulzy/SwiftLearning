//
//  PeopleCell.h
//  HouseMananger
//
//  Created by 王晗 on 15/1/19.
//  Copyright (c) 2015年 王晗. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerModel.h"
#import "TKAddressBook.h"
typedef void (^PassEvent)();
@interface PeopleCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
- (IBAction)addCustomerAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *addCustomerButton;
@property (nonatomic,strong)CustomerModel * customerModel;
@property (nonatomic,strong)TKAddressBook * tkAdressBook;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UIImageView *statusImgView;
@property (nonatomic,strong)NSArray * selectCellArray;
@property (nonatomic,copy)PassEvent  passEvent;
@end
