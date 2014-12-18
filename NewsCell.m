//
//  NewsCell.m
//  St.Petersburg
//
//  Created by 刘 吕琴 on 14-2-19.
//  Copyright (c) 2014年 Jiayi. All rights reserved.
//

#import "NewsCell.h"

@implementation NewsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.title = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, DeviceWidth-20-40, 18)];
        self.title.backgroundColor = [UIColor clearColor];
        self.title.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:self.title];
        self.summary = [[RTLabel alloc]initWithFrame:CGRectMake(10, 35,DeviceWidth-10-16-10, 35)];
        self.summary.backgroundColor = [UIColor clearColor];
        self.summary.textColor = [UIColor grayColor];
        self.summary.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.summary];
        self.time = [[UILabel alloc]initWithFrame:CGRectMake(10, 63, DeviceWidth-10-40, 15)];
        self.time.textColor = [UIColor grayColor];
        self.time.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.time];
        self.weidu = [[UILabel alloc]initWithFrame:CGRectMake(DeviceWidth - 40, self.time.frame.origin.y, 30, 15)];
        self.weidu.text = @"未读";
        self.weidu.textColor = [UIColor redColor];
        self.weidu.font = [UIFont systemFontOfSize:12];
        self.weidu.hidden = YES;
        [self.contentView addSubview:self.weidu];
        self.jianTouIV = [[UIImageView alloc]initWithFrame:CGRectMake(DeviceWidth - 16, 35, 16, 16)];
        self.jianTouIV.image = [UIImage imageNamed:@"cellJianTou.png"];
        [self.contentView addSubview:self.jianTouIV];
        self.line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 87.5-2, DeviceWidth, 2)];
        self.line.image = [UIImage imageNamed:@"entainmentLink"];
        [self.contentView addSubview:self.line];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
