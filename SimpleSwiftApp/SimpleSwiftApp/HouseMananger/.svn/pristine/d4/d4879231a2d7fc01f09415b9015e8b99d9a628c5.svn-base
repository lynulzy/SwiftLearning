//
//  TalkDetailController.m
//  HouseMananger
//
//  Created by 王晗 on 15-1-5.
//  Copyright (c) 2015年 王晗. All rights reserved.
//

#import "TalkDetailController.h"
#import "Common.h"
#import "UIViewExt.h"
#import "TalkDetailHeaderView.h"
#import "TalkDetailCell.h"
static NSString * talkDetailID = @"TalkDetailCell";
@interface TalkDetailController ()

@end

@implementation TalkDetailController{
    
    UITableView * _tabView;
    UIView * _commentView;
    EGORefreshTableHeaderView * _refreshHeaderView;
    BOOL _reloading;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"评论详情";
    [self _creatTabView];
    [self _creatEGOView];
}
- (void)_creatTabView{
    if (_tabView == nil) {
        _tabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-49) style:UITableViewStyleGrouped];
        [_tabView registerNib:[UINib nibWithNibName:@"TalkDetailCell" bundle:nil] forCellReuseIdentifier:talkDetailID];
        [self.view addSubview:_tabView];
        TalkDetailHeaderView * headerView = [[[NSBundle mainBundle] loadNibNamed:@"TalkDetailHeaderView" owner:nil options:nil] lastObject];
        NSString * s = @"别墅6500每平米地铁旁边超级值。心动不如行动快快抢购啊阿啊阿啊阿啊阿啊阿啊阿啊阿啊阿啊阿啊 ";
        headerView.contentLabel.height =[s sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(270, 199199)].height;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [headerView.nameLabel addGestureRecognizer:tap];
        headerView.contentLabel.text = s;
        headerView.height = 70+headerView.contentLabel.height;
        [headerView setTalkBlock:^{
            [self _creatCommetnView];
        }];
        [headerView setEventPassBlock:^{
            UITextField * textFiled =(UITextField *)[_commentView viewWithTag:200];
            [textFiled resignFirstResponder];
        }];
        _tabView.tableHeaderView = headerView;
        _tabView.delegate = self;
        _tabView.dataSource = self;
        
    }
}
- (void)_creatEGOView{
    //1.创建下拉刷新的控件
    _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - _tabView.bounds.size.height,_tabView.frame.size.width, _tabView.bounds.size.height)];
    _refreshHeaderView.delegate = self;
    [_tabView addSubview:_refreshHeaderView];
    
}

- (void)_creatCommetnView{
    if (_commentView == nil) {
        //监听键盘弹出的通知，通知名:UIKeyboardWillShowNotification
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        _commentView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-40-64, kScreenWidth, 40)];
        _commentView.backgroundColor = [UIColor grayColor];
        [self.view addSubview:_commentView];
        UITextField * commentTextFiled = [[UITextField alloc] initWithFrame:CGRectMake(5, 5, 200, 30)];
        [commentTextFiled becomeFirstResponder];
        commentTextFiled.tag =  200;
        [_commentView addSubview:commentTextFiled];
        UIButton * sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        sendButton.frame = CGRectMake(commentTextFiled.right+10, 5, kScreenWidth-commentTextFiled.width-10, 30);
        [sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [_commentView addSubview:sendButton];
    }

}
- (void)tapAction:(UIGestureRecognizer *)ges{
    NSLog(@"GG");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark  - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITextField * textFiled =(UITextField *)[_commentView viewWithTag:200];
    [textFiled resignFirstResponder];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TalkDetailCell * talkDetailCell = [tableView dequeueReusableCellWithIdentifier:talkDetailID forIndexPath:indexPath];
//    talkDetailCell.comentButton.tag = indexPath.row +20;
    [talkDetailCell setTalkBlock:^{
        
        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        [self _creatCommetnView];
    }];
    return talkDetailCell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    label.font = [UIFont systemFontOfSize:10];
    label.text = @"   评论列表";
    return label;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}
#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)finishReloadingData{
    //  model should call this when its done loading
    _reloading = NO;
    
    if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_tabView];
    }
}

-(void)beginToReloadData:(EGORefreshPos)aRefreshPos {
    
    // should be calling your tableviews data source model to reload
    _reloading = YES;
    if (aRefreshPos == EGORefreshHeader) {
        // pull down to refresh data
        [self performSelector:@selector(refreshView) withObject:nil afterDelay:2.0];
        
    }
}
//刷新调用的方法
-(void)refreshView {
    
    NSLog(@"刷新完成");
    [self testFinishedLoadData];
}
-(void)testFinishedLoadData{
    
    [self finishReloadingData];
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (_refreshHeaderView)
    {
        [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (_refreshHeaderView)
    {
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
    
}

#pragma mark -
#pragma mark EGORefreshTableDelegate Methods
- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos scrollView:(UIScrollView *)scrollView{
    
    [self beginToReloadData:aRefreshPos];
}

- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view {
    
    return _reloading; // should return if data source model is reloading
}

// if we don't realize this method, it won't display the refresh timestamp
- (NSDate*)egoRefreshTableDataSourceLastUpdated:(UIView*)view {
    
    return [NSDate date]; // should return date data source was last changed
}

#pragma mark - 键盘弹出的通知
- (void)keyboardWillShow:(NSNotification *)notification {
    
    //1.取得键盘的frame, UIKeyboardFrameEndUserInfoKey 键盘尺寸变化之后的frame
    NSValue *boundsValue = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect frame = [boundsValue CGRectValue];
    
    //2.键盘的高度
//    CGFloat height = CGRectGetHeight(frame);

    //3.调整视图的高度
    [UIView animateWithDuration:1 animations:^{
        _commentView.transform = CGAffineTransformMakeTranslation(0, -CGRectGetHeight(frame));
    }];
    _tabView.height = kScreenHeight-CGRectGetHeight(_commentView.frame)-CGRectGetHeight(frame);
}
- (void)keyboardWillHide:(NSNotification *)notification{
    _tabView.height = kScreenHeight-49;
    [UIView animateWithDuration:1 animations:^{
        _commentView.transform = CGAffineTransformIdentity;
        _commentView.hidden = YES;
        _commentView = nil;
    }];
    
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITextField * textFiled =(UITextField *)[_commentView viewWithTag:200];
    [textFiled resignFirstResponder];
}
@end
