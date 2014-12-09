//
//  MyGuideAndCarOrderDetailTableViewCell.m
//  St.Petersburg
//
//  Created by kirem-peter on 14-11-11.
//  Copyright (c) 2014年 Jiayi. All rights reserved.
//

#import "MyGuideAndCarOrderDetailTableViewCell.h"

@implementation MyGuideAndCarOrderDetailTableViewCell

#define IS_IOS_7 [[[UIDevice currentDevice]systemVersion]floatValue]>=7.0

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

-(NSMutableArray*)cellSubviews {
    if (!_cellSubviews) {
        _cellSubviews = [NSMutableArray array];
    }
    return _cellSubviews;
}

-(void)setModel:(NSDictionary *)model {
    _model = model;
    for (UIView* vi in self.cellSubviews) {
        [vi removeFromSuperview];
    }
    [self addcellSubviews:model];
}

-(void)addcellSubviews:(NSDictionary*)currentDic {
    NSArray* payNames = @[@"微信支付",@"支付宝客户端支付",@"支付宝网页支付",@"手机银联支付",@"信用卡支付",@"当面支付"];
    UIFont* font = [UIFont systemFontOfSize:14];
    UIColor* grayColor = [UIColor grayColor];
    UILabel* orderNumTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 70, 21)];
    orderNumTitle.backgroundColor = [UIColor clearColor];
    orderNumTitle.text = @"订单号：";
    orderNumTitle.textColor = grayColor;
    orderNumTitle.font = font;
    [self addSubview:orderNumTitle];
    [self.cellSubviews addObject:orderNumTitle];
    self.orderNumLab = [[UILabel alloc]initWithFrame:CGRectMake(80, 10, 230, 21)];
    self.orderNumLab.backgroundColor = [UIColor clearColor];
    self.orderNumLab.text = currentDic[@"OrderID"];
    self.orderNumLab.font = font;
    [self addSubview:self.orderNumLab];
    [self.cellSubviews addObject:self.orderNumLab];
    UILabel* orderPriceTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, 30, 70, 21)];
    orderPriceTitle.backgroundColor = [UIColor clearColor];
    orderPriceTitle.text = @"订单金额：";
    orderPriceTitle.textColor = grayColor;
    orderPriceTitle.font = font;
    [self addSubview:orderPriceTitle];
    [self.cellSubviews addObject:orderPriceTitle];
    self.orderPriceLab = [[UILabel alloc]initWithFrame:CGRectMake(80, 30, 230, 21)];
    self.orderPriceLab.backgroundColor = [UIColor clearColor];
    NSString *rmb = [NSString stringWithFormat:@"￥%@",[currentDic valueForKey:@"Cmoney"]];//人民币
    NSString *dollor = [NSString stringWithFormat:@"($%@)",[currentDic valueForKey:@"Umoney"]];//美元
    NSString *allStr = [NSString stringWithFormat:@"%@%@",rmb,dollor];
    NSMutableAttributedString *Str = [[NSMutableAttributedString alloc]initWithString:allStr];
    [Str addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:[allStr rangeOfString:rmb]];
    [Str addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:[allStr rangeOfString:dollor]];
    self.orderPriceLab.attributedText = Str;
    self.orderPriceLab.font = font;
    [self addSubview:self.orderPriceLab];
    [self.cellSubviews addObject:self.orderPriceLab];
    UILabel* orderTimeTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, 70, 21)];
    orderTimeTitle.backgroundColor = [UIColor clearColor];
    orderTimeTitle.text = @"下单时间：";
    orderTimeTitle.textColor = grayColor;
    orderTimeTitle.font = font;
    [self addSubview:orderTimeTitle];
    [self.cellSubviews addObject:orderTimeTitle];
    self.orderTimeLab = [[UILabel alloc]initWithFrame:CGRectMake(80, 50, 230, 21)];
    self.orderTimeLab.backgroundColor = [UIColor clearColor];
    self.orderTimeLab.text = currentDic[@"PTime"];
    self.orderTimeLab.font = font;
    [self addSubview:self.orderTimeLab];
    [self.cellSubviews addObject:self.orderTimeLab];
    UILabel* payWayTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, 70, 70, 21)];
    payWayTitle.backgroundColor = [UIColor clearColor];
    payWayTitle.text = @"支付方式：";
    payWayTitle.textColor = grayColor;
    payWayTitle.font = font;
    [self addSubview:payWayTitle];
    [self.cellSubviews addObject:payWayTitle];
    self.payWayLab = [[UILabel alloc]initWithFrame:CGRectMake(80, 70, 230, 21)];
    self.payWayLab.backgroundColor = [UIColor clearColor];
    int wayCount = [[currentDic valueForKey:@"PayType"] intValue];//支付方式
    if (wayCount <= 6) {
        if (wayCount == 0) {
            self.payWayLab.text = @"暂无";
        }else {
            self.payWayLab.text = payNames[wayCount - 1];
        }
    }
    self.payWayLab.font = font;
    [self addSubview:self.payWayLab];
    [self.cellSubviews addObject:self.payWayLab];
    UIImageView* line1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 100, DeviceWidth, 1)];
    line1.image = [UIImage imageNamed:@"links.png"];
    [self addSubview:line1];
    [self.cellSubviews addObject:line1];
    self.headIV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 110, 60, 45)];
    [self addSubview:self.headIV];
    [self.cellSubviews addObject:self.headIV];
    self.titleLab = [[UILabel alloc]initWithFrame:CGRectMake(80, 110, DeviceWidth - 80 - 17, 21)];
    self.titleLab.backgroundColor = [UIColor clearColor];
    NSString* sex = @"";
    NSString* guideName = [currentDic valueForKey:@"GuideName"];
    NSString* guideClass = [currentDic valueForKey:@"GuideClass"];
    if ([[currentDic valueForKey:@"Sex"]intValue] == 1) { //男
        sex = @"男";
    }else if ([[currentDic valueForKey:@"Sex"]intValue] == 2) { //女
        sex = @"女";
    }
    NSString* russiaTitle = [NSString stringWithFormat:@"%@ %@ %@",guideName, sex, guideClass];
    NSMutableAttributedString* russiaStr = [[NSMutableAttributedString alloc]initWithString:russiaTitle];
    [russiaStr addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:[russiaTitle rangeOfString:sex]];
    [russiaStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.047 green:0.345 blue:0.663 alpha:1] range:[russiaTitle rangeOfString:guideClass]];
    self.titleLab.attributedText = russiaStr;
    self.titleLab.font = font;
    [self addSubview:self.titleLab];
    [self.cellSubviews addObject:self.titleLab];
    UIImageView* jianTouIV = [[UIImageView alloc]init];//WithFrame:CGRectMake(DeviceWidth - 16, 124, 16, 16)];
    if (IS_IOS_7) {//iOS7.0及以上的版本
        jianTouIV.frame = CGRectMake(DeviceWidth - 16, 124, 16, 16);
    }else {//iOS7.0以下的版本
        jianTouIV.frame = CGRectMake(DeviceWidth - 21, 124, 16, 16);
    }
    jianTouIV.image = [UIImage imageNamed:@"cellJianTou.png"];
    [self addSubview:jianTouIV];
    [self.cellSubviews addObject:jianTouIV];
    UIImageView* line2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 165, DeviceWidth, 1)];
    line2.image = [UIImage imageNamed:@"links.png"];
    [self addSubview:line2];
    [self.cellSubviews addObject:line2];
    UILabel* selectTimeTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, 175, 70, 21)];
    selectTimeTitle.backgroundColor = [UIColor clearColor];
    selectTimeTitle.text = @"预订日期：";
    selectTimeTitle.textColor = grayColor;
    selectTimeTitle.font = font;
    [self addSubview:selectTimeTitle];
    [self.cellSubviews addObject:selectTimeTitle];
    self.selectTimeLab = [[RTLabel alloc]initWithFrame:CGRectMake(80, 175, DeviceWidth - 80 - 10, 21)];
    self.selectTimeLab.backgroundColor = [UIColor clearColor];
    self.selectTimeLab.text = currentDic[@"Startdate"];
    float selectTimeHeight = self.selectTimeLab.optimumSize.height;
    selectTimeHeight = selectTimeHeight>21?selectTimeHeight:21;
    self.selectTimeLab.frame = CGRectMake(80, 175, DeviceWidth - 80 - 10, selectTimeHeight);
    self.selectTimeLab.textColor = grayColor;
    self.selectTimeLab.font = font;
    [self addSubview:self.selectTimeLab];
    [self.cellSubviews addObject:self.selectTimeLab];
    UILabel* statusTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, 195 + selectTimeHeight - 21, 70, 21)];
    statusTitle.backgroundColor = [UIColor clearColor];
    statusTitle.text = @"订单状态：";
    statusTitle.textColor = grayColor;
    statusTitle.font = font;
    [self addSubview:statusTitle];
    [self.cellSubviews addObject:statusTitle];
    self.statusLab = [[UILabel alloc]initWithFrame:CGRectMake(80, 195 + selectTimeHeight - 21, 160, 21)];
    self.statusLab.backgroundColor = [UIColor clearColor];
    self.statusLab.font = font;
    [self addSubview:self.statusLab];
    [self.cellSubviews addObject:self.statusLab];
    
    self.goBtn = [[UIButton alloc]initWithFrame:CGRectMake(245, 195 + selectTimeHeight - 21, 70, 21)];
    [self.goBtn setTitleColor:[UIColor colorWithRed:0.047 green:0.345 blue:0.663 alpha:1] forState:UIControlStateNormal];
    self.goBtn.titleLabel.font = font;
    self.goBtn.hidden = YES;
    [self addSubview:self.goBtn];
