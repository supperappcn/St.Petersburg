//
//  OrderViewController.m
//  St.Petersburg
//
//  Created by 刘 吕琴 on 14-6-30.
//  Copyright (c) 2014年 Jiayi. All rights reserved.
//

#import "OrderViewController.h"
#import "AlixPayOrder.h"
#import "AlixPayResult.h"
#import "DataVerifier.h"
#import "DataSigner.h"
#import "GDataXMLNode.h"
#import "JSON.h"
#import "EntainDetailViewController.h"
#import "PaySuccessfullyViewController.h"

@interface OrderViewController()

@property (nonatomic, assign)float topViewHeight;
@property (nonatomic, assign)float attentionViewHeight;
@property (nonatomic, assign)float payWayViewHeight;
@property (nonatomic, assign)float bottomBarHeight;
@property (nonatomic, retain)NSArray* names;
@property (nonatomic, retain)NSMutableArray *pointIVArr;//存放选择支付方式按钮

@end

@implementation OrderViewController

static OrderViewController* orderViewController = nil;
+(OrderViewController *)sharedOrderViewController {
    @synchronized(self)
    {
        if (!orderViewController) {
            orderViewController = [[OrderViewController alloc]init];
        }
    }
    return orderViewController;
}

-(void)viewDidLoad{
    self.title = @"选择支付方式";
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //如果页面不是从 首页 跳转来的  则先判断价格和数量是否发生变化
    if (self.presentWay > 0) {
        NSString* roomNumberAndPrice = [self checkOutRoomNumberAndPrice];
        if (roomNumberAndPrice.intValue == 0) { //请求失败
            UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取数据失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView setTag:798];
            [alertView show];
        }else if (roomNumberAndPrice.intValue == -1) {  //数量不够
            UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"检测到剩余数量不够，请重新预订" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重新预订", nil];
            [alertView setTag:799];
            [alertView show];
        }else {
            NSArray* array = [roomNumberAndPrice componentsSeparatedByString:@","];
            self.RMB = array[2];
            self.dollar = array[3];
            NSString* p = array[1];
            self.payWay = array[4];
            if (p.intValue == 2) {//价格发生变动
                UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"检测到订单中价格已发生变化，是否继续" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"继续", nil];
                [alertView setTag:800];
                [alertView show];
            }
        }
        
    }else if (self.presentWay == 0) {   //从 首页->住宿->酒店列表 跳转过来
        
    }
    
    //添加scrollView，将topView、attentionView、payView全部放在scrollView中
    [self addScrollView];
    //添加“订单号”和“订单总额”视图
    [self addTopView];
    //添加“注意”按钮和文字
    [self addAttentionView];
    //添加”选择支付方式“视图
    [self addPayWayView];
    //添加“去支付”按钮
    [self addBottomBar];

    self.scrollView.contentSize = CGSizeMake(DeviceWidth, self.topViewHeight + self.attentionViewHeight + self.payWayViewHeight + 10);//  payWayViewHeight最底部裕量10单独加上
}

//自定义“返回”、“首页”按钮
-(void)viewDidAppear:(BOOL)animated {
    float height=35;
    UIButton *backbutton = [[UIButton alloc]init];
    backbutton.frame=CGRectMake(0, (44-height)/2, 55, height);
    [backbutton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIImageView*imageView=[[UIImageView alloc]initWithFrame:CGRectMake(-5, 10, 15, 15)];
    imageView.image=[UIImage imageNamed:@"_back.png"];
    [backbutton addSubview:imageView];
    UILabel*lable=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 40, 35)];
    lable.backgroundColor = [UIColor clearColor];
    lable.font=[UIFont systemFontOfSize:15];
    lable.textColor=[UIColor whiteColor];
    if (self.presentWay == 0) {
        lable.text=@"首页";
    }else {
        lable.text=@"返回";
    }
    [backbutton addSubview:lable];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backbutton];self.navigationItem.leftBarButtonItem =backItem;
}

