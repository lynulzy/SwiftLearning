//
//  EditCustomerController.m
//  HouseMananger
//
//  Created by 王晗 on 15/1/19.
//  Copyright (c) 2015年 王晗. All rights reserved.
//

#import "EditCustomerController.h"
#import "Common.h"
#import "UIViewExt.h"
#import "NameCell.h"
#import "PriceCell.h"
#import "ButtonCell.h"
#import "MyDataService.h"
#import "MBProgressHUD.h"
#import "AFHTTPRequestOperation.h"
#import "HouseCell.h"
#import "UserTmpParam.h"
#import "ShowMsgCell.h"
#import "CustomerViewController.h"
#import "LoginViewController.h"
static NSString * nameCellId= @"NameCell";
static NSString * priceCellId= @"PriceCell";
static NSString * buttonCellId= @"ButtonCell";
static NSString * houseCellId= @"HouseCell";
static NSString * showMsgCellId= @"ShowMsgCell";
@interface EditCustomerController (){
    UITableView * _tabView;
    BOOL _isOpen;
    NSMutableArray * _cityButtonArray;
    NSArray * _array;
    MBProgressHUD * _hud;
    AFHTTPRequestOperation * _regionReqOpera;
    AFHTTPRequestOperation * _addCustomerOpera;
    NSString * _phone;
    NSString * _name;
    NSString * _sex;
    NSString * _regionStr;
    NSString * _houseType;
    NSString * _priceRange;
    NSString * _purchase_intentions;
    CGFloat _minValue;
    CGFloat _maxValue;
    NSString * _value;
    UILabel * _purchaseLabel;
    UITextField * _text1;
    UITextField * _text2;
}
@end

@implementation EditCustomerController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"编辑客户";
    if (_isEdit == NO) {
        _name = _tkAddressBook.name;
        _phone = _tkAddressBook.tel;
        _sex = @"1";
    }else{
        _phone = _customerDetailModel.customer_mobile;
        _name =  _customerDetailModel.customer_name;
        _regionStr = _customerDetailModel.region;
        _houseType = _customerDetailModel.house_type;
//        _minValue = 0;
//        _maxValue = 100;
        if (![_customerDetailModel.price_range isEqualToString:@"(null)"]) {
            NSArray * array =  [_customerDetailModel.price_range componentsSeparatedByString:@"-"];
            _minValue = [array[0] floatValue]/10;
            if ([array[1] isEqualToString:@"0"]) {
                _maxValue = 100;
                _priceRange = [NSString stringWithFormat:@"%@万以上",array[0]];
            }
            if ([array[0] isEqualToString:@"0"]) {
                _maxValue = [array[1] floatValue]/10;
                _priceRange = [NSString stringWithFormat:@"%@万以下",array[1]];
            }
            if (![array[1] isEqualToString:@"0"] && ![array[0]isEqualToString:@"0"]) {
//                _minValue = [array[0] floatValue]/10;
                _maxValue = [array[1] floatValue]/10;
                _priceRange = [NSString stringWithFormat:@"%@万-%@万",array[0],array[1]];
            }
            if ([array[1] isEqualToString:@"0"]&&[array[0] isEqualToString:@"0"]) {
                _maxValue = 100;
                _priceRange = @"不限";
            }
        }else {
            _priceRange = @"不限" ;
        }
        
        NSLog(@"min:%.0f max:%.0f priceRance:%@ ",_minValue,_maxValue,_priceRange);
        _purchase_intentions = [NSString stringWithFormat:@"%@,%@,%@",_regionStr,_priceRange,_houseType];
        if ([_customerDetailModel.customer_sex integerValue] == 1) {
            _sex = @"1";
        }else{
            _sex = @"2";
        }
    }
    if (_regionStr == nil || _houseType == nil || _priceRange == nil) {
        _houseType = @"不限";
        _priceRange = @"不限";
        _regionStr = @"不限";
    }
    if (_tabView == nil) {
        _tabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStyleGrouped];
        _tabView.delegate = self;
        _tabView.dataSource=  self;
        [_tabView registerNib:[UINib nibWithNibName:@"NameCell" bundle:nil] forCellReuseIdentifier:nameCellId];
        [_tabView registerNib:[UINib nibWithNibName:@"PriceCell" bundle:nil] forCellReuseIdentifier:priceCellId];
        [_tabView registerClass:[ButtonCell class] forCellReuseIdentifier:buttonCellId];
        [_tabView registerClass:[HouseCell class] forCellReuseIdentifier:houseCellId];
        [_tabView registerNib:[UINib nibWithNibName:@"ShowMsgCell" bundle:nil] forCellReuseIdentifier:showMsgCellId];
        _tabView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tabView];
    }
    [self _creatTabFooterView];
    [self _loadDataByCityID:[[NSUserDefaults standardUserDefaults] objectForKey:@"cityId"]];
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        //YES: 当前此控制器被push之后，隐藏UITabbarController对象上的UITabbar
        self.hidesBottomBarWhenPushed = YES;
    }
    
    return self;
}

