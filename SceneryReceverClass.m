//
//  SceneryReceverClass.m
//  St.Petersburg
//
//  Created by 刘 吕琴 on 14-7-8.
//  Copyright (c) 2014年 Jiayi. All rights reserved.
//

#import "SceneryReceverClass.h"
#import "GDataXMLNode.h"
#import "OrderViewController.h"
#import "hotelCarenderViewController.h"
@implementation SceneryReceverClass
backButton

- (void)viewWillAppear:(BOOL)animated{
    
    //roomInformationStr = [[NSMutableString alloc] init];
    userConnectInformationStr = [[NSMutableString alloc] init];
    if (_checkDate) {
        if (self.ticketCount == 0)
        {
            
            [jian setBackgroundImage:[UIImage imageNamed:@"jian2"] forState:UIControlStateNormal];
            [jia setBackgroundImage:[UIImage imageNamed:@"jia2"] forState:UIControlStateNormal];
            zhong.text = @"0";
            jia.enabled = NO;
            jian.enabled = NO;
        }
        else{
            [jia setBackgroundImage:[UIImage imageNamed:@"jia"] forState:UIControlStateNormal];
            zhong.text = @"1";
            jia.enabled = YES;
        }
        
        UILabel *checkLab = (UILabel *)[sv viewWithTag:11];
        checkLab.backgroundColor = [UIColor clearColor];
        checkLab.text = _checkDate;
        price.text=[NSString stringWithFormat: @"<font size=20 color=orange >￥%d</font><font color=white>（$%d)</font>",_RMB.intValue*zhong.text.intValue,_dollar.intValue*zhong.text.intValue];
    }
    if (_check_outDate) {
        UILabel *check_outLab = (UILabel *)[sv viewWithTag:12];
        check_outLab.backgroundColor = [UIColor clearColor];
        check_outLab.text = _check_outDate;
        price.text=[NSString stringWithFormat: @"<font size=20 color=orange >￥%d</font><font color=white>（$%d)</font>",_RMB.intValue*zhong.text.intValue ,_dollar.intValue*zhong.text.intValue];
    }
}
-(void)viewDidLoad{
    viewHeight=0;
    self.view.backgroundColor = BLACK_VIEW_COLOR;
    _formatter = [[NSDateFormatter alloc]init];
    [_formatter setDateFormat:@"YYYY年MM月dd日"];
    
    _components = [[NSDateComponents alloc] init];
    [_components setDay:1];
    
    //加入sv
    sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight
                                                        )];
    [self changeViewFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight - 44) withView:sv];
    sv.backgroundColor = BLACK_VIEW_COLOR;
    [self.view addSubview:sv];
    
    paytype=@"1";
   // _dayCount=@"1";
    
    //表头
    [self addHeaderView];
    
    //填写资料
//    [self changeUserDataView:@"1"];
    
    //联系人、
    [self addLinkmanView];
    
    //预订须知
    [self addReseverKnowView];
    
    //支付方式
//    [self addPayView];
    
    //下bar
    [self addBottomBar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}