-(void)back{
    if (self.presentWay == 0) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//获取价格是否变化、是否支持当面支付...
-(NSString*)checkOutRoomNumberAndPrice {
    NSMutableString* urlStr = RussiaUrl5;
    [urlStr appendString:@"getOrderNewPrice"];
    NSUserDefaults*defaults=[NSUserDefaults standardUserDefaults];
    int ID = [defaults integerForKey:@"QuseID"];
    NSString* argStr = [NSString stringWithFormat:@"ordernumber=%@&userid=%d&prodclass=%d",_orderNumber,ID,self.prodClass];
    postRequestTongBu(argStr, urlStr, received);
    dicResultTongbuNoDic(received, result);
    return result;
}

-(void)addScrollView {
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight - 64 - 45)];  //45为“去支付”背景图guding.png的高度
    self.scrollView.backgroundColor = BLACK_VIEW_COLOR;
    self.scrollView.delegate = self;
//    self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.topViewHeight + self.attentionViewHeight + self.payWayViewHeight);
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
}

-(void)addTopView {
    NSArray *names = @[@"订单号",@"订单总额"];
    self.topViewHeight = 43 * names.count + 10;
    for (int i=0; i<2; i++) {
        UIImageView *bv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10+i*43, 320, 43)];//54
        [bv setImage:[UIImage imageNamed:i==0?@"MyDownCell":@"MyCenter"]];
        
        UILabel *name= [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 90, 43)];
        name.backgroundColor = [UIColor clearColor];
        name.font = [UIFont boldSystemFontOfSize:15];
        name.text = names[i];
        name.textColor = [UIColor grayColor];
        [bv addSubview:name];
        
        if (i == 0) {
            RTLabel *name2= [[RTLabel alloc] initWithFrame:CGRectMake(100, 15, 200, 18)];
            name2.backgroundColor = [UIColor clearColor];
            name2.font = [UIFont boldSystemFontOfSize:15];
            name2.text = _orderNumber;
            name2.textColor = [UIColor grayColor];
            [bv addSubview:name2];
        }else if (i == 1) {
            self.totalPrice = [[RTLabel alloc]initWithFrame:CGRectMake(100, 15, 200, 18)];
            self.totalPrice.backgroundColor = [UIColor clearColor];
            self.totalPrice.font = [UIFont boldSystemFontOfSize:15];
            self.totalPrice.text = [NSString stringWithFormat:@"<font color=orange>￥%@</font><font size=12><font color=gray>($%@)</font>", self.RMB, self.dollar];
            [bv addSubview:self.totalPrice];
        }
        [self.scrollView addSubview:bv];
    }
}

-(void)addAttentionView {
    UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, self.topViewHeight + 10, 15, 15)];
    imageView.image = [UIImage imageNamed:@"预订须知.png"];
    [self.scrollView addSubview:imageView];
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(30, self.topViewHeight + 10, self.scrollView.frame.size.width - 40, 48)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:13];
    label.numberOfLines = 3;
    label.textAlignment = NSTextAlignmentLeft;
    if (self.prodClass == 1) {
        label.text = @"您预订的线路行程在付款完成前，日期以及价格未做锁定，有可能产生变化，为了不影响您的旅行，请及时付款。";
    }else if (self.prodClass == 2) {
        label.text = @"您预订的景点门票在付款完成前，日期以及价格未做锁定，有可能产生变化，为了不影响您的旅行，请及时付款。";
    }else if (self.prodClass == 3) {
        label.text = @"您预订的酒店房型在付款完成前，房间以及价格未做锁定，有可能产生变化，为了不影响您的入住，请及时付款。";
    }else if (self.prodClass == 4) {
        label.text = @"您预订的娱乐门票在付款完成前，日期以及价格未做锁定，有可能产生变化，为了不影响您的旅行，请及时付款。";
    }else if (self.prodClass == 5) {
        label.text = @"您预订的导游订单在付款完成前，日期以及价格未做锁定，有可能产生变化，为了不影响您的旅行，请及时付款。";
    }else if (self.prodClass == 6) {
        label.text = @"您预订的租车订单在付款完成前，日期以及价格未做锁定，有可能产生变化，为了不影响您的旅行，请及时付款。";
    }
    [self.scrollView addSubview:label];
    self.attentionViewHeight = label.frame.size.height + 10;
}

