//
//  BuilidingDetaliController.m
//  HouseMananger
//
//  Created by 王晗 on 15-1-4.
//  Copyright (c) 2015年 王晗. All rights reserved.
//

#import "BuilidingDetaliController.h"
#import "Common.h"
#import "UIViewExt.h"
#import "DetailCell.h"
#import "SellCell.h"
#import "TalkCell.h"
#import "BuildingParamsController.h"
#import "TalkDetailController.h"
#import "MyDataService.h"
#import "UserTmpParam.h"
#import "BuildingDetalModel.h"
#import "BuildDetailHeaderView.h"
#import "MBProgressHUD.h"
#import "AFHTTPRequestOperation.h"
#import "ComentModel.h"
#import "TalkingViewController.h"
#import "UMSocial.h"
#import "PublishViewController.h"
#import "CustomerViewController.h"
#import "SaleCell.h"
#import "LoginViewController.h"
#import "ZoomImageView.h"
#import "UIImageView+WebCache.h"
#import "TalkingDetailViewController.h"
static NSString * detailCellID = @"DetailCell";
static NSString * sellCellID = @"SellCell";
static NSString * talkID = @"TalkCell";
static NSString * saleCellId = @"SaleCell";
@interface BuilidingDetaliController ()

@end

@implementation BuilidingDetaliController{
    UIView * _topButtonView;
    UIView * _bottomView;
    UIButton * _selectButton;
    UIButton * _goButton;
    UITableView * _detailTabView;
    UIView * _headerView;
    UITableView * _sellTabView;
    UITableView * _talkTabView;
    EGORefreshTableHeaderView * _refreshSellView;
    EGORefreshTableHeaderView * _refreshTalkView;
    BOOL _reloading;
    BuildingDetalModel * _buildingDetalModel;
    UIButton * _attentionButton;
    UIView * _tipView;
    MBProgressHUD * _hud;
    NSInteger _currentPage;
    AFHTTPRequestOperation * _buildDetailReqOpera;
    UIView * _tallView;
    TalkingViewController * _talkingVc;
    
    ZoomImageView * _headerImgView;
    UILabel * _buildNameLabel;
    UILabel * _priceLabel;
    UILabel * _startTimeLabel;
    UILabel * _cusCountLabel;
    UILabel * _tipCusLabel;
    UILabel * _managerCountLabel;
    UILabel * _tipManagerLabel;
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        //YES: 当前此控制器被push之后，隐藏UITabbarController对象上的UITabbar
        self.hidesBottomBarWhenPushed = YES;
    }
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"楼盘详情";
    _currentPage = 1;
    [self _initViews];
    [self _creatNavRightBotton];
    [self _creatTopButtonView];
    [self _creatBottomButtonView];
    [self _creatSellTabView];
    [self _creatDetailTabView];
}
- (void)_initViews{
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 150)];
    _headerView.backgroundColor = [UIColor whiteColor];
    
    _headerImgView  = [[ZoomImageView alloc] initWithFrame:CGRectMake(10, 10,kScreenWidth/2-20 , _headerView.height-20)];
    [_headerView addSubview:_headerImgView];
    
    _buildNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_headerImgView.right+10, _headerImgView.origin.y, (kScreenWidth/2-10), 30)];
    _buildNameLabel.font = [UIFont boldSystemFontOfSize:16];
    [_headerView addSubview:_buildNameLabel];
    
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_buildNameLabel.origin.x, _buildNameLabel.bottom+5, (kScreenWidth/2-20), 20)];
    _priceLabel.textColor = [UIColor grayColor];
    _priceLabel.font = [UIFont systemFontOfSize:12];
    [_headerView addSubview:_priceLabel];
    
    _startTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_buildNameLabel.origin.x, _priceLabel.bottom +5, (kScreenWidth/2-30), 20)];
    _startTimeLabel.textColor = [UIColor grayColor];
    _startTimeLabel.font = [UIFont systemFontOfSize:12];
    [_headerView  addSubview:_startTimeLabel];
    
    _cusCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(_buildNameLabel.origin.x, _startTimeLabel.bottom+5, (kScreenWidth/2-30)/2, 20)];
    _cusCountLabel.textColor = [UIColor grayColor];
    _cusCountLabel.font = [UIFont systemFontOfSize:13];
    _cusCountLabel.textAlignment = NSTextAlignmentCenter;
    [_headerView addSubview:_cusCountLabel];
    
    _tipCusLabel = [[UILabel alloc] initWithFrame:CGRectMake(_buildNameLabel.origin.x, _cusCountLabel.bottom+3, (kScreenWidth/2-30)/2, 20)];
    _tipCusLabel.textColor = [UIColor grayColor];
    _tipCusLabel.font = [UIFont systemFontOfSize:13];
    _tipCusLabel.textAlignment = NSTextAlignmentCenter;
    _tipCusLabel.text = @"意向客户" ;
    [_headerView addSubview:_tipCusLabel];
    
    UILabel * spreateLabel = [[UILabel alloc] initWithFrame:CGRectMake(_cusCountLabel.right+10, _cusCountLabel.origin.y, 1, 45)];
    spreateLabel.textColor = [UIColor grayColor];
    spreateLabel.backgroundColor = [UIColor grayColor];
    [_headerView addSubview:spreateLabel];
    
    _managerCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(spreateLabel.right+10, _cusCountLabel.origin.y, (kScreenWidth/2-30)/2, 20)];
    _managerCountLabel.textColor = [UIColor grayColor];
    _managerCountLabel.font = [UIFont systemFontOfSize:13];
    _managerCountLabel.textAlignment = NSTextAlignmentCenter;
    [_headerView addSubview:_managerCountLabel];
    
    
    _tipManagerLabel = [[UILabel alloc] initWithFrame:CGRectMake(_managerCountLabel.origin.x, _managerCountLabel.bottom+3, (kScreenWidth/2-30)/2, 20)];
    _tipManagerLabel.textColor = [UIColor grayColor];
    _tipManagerLabel.font = [UIFont systemFontOfSize:13];
    _tipManagerLabel.textAlignment = NSTextAlignmentCenter;
    _tipManagerLabel.text = @"合作经纪人" ;
    [_headerView addSubview:_tipManagerLabel];
}
- (void)_initTabViewData{
    _buildNameLabel.text = [NSString stringWithFormat:@"%@",_buildingDetalModel.name];
    _priceLabel.text = [NSString stringWithFormat:@"单价:%@元/平方米",_buildingDetalModel.price];
    _startTimeLabel.text = [NSString stringWithFormat:@"开盘时间:%@",_buildingDetalModel.startTime];
    _managerCountLabel.text = [NSString stringWithFormat:@"%@人",_buildingDetalModel.partner_num];
    _cusCountLabel.text = [NSString stringWithFormat:@"%@人",_buildingDetalModel.intention_customer_num];
    [_headerImgView sd_setImageWithURL:[NSURL URLWithString:_buildingDetalModel.logo] placeholderImage:[UIImage imageNamed:@"loadImg.jpg"]];
    _headerImgView.array = _buildingDetalModel.building_img;

}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (_hud) {
        [_hud hide:YES];
        _hud = nil;
    }
    if (_buildDetailReqOpera) {
        [_buildDetailReqOpera cancel];
    }
}
- (void)setBuildingID:(NSString *)buildingID{
    if (_buildingID != buildingID) {
        _buildingID = buildingID;
    }
    [self _loadData];
}
- (void)_loadData{
    if (_detailTabView.hidden ==YES) {
        _detailTabView.hidden = NO;
        [self.baseView removeFromSuperview];
        self.baseView = nil;
    }
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    NSString * dataStr = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]];
    NSString * contetStr = nil;
    if ([UserTmpParam getSession]!= nil &&[UserTmpParam getUserId]!=nil ) {
        contetStr = [NSString stringWithFormat:@"\{\"build_id\":\"%@\",\"user_id\":\"%@\",\"session\":\"%@\"}",_buildingID,[UserTmpParam getUserId],[UserTmpParam getSession]];
    }else{
        contetStr = [NSString stringWithFormat:@"\{\"build_id\":\"%@\"}",_buildingID];
    }
    [params setObject:contetStr forKey:@"data"];
    MyDataService * buildDetailReq = [[MyDataService alloc] init];
    if (_hud == nil) {
        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    _hud.labelText = @"正在加载..";
    [buildDetailReq setFailureBlock:^{
        [self _creatRequsetData:self.view];
    }];
    _buildDetailReqOpera = [buildDetailReq requestAFURL:BASE_URL httpMethod:@"POST" params:params data:nil actValue:@"get_build_detail" timeStamp:dataStr complection:^(id result) {
        NSLog(@"%@",result);
        [_hud hide:YES];
        _hud = nil;
        if ([[result objectForKey:@"error"] integerValue]==0) {
            _buildingDetalModel = [[BuildingDetalModel alloc] initWithDataDic:[result objectForKey:@"content"]];
            NSLog(@"%@",_buildingDetalModel.is_guanzhu);
            _attentionButton.hidden = NO;
            if ([[NSString stringWithFormat:@"%@",_buildingDetalModel.is_guanzhu] isEqualToString:@"0"]) {
                _attentionButton.selected = NO;
            }else{
                _attentionButton.selected = YES;
            }
            [self _initTabViewData];
            [_detailTabView  reloadData];
            [_sellTabView reloadData];
        }else{
            if ([[result objectForKey:@"error"] integerValue]==1021) {
                UIAlertView * alertView =  [[UIAlertView alloc] initWithTitle:@"提示" message:@"登录实效,请重新登录!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] ;
                alertView.tag = 2000;
                [alertView show];
            }
        }
    }];
}
//创建数据请求失败的视图
- (void)_creatRequsetData:(UIView *)view{
    [super _creatRequsetData:view];
    _detailTabView.hidden = YES;
    if (_hud != nil) {
        [_hud hide:YES afterDelay:0];
        _hud = nil;
    }
    [self.reloadButton addTarget:self action:@selector(_loadData) forControlEvents:UIControlEventTouchUpInside];
}

- (void)_creatNavRightBotton{
    if (_attentionButton == nil) {
        _attentionButton= [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [_attentionButton setImage:[UIImage imageNamed:@"收藏.png"] forState:UIControlStateNormal];
        _attentionButton.hidden = YES;
        [_attentionButton setImage:[UIImage imageNamed:@"已收藏.png"] forState:UIControlStateSelected];
//        if (_attentionButton.selected == YES) {
//            [_attentionButton setImage:[UIImage imageNamed:@"已收藏.png"] forState:UIControlStateDisabled];
//        }else{
//           [_attentionButton setImage:[UIImage imageNamed:@"收藏.png"] forState:UIControlStateDisabled];
//        }
        [_attentionButton addTarget:self action:@selector(attentionAction:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_attentionButton];
    }


}
- (void)_creatTopButtonView{
    if (_topButtonView == nil) {
        _topButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,kScreenWidth, 40)];
        _topButtonView.backgroundColor = TAB_BAR_COLOR;
        [self.view addSubview:_topButtonView];
        NSArray * buttonTitile = @[@"基本信息",@"卖点",@"论坛"];
        for (int i = 0; i<buttonTitile.count; i++) {
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(i*kScreenWidth/buttonTitile.count, 0, kScreenWidth/buttonTitile.count, 40);
            button.tag = i+100;
            if (i == 0) {
                _selectButton = button;
                _selectButton.selected = YES;
            }
            if (i == 1) {
                _goButton = button;
            }
            [_topButtonView addSubview:button];
            [button addTarget:self action:@selector(topButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [button setFont:[UIFont systemFontOfSize:14]];
            [button setTitle:buttonTitile[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor yellowColor] forState:UIControlStateSelected];
        }
        UIButton * firstButton = (UIButton *)[_topButtonView viewWithTag:100];
        UIButton * secendButton = (UIButton *)[_topButtonView viewWithTag:101];
        UIButton * thirdButton = (UIButton *)[_topButtonView viewWithTag:102];
        UILabel * label1 = [[UILabel alloc] initWithFrame:CGRectMake((secendButton.left-firstButton.right)/2+firstButton.right, 8, 1, 24)];
        label1.backgroundColor = [UIColor whiteColor];
        [_topButtonView addSubview:label1];
        
        UILabel * label2 = [[UILabel alloc] initWithFrame:CGRectMake((thirdButton.left-secendButton.right)/2+secendButton.right, 8, 1, 24)];
        label2.backgroundColor = [UIColor whiteColor];
        [_topButtonView addSubview:label2];
    }
}
- (void)_creatBottomButtonView{
    if (_bottomView == nil) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-49-64,kScreenWidth, 49)];
        _bottomView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"客户 所有.png"]];
        [self.view addSubview:_bottomView];
        NSArray * buttonName = @[@"分享.png",@"发帖.png",@"报备客户.png"];
        NSArray * titileName = @[@"分享楼盘",@"发个帖子",@"报备客户"];
        for (int i = 0; i<buttonName.count; i++) {
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(i*kScreenWidth/buttonName.count, 0, kScreenWidth/buttonName.count, 49);
            [button setFont:[UIFont systemFontOfSize:10]];
            [button setTitle:titileName[i] forState:UIControlStateNormal];
            [button setTitleEdgeInsets:UIEdgeInsetsMake(30, 0, 0, 36)];
            [button setImageEdgeInsets:UIEdgeInsetsMake(0, 31, 19, 0)];
            [button setImage:[UIImage imageNamed:buttonName[i]] forState:UIControlStateNormal];
            [_bottomView addSubview:button];
            switch (i) {
                case 0:
                    [button addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
                    break;
                case 1:
                    [button addTarget:self action:@selector(sendNewsAction:) forControlEvents:UIControlEventTouchUpInside];
                    break;
                case 2:
                    [button addTarget:self action:@selector(addCustomerAction:) forControlEvents:UIControlEventTouchUpInside];
                    break;
                case 3:
                    [button addTarget:self action:@selector(attentionAction:) forControlEvents:UIControlEventTouchUpInside];
                    break;
            }
        }
    }
    
}
- (void)_creatDetailTabView{
    if (_detailTabView == nil) {
        _detailTabView = [[UITableView alloc] initWithFrame:CGRectMake(0, _topButtonView.bottom, kScreenWidth, kScreenHeight-40-64-49) style:UITableViewStyleGrouped];
        _detailTabView.tag = 1000;
        _detailTabView.delegate = self;
        _detailTabView.dataSource = self;
//        _detailHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"BuildDetailHeaderView" owner:nil options:nil] lastObject];
        _detailTabView.tableHeaderView = _headerView;
        [self.view addSubview:_detailTabView];
        [_detailTabView registerNib:[UINib nibWithNibName:@"DetailCell" bundle:nil] forCellReuseIdentifier:detailCellID];
        [_detailTabView registerNib:[UINib nibWithNibName:@"SaleCell" bundle:nil] forCellReuseIdentifier:saleCellId];
    }
}
- (void)_creatSellTabView{
    if (_sellTabView == nil) {
        _sellTabView = [[UITableView alloc] initWithFrame:CGRectMake(0, _topButtonView.bottom, kScreenWidth, kScreenHeight-40-64-49) style:UITableViewStylePlain];
        [_sellTabView registerNib:[UINib nibWithNibName:@"SellCell" bundle:nil] forCellReuseIdentifier:sellCellID];
        _sellTabView.tag = 1001;
        _sellTabView.delegate = self;
        _sellTabView.dataSource = self;
        [self.view addSubview:_sellTabView];
        [self _creatEGOView:_sellTabView];
    }
}
- (void)_creatTalkTabView{
    _talkingVc = [[TalkingViewController alloc] initWithFrame:CGRectMake(0, _topButtonView.bottom-40, kScreenWidth, kScreenHeight-40-64-49) andBuildID:_buildingID andTableHeight:kScreenHeight-40-64-49];
    _talkingVc.isBuildDetail = YES;
    __weak BuilidingDetaliController * weakBuildDetilVC = self;
    [_talkingVc setPassBlock:^(NSDictionary *dic){
        TalkingDetailViewController *talkingDetailVC = [[TalkingDetailViewController alloc] init];
        talkingDetailVC.hidesBottomBarWhenPushed = YES;
        talkingDetailVC.dataDic = dic ;
        __strong BuilidingDetaliController * strongBuildDetilVC = weakBuildDetilVC;
        [strongBuildDetilVC.navigationController pushViewController:talkingDetailVC animated:YES];
    }];
    _tallView = [[UIView alloc] init];
    _tallView.frame = CGRectMake(0, _topButtonView.bottom, kScreenWidth, kScreenHeight-64-40-49);
    [self.view addSubview:_tallView];
    [_tallView addSubview:_talkingVc.view];
}
- (void)_creatEGOView:(UITableView *)tabView{
    //创建下拉刷新的控件
    if (tabView == _sellTabView) {
        if (_refreshSellView == nil) {
            _refreshSellView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - tabView.bounds.size.height, tabView.frame.size.width, tabView.bounds.size.height)];
            _refreshSellView.delegate = self;
        }

        _refreshSellView.tag = 200;
        [tabView addSubview:_refreshSellView];
    }else{
        if (_refreshTalkView == nil) {
            _refreshTalkView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - tabView.bounds.size.height, tabView.frame.size.width, tabView.bounds.size.height)];
            _refreshTalkView.delegate = self;
        }
        _refreshTalkView.tag = 300;
        [tabView addSubview:_refreshTalkView];
    }
}
#pragma mark -
#pragma mark Data Source Loading / Reloading Methods
//结束加载
- (void)finishReloadingData:(EGORefreshTableHeaderView *)refreashView{
    //  model should call this when its done loading
    _reloading = NO;
    if (refreashView.tag ==200) {
        [refreashView egoRefreshScrollViewDataSourceDidFinishedLoading:_sellTabView];
    }else{
        [refreashView egoRefreshScrollViewDataSourceDidFinishedLoading:_talkTabView];
    }
}
//开始加载
-(void)beginToReloadData:(EGORefreshPos)aRefreshPos refreshView:(EGORefreshTableHeaderView *)refreshHeaderView{
    
    // should be calling your tableviews data source model to reload
    _reloading = YES;
    if (aRefreshPos == EGORefreshHeader) {
        // pull down to refresh data
        [self performSelector:@selector(finishReloadingData:) withObject:refreshHeaderView afterDelay:2.0];
        
    }
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == _sellTabView) {
        
        [_refreshSellView egoRefreshScrollViewDidScroll:scrollView];
    }if (scrollView == _talkTabView){
        
        [_refreshTalkView egoRefreshScrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView == _sellTabView) {
        
        [_refreshSellView egoRefreshScrollViewDidEndDragging:scrollView];
    }if (scrollView == _talkTabView)
    {
        
        [_refreshTalkView egoRefreshScrollViewDidEndDragging:scrollView];
    }
}


