//
//  MyHotelOrederListTableViewCell.m
//  St.Petersburg
//
//  Created by 刘 吕琴 on 14-7-28.
//  Copyright (c) 2014年 Jiayi. All rights reserved.
//

#import "MyHotelOrederListTableViewCell.h"

@implementation MyHotelOrederListTableViewCell

#define IS_IOS_7 [[[UIDevice currentDevice]systemVersion]floatValue]>=7.0

- (void)awakeFromNib
{
    self.moreIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cellJianTou.png"]];
    if (IS_IOS_7) {
        self.moreIV.frame = CGRectMake(DeviceWidth - 16, 122, 16, 16);
    }else {
        self.moreIV.frame = CGRectMake(DeviceWidth - 31, 122, 16, 16);
    }
    NSLog(@"cell.moreIV.frame:%f,%f,%f,%f",DeviceWidth - 20, self.moreIV.frame.origin.y, self.frame.size.width, self.frame.size.height);
    [self.contentView addSubview:self.moreIV];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
