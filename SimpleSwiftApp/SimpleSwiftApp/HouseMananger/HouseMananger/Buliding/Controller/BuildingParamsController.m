//
//  BuildingParamsController.m
//  HouseMananger
//
//  Created by 王晗 on 15-1-4.
//  Copyright (c) 2015年 王晗. All rights reserved.
//

#import "BuildingParamsController.h"
#import "Common.h"
@interface BuildingParamsController ()

@end

@implementation BuildingParamsController
- (void)viewDidLoad {

    [super viewDidLoad];
    self.title = @"参数详情";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _Label1.text = _buildingDetalModel.startTime;
    _Label2.text = _buildingDetalModel.developer;
    _Label3.text = _buildingDetalModel.property_company;
    _Label4.text = _buildingDetalModel.property_type;
    _Label5.text = _buildingDetalModel.building_type;
    _Label6.text = _buildingDetalModel.building_area;
    _Label7.text = _buildingDetalModel.renovation_situation;
    _Label8.text = _buildingDetalModel.house_number;
    _Label9.text = _buildingDetalModel.car_number;
    _Label10.text = _buildingDetalModel.plot_ratio;
    _Label11.text = _buildingDetalModel.green_ratio;
    _Label12.text = _buildingDetalModel.property_fee;

}
- (void)setBuildingDetalModel:(BuildingDetalModel *)buildingDetalModel{
    if (_buildingDetalModel != buildingDetalModel) {
        _buildingDetalModel = buildingDetalModel;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 35;

}
#pragma mark - Table view data source


@end