#pragma mark -
#pragma mark EGORefreshTableDelegate Methods
//下啦到一定距离调用
- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos scrollView:(UIScrollView *)scrollView{
    if (scrollView == _sellTabView) {
        [self beginToReloadData:aRefreshPos refreshView:_refreshSellView];
    }
    if (scrollView == _talkTabView) {
        [self beginToReloadData:aRefreshPos refreshView:_refreshTalkView];
    }
}

- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view {
    
    return _reloading; // should return if data source model is reloading
}

// if we don't realize this method, it won't display the refresh timestamp
- (NSDate*)egoRefreshTableDataSourceLastUpdated:(UIView*)view {
    
    return [NSDate date]; // should return date data source was last changed
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Touch Action
- (void)topButtonAction:(UIButton *)button{
    _selectButton.selected = NO;
    button.selected = YES;
    _selectButton = button;
    switch (button.tag) {
        case 100:{
            [self.view bringSubviewToFront:_detailTabView];
        }
            break;
        case 101:{
            [self.view bringSubviewToFront:_sellTabView];
        }
            break;
        case 102:{
            if (_tallView == nil) {
                [self _creatTalkTabView];
            }
            [self.view bringSubviewToFront:_tallView];
        }
            break;
    }
    
}
- (void)shareAction:(UIButton *)button{
    NSArray * array =[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQzone,UMShareToSina,UMShareToQQ,UMShareToTencent,UMShareToEmail,UMShareToRenren,UMShareToDouban,nil];
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:nil
                                      shareText:@"GG"
                                     shareImage:nil
                                shareToSnsNames:array
                                       delegate:self];
    [UMSocialConfig showNotInstallPlatforms:array];
}
- (void)addCustomerAction:(UIButton *)button{
    CustomerViewController * addCustomerCtrl = [[UIStoryboard storyboardWithName:@"Customer" bundle:nil] instantiateViewControllerWithIdentifier:@"CustomerViewController"];
    addCustomerCtrl.hidesBottomBarWhenPushed = YES;
    addCustomerCtrl.title = @"客户";
    addCustomerCtrl.buildId = _buildingID;
    addCustomerCtrl.isLoadNoAdd = YES;
    addCustomerCtrl.buildName = _buildingDetalModel.name;
    [self.navigationController pushViewController:addCustomerCtrl animated:YES];
    
    
}
- (void)sendNewsAction:(UIButton *)button{
    PublishViewController * publiscVC = [[PublishViewController alloc] init];
    publiscVC.buildID  = _buildingID;
    publiscVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:publiscVC animated:YES];
}
- (void)attentionAction:(UIButton *)button{
    if ([self isLogin]) {
        if (button.selected == YES) {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定不在关注此楼盘?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alertView show];
            alertView.tag = 9000;
        }else{
            [self _attentionBuilding];
            button.selected = YES;
        }
    }else{
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没有登录点击确定登陆!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] show];
    }
}
- (void)_creatTipView:(NSString *)content{
    if (_tipView == nil) {
        _tipView = [[UIView alloc] initWithFrame:CGRectMake((kScreenWidth-100)/2, -60, 100, 40)];
        _tipView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
        [self.view addSubview:_tipView];
        UILabel * label = [[UILabel alloc] initWithFrame:_tipView.bounds];
        label.text = content;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:13];
        [_tipView addSubview:label];
    }
}
- (BOOL)isLogin {
    
    if ([UserTmpParam getUserId].length == 0 || [UserTmpParam getSession].length == 0) {
        return NO;
    } else {
        return YES;
    }
}

