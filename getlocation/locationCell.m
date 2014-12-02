//
//  locationCell.m
//  St.Petersburg
//
//  Created by beginner on 14-11-20.
//  Copyright (c) 2014年 Jiayi. All rights reserved.
//

#import "locationCell.h"

@implementation locationCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.raingeL = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, self.frame.size.width, 24)];
        self.raingeL.backgroundColor = [UIColor clearColor];
        self.raingeL.font = [UIFont systemFontOfSize:15];
        self.raingeL.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.raingeL];
        
        
        self.cityL = [[UILabel alloc]initWithFrame:CGRectMake(20, 24, self.frame.size.width, 18)];
        self.cityL.backgroundColor = [UIColor clearColor];
        self.cityL.font = [UIFont systemFontOfSize:13.5];
        self.cityL.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.cityL];
        
        
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