- (void)_loadDataByCityID:(NSString *)cityId{
    if (_tabView.hidden == YES) {
        _tabView.hidden = NO;
        [self.baseView removeFromSuperview];
        self.baseView = nil;
    }
    _cityButtonArray = [NSMutableArray array];
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    NSString * dataStr = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]];
    NSString * contenStr = [NSString stringWithFormat:@"{\"city_id\":\"%@\"}",cityId];
    [params setObject:contenStr forKey:@"data"];
    MyDataService * regionReq = [[MyDataService alloc] init];
    if (_hud == nil) {
        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    _hud.mode = MBProgressHUDModeIndeterminate;
    _hud.labelText = @"正在加载..";
    [regionReq setFailureBlock:^{
        [self _creatRequsetData:self.view];
    }];
    _regionReqOpera = [regionReq requestAFURL:BASE_URL httpMethod:@"POST" params:params data:nil actValue:@"get_one_region" timeStamp:dataStr complection:^(id result) {
        NSLog(@"%@",result);
        [_hud hide:YES afterDelay:0];
        _hud = nil;
        for (NSDictionary * cityDic in [result objectForKey:@"content"]) {
            [_cityButtonArray addObject:[cityDic objectForKey:@"region_name"]];
        }
        [_tabView reloadData];
    }];
}
//创建数据请求失败的视图
- (void)_creatRequsetData:(UIView *)view{
    [super _creatRequsetData:view];
    _tabView.hidden = YES;
    if (_hud != nil) {
        [_hud hide:YES afterDelay:0];
        _hud = nil;
    }
    [self.reloadButton addTarget:self action:@selector(loadGGdata) forControlEvents:UIControlEventTouchUpInside];
}
- (void)loadGGdata{
   [self _loadDataByCityID:[[NSUserDefaults standardUserDefaults] objectForKey:@"cityId"]];
}
- (void)_creatTabFooterView{
    UIView * view = [[UIView  alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    view.backgroundColor = [UIColor clearColor];
    UIButton * saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    saveButton.frame = CGRectMake(20,10, kScreenWidth-40, 30);
    saveButton.backgroundColor = [UIColor greenColor];
    [saveButton addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
    if (_isEdit == NO) {
        [saveButton setTitle:@"添加" forState:UIControlStateNormal];
    }else{
        [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    }
    [view addSubview:saveButton];
    [_tabView setTableFooterView:view];
}
- (void)saveAction:(UIButton *)button{
    if (_isEdit == NO) {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确认添加此联系人?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        alertView.tag = 6000;
        [alertView show];
    }else{
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确认修改此联系人信息?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        alertView.tag = 7000;
        [alertView show];
    }
}
//判断字符串全部是由数字组成
- (BOOL)isPureInt:(NSString *)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}
//匹配手机号
- (BOOL)isPhoneNum:(NSString *)phoneNum{
    //1、定义正则表达式
    NSString * regex = @"^[1][34578]+\\d{9}";
    //2、创建正则表达式实现对象
    NSRegularExpression *regexExpre = [[NSRegularExpression alloc] initWithPattern:regex options:NSRegularExpressionCaseInsensitive error:nil];
    //3、查找符合正则表达式的子字符串
    NSArray *items = [regexExpre matchesInString:phoneNum options:NSMatchingReportProgress range:NSMakeRange(0, phoneNum.length)];
    if (items.count != 0) {
        return YES;
    }else
        return NO;
}
- (void)addRequset{
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    NSString * dataStr = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]];
    //_value:0-100,100-0;
    NSString * contenStr = [NSString stringWithFormat:@"{\"user_id\":\"%@\",\"customer_name\":\"%@\",\"customer_sex\":\"%@\",\"session\":\"%@\",\"customer_mobile\":\"%@\",\"purchase_intentions\":\"%@\",\"price_range\":\"%@\",\"region\":\"%@\",\"house_type\":\"%@\",\"remark\":\"\"}",[UserTmpParam getUserId],_name,_sex,[UserTmpParam getSession],_phone,_purchase_intentions,_value,_regionStr,_houseType];
    [params setObject:contenStr forKey:@"data"];
    MyDataService * addCusRep = [[MyDataService alloc] init];
    if (_sex == nil) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择客户性别!" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] show];
        return;
    }
    if (![self isPureInt:_text2.text] || ![self isPhoneNum:_text2.text]) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"手机号码格式输入有误输入有误!(只能含有数字,不能有其他字符)" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] show];
        [_text2 becomeFirstResponder];
        return;
    }
    if (_hud == nil) {
        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    _hud.mode = MBProgressHUDModeIndeterminate;
    _hud.labelText = @"正在保存..";
    [addCusRep setFailureBlock:^{
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"添加客户失败,点击确定重新保存!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = 4000;
        [alertView show];
    }];
    _addCustomerOpera = [addCusRep requestAFURL:BASE_URL httpMethod:@"POST" params:params data:nil actValue:@"add_customer" timeStamp:dataStr complection:^(id result) {
        
        [_hud hide:YES afterDelay:0];
        _hud = nil;
        NSLog(@"%@",result);
        if ([[result objectForKey:@"error"] integerValue] == 0) {
            CustomerViewController * customerVC =  self.navigationController.viewControllers[0];
            customerVC.isReload = YES;
            [self.navigationController popToRootViewControllerAnimated:YES];
        
        }else {
            if ([[result objectForKey:@"error"] integerValue] == 1021) {
                [[[UIAlertView alloc] initWithTitle:@"提示" message:@"登录超时,请重新登录!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] show];
            }
        }
    }];

}
- (void)saveRequset{
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    NSString * dataStr = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]];
    //_value:0-100,100-0;
    NSString * contenStr = [NSString stringWithFormat:@"{\"user_id\":\"%@\",\"customer_name\":\"%@\",\"customer_sex\":\"%@\",\"session\":\"%@\",\"purchase_intentions\":\"%@\",\"price_range\":\"%@\",\"region\":\"%@\",\"house_type\":\"%@\",\"remark\":\"\",\"customer_id\":\"%@\"}",[UserTmpParam getUserId],_name,_sex,[UserTmpParam getSession],_purchase_intentions,_value,_regionStr,_houseType,_customerDetailModel.customer_id];
    if (_sex == nil) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择客户性别!" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] show];
        return;
    }
    [params setObject:contenStr forKey:@"data"];
    MyDataService * addCusRep = [[MyDataService alloc] init];
    if (_hud == nil) {
        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    _hud.mode = MBProgressHUDModeIndeterminate;
    _hud.labelText = @"正在修改..";
    [addCusRep setFailureBlock:^{
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"修改客户失败,点击确定重新保存!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = 5000;
        [alertView show];
    }];
    _addCustomerOpera = [addCusRep requestAFURL:BASE_URL httpMethod:@"POST" params:params data:nil actValue:@"edit_customer" timeStamp:dataStr complection:^(id result) {
        [_hud hide:YES afterDelay:0];
        _hud = nil;
        if ([[result objectForKey:@"error"] integerValue]==0) {
            CustomerViewController * customerVC =  self.navigationController.viewControllers[0];
            customerVC.isReload = YES;
            [self.navigationController popToRootViewControllerAnimated:YES];
            NSLog(@"%@",result);
        }else{
            if ([[result objectForKey:@"error"] integerValue]==1021) {
                [[[UIAlertView alloc] initWithTitle:@"提示" message:@"添加客户失败!" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] show];
            }
        }
    }];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_text1 resignFirstResponder];
    [_text2 resignFirstResponder];
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 2000) {
        if (buttonIndex == 0) {
            
        }
        if (buttonIndex == 1) {
            LoginViewController *loginVC = [[LoginViewController alloc] init];
            loginVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:loginVC animated:YES];
        }
    }
    if (alertView.tag == 4000) {
        if (buttonIndex == 0) {
            
        }
        if (buttonIndex == 1) {
            [self addRequset];
        }
  
    }
    if (alertView.tag == 5000) {
        if (buttonIndex == 0) {
            
        }
        if (buttonIndex == 1) {
            [self saveRequset];
        }
    }
    if (alertView.tag == 6000) {
        if (buttonIndex == 0) {
            
        }
        if (buttonIndex == 1) {
            [self addRequset];
        }
    }
    if (alertView.tag == 7000) {
        if (buttonIndex == 0) {
            
        }
        if (buttonIndex == 1) {
            [self saveRequset];
        }
    }

}

