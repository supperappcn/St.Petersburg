//
//  MyOrderListTableViewCell.h
//  St.Petersburg
//
//  Created by kirem-peter on 14-11-18.
//  Copyright (c) 2014年 Jiayi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyOrderListTableViewCell : UITableViewCell
@property (strong, nonatomic) NSMutableArray* cellSubviews;
@property (strong, nonatomic) NSDictionary* model;
@property (assign, nonatomic) CGFloat orderTimeLabHeight;
-(void)setModel:(NSDictionary *)model;
@end
