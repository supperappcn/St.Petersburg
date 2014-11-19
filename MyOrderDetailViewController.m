//
//  MyOrderDetailViewController.m
//  St.Petersburg
//
//  Created by kirem-peter on 14-11-18.
//  Copyright (c) 2014年 Jiayi. All rights reserved.
//

#import "MyOrderDetailViewController.h"

@interface MyOrderDetailViewController ()
@property (strong, nonatomic) UIScrollView* sv;
@property (assign, nonatomic) CGFloat topViewHeight;
@property (assign, nonatomic) CGFloat orderInfoViewHeight;
@property (assign, nonatomic) CGFloat linkerManViewHeight;

@end

@implementation MyOrderDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

backButton
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"订单详情";
    [self addScrollView];
    [self addTopView];
    [self addOrderInfoView];
    [self addLinkerManView];
    [self setScrollViewContentSize];
}

-(void)addScrollView {
    self.sv = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.sv.backgroundColor = [UIColor colorWithRed:0.945 green:0.945 blue:0.945 alpha:1];
    [self.view addSubview:self.sv];
}

-(void)addTopView {
    UIColor* grayColor = [UIColor grayColor];
    UIFont* font = [UIFont systemFontOfSize:14];
    UILabel* orderNumTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 70, 21)];
    orderNumTitle.text = @"订单号：";
    orderNumTitle.textColor = grayColor;
    orderNumTitle.font = font;
    [self.sv addSubview:orderNumTitle];
    UILabel* orderNumLab = [[UILabel alloc]initWithFrame:CGRectMake(80, 10, 230, 21)];
    orderNumLab.text = self.currentDic[@"OrderID"];
    orderNumLab.font = font;
    [self.sv addSubview:orderNumLab];
    UILabel* orderStatusTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, 30, 70, 21)];
    orderStatusTitle.text = @"订单状态：";
    orderStatusTitle.textColor = grayColor;
    orderStatusTitle.font = font;
    [self.sv addSubview:orderStatusTitle];
    UILabel* orderStatusLab = [[UILabel alloc]initWithFrame:CGRectMake(80, 30, 230, 21)];
    orderStatusLab.text = self.currentDic[@"Status"];
    orderStatusLab.textColor = [UIColor colorWithRed:0.192 green:0.482 blue:0.76 alpha:1];
    orderStatusLab.font = font;
    [self.sv addSubview:orderStatusLab];
    self.topViewHeight = 10 + 20 + 21;
}

-(void)addOrderInfoView {
    UIColor* grayColor = [UIColor grayColor];
    UIFont* font = [UIFont systemFontOfSize:14];
    UIView* orderInfoView = [[UIView alloc]initWithFrame:CGRectMake(0, self.topViewHeight, DeviceWidth, 35 + 82)];
    orderInfoView.backgroundColor = [UIColor colorWithRed:0.945 green:0.945 blue:0.945 alpha:1];
    [self.sv addSubview:orderInfoView];
    UILabel* orderInfoLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 78, 20)];
    orderInfoLab.text = @"订单信息";
    orderInfoLab.font = [UIFont systemFontOfSize:12];
    [orderInfoView addSubview:orderInfoLab];
    UIView* orderView = [[UIView alloc]initWithFrame:CGRectMake(0, 35, self.view.frame.size.width, 82)];
    orderView.backgroundColor = [UIColor whiteColor];
    [orderInfoView addSubview:orderView];
    UIImageView* startdayIV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 12, 18, 18)];
    startdayIV.image = [UIImage imageNamed:@"住宿预订第1步_03.png"];
    [orderView addSubview:startdayIV];
    UILabel* startdayTitle = [[UILabel alloc]initWithFrame:CGRectMake(38, 10, 70, 21)];
    startdayTitle.text = @"选择日期";
    startdayTitle.textColor = grayColor;
    startdayTitle.font = font;
    [orderView addSubview:startdayTitle];
    RTLabel* startdayLab = [[RTLabel alloc]initWithFrame:CGRectMake(120, 12, self.view.frame.size.width - 120 - 10, 21)];
    startdayLab.text = self.currentDic[@"Startdate"];
    float height = startdayLab.optimumSize.height;
    height = height>21?height:21;
    startdayLab.frame = CGRectMake(120, 12, DeviceWidth - 120 - 10, height);
    startdayLab.font = font;
    [orderView addSubview:startdayLab];
    UIImageView* link = [[UIImageView alloc]initWithFrame:CGRectMake(10, 41 + height - 21, self.view.frame.size.width - 10, 1)];
    link.image = [UIImage imageNamed:@"links.png"];
    [orderView addSubview:link];
    UIImageView* peopleCountIV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 53 + height - 21, 18, 18)];
    peopleCountIV.image = [UIImage imageNamed:@"住宿预订第1步_03-09.png"];
    [orderView addSubview:peopleCountIV];
    UILabel* peopleCountTitle = [[UILabel alloc]initWithFrame:CGRectMake(38, 51 + height - 21, 70, 21)];
    peopleCountTitle.text = @"游客人数";
    peopleCountTitle.textColor = grayColor;
    peopleCountTitle.font = font;
    [orderView addSubview:peopleCountTitle];
    UILabel* peopleCountLab = [[UILabel alloc]initWithFrame:CGRectMake(120, 51 + height - 21, self.view.frame.size.width - 120 - 10, 21)];
    peopleCountLab.text = [NSString stringWithFormat:@"%@", [self.currentDic valueForKey:@"PCount"]];
    peopleCountLab.font = font;
    [orderView addSubview:peopleCountLab];
    orderView.frame = CGRectMake(orderView.frame.origin.x, orderView.frame.origin.y, orderView.frame.size.width, orderView.frame.size.height + height - 21);
    orderInfoView.frame = CGRectMake(orderInfoView.frame.origin.x, orderInfoView.frame.origin.y, orderInfoView.frame.size.width, orderInfoView.frame.size.height + height - 21);
    self.orderInfoViewHeight = orderInfoView.frame.size.height;
}

