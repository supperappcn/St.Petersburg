//
//  NewsCell.h
//  St.Petersburg
//
//  Created by 刘 吕琴 on 14-2-19.
//  Copyright (c) 2014年 Jiayi. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface NewsCell : UITableViewCell
@property (nonatomic, strong) UILabel* title;
@property (nonatomic, strong) RTLabel* summary;
@property (nonatomic, strong) UILabel* time;
@property (nonatomic, strong) UIImageView* jianTouIV;
@property (nonatomic, strong) UIImageView* line;
@property(nonatomic,strong)UILabel* weidu;//未读

@end