- (void)keyboardDidShow:(NSNotification *)notif {
    
    CGRect rect = [[notif.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat height = rect.size.height;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    sv.frame = CGRectMake(0, 0, 320, self.view.frame.size.height-height);
    [sv setContentSize:CGSizeMake(sv.contentSize.width, 188 + 80 + footerViewHeight - 44 - 44)];
    [UIView commitAnimations];
    
}


- (void)keyboardWillHide:(NSNotification *)notif {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    sv.frame = self.view.bounds;
    [sv setContentSize:CGSizeMake(sv.contentSize.width, 188 + 80 + footerViewHeight - 44)];

    [UIView commitAnimations];
}

- (void)addHeaderView{
    russianName = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 300, 20)];
    russianName.backgroundColor = [UIColor clearColor];
    russianName.text=_russianStr;
    russianName.font = [UIFont boldSystemFontOfSize:18];
    [sv addSubview:russianName];
    
    chineseName = [[UILabel alloc] initWithFrame:CGRectMake(10, 27, 300, 15)];
    chineseName.backgroundColor = [UIColor clearColor];
    chineseName.text = _chineseStr;
    chineseName.font = [UIFont boldSystemFontOfSize:14];
    chineseName.textColor = [UIColor grayColor];
    [sv addSubview:chineseName];
    
    
    RTLabel *lab = [[RTLabel alloc]initWithFrame:CGRectMake(10, 50, 300, 15)];
    lab.backgroundColor = [UIColor clearColor];
    lab.text = [NSString stringWithFormat:@"%@",_roomTypeStr];
    lab.font = [UIFont systemFontOfSize:11];
    [sv addSubview:lab];
    
    RTLabel *lab2 = [[RTLabel alloc]initWithFrame:CGRectMake(10, 70, 300, 15)];
    lab2.backgroundColor = [UIColor clearColor];
    lab2.text = [NSString stringWithFormat:@"<font size=11 color=gray>开放时间 : </font>%@",_showTime];
    lab2.font = [UIFont systemFontOfSize:11];
    [sv addSubview:lab2];
    
    
    NSArray *imageNames = @[@"住宿预订第1步_03",@"住宿预订第1步_03-09"];
    NSArray *names = @[@"选择日期",@"预订人数"];
    for (int i=0; i<2; i++) {
        UIButton *bv = [[UIButton alloc]initWithFrame:CGRectMake(0, 80+10+i*43, 320, 43)];
        [bv setBackgroundImage:[UIImage imageNamed:i==0?@"MyDownCell":@"MyUpCell"] forState:UIControlStateNormal];
        [sv addSubview:bv];
        bv.tag=i;
        if (i==0) {
            [bv  addTarget:self action:@selector(gotoChangeDate:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(10, 13, 16, 16)];
        iv.image=[UIImage imageNamed:imageNames[i]];
        [bv addSubview:iv];
        
        UILabel *name= [[UILabel alloc] initWithFrame:CGRectMake(36, 13.5, 70, 16)];
        name.backgroundColor = [UIColor clearColor];
        name.font = [UIFont systemFontOfSize:16];
        name.text = names[i];
        name.textColor = [UIColor grayColor];
        [bv addSubview:name];
        switch (i) {
            case 0:{
                [bv setBackgroundImage:[UIImage imageNamed:@"mine_newsAndSet_h"] forState:UIControlStateHighlighted];
                
                
                //前日期
                UILabel *date= [[UILabel alloc] initWithFrame:CGRectMake(116, 13.5, 200, 16)];
                date.backgroundColor = [UIColor clearColor];
                date.font = [UIFont systemFontOfSize:16];
                //date.text = [_formatter stringFromDate:[NSDate date]];
                date.tag = 11;
                [bv addSubview:date];
                
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                [btn setBackgroundImage:[UIImage imageNamed:@"cellJianTou"] forState:UIControlStateNormal];
                btn.frame = CGRectMake(296.5, 13.5, 16, 16);
                [bv addSubview:btn];
            }
        
                
                break;
            case 1:{
                
                [bv setBackgroundImage:[UIImage imageNamed:@"MyUpCell"] forState:UIControlStateHighlighted];
                UIView *v = [[UIView alloc]initWithFrame:CGRectMake(116, 7, 60+41, 29)];
                jian = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 29)];
                [jian setBackgroundImage:[UIImage imageNamed:@"jian2"] forState:UIControlStateNormal];
                [jian setBackgroundImage:[UIImage imageNamed:@"jian2"] forState:UIControlStateHighlighted];
                [jian addTarget:self action:@selector(changeCount:) forControlEvents:UIControlEventTouchUpInside];
                jian.tag = 1;
                jian.enabled=NO;
                [v addSubview:jian];
                
                zhong = [[UITextField alloc]initWithFrame:CGRectMake(30, 0, 41, 29)];
                zhong.textAlignment = NSTextAlignmentCenter;
                zhong.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                zhong.textColor = [UIColor colorWithRed:0 green:109/255.0 blue:184/255.0 alpha:1];
                zhong.enabled = NO;
                zhong.layer.contents = (id)[UIImage imageNamed:@"zhong"].CGImage;
                zhong.text = @"1";
                [v addSubview:zhong];
                
                jia = [[UIButton alloc]initWithFrame:CGRectMake(71, 0, 30, 29)];
                [jia setBackgroundImage:[UIImage imageNamed:@"jia"] forState:UIControlStateNormal];
                [jia setBackgroundImage:[UIImage imageNamed:@"jia2"] forState:UIControlStateHighlighted];
                [jia addTarget:self action:@selector(changeCount:) forControlEvents:UIControlEventTouchUpInside];
                jia.tag = 2;
                [v addSubview:jia];
                [bv addSubview:v];
                
            }
                
                break;
            default:
                break;
        }
    }
    
//    RTLabel *lastLab = [[RTLabel alloc] initWithFrame:CGRectMake(10, 254, 300, 40)];
//    lastLab.font = [UIFont systemFontOfSize:10];
//    lastLab.textColor = [UIColor grayColor];
//    lastLab.text = @"• 请如实填写入住人的真实信息，信息需与护照信息一致。\n• 入住人信息一经提交后，不可更改。请慎重填写，以免影响入住。";
//    [sv addSubview:lastLab];
    
}
- (void)gotoChangeDate:(UIButton*)btn{
    
    hotelCarenderViewController *mcvc = [hotelCarenderViewController new];
    if (_checkDate)
    {
        [self.navigationController popViewControllerAnimated:NO];
    }
    else
    {
        mcvc.title = @"游玩日期";
        mcvc.ProdType = @"3";
        mcvc.ID = _ID;
        mcvc.HotelCNName = _chineseStr;
        mcvc.HotelRUName = _russianStr;
        mcvc.showTime = _showTime;
        mcvc.dataDic = _dataDic;
        [self.navigationController pushViewController:mcvc animated:NO];
    }
    
}
- (void)changeCount:(UIButton*)btn{
    switch (btn.tag) {
            
        case 1:{
            //第一个减
            
            zhong.text = [NSString stringWithFormat:@"%d",[zhong.text intValue]-1];
            [sv setContentSize:CGSizeMake(sv.contentSize.width, sv.contentSize.height - 248)]; //sv自适应
        }
            
            break;
        case 2://第一个加
        {
            
            zhong.text = [NSString stringWithFormat:@"%d",[zhong.text intValue]+1];
            [sv setContentSize:CGSizeMake(sv.contentSize.width, sv.contentSize.height + 248)]; //sv自适应
        }
            break;
            
            
        default:
            break;
            
            
    }

    if (zhong.text.intValue==1)
    {
        [jian setBackgroundImage:[UIImage imageNamed:@"jian2"] forState:UIControlStateNormal];
        jian.enabled=NO;
    }
    else if (self.ticketCount >= 10 || self.ticketCount == 0)
    {
        if (zhong.text.intValue==10) {
            [jia setBackgroundImage:[UIImage imageNamed:@"jia2"] forState:UIControlStateNormal];
            jia.enabled=NO;
        }
        else{
            [jian setBackgroundImage:[UIImage imageNamed:@"jian"] forState:UIControlStateNormal];
            jian.enabled=YES;
            
            [jia setBackgroundImage:[UIImage imageNamed:@"jia"] forState:UIControlStateNormal];
            jia.enabled=YES;
        }
    }
    else
    {
        if (zhong.text.intValue==self.ticketCount)
        {
            [jia setBackgroundImage:[UIImage imageNamed:@"jia2"] forState:UIControlStateNormal];
            jia.enabled=NO;
        }
        else{
            [jian setBackgroundImage:[UIImage imageNamed:@"jian"] forState:UIControlStateNormal];
            jian.enabled=YES;
            
            [jia setBackgroundImage:[UIImage imageNamed:@"jia"] forState:UIControlStateNormal];
            jia.enabled=YES;
        }
    }
    
    
    
    
    price.text=[NSString stringWithFormat: @"<font size=20 color=orange >￥%d</font><font color=white>（$%d)</font>",_RMB.intValue*zhong.text.intValue ,_dollar.intValue*zhong.text.intValue];
    
}

