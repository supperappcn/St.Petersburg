//
//  PaySuccessfullyViewController.m
//  St.Petersburg
//
//  Created by kirem-peter on 14-11-14.
//  Copyright (c) 2014年 Jiayi. All rights reserved.
//

#import "PaySuccessfullyViewController.h"
#import "MyEntainOrderDetailTableViewController.h"

@interface PaySuccessfullyViewController ()

@end

@implementation PaySuccessfullyViewController

backButton
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"预订成功";
    self.view.backgroundColor = [UIColor colorWithRed:0.945 green:0.945 blue:0.945 alpha:1];
    [self addOrderInfoView];
    [self addBottomBar];//添加“查看订单”按钮及背景
}

-(void)addOrderInfoView {
    UIColor* grayColor = [UIColor grayColor];
    UIFont* font_14 = [UIFont systemFontOfSize:14];
    RTLabel* messageLab = [[RTLabel alloc]initWithFrame:CGRectMake(10, 12, self.view.frame.size.width - 20, 20)];//使用RTLabel时存在2pixel的误差
    messageLab.backgroundColor = [UIColor clearColor];
    if ([self.payWay isEqualToString:@"当面支付"]) {
        messageLab.text = @"您的订单已选择当面支付！将有相关客服人员与您联系。";
    }else {
        messageLab.text = @"支付成功！将有相关客服人员与您联系。";
    }
    float messageLabHeight = messageLab.optimumSize.height;
    messageLabHeight = messageLabHeight>20?messageLabHeight:20;
    messageLab.frame = CGRectMake(messageLab.frame.origin.x, messageLab.frame.origin.y, messageLab.frame.size.width, messageLabHeight);
    messageLab.font = font_14;
    [self.view addSubview:messageLab];
    UIView* orderView = [[UIView alloc]initWithFrame:CGRectMake(0, 10 + messageLabHeight + 10, self.view.frame.size.width, 123)];
    orderView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:orderView];
    NSArray* orderName = @[@"订单号：",@"订单总额：",@"支付方式："];
    for (int i = 0; i < 3; i++) {
        UILabel* orderTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, 10 + 41*i, 70, 21)];
        orderTitle.backgroundColor = [UIColor clearColor];
        orderTitle.text = orderName[i];
        orderTitle.textColor = grayColor;
        orderTitle.font = font_14;
        [orderView addSubview:orderTitle];
        if (i) {
            UIImageView* line = [[UIImageView alloc]initWithFrame:CGRectMake(10, 41*i, self.view.frame.size.width - 10, 1)];
            line.image = [UIImage imageNamed:@"links.png"];//MyCenter.png
            [orderView addSubview:line];
        }
        UILabel* orderLab = [[UILabel alloc]initWithFrame:CGRectMake(80, 10 + 41*i, self.view.frame.size.width - 10 - 80, 21)];
        orderLab.backgroundColor = [UIColor clearColor];
        orderLab.font = font_14;
        [orderView addSubview:orderLab];
        if (i == 0) {
            orderLab.text = self.orderNum;
        }else if (i == 1) {
            orderLab.attributedText = self.orderPrice;
        }else if (i == 2) {
            orderLab.text = self.payWay;
        }
    }
}

-(void)addBottomBar {
    UIView* barView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 45 - 64, self.view.frame.size.width, 45)];
    [self.view addSubview:barView];
    UIImageView* barIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, barView.frame.size.width, barView.frame.size.height)];
    barIV.image = [UIImage imageNamed:@"guding.png"];
    [barView addSubview:barIV];
    UIButton* checkOrderBtn = [[UIButton alloc]initWithFrame:CGRectMake((self.view.frame.size.width-70)/2, 7.5, 70, 30)];
    checkOrderBtn.backgroundColor = [UIColor colorWithRed:0 green:0.435 blue:0.698 alpha:1];
    checkOrderBtn.layer.cornerRadius = 4;
    checkOrderBtn.layer.masksToBounds = YES;
    [checkOrderBtn setTitle:@"查看订单" forState:UIControlStateNormal];
    checkOrderBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [checkOrderBtn addTarget:self action:@selector(checkOrderDetail) forControlEvents:UIControlEventTouchUpInside];
    [barView addSubview:checkOrderBtn];
}

-(void)checkOrderDetail {
    NSLog(@"查看订单，跳转到订单详情页面");
    MyEntainOrderDetailTableViewController* meodTVC = [MyEntainOrderDetailTableViewController new];
    meodTVC.prodClass = [NSString stringWithFormat:@"%d", self.prodClass];
    meodTVC.orderNum = self.orderNum;
    meodTVC.orderPrice = self.orderPrice;
    meodTVC.payStr = self.payWay;
    meodTVC.pushWay = 1;
    [self.navigationController pushViewController:meodTVC animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