#pragma mark  -UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
//- (void)viewWillDisappear:(BOOL)animated{
//    UIAlertView * alerView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定保存此liani" delegate:<#(id)#> cancelButtonTitle:<#(NSString *)#> otherButtonTitles:<#(NSString *), ...#>, nil]
//}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }
    else{
        if (_isOpen) {
            return 4;
        }else{
            return 1;
        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        NameCell * cell  = [tableView dequeueReusableCellWithIdentifier:nameCellId forIndexPath:indexPath];
        [cell setPassNameBlock:^(NSString * sex){
            _sex = sex;
        }];
        if (indexPath.row == 1) {
            _text2 = cell.valueLabel;
            [cell setPassValueBlock:^(NSString *phone){
                _phone = phone;
            }];
            cell.switch2.hidden = YES;
            if (_isEdit == NO) {
                cell.valueLabel.text = _tkAddressBook.tel;
            }else {
                cell.valueLabel.text = _customerDetailModel.customer_mobile;
            }
            cell.tipLabel.text = @"电话";
        }
        if (indexPath.row == 0) {
            _text1 = cell.valueLabel;
            [cell setPassValueBlock:^(NSString *name){
                _name = name;
            }];
            cell.tipLabel.text = @"姓名";
            cell.switch2.hidden = NO;
            if (_isEdit == NO) {
                cell.valueLabel.text = _tkAddressBook.name;
            }else{
                cell.valueLabel.text = _customerDetailModel.customer_name;
                if ([_customerDetailModel.customer_sex integerValue] == 1) {
                    [cell.switch2 setOn:NO];
                }else{
                    [cell.switch2 setOn:YES];
                }
            }
        }
        return cell;
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            ShowMsgCell * cell = [tableView dequeueReusableCellWithIdentifier:showMsgCellId forIndexPath:indexPath];
//            cell.button.selected = NO;
            if (_isEdit == NO) {
                if (_purchase_intentions != nil) {
                    cell.msgStr = _purchase_intentions;
                }else{
                    cell.msgStr = @"未填写(完善购房意向可获得额外积分)";
                }
            }else {
                if (_purchase_intentions == nil) {
                    cell.msgStr = _customerDetailModel.purchase_intentions;
                    if ([_customerDetailModel.purchase_intentions isEqualToString:@"(null)"]) {
                        cell.msgStr = @"未填写(完善购房意向可获得额外积分)";
                    }
                }else{
                    cell.msgStr = _purchase_intentions;
                }
            }
            
            return cell;
        }
        if (indexPath.row == 1) {
            PriceCell * cell = [tableView dequeueReusableCellWithIdentifier:priceCellId forIndexPath:indexPath];
            [cell setPassValue:^(NSString *priceValue,CGFloat minValue,CGFloat maxValue){
                _priceRange = priceValue;//100-0.0-100
                _minValue = minValue/10;//0-100,100-0
                _maxValue = maxValue/10;//100-0,0-100
                _value = [NSString stringWithFormat:@"%.0f-%.0f",_minValue*10,_maxValue*10];
                _purchase_intentions = [NSString stringWithFormat:@"%@,%@,%@",_regionStr,_priceRange,_houseType];
                NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
                [_tabView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                NSLog(@"min:%.0f max:%.0f priceRance:%@ ",_minValue,_maxValue,_priceRange);
            }];
            if (_isEdit == YES) {
                cell.minValue = _minValue;
                cell.maxValue = _maxValue;
                [cell.sliderView setLowerValue:_minValue];
                [cell.sliderView setUpperValue:_maxValue];
                //设置label文字显示
                NSLog(@"%.0f",cell.sliderView.minimumValue);
                cell.priceLabel.text = [NSString stringWithFormat:@"价格区间:%@", _priceRange];
                NSLog(@"min:%.0f max:%.0f priceRance:%@ ",_minValue,_maxValue,_priceRange);
            }else {
                cell.minValue = 0;
                cell.maxValue = 100;
                [cell.sliderView setLowerValue:0];
                [cell.sliderView setUpperValue:100];
            }
            return cell;
        }
        if (indexPath.row == 2) {
            ButtonCell * cell = [tableView dequeueReusableCellWithIdentifier:buttonCellId forIndexPath:indexPath];
            [cell setPassValue:^(NSString * region){
                _regionStr = region;
                NSLog(@"%@",_regionStr);
                _purchase_intentions = [NSString stringWithFormat:@"%@,%@,%@",_regionStr,_priceRange,_houseType];
                NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
                [_tabView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }];
            if (_regionStr != nil) {
                cell.buttonLabel.text = [NSString stringWithFormat:@"区域:%@",_regionStr];
                NSArray * separated = [_regionStr componentsSeparatedByString:@"/"];
                cell.spertaeArray = separated;
            }
            if (_isEdit == YES) {
                
                NSArray * separated = [_customerDetailModel.region componentsSeparatedByString:@"/"];
                cell.spertaeArray = separated;
                if (_regionStr != nil) {
                    NSArray * separated = [_regionStr componentsSeparatedByString:@"/"];
                    cell.spertaeArray = separated;
                }
            }
            cell.array = _cityButtonArray;
            return cell;
        }
        if (indexPath.row == 3) {
            HouseCell * cell = [tableView dequeueReusableCellWithIdentifier:houseCellId forIndexPath:indexPath];
            _array = [NSArray arrayWithObjects:@"不限",@"一室",@"二室",@"三室",@"四室",@"五室及以上",@"复式",@"别墅",@"商铺", nil];
            [cell setPassBlock:^(NSString * house){
                _houseType = house;
                _purchase_intentions = [NSString stringWithFormat:@"%@,%@,%@",_regionStr,_priceRange,_houseType];
                NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
                [_tabView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }];
            if (_houseType != nil) {
                NSArray * separated = [_houseType componentsSeparatedByString:@","];
                cell.spertaeArray = separated;
            }
            if (_isEdit == YES) {
                cell.buttonLabel.text = [NSString stringWithFormat:@"户型:%@",_houseType];
                NSArray * separated = [_customerDetailModel.house_type componentsSeparatedByString:@"/"];
                cell.spertaeArray = separated;
                if (_houseType != nil) {
                    NSArray * separated = [_houseType componentsSeparatedByString:@"/"];
                    cell.spertaeArray = separated;
                }
            }
            cell.array = _array;
            return cell;
        }

    }
    UITableViewCell * cell = [[UITableViewCell alloc]init];
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    if (section == 0) {
        UILabel * label = [[UILabel  alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-40, 20)];
        [view addSubview:label];
        label.font = [UIFont systemFontOfSize:14];
        label.text = @"   基本信息";
        return view;
    }else{
        _purchaseLabel = [[UILabel  alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-40, 20)];
        [view addSubview:_purchaseLabel];
        _purchaseLabel.font = [UIFont systemFontOfSize:14];
        _purchaseLabel.text = @"   购房意向";
        return view;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 44;
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            return 44;
        }
        if (indexPath.row == 1) {
            return 70;
        }
        if (indexPath.row == 2) {
            NSInteger i ;
            if ((_cityButtonArray.count+1)%3==0 && (_cityButtonArray.count+1)/3 != 0) {
                i = (_cityButtonArray.count+1)/3;
            }else{
                i = (_cityButtonArray.count+1)/3+1;
            }
            return i*40+30+10;
        }
        if (indexPath.row == 3) {
            NSInteger i ;
            if ((_array.count)%3==0 && (_array.count)/3 != 0) {
                i = (_array.count)/3;
            }else{
                i = (_array.count)/3+1;
            }
            return i*40+30+10;
        }
    }
    return 0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            ShowMsgCell * cell = (ShowMsgCell *)[tableView cellForRowAtIndexPath:indexPath];
            if (_isOpen == YES) {
                cell.isUp = NO;
//                [cell.imageView setImage:[UIImage imageNamed:@"向上.png"]];
                _isOpen = NO;
//                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }else{
                cell.isUp = YES;
//                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//                [cell.imageView setImage:[UIImage imageNamed:@"向下.png"]];
                _isOpen = YES;
            }
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:1];
            [_tabView reloadSections:indexSet
                    withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}
@end
