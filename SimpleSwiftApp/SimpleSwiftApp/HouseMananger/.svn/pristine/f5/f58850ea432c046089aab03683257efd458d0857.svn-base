//
//  TalkingListCell.h
//  HouseMananger
//
//  Created by ZXH on 15/1/15.
//  Copyright (c) 2015年 ZSXJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TalkingListCellDelegate <NSObject>

- (void)imageViewTouchEnlargeWithRow:(NSInteger)row andCurrentPage:(NSInteger)currPage;

@end

@interface TalkingListCell : UITableViewCell

@property(nonatomic, weak) id<TalkingListCellDelegate>delegate;

- (void)reloadCellSubViewsWithData:(NSDictionary *)dataDic forRow:(NSInteger)row;

@end
