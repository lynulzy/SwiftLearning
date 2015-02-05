//
//  RankViewController.m
//  HouseMananger
//
//  Created by ZXH on 15/2/3.
//  Copyright (c) 2015年 ZSXJ. All rights reserved.
//

#import "RankViewController.h"

#import "BuildRankViewController.h"
#import "AgentRankViewController.h"
#import "MessageShow.h"

#define TAG_CTRL_PANEL_VIEW         1000
#define TAG_CTRL_PANEL_BTN_BEGIN    2000
#define TAG_PanelBtnLabel_BEGIN     3000
#define TAG_LINE_VIEW               4000
#define TAG_BG_SCROLLVIEW           5000

#define CONTROL_PANEL_HEIGHT        30.0F
#define ANIMATION_DURATION          (0.3F)

@interface RankViewController ()
<
UIScrollViewDelegate
>
{
    BuildRankViewController *_buildRVC;
    AgentRankViewController *_agentRVC;
}
@property(nonatomic, strong) NSArray *titleArr;
@property(nonatomic, strong) UIScrollView *bgScrollView;
@end

@implementation RankViewController

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
    
    self.navigationItem.title = @"排行榜";
    
//    [self loadData];
    [self loadSubViews];
}

- (void)loadSubViews {
    
    [self loadControlPanel];
    [self loadMainView];
}

- (void)loadMainView {
    
    // Back Scroll View
    self.bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                       0 + CONTROL_PANEL_HEIGHT,
                                                                       size_width,
                                                                       size_height - 44 - CONTROL_PANEL_HEIGHT)];
    self.bgScrollView.backgroundColor = [UIColor whiteColor];
    self.bgScrollView.tag = TAG_BG_SCROLLVIEW;
    self.bgScrollView.showsHorizontalScrollIndicator = NO;
    self.bgScrollView.pagingEnabled = YES;
    self.bgScrollView.delegate = self;
    self.bgScrollView.userInteractionEnabled = YES;
    self.bgScrollView.contentSize = CGSizeMake(size_width * self.titleArr.count,
                                               self.bgScrollView.frame.size.height);
    [self.view addSubview:self.bgScrollView];
    
    // 已结算佣金
    _buildRVC = [[BuildRankViewController alloc] initWithFrame:CGRectMake(0,
                                                                          0,
                                                                          size_width,
                                                                          size_height - 44 - CONTROL_PANEL_HEIGHT)];
//    _buildRVC.delegate = self;
    [self.bgScrollView addSubview:_buildRVC.view];
    
    
    // 待结算佣金
    _agentRVC = [[AgentRankViewController alloc] initWithFrame:CGRectMake(size_width,
                                                                          0,
                                                                          size_width,
                                                                          size_height - 44 - CONTROL_PANEL_HEIGHT)];
//    _agentRVC.delegate = self;
    [self.bgScrollView addSubview:_agentRVC.view];
    
}

