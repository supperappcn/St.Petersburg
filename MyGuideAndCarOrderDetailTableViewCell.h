//
//  MyGuideAndCarOrderDetailTableViewCell.h
//  St.Petersburg
//
//  Created by kirem-peter on 14-11-11.
//  Copyright (c) 2014年 Jiayi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyGuideAndCarOrderDetailTableViewCell : UITableViewCell

@property (strong, nonatomic)NSMutableArray* cellSubviews;
@property (strong, nonatomic)UILabel* orderNumLab;
@property (strong, nonatomic)UILabel* orderPriceLab;
@property (strong, nonatomic)UILabel* orderTimeLab;
@property (strong, nonatomic)UILabel* titleLab;
@property (strong, nonatomic)UILabel* carInfoLab;
@property (strong, nonatomic)UILabel* payWayLab;
@property (strong, nonatomic)RTLabel* selectTimeLab;
@property (strong, nonatomic)UILabel* statusLab;

@property (strong, nonatomic)UIImageView* headIV;
@property (strong, nonatomic)UIButton* goBtn;


@property (strong, nonatomic)NSDictionary* model;
-(void)setModel:(NSDictionary *)model;
@end
