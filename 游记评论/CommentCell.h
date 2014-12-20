//
//  CommentCell.h
//  St.Petersburg
//
//  Created by beginner on 14-12-11.
//  Copyright (c) 2014年 Jiayi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentCell : UITableViewCell

@property (retain , nonatomic) UIImageView *imgTouX;//头像

@property (retain , nonatomic) RTLabel *UserL;//用户的那一行包日期

@property (retain , nonatomic) UIWebView *ContentL;//内容

@property (retain , nonatomic) UIButton *replyB;//回复

@property (retain , nonatomic) UIImageView*link;//分割线


@end