- (void)addLinkmanView{
    footerViewHeight = 0;
    footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 178+10, 320, 500)];
    
    UIView *linkmanView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 248)];
    NSArray *linkmanNames = @[@"联系人信息",@"姓名",@"联系电话",@"电子邮箱",@"QQ",@"微信"];
    for (int i=0; i<6; i++) {
        UIButton *bv = [[UIButton alloc]initWithFrame:CGRectMake(0, 10+i*43, 320, 43)];
        [bv setBackgroundImage:[UIImage imageNamed:i==0?@"MyDownCell":i==5?@"MyUpCell":@"MyCenter"] forState:UIControlStateNormal];
        [linkmanView addSubview:bv];
        
        UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(10, 13.5, 140, 16)];
        name.backgroundColor = [UIColor clearColor];
        name.font = [UIFont systemFontOfSize:i==0?12.5:16];
        name.text = linkmanNames[i];
        name.textColor =  i==0?[UIColor blackColor]:[UIColor grayColor];
        [bv addSubview:name];
        
        if (i!=0) {
            UITextField *file = [[UITextField alloc] initWithFrame:CGRectMake(116, 0, 230, 43)];
            file.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            file.tag = [NSString stringWithFormat:@"10%d",i].intValue;
            file.font = [UIFont systemFontOfSize:16];
            file.delegate = self;
            [bv addSubview:file];
            if (i==4||i==5) {
                file.placeholder = @"选填";
            }
        }
    }
    [footerView addSubview:linkmanView];
    footerViewHeight = 248;
    [sv addSubview:footerView];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:NO];
    return YES;
}
- (void)addReseverKnowView{
    
    if (_reseverKnowStr.length>0) {
        RTLabel *content = [[RTLabel alloc] initWithFrame:CGRectMake(10, 43+10, 300, 0)];
        content.backgroundColor = [UIColor clearColor];
        content.text = _reseverKnowStr;
        content.font = [UIFont systemFontOfSize:11];
        content.frame = CGRectMake(10, 43+10, 300, content.optimumSize.height);
        
        UIView *rkv = [[UIView alloc] initWithFrame:CGRectMake(0, footerViewHeight+20, 320, 43+content.optimumSize.height+10)];
        
        for (int i=0; i<2; i++) {
            
            UIImageView *bv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 43*i, 320, i==0?43:content.optimumSize.height+20)];
            [bv setImage:[UIImage imageNamed:i==0?@"MyDownCell":@"MyUpCell"]];
            [rkv addSubview:bv];
            if (i==0) {
                UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 15.5, 15.5)];
                iv.image = [UIImage imageNamed:@"预订须知"];
                [bv addSubview:iv];
                
                UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(35.5, 0, 70, 43)];
                name.backgroundColor = [UIColor clearColor];
                name.font = [UIFont systemFontOfSize:12.5];
                name.text = @"预订须知";
                [bv addSubview:name];
            }
        }
        footerViewHeight = footerViewHeight+20+43+content.optimumSize.height+10;
        [footerView addSubview:rkv];
        [rkv addSubview:content];
    }
    
    
}
/*
- (void)addPayView{
    pointIVArr = [NSMutableArray array];
    int count=_payWay.intValue==1?6:7;
    UIView *payView = [[UIView alloc] initWithFrame:CGRectMake(0, footerViewHeight+20, 320, count*43)];
    // payView.backgroundColor = [UIColor redColor];
    NSArray *names = @[@"选择支付方式",@"微信支付",@"支付宝客户端支付",@"支付宝网页支付",@"手机银联支付",@"信用卡支付",@"当面支付"];
    NSArray *imageNames = @[@"",@"weixin",@"zhi",@"zhifubao",@"yinlian",@"xinyongka",@"dangmian"];
    for (int i=0; i<count; i++) {
        UIImageView *bv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10+i*43, 320, 43)];
        [bv setImage:[UIImage imageNamed:i==0?@"MyDownCell":i==6?@"MyUpCell":@"MyCenter"]];
        bv.userInteractionEnabled = YES;
        [payView addSubview:bv];
        
        UILabel *name = [[UILabel alloc]init];
        name.text = names[i];
        if (i!=0) {
            name.frame = CGRectMake(64, 0, 140, 43);
            name.font = [UIFont systemFontOfSize:16];
            UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(10, 7, 44, 29)];
            iv.image = [UIImage imageNamed:imageNames[i]];
            [bv addSubview:iv];
            
            //点点
            UIImageView *point = [[UIImageView alloc] initWithFrame:CGRectMake(290, 12.5, 20, 20)];
            point.tag = i;
            point.image = [UIImage imageNamed:i==1?@"住宿预订第1步_19":@"住宿预订第1步_19-14"];
            point.userInteractionEnabled = YES;
            [bv addSubview:point];
            [pointIVArr addObject:point];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectPayWay:)];
            [point addGestureRecognizer:tap];
        }else{
            name.frame = CGRectMake( 10, 0, 140, 43);
            name.font = [UIFont systemFontOfSize:12.5];
        }
        [bv addSubview:name];
        
    }
 
    
//    [footerView addSubview:payView];
//    footerViewHeight = footerViewHeight+10+count*43;
//    footerView.frame = CGRectMake(0, 178, 320, footerViewHeight);
//    NSLog(@"1 vjiewHeight %f footerViewheight %f",viewHeight,footerViewHeight);
    
}
 */