-(void)addLinkerManView {
    UIColor* grayColor = [UIColor grayColor];
    UIFont* font = [UIFont systemFontOfSize:14];
    UIView* linkerManView = [[UIView alloc]initWithFrame:CGRectMake(0, self.topViewHeight + self.orderInfoViewHeight, DeviceWidth, 256)];
    linkerManView.backgroundColor = [UIColor colorWithRed:0.945 green:0.945 blue:0.945 alpha:1];
    [self.sv addSubview:linkerManView];
    UIView* linkerView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, 246)];
    linkerView.backgroundColor = [UIColor whiteColor];
    [linkerManView addSubview:linkerView];
    UILabel* linkerInfoLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 80, 21)];
    linkerInfoLab.text = @"联系人信息";
    linkerInfoLab.font = [UIFont systemFontOfSize:12];
    [linkerView addSubview:linkerInfoLab];
    UILabel* linkerNameTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, 51, 80, 21)];
    linkerNameTitle.text = @"姓名";
    linkerNameTitle.textColor = grayColor;
    linkerNameTitle.font = font;
    [linkerView addSubview:linkerNameTitle];
    UILabel* linkerNameLab = [[UILabel alloc]initWithFrame:CGRectMake(100, 51, 210, 21)];
    linkerNameLab.text = self.currentDic[@"Uname"];
    linkerNameLab.font = font;
    [linkerView addSubview:linkerNameLab];
    UILabel* linkerPhoneTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, 92, 80, 21)];
    linkerPhoneTitle.text = @"联系电话";
    linkerPhoneTitle.textColor = grayColor;
    linkerPhoneTitle.font = font;
    [linkerView addSubview:linkerPhoneTitle];
    UILabel* linkerPhoneLab = [[UILabel alloc]initWithFrame:CGRectMake(100, 92, 210, 21)];
    linkerPhoneLab.text = self.currentDic[@"Phone"];
    linkerPhoneLab.font = font;
    [linkerView addSubview:linkerPhoneLab];
    UILabel* linkerEmailTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, 133, 80, 21)];
    linkerEmailTitle.text = @"电子邮箱";
    linkerEmailTitle.textColor = grayColor;
    linkerEmailTitle.font = font;
    [linkerView addSubview:linkerEmailTitle];
    UILabel* linkerEmailLab = [[UILabel alloc]initWithFrame:CGRectMake(100, 133, 210, 21)];
    linkerEmailLab.text = self.currentDic[@"Email"];
    linkerEmailLab.font = font;
    [linkerView addSubview:linkerEmailLab];
    UILabel* linkerQQTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, 174, 80, 21)];
    linkerQQTitle.text = @"QQ";
    linkerQQTitle.textColor = grayColor;
    linkerQQTitle.font = font;
    [linkerView addSubview:linkerQQTitle];
    UILabel* linkerQQLab = [[UILabel alloc]initWithFrame:CGRectMake(100, 174, 210, 21)];
    linkerQQLab.text = self.currentDic[@"QQ"];
    linkerQQLab.font = font;
    [linkerView addSubview:linkerQQLab];
    UILabel* linkerWeiXinTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, 215, 80, 21)];
    linkerWeiXinTitle.text = @"微信";
    linkerWeiXinTitle.textColor = grayColor;
    linkerWeiXinTitle.font = font;
    [linkerView addSubview:linkerWeiXinTitle];
    UILabel* linkerWeiXinLab = [[UILabel alloc]initWithFrame:CGRectMake(100, 215, 210, 21)];
    linkerWeiXinLab.text = self.currentDic[@"Weixin"];
    linkerWeiXinLab.font = font;
    [linkerView addSubview:linkerWeiXinLab];
    for (int i = 1; i < 6; i++) {
        UIImageView* line = [[UIImageView alloc]initWithFrame:CGRectMake(10, 41*i, self.view.frame.size.width - 10, 1)];
        line.image = [UIImage imageNamed:@"links.png"];
        [linkerView addSubview:line];
    }
    self.linkerManViewHeight = linkerManView.frame.size.height;
}

-(void)setScrollViewContentSize {
    self.sv.contentSize = CGSizeMake(self.view.frame.size.width, self.topViewHeight + self.orderInfoViewHeight + self.linkerManViewHeight);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
