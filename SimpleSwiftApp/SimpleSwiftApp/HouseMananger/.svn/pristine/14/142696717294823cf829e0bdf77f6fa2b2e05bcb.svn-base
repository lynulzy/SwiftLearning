//
//  TalkingViewController.m
//  HouseMananger
//
//  Created by ZXH on 15/1/15.
//  Copyright (c) 2015年 ZSXJ. All rights reserved.
//

#import "TalkingViewController.h"

#import "TalkingDataController.h"
#import "TalkingListCell.h"

#import "TalkingDetailViewController.h"
#import "PublishViewController.h"

#import "PicScanViewController.h"

#import "EGORefreshTableFooterView.h"
#import "EGORefreshTableHeaderView.h"

#import "MessageShow.h"
@interface TalkingViewController ()
<
UITableViewDataSource,
UITableViewDelegate,
TalkingDataControllerDelegate,
EGORefreshTableDelegate,
TalkingListCellDelegate
>
{
    TalkingDataController *_talkingListDC;
    
    NSInteger currentPage;

    //EGOHeader
    EGORefreshTableHeaderView *_refreshHeaderView;
    //EGOFoot
    EGORefreshTableFooterView *_refreshFooterView;
    
    BOOL _reloading;
    
    CGFloat _theTableHeight;
}
@property(nonatomic, copy) NSString *buildID;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *talkingListArr;
@end

@implementation TalkingViewController

- (id)initWithFrame:(CGRect)theRect andBuildID:(NSString*)theBuildID andTableHeight:(CGFloat)theHeight{
    
    if ((self = [super init])) {
        self.buildID = theBuildID;
        _theTableHeight = theHeight;
        self.view.frame = theRect;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    BOOL xx = [[[NSUserDefaults standardUserDefaults] objectForKey:@"from"] isEqualToString:@"publish"];
    if (xx) {
        
        self.tableView.contentOffset = CGPointMake(0, -100);
        [_refreshHeaderView egoRefreshScrollViewDidScroll:self.tableView];
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:self.tableView];
        [_refreshHeaderView refreshLastUpdatedDate];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"from"];
    }
}

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
    
    self.navigationItem.title = @"论坛";
    
    DDLog(@"%@", self.buildID == nil ? @"nil" : @"不为nil")
    
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
    DDLog(@"\n\r view = %f  \n\r table = %f", self.view.bounds.size.height, self.tableView.frame.size.height)
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
        [self performSelector:@selector(loadTalkingListData) withObject:nil afterDelay:2.0];
        
    } else if(aRefreshPos == EGORefreshFooter) {
        // Pull up to load more data
        currentPage++;
        [self performSelector:@selector(loadTalkingListData) withObject:nil afterDelay:2.0];
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

- (void)loadTalkingListData {
    
    NSString *theBuildID = (0 < self.buildID.length && nil != self.buildID ? self.buildID : @"");
    
    NSString *thePage = [NSString stringWithFormat:@"%ld", (long)currentPage];
    NSDictionary *params = @{@"build_id"    : theBuildID,
                             @"page"        : thePage,
                             @"page_size"   : @"10"};
    
    if (nil == _talkingListDC) {
        _talkingListDC = [[TalkingDataController alloc] init];
        _talkingListDC.delegate = self;
    }

    [_talkingListDC mrTalkingList:params];
}

- (void)loadData {
    self.talkingListArr = [[NSMutableArray alloc] initWithCapacity:0];
    currentPage = 1;
    _reloading = NO;
}

- (void)loadSubviews {
    CGFloat tableHeight = (0 < self.buildID.length && nil != self.buildID ? _theTableHeight : (size_height - 44 - 49));
    // TableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, size_width, tableHeight) style:UITableViewStylePlain];
    self.tableView.backgroundColor = BACK_COLOR;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[TalkingListCell class] forCellReuseIdentifier:@"TalkingListCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    
    // Right bar button item
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithTitle:@"发帖" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarBtnClick)];
    self.navigationItem.rightBarButtonItem = rightBarBtn;
}

