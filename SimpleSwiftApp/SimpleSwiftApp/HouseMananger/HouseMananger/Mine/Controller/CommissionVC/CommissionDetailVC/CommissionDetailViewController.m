//
//  CommissionDetailViewController.m
//  HouseMananger
//
//  Created by ZXH on 15/1/14.
//  Copyright (c) 2015年 ZSXJ. All rights reserved.
//

#import "CommissionDetailViewController.h"

#import "CommissionDetailDataController.h"
#import "CommissionDetailCell.h"

#import "EGORefreshTableFooterView.h"
#import "EGORefreshTableHeaderView.h"
#import "MessageShow.h"

#define TOP_VIEW_HIGHT      60.0F

@interface CommissionDetailViewController ()
<
UITableViewDataSource,
UITableViewDelegate,
CommissionDetailDataControllerDelegate,
EGORefreshTableDelegate
>
{
    CommissionDetailDataController *_commissionDetailDC;
    NSInteger currentPage;
    
    //EGOHeader
    EGORefreshTableHeaderView *_refreshHeaderView;
    //EGOFoot
    EGORefreshTableFooterView *_refreshFooterView;
    
    BOOL _reloading;
}
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *commissionDetailListArr;
@property(nonatomic, strong) NSMutableDictionary *commissionDetailListDic;

@end


@implementation CommissionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = BACK_COLOR;
    if (IOS7Later) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.navigationController.navigationBar.barTintColor = TAB_BAR_COLOR;
    }
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent = NO;
    
    self.navigationItem.title = @"详情";
    
    [self loadData];
    [self loadSubviews];
    [self createHeaderView];
}

- (void)createHeaderView {
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
    _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:
                          CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,
                                     self.view.frame.size.width, self.view.bounds.size.height)];
    _refreshHeaderView.delegate = self;
    
    [self.tableView addSubview:_refreshHeaderView];
    [MessageShow showMessageView:MESSAGE_TYPE_WAITING code:0 msg:@"正在加载..." autoClose:1 time:15];

    // 首次进入 自动下拉刷新
//    self.tableView.contentInset = UIEdgeInsetsMake(100, 0, 0, 0);
    self.tableView.contentOffset = CGPointMake(0, -100);
    [_refreshHeaderView egoRefreshScrollViewDidScroll:self.tableView];
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:self.tableView];
    [_refreshHeaderView refreshLastUpdatedDate];
}

- (void)testFinishedLoadData {
    
    [self finishReloadingData];
}

#pragma mark - Method that should be called when the refreshing is finished
- (void)finishReloadingData {
    //  Model should call this when its done loading
    _reloading = NO;
    
    if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    }
    
    if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    }
}

- (void)setFooterView {
    // If the footerView is nil, then create it, reset the position of the footer
    CGFloat height = MAX(self.tableView.contentSize.height, self.tableView.frame.size.height);
    if (_refreshFooterView && [_refreshFooterView superview]) {
        // reset position
        _refreshFooterView.frame = CGRectMake(0.0f, height,
                                              self.tableView.frame.size.width, self.view.bounds.size.height);
    } else {
        // create the footerView
        _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:
                              CGRectMake(0.0f, height,
                                         self.tableView.frame.size.width, self.view.bounds.size.height)];
        _refreshFooterView.delegate = self;
        [self.tableView addSubview:_refreshFooterView];
    }
    
    if (_refreshFooterView) {
        
        [_refreshFooterView refreshLastUpdatedDate];
    }
}

- (void)removeFooterView {
    
    if (_refreshFooterView && [_refreshFooterView superview]) {
        
        [_refreshFooterView removeFromSuperview];
    }
    _refreshFooterView = nil;
}

