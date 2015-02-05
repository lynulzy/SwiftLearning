//
//  WaitingLishViewController.m
//  HouseMananger
//
//  Created by ZXH on 15/1/27.
//  Copyright (c) 2015年 ZSXJ. All rights reserved.
//

#import "WaitingLishViewController.h"

#import "CommissionDataController.h"
#import "CommissionCell.h"
#import "CommissionDetailViewController.h"

#import "EGORefreshTableFooterView.h"
#import "EGORefreshTableHeaderView.h"
#import "MessageShow.h"

#define TOP_VIEW_HIGHT      60.0F
@interface WaitingLishViewController ()
<
UITableViewDataSource,
UITableViewDelegate,
CommissionDataControllerDelegate,
EGORefreshTableDelegate
>
{
    CommissionDataController *_commissionDC;
    NSInteger currentPage;
    NSString *_settlementStr;
    
    CGFloat tableHight;
    
    //EGOHeader
    EGORefreshTableHeaderView *_refreshHeaderView;
    //EGOFoot
    EGORefreshTableFooterView *_refreshFooterView;
    
    BOOL _reloading;
}
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *commissionListArr;
@property(nonatomic, strong) UILabel *topLab;
@end

@implementation WaitingLishViewController

- (id)initWithFrame:(CGRect)theRect {
    if ((self = [super init])) {
        tableHight = theRect.size.height;
        self.view.frame = theRect;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    if (IOS7Later) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.navigationController.navigationBar.barTintColor = TAB_BAR_COLOR;
    }
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent = NO;
    
    self.navigationItem.title = @"待结佣金";
    
    [self loadData];
    [self loadSubviews];
    [self createHeaderView];
}

- (void)loadData {
    self.commissionListArr = [[NSMutableArray alloc] initWithCapacity:0];
    currentPage = 1;
    _settlementStr = @"2";
    [self loadCommissionListData];
}

- (void)loadCommissionListData {
    NSString *thePage = [NSString stringWithFormat:@"%ld", (long)currentPage];
    NSDictionary *params = @{@"page"       : thePage,
                             @"page_size"  : @"10",
                             @"settlement" : _settlementStr};
    
    if (nil == _commissionDC) {
        _commissionDC = [[CommissionDataController alloc] init];
        _commissionDC.delegate = self;
    }
    
    [_commissionDC mrCommission:params];
}

- (void)loadSubviews {
    
    // TableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, size_width, tableHight) style:UITableViewStylePlain];
    self.tableView.backgroundColor = BACK_COLOR;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[CommissionCell class] forCellReuseIdentifier:@"CommissionCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    
    
    self.topLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size_width, TOP_VIEW_HIGHT)];
    self.topLab.textAlignment = NSTextAlignmentCenter;
    self.topLab.font = [UIFont boldSystemFontOfSize:21.0F];
    self.topLab.textColor = [UIColor orangeColor];
    //    self.topLab.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = self.topLab;
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

#pragma mark - UIScrollViewDelegate Methods
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

#pragma mark - EGORefreshTableDelegate Methods
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
    
    DDLog(@"%lu", (unsigned long)self.commissionListArr.count)
    return self.commissionListArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = indexPath.row;
    CommissionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommissionCell"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = BACK_COLOR;
    NSDictionary *dic = [self.commissionListArr objectAtIndex:row];
    [cell reloadCellSubViewsWithData:dic withType:_settlementStr];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 5+25+5+20+5 + 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = indexPath.row;
    
    [self.delegate pushToDetailWith:self.commissionListArr[row] andType:_settlementStr];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - CommissionDataControllerDelegate
- (void)onGetCommissionReceiveData:(NSDictionary *)receiveDict withReqTag:(NSInteger)tag {
    
    [MessageShow closeMsgAlertView];
    [self removeFooterView];
    
    if (1 == currentPage) {
        [self.commissionListArr removeAllObjects];
    }
    
    [self.commissionListArr addObjectsFromArray:receiveDict[@"content"][@"get_commission_list"]];
    [self.tableView reloadData];
    self.topLab.text = [NSString stringWithFormat:@"待结算佣金 共 %@ 元", receiveDict[@"content"][@"wait_commission"]];

    [self testFinishedLoadData];
    if ([receiveDict[@"content"][@"page_count"] integerValue] > currentPage) {
        [self setFooterView];
    }
}

- (void)onGetCommissionFailedWithError:(NSError *)error withReqTag:(NSInteger)tag {
    [MessageShow closeMsgAlertView];
    [self testFinishedLoadData];
    [self setFooterView];
}

@end
