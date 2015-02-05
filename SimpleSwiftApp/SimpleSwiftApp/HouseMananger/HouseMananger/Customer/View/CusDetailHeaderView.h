//
//  CusDetailHeaderView.h
//  HouseMananger
//
//  Created by 王晗 on 15/1/21.
//  Copyright (c) 2015年 王晗. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerDetailModel.h"
@interface CusDetailHeaderView : UIView<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
- (IBAction)sendMsgAction:(id)sender;
- (IBAction)phoneAction:(id)sender;
@property (nonatomic,strong)CustomerDetailModel * customerDetailModel;
@end
