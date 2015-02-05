//
//  MyNewsCell.h
//  HouseMananger
//
//  Created by ZXH on 15/1/12.
//  Copyright (c) 2015年 ZSXJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyNewsCell : UITableViewCell

- (void)reloadCellSubViewsWithData:(NSDictionary *)dataDic forRow:(NSInteger)row;

@end
