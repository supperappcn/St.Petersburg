//
//  MyOrderListTableViewCell.m
//  St.Petersburg
//
//  Created by kirem-peter on 14-11-18.
//  Copyright (c) 2014年 Jiayi. All rights reserved.
//

#import "MyOrderListTableViewCell.h"

@implementation MyOrderListTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(NSMutableArray *)cellSubviews {
    if (!_cellSubviews) {
        _cellSubviews = [NSMutableArray array];
    }
    return _cellSubviews;
}

-(void)setModel:(NSDictionary *)model {
    _model = model;
    for (UIView* vi in self.cellSubviews) {
        [vi removeFromSuperview];
    }
    [self addCellViews:model];
}

-(void)addCellViews:(NSDictionary*)dic {
    UIFont* font = [UIFont systemFontOfSize:14];
    UIColor* grayColor = [UIColor grayColor];
    UILabel* orderNumTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 70, 21)];
    orderNumTitle.backgroundColor = [UIColor clearColor];
    orderNumTitle.text = @"订单号：";
    orderNumTitle.textColor = grayColor;
    orderNumTitle.font = font;
    [self addSubview:orderNumTitle];
    [self.cellSubviews addObject:orderNumTitle];
    UILabel* orderNumLab = [[UILabel alloc]initWithFrame:CGRectMake(80, 10, 230, 21)];
    orderNumLab.backgroundColor = [UIColor clearColor];
    orderNumLab.text = dic[@"OrderID"];
    orderNumLab.font = font;
    [self addSubview:orderNumLab];
    [self.cellSubviews addObject:orderNumLab];
    UILabel* orderStatusTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, 30, 70, 21)];
    orderStatusTitle.backgroundColor = [UIColor clearColor];
    orderStatusTitle.text = @"订单状态：";
    orderStatusTitle.textColor = grayColor;
    orderStatusTitle.font = font;
    [self addSubview:orderStatusTitle];
    [self.cellSubviews addObject:orderStatusTitle];
    UILabel* orderStatusLab = [[UILabel alloc]initWithFrame:CGRectMake(80, 30, 230, 21)];
    orderStatusLab.backgroundColor = [UIColor clearColor];
    orderStatusLab.text = dic[@"Status"];
    orderStatusLab.textColor = [UIColor colorWithRed:0.192 green:0.482 blue:0.76 alpha:1];
    orderStatusLab.font = font;
    [self addSubview:orderStatusLab];
    [self.cellSubviews addObject:orderStatusLab];
    UILabel* orderTimeTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, 70, 21)];
    orderTimeTitle.backgroundColor = [UIColor clearColor];
    orderTimeTitle.text = @"预订日期：";
    orderTimeTitle.textColor = grayColor;
    orderTimeTitle.font = font;
    [self addSubview:orderTimeTitle];
    [self.cellSubviews addObject:orderTimeTitle];
    RTLabel* orderTimeLab = [[RTLabel alloc]initWithFrame:CGRectMake(80, 52, DeviceWidth - 17 - 80, 21)];
    orderTimeLab.text = dic[@"Startdate"];
    self.orderTimeLabHeight = orderTimeLab.optimumSize.height;
    self.orderTimeLabHeight = self.orderTimeLabHeight>21?self.orderTimeLabHeight:21;
    orderTimeLab.frame = CGRectMake(orderTimeLab.frame.origin.x, orderTimeLab.frame.origin.y, orderTimeLab.frame.size.width, orderTimeLab.frame.size.height + self.orderTimeLabHeight - 21);
    orderTimeLab.font = font;
    [self addSubview:orderTimeLab];
    [self.cellSubviews addObject:orderTimeLab];
    UILabel* infoLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 70 + self.orderTimeLabHeight - 21, DeviceWidth, 21)];
    infoLab.backgroundColor = [UIColor clearColor];
    infoLab.text = [NSString stringWithFormat:@"%@  %@位游客", dic[@"Uname"], dic[@"PCount"]];
    infoLab.font = font;
    [self addSubview:infoLab];
    [self.cellSubviews addObject:infoLab];
    UIImageView* jianTouIV = [[UIImageView alloc]initWithFrame:CGRectMake(DeviceWidth - 17, 43 + (self.orderTimeLabHeight - 21)/2, 17, 17)];
    jianTouIV.image = [UIImage imageNamed:@"cellJianTou.png"];
    [self addSubview:jianTouIV];
    [self.cellSubviews addObject:jianTouIV];
    
}


@end