#pragma mark - 工具条 楼盘报备排行榜 经纪人排行榜
- (void)loadControlPanel {
    // Control panel
    UIView *ctrlPanelView = [[UIView alloc] initWithFrame:CGRectMake(0.0F, 0.0F, size_width, CONTROL_PANEL_HEIGHT)];
    ctrlPanelView.backgroundColor = BACK_COLOR;
    ctrlPanelView.tag = TAG_CTRL_PANEL_VIEW;
    [self.view addSubview:ctrlPanelView];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, CONTROL_PANEL_HEIGHT - 0.5, size_width, 0.5)];
    lineView1.backgroundColor = [UIColor lightGrayColor];
    [ctrlPanelView addSubview:lineView1];
    
    self.titleArr = @[@"楼盘报备排行榜", @"经纪人排行榜"];
    CGFloat btnWidth = size_width / self.titleArr.count;
    
    for (NSInteger i = 0; i < self.titleArr.count; i++) {
        UIButton *ctrlPanelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        ctrlPanelBtn.frame = CGRectMake(0.0F + btnWidth * i,
                                        0.0F,
                                        btnWidth,
                                        CONTROL_PANEL_HEIGHT - 2);
        [ctrlPanelBtn setBackgroundColor:[UIColor colorWithRed:244/255.0F green:244/255.0F blue:244/255.0F alpha:1.0F]];
        [ctrlPanelBtn setTitle:self.titleArr[i] forState:UIControlStateNormal];
        ctrlPanelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15.0F];
        [ctrlPanelBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
        [ctrlPanelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [ctrlPanelBtn addTarget:self action:@selector(panelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        ctrlPanelBtn.tag = TAG_CTRL_PANEL_BTN_BEGIN + i;
        if(0 == i) {
            ctrlPanelBtn.selected = YES;
            
        } else {
            ctrlPanelBtn.selected = NO;
            
        }
        [ctrlPanelView addSubview:ctrlPanelBtn];
        
        // 小竖线
        if (i < self.titleArr.count - 1) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0.0F + btnWidth * (i+1) - 1,
                                                                        5.0F,
                                                                        1,
                                                                        CONTROL_PANEL_HEIGHT - 10)];
            lineView.backgroundColor = [UIColor lightGrayColor];
            [ctrlPanelView addSubview:lineView];
        }
    }
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                CONTROL_PANEL_HEIGHT - 2,
                                                                size_width/self.titleArr.count,
                                                                2)];
    lineView.backgroundColor = [UIColor orangeColor];
    lineView.tag = TAG_LINE_VIEW;
    [ctrlPanelView addSubview:lineView];
    
}

// 切换 商品详情  商品简介
- (void)panelBtnClick:(UIButton *)btn {
    NSInteger index = btn.tag - TAG_CTRL_PANEL_BTN_BEGIN;
    [self changeButtonStatusWithTag:index];
    
    // 滑动小横线  滑动bgScrollView
    UIView *ctrlPanelView = (UIView *)[self.view viewWithTag:TAG_CTRL_PANEL_VIEW];
    UIView *lineView = (UIView *)[ctrlPanelView viewWithTag:TAG_LINE_VIEW];
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = lineView.frame;
        frame.origin.x = index * size_width / self.titleArr.count;
        lineView.frame = frame;
        self.bgScrollView.contentOffset = CGPointMake(index * size_width, 0.0F);
    }];
}

- (void)adjustItemPage:(CGFloat)theOffsetX {
    
    NSInteger page = theOffsetX / size_width;
    [self changeButtonStatusWithTag:page];
    
    // 小横线 实时改变位置
    UIView *ctrlPanelView = (UIView *)[self.view viewWithTag:TAG_CTRL_PANEL_VIEW];
    UIView *lineView = (UIView *)[ctrlPanelView viewWithTag:TAG_LINE_VIEW];
    CGRect frame = lineView.frame;
    frame.origin.x = theOffsetX / self.titleArr.count;
    lineView.frame = frame;
}

// 改变Button选中状态
- (void)changeButtonStatusWithTag:(NSInteger)tag {
    
    NSInteger btnTag = TAG_CTRL_PANEL_BTN_BEGIN + tag;
    UIView *ctrlPanelView = (UIView *)[self.view viewWithTag:TAG_CTRL_PANEL_VIEW];
    
    for (UIView *temp in ctrlPanelView.subviews) {
        
        if ([temp isKindOfClass:[UIButton class]]) {
            
            UIButton *currentBtn = (UIButton*)temp;
            
            if (currentBtn.tag == btnTag) {
                currentBtn.selected = YES;
            } else {
                currentBtn.selected = NO;
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)pushToDetailWith:(NSDictionary *)dataDic andType:(NSString *)settlementStr {
//    CommissionDetailViewController *commissionDetailVC = [[CommissionDetailViewController alloc] init];
//    commissionDetailVC.bulidID = dataDic[@"id"];
//    commissionDetailVC.settlement = settlementStr;
//    
//    commissionDetailVC.buildNameStr = dataDic[@"name"];
//    commissionDetailVC.orderNumStr = dataDic[@"order_num"];
//    commissionDetailVC.commissionStr = dataDic[@"commission"];
//    
//    commissionDetailVC.commissionStatus = settlementStr;
//    [self.navigationController pushViewController:commissionDetailVC animated:YES];
}

@end