-(void)addPayWayView {
    self.pointIVArr = [NSMutableArray array];
    int count = self.payWay.intValue==1?3:4;
    UIView *payWayView = [[UIView alloc] initWithFrame:CGRectMake(0, self.topViewHeight + self.attentionViewHeight, 320, count*43)];
    [self.scrollView addSubview:payWayView];
    self.payWayViewHeight = payWayView.frame.size.height;
    self.names = @[@"选择支付方式",@"支付宝客户端支付",@"支付宝网页支付",@"当面支付"];
    NSArray *imageNames = @[@"",@"zhi",@"zhifubao",@"dangmian"];
    for (int i=0; i<count; i++) {
        UIImageView *bv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10+i*43, 320, 43)];
        [bv setImage:[UIImage imageNamed:i==0?@"MyDownCell":i==3?@"MyUpCell":@"MyCenter"]];
        bv.userInteractionEnabled = YES;
        [payWayView addSubview:bv];
        
        UILabel *name = [[UILabel alloc]init];
        name.backgroundColor = [UIColor clearColor];
        name.text = self.names[i];
        if (i!=0) {
            name.frame = CGRectMake(64, 0, 140, 43);
            name.font = [UIFont systemFontOfSize:16];
            UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(10, 7, 44, 29)];
            iv.image = [UIImage imageNamed:imageNames[i]];
            [bv addSubview:iv];
            
            UIImageView *point = [[UIImageView alloc] initWithFrame:CGRectMake(290, 12.5, 20, 20)];
            point.tag = i;
            point.image = [UIImage imageNamed:i==1?@"住宿预订第1步_19":@"住宿预订第1步_19-14"];
            point.userInteractionEnabled = YES;
            [bv addSubview:point];
            [self.pointIVArr addObject:point];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectPayWay:)];
            [point addGestureRecognizer:tap];
        }else{
            name.frame = CGRectMake( 10, 0, 140, 43);
            name.font = [UIFont systemFontOfSize:12.5];
        }
        [bv addSubview:name];
    }
    _selectPayWay = @"1";
#pragma  mark-  Changed...
    /*  将其它支付方式屏蔽
     self.pointIVArr = [NSMutableArray array];
     int count = self.payWay.intValue==1?6:7;
     UIView *payWayView = [[UIView alloc] initWithFrame:CGRectMake(0, self.topViewHeight + self.attentionViewHeight, 320, count*43)];
     [self.scrollView addSubview:payWayView];
     self.payWayViewHeight = payWayView.frame.size.height;
     self.names = @[@"选择支付方式",@"微信支付",@"支付宝客户端支付",@"支付宝网页支付",@"手机银联支付",@"信用卡支付",@"当面支付"];
     NSArray *imageNames = @[@"",@"weixin",@"zhi",@"zhifubao",@"yinlian",@"xinyongka",@"dangmian"];
     for (int i=0; i<count; i++) {
     UIImageView *bv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10+i*43, 320, 43)];
     [bv setImage:[UIImage imageNamed:i==0?@"MyDownCell":i==6?@"MyUpCell":@"MyCenter"]];
     bv.userInteractionEnabled = YES;
     [payWayView addSubview:bv];
     
     UILabel *name = [[UILabel alloc]init];
     name.text = self.names[i];
     if (i!=0) {
     name.frame = CGRectMake(64, 0, 140, 43);
     name.font = [UIFont systemFontOfSize:16];
     UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(10, 7, 44, 29)];
     iv.image = [UIImage imageNamed:imageNames[i]];
     [bv addSubview:iv];
     
     UIImageView *point = [[UIImageView alloc] initWithFrame:CGRectMake(290, 12.5, 20, 20)];
     point.tag = i;
     point.image = [UIImage imageNamed:i==1?@"住宿预订第1步_19":@"住宿预订第1步_19-14"];
     point.userInteractionEnabled = YES;
     [bv addSubview:point];
     [self.pointIVArr addObject:point];
     
     UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectPayWay:)];
     [point addGestureRecognizer:tap];
     }else{
     name.frame = CGRectMake( 10, 0, 140, 43);
     name.font = [UIFont systemFontOfSize:12.5];
     }
     [bv addSubview:name];
     }
     _selectPayWay = @"1";
     */
}

