//
//  TravelViewController_2.h
//  St.Petersburg
//
//  Created by kirem-peter on 14-12-11.
//  Copyright (c) 2014年 Jiayi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TravelViewController_2 : UIViewController
@property (nonatomic, assign)int ID;
@property (nonatomic, strong)NSDictionary* dic;
@property (nonatomic, assign)int presentWay;//0 “游记攻略”-“游记列表”-“游记正文”跳转过来; 1 “我的”-“游记”-“游记列表”-“游记正文”跳转过来
@end