- (void)selectPayWay:(UITapGestureRecognizer*)tap{
    NSLog(@"tag  %d",tap.view.tag);
    paytype = [NSString stringWithFormat:@"%d",tap.view.tag];
    UIImageView *iv = (UIImageView*)tap.view;
    for (int i=1;  i<=pointIVArr.count; i++) {
        if (tap.view.tag==i) {
            iv.image = [UIImage imageNamed:@"住宿预订第1步_19"];
        }else{
            [(UIImageView*)pointIVArr[i-1] setImage:[UIImage imageNamed:@"住宿预订第1步_19-14"]];
        }
    }
}
- (void)addBottomBar{
    UIImageView*guding=[[UIImageView alloc]initWithFrame:CGRectMake(0,  DeviceHeight-64-45, 320, 45)];
    guding.userInteractionEnabled=YES;
    guding.image=[UIImage imageNamed:@"guding.png"];
    [self.view addSubview:guding];
    //价格和预订
    
    price=[[RTLabel alloc]initWithFrame:CGRectMake(10, 10, 150, 25)];
    price.backgroundColor = [UIColor clearColor];
    price.text=[NSString stringWithFormat: @"<font size=20 color=orange >￥%@</font><font color=white>（$%@)</font>",_RMB,_dollar];
    price.font = [UIFont systemFontOfSize:13.5];
    [guding addSubview:price];
    
    //预订按钮////////////////////////////////////
    UIButton*orderButton=[UIButton buttonWithType:UIButtonTypeCustom];
    orderButton.layer.cornerRadius=4;
    orderButton.titleLabel.font = [UIFont systemFontOfSize:13.5];
    orderButton.frame=CGRectMake(240,10, 72.5, 25);
    //orderButton.tag = [[dataArray[index] objectForKey:@"ID"] integerValue];
    orderButton.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"13"]];
    [orderButton addTarget:self action:@selector(goUpOrder) forControlEvents:UIControlEventTouchUpInside];
    [orderButton setTitle:@"提交订单" forState:UIControlStateNormal];
    [guding addSubview:orderButton];
    [sv setContentSize:CGSizeMake(320, 188+footerViewHeight+80+20)];
    NSLog(@"sv.contentSize:%f,%f,footerViewHeigh:%f", sv.contentSize.width, sv.contentSize.height, footerViewHeight);
}
//埋单 提交数据
- (void)goUpOrder{
    
    UILabel *lab = (UILabel*)[sv viewWithTag:11];
    lab.backgroundColor = [UIColor clearColor];
    //UILabel *lab2 = (UILabel*)[userDataView viewWithTag:12];
    if (lab.text.length==0) {
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:[NSString  stringWithFormat:@"日期不能为空"] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [av show];
       // roomInformationStr=[NSMutableString new];
        return;
    }

    //判断联系人输入内容
    for (int i=1; i<=5; i++) {
        UITextField *file = (UITextField*)[sv viewWithTag:[NSString stringWithFormat:@"10%d",i].intValue];
        file.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        if (file.text.length==0&&i<4) {
            NSString *name = i==1?@"姓名":i==2?@"联系电话":@"电子邮箱";
            UIAlertView *av = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@不能为空",name] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [av show];
            userConnectInformationStr=[NSMutableString new];
            return;
        }
        
    }
    
    NSMutableString *urlStr = RussiaUrl5;
    [urlStr appendString:@"getAddViewOrder"];
    int d = [_RMB intValue]*[zhong.text intValue];
    int r = [_dollar intValue]*[zhong.text intValue];
    // price.text=[NSString stringWithFormat: @"<font size=20 color=orange >￥%d</font><font color=white>（$%d)</font>",d,r];
    NSDateFormatter*form=[NSDateFormatter new];
    form.dateFormat=@"YYYY-MM-dd";
    
#pragma mark  Changed...     把 paytype = %@，paytype改为了 paytype = %d，0
    NSString *argStr = [NSString stringWithFormat:@"viewprodid=%@&userid=%@&username=%@&vdate=%@&vcount=%@&cmoney=%d&umoney=%d&uname=%@&phone=%@&email=%@&qq=%@&weixin=%@&paytype=%d",_ID,GET_USER_DEFAUT(QUSE_ID),GET_USER_DEFAUT(USER_NAME),_checkDate,zhong.text,d,r,[(UITextField*)[footerView viewWithTag:101] text],[(UITextField*)[footerView viewWithTag:102] text],[(UITextField*)[footerView viewWithTag:103] text],[(UITextField*)[footerView viewWithTag:104] text],[(UITextField*)[footerView viewWithTag:105] text],0];

    postRequestYiBu(argStr, urlStr)
    
}
postRequestAgency(datas)
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    dicResultYiBuNoDic(datas, result)
    NSLog(@"result %@",result);
    if (result.intValue>0) {
        OrderViewController *ovc = [OrderViewController sharedOrderViewController];
        ovc.presentWay = 0;
        ovc.prodClass = 2;
        ovc.orderNumber = result;
        ovc.RMB=[NSString stringWithFormat:@"%d", _RMB.intValue*zhong.text.intValue];
        ovc.dollar=[NSString stringWithFormat:@"%d", _dollar.intValue*zhong.text.intValue];
        ovc.selectPayWay=paytype;
        ovc.productDescription=_roomTypeStr;
        ovc.productName=_chineseStr;
        [self.navigationController pushViewController:ovc animated:NO];
    }else if (result.intValue==0){
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"预订失败，请重新预订。" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [av show];
    }else if (result.intValue==-1){
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"已经超出了预订时间，请重新预订。" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [av show];
    }
}
@end