- (void)selectPayWay:(UITapGestureRecognizer*)tap{
    _selectPayWay = [NSString stringWithFormat:@"%d",tap.view.tag];
    UIImageView *iv = (UIImageView*)tap.view;
    for (int i=1;  i<=self.pointIVArr.count; i++) {
        if (tap.view.tag==i) {
            iv.image = [UIImage imageNamed:@"住宿预订第1步_19"];
        }else{
            [(UIImageView*)self.pointIVArr[i-1] setImage:[UIImage imageNamed:@"住宿预订第1步_19-14"]];
        }
    }
}

- (void)addBottomBar{
    UIView* gudingView = [[UIView alloc]initWithFrame:CGRectMake(0,  DeviceHeight-64-45, 320, 45)];
    gudingView.backgroundColor = [UIColor whiteColor];
    UIImageView* guding=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, gudingView.frame.size.width, gudingView.frame.size.height)];
    guding.image=[UIImage imageNamed:@"guding.png"];
    [gudingView addSubview:guding];
    [self.view addSubview:gudingView];
    self.bottomBarHeight = gudingView.frame.size.height;
    //"去支付"按钮////////////////////////////////////
    UIButton*orderButton=[[UIButton alloc]initWithFrame:CGRectMake((DeviceWidth-70)/2, 7.5, 70, 30)];
    orderButton.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"13"]];
    orderButton.layer.cornerRadius=4;
    orderButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [orderButton addTarget:self action:@selector(goToPay) forControlEvents:UIControlEventTouchUpInside];
    [orderButton setTitle:@"去支付" forState:UIControlStateNormal];
    [gudingView addSubview:orderButton];
}

#pragma mark  goToPay
- (void)goToPay{
    NSString* commitResult = [self commitOrder];
    if (commitResult.intValue == 0) {   //获取失败
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取订单失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        alertView.tag = 600;
        [alertView show];
    }else if (commitResult.intValue == 1) { //提交订单成功
        if (_selectPayWay.intValue == 1) {
            NSLog(@"微信支付");
            
        }else if (_selectPayWay.intValue == 2 || _selectPayWay.intValue == 3) {
            NSLog(@"支付宝客户端支付");
            [self alixPay];
        }else if (_selectPayWay.intValue == 4) {
            NSLog(@"手机银联支付");
            
        }else if (_selectPayWay.intValue == 5) {
            NSLog(@"信用卡支付");
            
        }else if (_selectPayWay.intValue == 6) {
            NSLog(@"当面支付");
            
        }
    }else if (commitResult.intValue == 2) { //向服务器提交订单失败
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"提交订单失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        alertView.tag = 601;
        [alertView show];
    }
}

//点击“去支付”后给服务器提交订单
-(NSString*)commitOrder {
    NSMutableString* urlStr = RussiaUrl5;
    [urlStr appendString:@"getAddOrderSecond"];
    NSUserDefaults*defaults=[NSUserDefaults standardUserDefaults];
    int ID = [defaults integerForKey:@"QuseID"];
    NSString* argStr = [NSString stringWithFormat:@"ordernumber=%@&userid=%d&prodclass=%d&paytype=%@",_orderNumber,ID,self.prodClass,_selectPayWay];
    postRequestTongBu(argStr, urlStr, received);
    dicResultTongbuNoDic(received, result);
    return result;
}

