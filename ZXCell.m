//
//  ZXCell.m
//  St.Petersburg
//
//  Created by beginner on 14-12-6.
//  Copyright (c) 2014年 Jiayi. All rights reserved.
//

#import "ZXCell.h"

@implementation ZXCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.ZXImgV = [[UIImageView alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:self.ZXImgV];
        
        self.ZXNameL = [[UILabel alloc]initWithFrame:CGRectZero];
        self.ZXNameL.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:self.ZXNameL];
        
        self.ZXDateL = [[UILabel alloc]initWithFrame:CGRectZero];
        self.ZXDateL.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:self.ZXDateL];
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