// 刷新
#pragma mark - Data reloading methods that must be overide by the subclass
- (void)beginToReloadData:(EGORefreshPos)aRefreshPos {
    
    // should be calling your tableviews data source model to reload
    _reloading = YES;
    if (aRefreshPos == EGORefreshHeader) {
        // Pull down to refresh data
        currentPage = 1;
        [self performSelector:@selector(loadCommissionListData) withObject:nil afterDelay:2.0];
        
    } else if(aRefreshPos == EGORefreshFooter) {
        // Pull up to load more data
        currentPage++;
        [self performSelector:@selector(loadCommissionListData) withObject:nil afterDelay:2.0];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (_refreshHeaderView) {
        
        [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    }
    
    if (_refreshFooterView) {
        
        [_refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if (_refreshHeaderView) {
        
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
    
    if (_refreshFooterView) {
        
        [_refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
    }
}

#pragma mark - EGORefreshTableDelegate
- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos scrollView:(UIScrollView *)scrollView {
    // 开始网络请求
    [self beginToReloadData:aRefreshPos];
}

- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view {
    
    return _reloading;
}

// 记录最后操作的时间
- (NSDate*)egoRefreshTableDataSourceLastUpdated:(UIView*)view {
    
    return [NSDate date];
}


- (void)loadCommissionListData {
    NSString *thePage = [NSString stringWithFormat:@"%ld", (long)currentPage];
    NSDictionary *params = @{@"page"       : thePage,
                             @"page_size"  : @"10",
                             @"settlement" : self.settlement,
                             @"build_id"   : self.bulidID};
    
    if (nil == _commissionDetailDC) {
        _commissionDetailDC = [[CommissionDetailDataController alloc] init];
        _commissionDetailDC.delegate = self;
    }
    
    [_commissionDetailDC mrCommissionDetail:params];
}

- (void)loadData {
    self.commissionDetailListArr = [[NSMutableArray alloc] initWithCapacity:0];
    currentPage = 1;
}

- (void)loadSubviews {
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, size_width - 20, TOP_VIEW_HIGHT)];
    topView.backgroundColor = BACK_COLOR;
    [self.view addSubview:topView];
    
    CGFloat backWidth = topView.frame.size.width;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, TOP_VIEW_HIGHT - 0.5, size_width, 0.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:lineView];
    
    // Build name
    UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, backWidth - 20, 25)];
    nameLab.font = [UIFont boldSystemFontOfSize:16.0F];
    nameLab.text = self.buildNameStr;
    [topView addSubview:nameLab];
    
    // Order number
    UILabel *orderNumLab = [[UILabel alloc] initWithFrame:CGRectMake(10, nameLab.frame.origin.y + nameLab.frame.size.height + 5, 100, 20)];
    orderNumLab.font = [UIFont systemFontOfSize:15.0F];
    orderNumLab.text = [NSString stringWithFormat:@"%@个订单", self.orderNumStr];
    [topView addSubview:orderNumLab];
    
    // Commission
    UILabel *commissionLab = [[UILabel alloc] initWithFrame:CGRectMake(backWidth - 8 - 150, nameLab.frame.origin.y + nameLab.frame.size.height + 5, 140, 20)];
    commissionLab.textAlignment = NSTextAlignmentRight;
    commissionLab.font = [UIFont systemFontOfSize:15.0];
    [topView addSubview:commissionLab];
    if ([self.commissionStatus isEqualToString:@"1"]) {
        commissionLab.text = [NSString stringWithFormat:@"已结佣金:￥%@", self.commissionStr];
    }
    if ([self.commissionStatus isEqualToString:@"2"]) {
        commissionLab.text = [NSString stringWithFormat:@"待结佣金:￥%@", self.commissionStr];
    }
    
    // TableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, TOP_VIEW_HIGHT, size_width, size_height - 44 - TOP_VIEW_HIGHT) style:UITableViewStylePlain];
    self.tableView.backgroundColor = BACK_COLOR;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[CommissionDetailCell class] forCellReuseIdentifier:@"CommissionDetailCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    DDLog(@"%lu", (unsigned long)self.commissionDetailListArr.count)
    return self.commissionDetailListArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = indexPath.row;
    CommissionDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommissionDetailCell"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = BACK_COLOR;
    NSDictionary *dic = [self.commissionDetailListArr objectAtIndex:row];
    [cell reloadCellSubViewsWithData:dic forRow:row withType:self.settlement];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 5+25+5+20+5 + 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - CommissionDataControllerDelegate
- (void)onGetCommissionDetailReceiveData:(NSDictionary *)receiveDict withReqTag:(NSInteger)tag {

    [MessageShow closeMsgAlertView];
    self.commissionDetailListDic = [[NSMutableDictionary alloc] initWithDictionary:receiveDict];
    [self removeFooterView];
    
    if (1 == currentPage) {
        [self.commissionDetailListArr removeAllObjects];
    }
    
    [self.commissionDetailListArr addObjectsFromArray:receiveDict[@"content"][@"get_order_list"]];
    [self.tableView reloadData];
    
    [self testFinishedLoadData];
    if ([receiveDict[@"content"][@"page_count"] integerValue] > currentPage) {
        [self setFooterView];
    }
}

- (void)onGetCommissionDetailFailedWithError:(NSError *)error withReqTag:(NSInteger)tag {
    [MessageShow closeMsgAlertView];
    [self testFinishedLoadData];
    [self setFooterView];
}

@end
