//
//  EditCustomerController.h
//  HouseMananger
//
//  Created by 王晗 on 15/1/19.
//  Copyright (c) 2015年 王晗. All rights reserved.
//

#import "BaseViewController.h"
#import "TKAddressBook.h"
#import "CustomerDetailModel.h"
@interface EditCustomerController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UIAlertViewDelegate>
@property (nonatomic,strong)TKAddressBook * tkAddressBook;
@property (nonatomic,strong)CustomerDetailModel * customerDetailModel;
@property (nonatomic,assign)BOOL isEdit;
@end