- (void)_attentionBuilding{
        NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
        NSString * dataStr = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]];
        NSString * contetStr = [NSString stringWithFormat:@"\{\"build_id\":\"%@\",\"user_id\":\"%@\",\"session\":\"%@\"}",_buildingID,[UserTmpParam getUserId],[UserTmpParam getSession]];
        [params setObject:contetStr forKey:@"data"];
        MyDataService * attentionReq = [[MyDataService alloc] init];
        [attentionReq setFailureBlock:^{
            _attentionButton.selected = NO;
            [self _creatTipView:@"添加关注失败!"];
            [UIView animateWithDuration:1 animations:^{
                _tipView.transform = CGAffineTransformMakeTranslation(0, 60);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.5 animations:^{
                    _tipView.transform = CGAffineTransformIdentity;
                }];
            }];
        }];
        [attentionReq requestAFURL:BASE_URL httpMethod:@"POST" params:params data:nil actValue:@"guanzhu_build" timeStamp:dataStr complection:^(id result) {
            NSLog(@"%@",result);
            if ([[result objectForKey:@"error"] integerValue]==0) {
                [self _creatTipView:@"关注成功!"];
                [UIView animateWithDuration:1 animations:^{
                    _tipView.transform = CGAffineTransformMakeTranslation(0, 60);
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.5 animations:^{
                        _tipView.transform = CGAffineTransformIdentity;
                    }];
                }];
            }else{
                if ([[result objectForKey:@"error"] integerValue]==1021) {
                    UIAlertView * alertView =  [[UIAlertView alloc] initWithTitle:@"提示" message:@"登录实效,请重新登录!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] ;
                    alertView.tag = 2000;
                    [alertView show];
                }
            }
        }];
        _tipView = nil;
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 9000) {
        if (buttonIndex == 0) {
            
        }
        if (buttonIndex == 1) {
            [self _cancelAttentionBuilding];
            _attentionButton.selected = NO;
        }
 
    }
    if (alertView.tag == 2000){
        if (buttonIndex == 0) {
            
        }
        if (buttonIndex == 1) {
            LoginViewController *loginVC = [[LoginViewController alloc] init];
            loginVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:loginVC animated:YES];
        }
    }
}

