//
//  OrderViewController.h
//  St.Petersburg
//
//  Created by 刘 吕琴 on 14-6-30.
//  Copyright (c) 2014年 Jiayi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlixLibService.h"
#import "MyEntainOrderDetailTableViewController.h"

@interface OrderViewController : UIViewController <UIScrollViewDelegate>
@property (nonatomic , copy) NSString * payWay;//1在线支付   2在线和当面支付
@property (nonatomic , copy) NSString *selectPayWay;//1.微信支付  2、3.支付宝支付  4.银联支付  5.信用卡支付  6.当面支付
@property (nonatomic , copy) NSString *dollar;//美元价格
@property (nonatomic , copy) NSString *RMB;//人民币价格
@property (nonatomic , copy) NSString *orderNumber;//用来传订单号
@property (nonatomic , copy) NSString *productName;//产品名称
@property (nonatomic , copy) NSString *productDescription;//产品描述
@property (nonatomic , assign) int prodClass;//1.线路 2.景点 3.酒店 4.门票 5.导游 6.租车
@property (nonatomic , assign) int presentWay;//用来区分从哪个页面push进来的
@property (nonatomic , retain) UIScrollView* scrollView;
@property (nonatomic , retain) RTLabel* totalPrice;//显示价格的label
@property (nonatomic , strong) MyEntainOrderDetailTableViewController* meodTVC;//用于接受价格变化后反向传值

+(OrderViewController*)sharedOrderViewController;
- (void)parse:(NSURL *)url application:(UIApplication *)application;
-(void)paymentResult:(NSString*)result;

@end
