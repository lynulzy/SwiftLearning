//
//  BuildingParamsController.h
//  HouseMananger
//
//  Created by 王晗 on 15-1-4.
//  Copyright (c) 2015年 王晗. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BuildingDetalModel.h"
@interface BuildingParamsController : UITableViewController
@property (weak, nonatomic) IBOutlet UILabel *Label1;
@property (weak, nonatomic) IBOutlet UILabel *Label2;
@property (weak, nonatomic) IBOutlet UILabel *Label3;
@property (weak, nonatomic) IBOutlet UILabel *Label4;
@property (weak, nonatomic) IBOutlet UILabel *Label5;
@property (weak, nonatomic) IBOutlet UILabel *Label6;
@property (weak, nonatomic) IBOutlet UILabel *Label7;
@property (weak, nonatomic) IBOutlet UILabel *Label8;
@property (weak, nonatomic) IBOutlet UILabel *Label9;
@property (weak, nonatomic) IBOutlet UILabel *Label10;
@property (weak, nonatomic) IBOutlet UILabel *Label11;
@property (weak, nonatomic) IBOutlet UILabel *Label12;
@property (nonatomic,strong)BuildingDetalModel * buildingDetalModel;

@end