- (void)_cancelAttentionBuilding{
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    NSString * dataStr = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]];
    NSString * contetStr = [NSString stringWithFormat:@"\{\"build_id\":\"%@\",\"user_id\":\"%@\",\"session\":\"%@\"}",_buildingID,[UserTmpParam getUserId],[UserTmpParam getSession]];
    [params setObject:contetStr forKey:@"data"];
    MyDataService * cancelAttention = [[MyDataService alloc] init];
    [cancelAttention setFailureBlock:^{
        _attentionButton.selected = YES;
        [self _creatTipView:@"取消关注失败!"];
        [UIView animateWithDuration:1 animations:^{
            _tipView.transform = CGAffineTransformMakeTranslation(0, 60);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                _tipView.transform = CGAffineTransformIdentity;
            }];
        }];

    }];
    [cancelAttention requestAFURL:BASE_URL httpMethod:@"POST" params:params data:nil actValue:@"cancel_guanzhu_build" timeStamp:dataStr complection:^(id result) {
        if ([[result objectForKey:@"error"] integerValue]==0) {
            NSLog(@"%@",result);
            [self _creatTipView:@"取消关注!"];
            [UIView animateWithDuration:1 animations:^{
                _tipView.transform = CGAffineTransformMakeTranslation(0, 60);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.5 animations:^{
                    _tipView.transform = CGAffineTransformIdentity;
                }];
            }];
        }else{
            if ([[result objectForKey:@"error"] integerValue]==1021) {
                UIAlertView * alertView =  [[UIAlertView alloc] initWithTitle:@"提示" message:@"登录实效,请重新登录!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] ;
                alertView.tag = 2000;
                [alertView show];
            }
        }
    }];
    _tipView = nil;
}
#pragma mark - UITabViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView.tag == 1000) {
        return 3;
    }
    else{
        return 1;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 1000) {
        if (section == 0) {
            return 1;
        }
        if (section == 1) {
            return 1;
        }
        if (section == 2) {
            if (_buildingDetalModel.buy_point.count == 0) {
                return 1;
            }else{
                return _buildingDetalModel.buy_point.count;
            }
        }

        
    }
    if (tableView.tag == 1001) {
        return _buildingDetalModel.buy_point.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 1000) {
        
        if (indexPath.section == 0) {
            DetailCell * cell = [tableView dequeueReusableCellWithIdentifier:detailCellID forIndexPath:indexPath];
            cell.imageView.image = [UIImage imageNamed:@"佣金、优惠.png"];
            if (indexPath.row == 0) {
                cell.nameLabel.hidden = NO;
                cell.valueLabel.hidden = NO;
                cell.imgView.hidden = NO;
                cell.nameLabel.text = @"合租佣金:";
                if (_buildingDetalModel == nil) {
                    cell.valueLabel.text = @"";
                    return cell;
                }
                if (_buildingDetalModel.highest_commission_ratio == nil) {
                    cell.valueLabel.text = [NSString stringWithFormat:@"%@/套",_buildingDetalModel.highest_commission_price];
                }else{
                    cell.valueLabel.text = [NSString stringWithFormat:@"%@％/套",_buildingDetalModel.highest_commission_ratio];
                }
                return cell;
            }
        }
        if (indexPath.section == 1) {
            DetailCell * cell = [tableView dequeueReusableCellWithIdentifier:detailCellID forIndexPath:indexPath];
            cell.nameLabel.hidden = NO;
            cell.valueLabel.hidden = NO;
            cell.imgView.hidden = NO;
            cell.imageView.image = [UIImage imageNamed:@"楼盘参数.png"];
            cell.nameLabel.text = @"楼盘参数";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.valueLabel.text = @"";
            return cell;
        }
        if (indexPath.section == 2) {
            SaleCell * cell = [tableView dequeueReusableCellWithIdentifier:saleCellId forIndexPath:indexPath];
            cell.accessoryType = UITableViewCellAccessoryNone;
            if (_buildingDetalModel != nil) {
                if ( _buildingDetalModel.buy_point.count == 0 ||_buildingDetalModel.buy_point == nil) {
                    cell.salePoint = [NSDictionary dictionaryWithObject:@"此楼盘暂无卖点" forKey:@"point_content"];
                    cell.imgView.hidden = YES;
                }else {
                    cell.imageView.image = [UIImage imageNamed:@"卖点.png"];
                    cell.imgView.hidden = NO;
                    cell.salePoint = _buildingDetalModel.buy_point[indexPath.row];
                }
            }
            return cell;
        }
    }
    if (tableView.tag == 1001) {
        SellCell * cell = [tableView dequeueReusableCellWithIdentifier:sellCellID forIndexPath:indexPath];
        if (_buildingDetalModel.buy_point.count != 0) {
            cell.sellLabel.text  = [_buildingDetalModel.buy_point[indexPath.row] objectForKey:@"point_content"];
        }
        return cell;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag ==1000) {
        if (indexPath.section == 1) {
            BuildingParamsController * bulidingParamsCtrl = [[UIStoryboard storyboardWithName:@"Buliding" bundle:nil] instantiateViewControllerWithIdentifier:@"BuildingParamsController"];
            bulidingParamsCtrl.buildingDetalModel = _buildingDetalModel;
            [self.navigationController pushViewController:bulidingParamsCtrl animated:YES];
        }
        if (indexPath.section == 2) {
            [self topButtonAction:_goButton];
        }
    }
    if (tableView.tag ==1001) {
        
    }
    if (tableView.tag == 1002) {
        TalkDetailController * talkDetailCtrl = [[TalkDetailController alloc] init];
        [self.navigationController pushViewController:talkDetailCtrl animated:YES];
        
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView.tag == 1000) {
        return 20;
    }
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 1002) {
        
        return 100;
    }
    return 44;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView.tag == 1000) {
        UILabel * label  =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor  = [UIColor grayColor];
        switch (section) {
            case 0:
                label.text = @"   佣金/优惠";
                break;
            case 1:
                label.text = @"   具体参数";
                break;
            case 2:
                label.text = @"   楼盘卖点";
                break;
                
        }
        return label;
    }
    return nil;
}
@end
