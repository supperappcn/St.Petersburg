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
    if (IS_IOS_7) {
        
    }else {
        self.moreIV.frame = CGRectMake(DeviceWidth - 20, self.moreIV.frame.origin.y, self.frame.size.width, self.frame.size.height);
        NSLog(@"cell.moreIV.frame:%f,%f,%f,%f",DeviceWidth - 20, self.moreIV.frame.origin.y, self.frame.size.width, self.frame.size.height);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