- (void)rightBarBtnClick {
    PublishViewController *publishVC = [[PublishViewController alloc] init];
    publishVC.buildID = @"";
    publishVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:publishVC animated:self];
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
    return [self.talkingListArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = indexPath.row;
    
    TalkingListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TalkingListCell"];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = BACK_COLOR;
    NSDictionary *dic = [self.talkingListArr objectAtIndex:row];
    [cell reloadCellSubViewsWithData:dic forRow:row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    NSDictionary *dataDic = [self.talkingListArr objectAtIndex:row];
    
    CGFloat kIconWidth = (size_width - 56) * 0.16;   // 头像宽度
    
    // Top留白
    CGFloat topGap = 10.0F;
    
    // 用户名高度
    CGFloat nameHight = kIconWidth/2;
    
    // 楼盘名称高度
    CGFloat buildNameHight;
    if ([dataDic[@"name"] isEqual:[NSNull null]]) {
        buildNameHight = 0;
    } else {
        buildNameHight = kIconWidth/2;
    }
    
    // 文字Label宽度
    CGFloat questionWidth = (size_width -56) * 0.84;
    
    CGSize qLabelSize = CGSizeMake(0, 0);
    if (IOS7Later) {
        // 计算Label高度
        qLabelSize = [dataDic[@"content"] boundingRectWithSize:CGSizeMake(questionWidth, 1000)
                                                   options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                                attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0F]} context:nil].size;
    } else {
        qLabelSize = [dataDic[@"content"] sizeWithFont:[UIFont systemFontOfSize:15.0F] constrainedToSize:CGSizeMake(questionWidth, 1000)];
    }

    // 图片边长
    CGFloat imageWidth = (questionWidth - 40) / 3;
    // 图片个数
    NSInteger imageCount = [dataDic[@"pic"] count];
    // 图片行数
    NSInteger imageLineCount = imageCount / 3;
    if (0 != imageCount % 3) {
        imageLineCount += 1;
    }
    // 图片占用高度
    CGFloat imageTotalHeight = imageLineCount * (imageWidth + 5);
    
    // 时间Label高度
    NSInteger timeHight = 20;
    
    return (topGap + nameHight + buildNameHight + qLabelSize.height + 5 + imageTotalHeight + timeHight + 5 + (3 + 5));
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_isBuildDetail == NO) {
        TalkingDetailViewController *talkingDetailVC = [[TalkingDetailViewController alloc] init];
        talkingDetailVC.hidesBottomBarWhenPushed = YES;
        
        talkingDetailVC.dataDic = self.talkingListArr[row];
        
        [self.navigationController pushViewController:talkingDetailVC animated:YES];
        
    }else {
        _passBlock(self.talkingListArr[row]);
    }
    
}

#pragma mark - TalkingListCellDelegate
- (void)imageViewTouchEnlargeWithRow:(NSInteger)row andCurrentPage:(NSInteger)currPage {
    NSMutableArray *picArr = [[NSMutableArray alloc] initWithArray:self.talkingListArr[row][@"pic"]];
    
    PicScanViewController *picScanVC = [[PicScanViewController alloc] init];
    picScanVC.currentPage = currPage;
    picScanVC.imageUrlArray = picArr;
    //    [picScanVC.imageUrlArray addObject:dic[imageUrl]];
    
    picScanVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:picScanVC animated:YES];
}

#pragma mark - MyNewsDataControllerDelegate
- (void)onGetTalkingListReceiveData:(NSDictionary *)receiveDict withReqTag:(NSInteger)tag {

    [MessageShow closeMsgAlertView];
    [self removeFooterView];
    
    NSMutableDictionary *talkingListDic = [[NSMutableDictionary alloc] initWithDictionary:receiveDict];
    
    if (1 == currentPage) {
        [self.talkingListArr removeAllObjects];
    }
    
    [self.talkingListArr addObjectsFromArray:talkingListDic[@"content"][@"say_list"]];
    [self.tableView reloadData];
    
    [self testFinishedLoadData];
    if ([talkingListDic[@"content"][@"page_count"] integerValue] > currentPage) {
        [self setFooterView];
    }    
}

- (void)onGetTalkingListFailedWithError:(NSError *)error withReqTag:(NSInteger)tag {
    
    [MessageShow closeMsgAlertView];
    [self testFinishedLoadData];
    [self setFooterView];
}

@end
