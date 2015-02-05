//
//  MyNewsViewController.m
//  HouseMananger
//
//  Created by ZXH on 15/1/9.
//  Copyright (c) 2015年 ZSXJ. All rights reserved.
//

#import "MyNewsViewController.h"

#import "MyNewsDataController.h"
#import "MyNewsCell.h"

#import "EGORefreshTableFooterView.h"
#import "EGORefreshTableHeaderView.h"
#import "MessageShow.h"

@interface MyNewsViewController ()
<
UITableViewDataSource,
UITableViewDelegate,
MyNewsDataControllerDelegate,
EGORefreshTableDelegate
>
{
    MyNewsDataController *_myNewsDC;
    
    NSInteger currentPage;
    
    //EGOHeader
    EGORefreshTableHeaderView *_refreshHeaderView;
    //EGOFoot
    EGORefreshTableFooterView *_refreshFooterView;
    
    BOOL _reloading;
}
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *newsListArr;

@end

@implementation MyNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (IOS7Later) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.navigationController.navigationBar.barTintColor = TAB_BAR_COLOR;
    }
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent = NO;
    
    self.navigationItem.title = @"我的消息";
    
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

-(void)removeFooterView {
    
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
        [self performSelector:@selector(loadNewsListData) withObject:nil afterDelay:2.0];
        
    } else if(aRefreshPos == EGORefreshFooter) {
        // Pull up to load more data
        currentPage++;
        [self performSelector:@selector(loadNewsListData) withObject:nil afterDelay:2.0];
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


- (void)loadNewsListData {
    NSString *thePage = [NSString stringWithFormat:@"%ld", (long)currentPage];
    NSDictionary *params = @{@"page" : thePage,
                             @"page_size" : @"10"};
    
    if (nil == _myNewsDC) {
        _myNewsDC = [[MyNewsDataController alloc] init];
        _myNewsDC.delegate = self;
    }
    
    [_myNewsDC mrMyNews:params];
}


- (void)loadData {
    self.newsListArr = [[NSMutableArray alloc] initWithCapacity:0];
    currentPage = 1;
    _reloading = NO;
}

- (void)loadSubviews {
    // TableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, size_width, size_height - 44) style:UITableViewStylePlain];
    self.tableView.backgroundColor = BACK_COLOR;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[MyNewsCell class] forCellReuseIdentifier:@"MyNewsCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorColor = [UIColor clearColor];
//    self.tableView.contentOffset = CGPointMake(0, (self.tableView.contentSize.height - self.tableView.frame.size.height) > 0 ? (self.tableView.contentSize.height - self.tableView.frame.size.height) : 0);
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
    return [self.newsListArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = indexPath.row;
    MyNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyNewsCell"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = BACK_COLOR;
    NSDictionary *dic = [self.newsListArr objectAtIndex:row];
    [cell reloadCellSubViewsWithData:dic forRow:row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    NSDictionary *dic = [self.newsListArr objectAtIndex:row];
    
    CGSize labelSize = [dic[@"content"] boundingRectWithSize:CGSizeMake(size_width - 60, 1000)
                                                         options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                                      attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0F]} context:nil].size;
    
    return (5+25+20+10+labelSize.height+20+5);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - MyNewsDataControllerDelegate
- (void)onGetMyNewsReceiveData:(NSDictionary *)receiveDict withReqTag:(NSInteger)tag {
    
    [MessageShow closeMsgAlertView];
    [self removeFooterView];
    
    NSMutableDictionary *newsListDic = [[NSMutableDictionary alloc] initWithDictionary:receiveDict];
    
    if (1 == currentPage) {
        [self.newsListArr removeAllObjects];
    }
    
    [self.newsListArr addObjectsFromArray:newsListDic[@"content"][@"get_msg_list"]];
    [self.tableView reloadData];
    
    [self testFinishedLoadData];
    if ([newsListDic[@"content"][@"page_count"] integerValue] > currentPage) {
        [self setFooterView];
    }
}

- (void)onGetMyNewsFailedWithError:(NSError *)error withReqTag:(NSInteger)tag {
    [MessageShow closeMsgAlertView];
    [self testFinishedLoadData];
    [self setFooterView];
}

@end
