//
//  MyOrderListViewController.h
//  St.Petersburg
//
//  Created by kirem-peter on 14-11-18.
//  Copyright (c) 2014年 Jiayi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyOrderListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,NSURLConnectionDataDelegate>

@property (strong, nonatomic) NSArray* tableArr;//订单数据

@property (strong, nonatomic) IBOutlet UIButton *firstBtn;
@property (strong, nonatomic) IBOutlet UIButton *secondBtn;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;

@end
