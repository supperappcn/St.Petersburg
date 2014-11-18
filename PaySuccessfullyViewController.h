//
//  PaySuccessfullyViewController.h
//  St.Petersburg
//
//  Created by kirem-peter on 14-11-14.
//  Copyright (c) 2014年 Jiayi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaySuccessfullyViewController : UIViewController
@property (nonatomic, copy)NSString* orderNum;//订单号
@property (nonatomic, copy)NSAttributedString* orderPrice;//订单金额
@property (nonatomic, copy)NSString* payWay;//支付方式：微信支付、支付宝支付、银联支付...
@property (nonatomic, assign)int prodClass;//1.线路 2.景点 3.酒店 4.娱乐门票 5.导游 6.租车
@end