-(void)alixPay {
    NSString* appScheme = @"StPetersburg";
    NSString* orderInfo = [self getOrderInfo];
    NSString* signedStr = [self doRsa:orderInfo];
    
    NSString* orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",orderInfo,signedStr,@"RSA"];
    
    [AlixLibService payOrder:orderString AndScheme:appScheme seletor:@selector(paymentResult:) target:self];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        if (alertView.tag == 123) { //失败后重新支付
            [self alixPay];
        }else if (alertView.tag == 799) {  //重新预订
            EntainDetailViewController* entainDetailVC = [EntainDetailViewController new];
            entainDetailVC.hotelID = self.orderNumber.intValue;
            entainDetailVC.navName = @"酒店介绍";
            [self.navigationController pushViewController:entainDetailVC animated:YES];
        }else if (alertView.tag == 800) {
            NSString* modifyResult = [self modifyOrderPrice];
            if (modifyResult.intValue == 1) {   //接受价格变化，继续
                if (self.presentWay == 2) {   //将变化后的价格反向传值过去
                    NSString* rmbPrice = [NSString stringWithFormat:@"￥%@",self.RMB];
                    NSString *dollarPrice = [NSString stringWithFormat:@"($%@)",self.dollar];
                    NSString *allStr = [NSString stringWithFormat:@"%@%@",rmbPrice,dollarPrice];
                    NSMutableAttributedString *Str = [[NSMutableAttributedString alloc]initWithString:allStr];
                    [Str addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:[allStr rangeOfString:rmbPrice]];
                    [Str addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:[allStr rangeOfString:dollarPrice]];
                    self.meodTVC.orderPriceLab.attributedText = Str;
                }
            }else {
                UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取数据失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                alertView.tag = 900;
                [alertView show];
            }
        }
        
    }else if (buttonIndex == 0) {   //非支付失败 且取消时返回上一个界面
        if (alertView.tag == 123) { //取消重新支付
            
        }else { //返回
            if (self.presentWay == 0) { //从首页->选择支付方式  则返回到首页
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }
}

-(NSString*)modifyOrderPrice {
    NSMutableString* urlStr = RussiaUrl5;
    [urlStr appendString:@"ModifyOrderPrice"];
    NSUserDefaults*defaults=[NSUserDefaults standardUserDefaults];
    int ID = [defaults integerForKey:@"QuseID"];
    NSString* argStr = [NSString stringWithFormat:@"ordernumber=%@&userid=%d&prodclass=%d&uprice=%@&cprice=%@",_orderNumber,ID,self.prodClass,self.dollar,self.RMB];
    postRequestTongBu(argStr, urlStr, received);
    dicResultTongbuNoDic(received, result);
    return result;
}

-(NSString*)getOrderInfo {
    AlixPayOrder* order = [[AlixPayOrder alloc]init];
    order.partner = PartnerID;
    order.seller = SellerID;
    
    order.tradeNO = _orderNumber;
    order.productName = _productName;
    order.productDescription = _productDescription;
    order.amount = self.RMB; //@"0.01";
    NSLog(@"self.RMB:%@,_orderNumber:%@, _productName:%@, _productDescription:%@", self.RMB,_orderNumber, _productName, _productDescription);
    if (self.prodClass == 1) {
        order.notifyURL = @"http://t.russia-online.cn/linenotify_url.aspx";
    }else if (self.prodClass == 2) {
        order.notifyURL = @"http://t.russia-online.cn/viewnotify_url.aspx";
    }else if (self.prodClass == 3) {
        order.notifyURL = @"http://t.russia-online.cn/notify_url.aspx";
    }else if (self.prodClass == 4) {
        order.notifyURL = @"http://t.russia-online.cn/ticketnotify_url.aspx";
    }else if (self.prodClass == 5 || self.prodClass == 6) {
        order.notifyURL = @"http://t.russia-online.cn/guidenotify_url.aspx";
    }
    return [order description];
}

-(NSString*)doRsa:(NSString*)orderInfo {
    id<DataSigner> signer;
    signer = CreateRSADataSigner(PrivateKey);
    NSString* signedString = [signer signString:orderInfo];
    return signedString;
}

//wap回调函数
-(void)paymentResult:(NSString *)result {
    AlixPayResult* alixPayResult = [[AlixPayResult alloc]initWithString:result];
    BOOL judge1 = [self checkOutAlixPayResult:alixPayResult];
    BOOL judge2 = [self checkOutPayResult];
    if (judge1 && judge2) {
        NSLog(@"服务器、手机端显示支付完成");
        [self goToPaySuccessfullyViewController];
    }
}

//快捷支付回调函数
- (void)parse:(NSURL *)url application:(UIApplication *)application {
    AlixPayResult* alixPayResult = [self handleOpenURL:url];
    BOOL judge1 = [self checkOutAlixPayResult:alixPayResult];
    BOOL judge2 = [self checkOutPayResult];
    if (judge1 && judge2) {
        NSLog(@"服务器、手机端显示支付完成");
        [self goToPaySuccessfullyViewController];
    }
}

-(void)goToPaySuccessfullyViewController {
    PaySuccessfullyViewController* payedVC = [PaySuccessfullyViewController new];
    payedVC.orderNum = self.orderNumber;
    payedVC.prodClass = self.prodClass;
    
    NSString* testRMB = [NSString stringWithFormat:@"￥%@", self.RMB];
    NSString* testDollar = [NSString stringWithFormat:@"($%@)", self.dollar];
    NSString* testAllStr = [NSString stringWithFormat:@"%@%@", testRMB, testDollar];
    NSMutableAttributedString* testPrice = [NSMutableAttributedString attributedStringWithString:testAllStr];
    [testPrice addAttributes:@{NSForegroundColorAttributeName: [UIColor orangeColor]} range:[testAllStr rangeOfString:testRMB]];
    [testPrice addAttributes:@{NSForegroundColorAttributeName: [UIColor grayColor]} range:[testAllStr rangeOfString:testDollar]];
    payedVC.orderPrice = testPrice;
    
    NSString* zhiFuFangShi = @"";
    if (_selectPayWay.intValue == 1) {
        zhiFuFangShi = @"微信支付";
    }else if (_selectPayWay.intValue == 2) {
        zhiFuFangShi = @"支付宝客户端支付";
    }else if (_selectPayWay.intValue == 3) {
        zhiFuFangShi = @"支付宝网页支付";
    }else if (_selectPayWay.intValue == 4) {
        zhiFuFangShi = @"手机银联支付";
    }else if (_selectPayWay.intValue == 5) {
        zhiFuFangShi = @"信用卡支付";
    }else if (_selectPayWay.intValue == 6) {
        zhiFuFangShi = @"当面支付";
    }
    payedVC.payWay = zhiFuFangShi;
    [self.navigationController pushViewController:payedVC animated:YES];
}

//查看支付宝给app返回结果
-(BOOL)checkOutAlixPayResult:(AlixPayResult*)alixPayResult {
    if (alixPayResult) {
        if (alixPayResult.statusCode == 9000) {
            
            id<DataVerifier> verifier;
            verifier = CreateRSADataVerifier(PublicKey);
            
            if ([verifier verifyString:alixPayResult.resultString withSign:alixPayResult.signString]) {
                return YES;
                
            }else {
                return NO;
            }
        }else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"支付失败，请重试" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重试", nil];
            [alert setTag:123];
            [alert show];
            return NO;
        }
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"支付失败，请重试" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重试", nil];
        [alert setTag:123];
        [alert show];
        return NO;
    }
}

- (AlixPayResult *)resultFromURL:(NSURL *)url {
	NSString * query = [[url query] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	return [[AlixPayResult alloc] initWithString:query];
}

- (AlixPayResult *)handleOpenURL:(NSURL *)url {
	AlixPayResult * result = nil;
	if (url != nil && [[url host] compare:@"safepay"] == 0) {
		result = [self resultFromURL:url];
	}
	return result;
}

//从服务器获取数据看是否完成支付
-(BOOL)checkOutPayResult {
    NSMutableString* urlStr = RussiaUrl4;
    [urlStr appendString:@"GetHotelorderPayinfo"];
    NSLog(@"_orderNumber...:%@", _orderNumber);
    NSString* argumentStr = [NSString stringWithFormat:@"prodclassid=%d&ordernumber=%@",self.prodClass,_orderNumber];
    postRequestTongBu(argumentStr, urlStr, received);
    dicResultTongbuNoDic(received, result);
    NSLog(@"orderNumber:%@,checkOutPayResult:%@",_orderNumber,result);
    
    if (result.intValue == 2) {
        NSLog(@"服务器显示支付完成");
        return YES;
    }else {
        return NO;
    }
}


@end
