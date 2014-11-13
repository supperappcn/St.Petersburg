//
//  MyEntainOrderDetailTableViewController.h
//  St.Petersburg
//
//  Created by kirem-peter on 14-11-5.
//  Copyright (c) 2014年 Jiayi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyEntainOrderDetailTableViewController : UITableViewController

@property (retain, nonatomic)NSDictionary* currentDic;
@property (strong, nonatomic)NSMutableArray *tableArr;//存放有多少游客信息的
@property (copy, nonatomic)NSString* prodClass;//prodclass：1线路、2景点、3酒店、4门票、5导游、6租车
@property (assign, nonatomic)int hotelID;//XXID，重新预订时需要用到

//topView中各项的值
@property (copy, nonatomic)NSAttributedString* orderPrice;//订单金额
@property (strong, nonatomic)UILabel* orderPriceLab;//用来显示订单的金额
@property (copy, nonatomic)NSString* payStr;//支付方式
@property (strong, nonatomic)UIImage* headImage;

@end