//    [self.cellSubviews addObject:self.cellSubviews];
    
    if ([[currentDic valueForKey:@"ProdType"]intValue] == 1) { //导游
        self.headIV.frame = CGRectMake(10, 110, 60, 90);
        UILabel* languageTitle = [[UILabel alloc]initWithFrame:CGRectMake(80, 130, 40, 20)];
        languageTitle.backgroundColor = [UIColor clearColor];
        languageTitle.text = @"语言：";
        languageTitle.textColor = grayColor;
        languageTitle.font = [UIFont systemFontOfSize:12];
        [self addSubview:languageTitle];
        [self.cellSubviews addObject:languageTitle];
        UILabel* languageLab = [[UILabel alloc]initWithFrame:CGRectMake(120, 130, DeviceWidth - 120 - 17, 20)];
        languageLab.backgroundColor = [UIColor clearColor];
        languageLab.text = currentDic[@"Language"];
        languageLab.font = [UIFont systemFontOfSize:12];
        [self addSubview:languageLab];
        [self.cellSubviews addObject:languageLab];
        UILabel* shanChangTitle = [[UILabel alloc]initWithFrame:CGRectMake(80, 150, 65, 20)];
        shanChangTitle.backgroundColor = [UIColor clearColor];
        shanChangTitle.text = @"擅长讲解：";
        shanChangTitle.textColor = grayColor;
        shanChangTitle.font = [UIFont systemFontOfSize:12];
        [self addSubview:shanChangTitle];
        [self.cellSubviews addObject:shanChangTitle];
        RTLabel* shanChangLab = [[RTLabel alloc]initWithFrame:CGRectMake(145, 152, DeviceWidth - 145 - 17, 20)];
        shanChangLab.backgroundColor = [UIColor clearColor];
        shanChangLab.text = currentDic[@"JiangJie"];
        float shanChangHeight = shanChangLab.optimumSize.height;
        shanChangHeight = shanChangHeight>20?shanChangHeight:20;
        shanChangLab.frame = CGRectMake(145, 152, DeviceWidth - 145 - 17, shanChangHeight);
        shanChangLab.font = [UIFont systemFontOfSize:12];
        [self addSubview:shanChangLab];
        [self.cellSubviews addObject:shanChangLab];
        jianTouIV.frame = CGRectMake(jianTouIV.frame.origin.x, 146, jianTouIV.frame.size.width, jianTouIV.frame.size.height);
        line2.frame = CGRectMake(0, 210, DeviceWidth, 1);
        selectTimeTitle.frame = CGRectMake(10, 220, 70, 21);
        self.selectTimeLab.frame = CGRectMake(80, 220, DeviceWidth - 80 - 10, 21);
        statusTitle.frame = CGRectMake(10, 240, 70, 21);
        self.statusLab.frame = CGRectMake(80, 240, 160, 21);
        self.goBtn.frame = CGRectMake(245, 240, 70, 21);
        
        
    }else if ([[currentDic valueForKey:@"ProdType"]intValue] == 2) { //租车
        self.carInfoLab = [[UILabel alloc]initWithFrame:CGRectMake(80, 130, DeviceWidth - 80 - 17, 20)];
        self.carInfoLab.backgroundColor = [UIColor clearColor];
        self.carInfoLab.text = [NSString stringWithFormat:@"%@人座 %@ %@",currentDic[@"SeatCount"], currentDic[@"CarType"], currentDic[@"JiCheng"]];
        self.carInfoLab.textColor = [UIColor colorWithRed:0.047 green:0.345 blue:0.663 alpha:1];
        self.carInfoLab.font = [UIFont systemFontOfSize:12];
        [self addSubview:self.carInfoLab];
        [self.cellSubviews addObject:self.carInfoLab];
        
    }
    /*
    if ([[currentDic valueForKey:@"Status"]length]>0) {
        //        1待支付, 2待处理, 3预订成功等待出游, 4已失效,
        //        5已完成, 6已取消, 7出游中,         8已点评;
        cell.statusLab.text = [currentDic valueForKey:@"Status"];
        if ([cell.statusLab.text isEqualToString:@"待支付"]) {
            cell.statusLab.textColor = [UIColor redColor];
            [cell.goBtn setTitle:@"去支付" forState:UIControlStateNormal];
            cell.goBtn.hidden = NO;
        }else if ([cell.statusLab.text isEqualToString:@"待处理"]||[cell.statusLab.text isEqualToString:@"预订成功等待出游"]){
            
        }else if ([cell.statusLab.text isEqualToString:@"已完成"]){
            if ([[currentDic valueForKey:@"IsReview"]intValue]==0) {
                [cell.goBtn setTitle:@"去点评" forState:UIControlStateNormal];
                cell.goBtn.hidden = NO;
            }
        }else if ([cell.statusLab.text isEqualToString:@"出游中"]){
            
        }else if ([cell.statusLab.text isEqualToString:@"已失效"]||[cell.statusLab.text isEqualToString:@"已取消"]){
            cell.statusLab.textColor = [UIColor grayColor];
            [cell.goBtn setTitle:@"重新预订" forState:UIControlStateNormal];
            cell.goBtn.hidden = NO;
        }
    }
    */
}

@end
