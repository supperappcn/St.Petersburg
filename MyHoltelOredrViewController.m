//
//  MyHoltelOredrViewController.m
//  St.Petersburg
//
//  Created by 刘 吕琴 on 14-7-28.
//  Copyright (c) 2014年 Jiayi. All rights reserved.
//

#import "MyHoltelOredrViewController.h"
#import "MyHotelOrederListTableViewCell.h"
#import "GDataXMLNode.h"
#import "JSON.h"
#import "OrderViewController.h"
#import "MyEntainOrderDetailTableViewController.h"
#import "MyGuideAndCarOrderDetailTableViewCell.h"
#import "EntainReseverClass.h"
#import "EntainDetailViewController.h"//酒店预订  线路预订  景点预订  娱乐门票预订
#import "GuideDetailViewController.h"//导游预订  租车预订

static const int pageSize = 10;
int pageindex = 1;
@interface MyHoltelOredrViewController ()
@property (nonatomic, retain)NSMutableArray* hotelIDs;//LineID、ViewID、HotelID、TicketID、GuideID
@end

@implementation MyHoltelOredrViewController

backButton
static NSString *identifier = @"Cell";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}
- (void)viewDidLoad{
    self.hotelIDs = [NSMutableArray array];
    hideTabbar
    tableArr = [NSMutableArray array];
    pageIndexOne=1;
    pageIndexTwo=1;
    payNames = @[@"微信支付",@"支付宝客户端支付",@"支付宝网页支付",@"手机银联支付",@"信用卡支付",@"当面支付"];
    if ([self.title isEqualToString:@"导游/租车订单"]) {
        picPath=@"guide";
        picName=@"Pic";
        picID=@"GuideID";
        [self.myTableview registerClass:[MyGuideAndCarOrderDetailTableViewCell class] forCellReuseIdentifier:identifier];
    }else {
        if ([self.title isEqualToString:@"线路订单"]) {
            picPath=@"line";
            picName=@"Pic";
            picID=@"LineID";
        }else if ([self.title isEqualToString:@"景点订单"]) {
            picPath=@"view";
            picName=@"ViewPic";
            picID=@"ViewID";
        }else if ([self.title isEqualToString:@"酒店订单"]) {
            picPath=@"hotel";
            picName=@"HotelPic";
            picID=@"HotelID";
        }else if ([self.title isEqualToString:@"娱乐订单"]) {
            picPath=@"ticket";
            picName=@"TicketCName";
            picID=@"TicketID";
        }
        
    }
    typeId=1;
    aicv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    aicv.frame = CGRectMake(65+(8-self.title.length)*10, (44- aicv.frame.size.height)/2, aicv.frame.size.width,  aicv.frame.size.height);
    [self.navigationController.navigationBar addSubview: aicv];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    footerView.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    aicv2 = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    aicv2.frame = CGRectMake(145, 0, 40,  40);
    //[aicv2 startAnimating];
    [footerView addSubview: aicv2];
    _myTableview.tableFooterView=footerView;
    
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    [_myTableview addSubview:refreshControl];
    
    [self loadNewData:0];
}

-(void)viewWillAppear:(BOOL)animated {
    [_myTableview reloadData];
}

- (void)refreshData{
    [refreshControl beginRefreshing];
    [self loadNewData:0];
}
- (void)loadNewData:(NSInteger)index{
    [aicv startAnimating];
    NSMutableString *urlStr =RussiaUrl4;
    if ([self.title isEqualToString:@"线路订单"]) {
        [urlStr appendString:@"LineOrderList"];
    }else if ([self.title isEqualToString:@"景点订单"]) {
        [urlStr appendString:@"ViewOrderList"];
    }else if ([self.title isEqualToString:@"酒店订单"]) {
        [urlStr appendString:@"HotelOrderList"];
    }else if ([self.title isEqualToString:@"娱乐订单"]) {
        [urlStr appendString:@"TicketOrderList"];
    }else if ([self.title isEqualToString:@"导游/租车订单"]) {
        [urlStr appendString:@"GuideOrderList"];
    }
    
    NSString *argumentStr = [NSMutableString stringWithFormat:@"cityid=2&userid=%@&typeid=%d&pagesize=%d&pageindex=%d",GET_USER_DEFAUT(QUSE_ID),typeId,pageSize,index ];
    postRequestYiBu(argumentStr, urlStr);
}

#pragma mark -urlconnectiondelegate-
postRequestAgency(datas)
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    dicResultYiBu(datas, result, dic)
    NSLog(@"dic  %@",dic);
    if (result.length>11) {
        if (typeId==1) {
            tableArr=tableArrBtnOne=[dic valueForKey:@"ds"];
            pageIndexOne=1;
        }else {
            tableArr=tableArrBtnTwo = [dic valueForKey:@"ds"];
            pageIndexTwo=1;
        }
        //tableArr = [dic valueForKey:@"ds"];
    }else tableArr=nil;
    [aicv stopAnimating];
    [refreshControl endRefreshing];
    [_myTableview reloadData];
    [self.hotelIDs removeAllObjects];
    for (NSDictionary* dic in tableArr) {
        NSString* hotelID = @"";
        if ([self.title isEqualToString:@"线路订单"]) {
            hotelID = [dic valueForKey:@"LineID"];
        }else if ([self.title isEqualToString:@"景点订单"]) {
            hotelID = [dic valueForKey:@"ViewID"];
        }else if ([self.title isEqualToString:@"酒店订单"]) {
            hotelID = [dic valueForKey:@"HotelID"];
        }else if ([self.title isEqualToString:@"娱乐订单"]) {
            hotelID = [dic valueForKey:@"TicketID"];
        }else if ([self.title isEqualToString:@"导游/租车订单"]) {
            hotelID = [dic valueForKey:@"GuideID"];
        }
        [self.hotelIDs addObject:hotelID];
    }
}

#pragma mark -tableView-
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.title isEqualToString:@"线路订单"]) {
        MyEntainOrderDetailTableViewController* mlodtvc = [MyEntainOrderDetailTableViewController new];
        mlodtvc.currentDic = tableArr[indexPath.section];
        MyHotelOrederListTableViewCell *cell = (MyHotelOrederListTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
        mlodtvc.headImage = cell.headIV.image;
        mlodtvc.orderPrice = cell.priceLab.attributedText;
        mlodtvc.payStr=cell.payWayLab.text;
        mlodtvc.prodClass = @"1";
        mlodtvc.hotelID = [self.hotelIDs[indexPath.section]intValue];
        [self.navigationController pushViewController:mlodtvc animated:YES];
    }else if ([self.title isEqualToString:@"景点订单"]) {
        MyEntainOrderDetailTableViewController* mvodtvc = [MyEntainOrderDetailTableViewController new];
        mvodtvc.currentDic = tableArr[indexPath.section];
        MyHotelOrederListTableViewCell *cell = (MyHotelOrederListTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
        mvodtvc.headImage = cell.headIV.image;
        mvodtvc.orderPrice = cell.priceLab.attributedText;
        mvodtvc.payStr=cell.payWayLab.text;
        mvodtvc.prodClass = @"2";
        mvodtvc.hotelID = [self.hotelIDs[indexPath.section]intValue];
        [self.navigationController pushViewController:mvodtvc animated:YES];
    }else if ([self.title isEqualToString:@"酒店订单"]) {
        MyEntainOrderDetailTableViewController* mhodtvc = [MyEntainOrderDetailTableViewController new];
        mhodtvc.currentDic = tableArr[indexPath.section];
        MyHotelOrederListTableViewCell *cell = (MyHotelOrederListTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
        mhodtvc.headImage = cell.headIV.image;
        mhodtvc.orderPrice = cell.priceLab.attributedText;
        mhodtvc.payStr=cell.payWayLab.text;
        mhodtvc.prodClass = @"3";
        mhodtvc.hotelID = [self.hotelIDs[indexPath.section]intValue];
        
        /*跳转到之前的酒店订单详情页面
        MyHotelOredeDetailTableViewController *mhdtc = [MyHotelOredeDetailTableViewController new];
        mhdtc.currentDic = tableArr[indexPath.section];
        MyHotelOrederListTableViewCell *cell = (MyHotelOrederListTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
        mhdtc.headImage = cell.headIV.image;
        mhdtc.priceStr=cell.priceLab.attributedText;
        mhdtc.payStr=cell.payWayLab.text;
        mhdtc.subheadStr = cell.subheadLab.text;
        mhdtc.hotelID = [self.hotelIDs[indexPath.section]intValue];
         */
        [self.navigationController pushViewController:mhodtvc animated:YES];
    }else if ([self.title isEqualToString:@"娱乐订单"]) {
        MyEntainOrderDetailTableViewController* mtodtvc = [MyEntainOrderDetailTableViewController new];
        mtodtvc.currentDic = tableArr[indexPath.section];
        MyHotelOrederListTableViewCell *cell = (MyHotelOrederListTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
        mtodtvc.headImage = cell.headIV.image;
        mtodtvc.orderPrice = cell.priceLab.attributedText;
        mtodtvc.payStr=cell.payWayLab.text;
        mtodtvc.prodClass = @"4";
        mtodtvc.hotelID = [self.hotelIDs[indexPath.section]intValue];
        [self.navigationController pushViewController:mtodtvc animated:YES];
    }else if ([self.title isEqualToString:@"导游/租车订单"]) {
        NSDictionary* dic = tableArr[indexPath.section];
        MyEntainOrderDetailTableViewController* mgodtvc = [MyEntainOrderDetailTableViewController new];
        mgodtvc.currentDic = tableArr[indexPath.section];
        MyGuideAndCarOrderDetailTableViewCell *cell = (MyGuideAndCarOrderDetailTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
        mgodtvc.headImage = cell.headIV.image;
        mgodtvc.orderPrice = cell.orderPriceLab.attributedText;
        mgodtvc.payStr=cell.payWayLab.text;
        if ([[dic valueForKey:@"ProdType"]intValue] == 1) {
            mgodtvc.prodClass = @"5";
        }else if ([[dic valueForKey:@"ProdType"]intValue] == 2) {
            mgodtvc.prodClass = @"6";
        }
        mgodtvc.hotelID = [self.hotelIDs[indexPath.section]intValue];
        [self.navigationController pushViewController:mgodtvc animated:YES];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return tableArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *currentDic = tableArr[indexPath.section];
    if ([self.title isEqualToString:@"导游/租车订单"]) {
        MyGuideAndCarOrderDetailTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[MyGuideAndCarOrderDetailTableViewCell alloc]init];
        }
        if (cell.goBtn) {
            [cell.goBtn removeFromSuperview];
        }
        [cell setModel:currentDic];
        [cell.goBtn setTitleColor:[UIColor colorWithRed:0 green:0.58 blue:0.98 alpha:1] forState:UIControlStateNormal];
        cell.goBtn.tag = indexPath.section;
        if ([[currentDic valueForKey:@"Status"]length]>0) {
            //        1待支付, 2待处理, 3预订成功等待出游, 4已失效,
            //        5已完成, 6已取消, 7出游中,         8已点评;
            cell.statusLab.text = [currentDic valueForKey:@"Status"];
            if ([cell.statusLab.text isEqualToString:@"待支付"]) {
                cell.statusLab.textColor = [UIColor redColor];
                [cell.goBtn setTitle:@"去支付" forState:UIControlStateNormal];
                cell.goBtn.hidden = NO;
            }else if ([cell.statusLab.text isEqualToString:@"待处理"]||[cell.statusLab.text isEqualToString:@"预订成功等待出游"]||[cell.statusLab.text isEqualToString:@"已点评"]){
                
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
        if ([[currentDic valueForKey:picName]length]>0) {
            [LINE_VIEW_C loadPic_tableViewDataArray:tableArr objectAtIndex:indexPath.section objectForKey:picName picHeadUrlStr:PicUrl picUrlPathStr:picPath PicLoadName:[currentDic valueForKey:picName] headView:cell.headIV];
        }
        if (cell.goBtn) {
            if (![cell.goBtn isHidden]) {
                [cell.goBtn addTarget:self action:@selector(clickGoBtn:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        
        return cell;
    }else {
        MyHotelOrederListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier ];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MyHotelOrederListTableViewCell" owner:self options:nil] lastObject];
        }
        cell.orderNumLab.text = [currentDic valueForKey:@"OrderID"];//订单号
        
        NSString *rmb = [NSString stringWithFormat:@"￥%@",[currentDic valueForKey:@"Cmoney"]];//人民币
        NSString *dollor = [NSString stringWithFormat:@"($%@)",[currentDic valueForKey:@"Umoney"]];//美元
        NSString *allStr = [NSString stringWithFormat:@"%@%@",rmb,dollor];
        NSMutableAttributedString *Str = [[NSMutableAttributedString alloc]initWithString:allStr];
        [Str addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:[allStr rangeOfString:rmb]];
        [Str addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:[allStr rangeOfString:dollor]];
        cell.priceLab.attributedText = Str;//订单金额
        
        cell.orderTimeLab.text = [currentDic valueForKey:@"PTime"];//下单时间
        
        int wayCount = [[currentDic valueForKey:@"PayType"] intValue];//支付方式
        if (wayCount <= 6) {
            if (wayCount == 0) {
                cell.payWayLab.text = @"暂无";
            }else {
                cell.payWayLab.text = payNames[wayCount - 1];
            }
        }
        cell.goBtn.hidden = YES;
        [cell.goBtn setTitleColor:[UIColor colorWithRed:0 green:0.58 blue:0.98 alpha:1] forState:UIControlStateNormal];
        cell.goBtn.tag = indexPath.section;
        
        
#pragma mark  -differences-
        if ([self.title isEqualToString:@"线路订单"]) {
            cell.russualTitleLab.text = [currentDic valueForKey:@"Title"];//线路标题
            cell.chineseTitleLab.text = [NSString stringWithFormat:@"%@天行程",[currentDic valueForKey:@"LineDays"]];//行程天数
            cell.dateLab.text = @"出发日期";
            cell.checkInLab.text = [currentDic valueForKey:@"Startdate"];//出发日期
            if ([[currentDic valueForKey:@"Status"]length]>0) {
                //        1待支付, 2待处理, 3预订成功等待出游, 4已失效,
                //        5已完成, 6已取消, 7出游中,         8已点评;
                cell.statusLab.text = [currentDic valueForKey:@"Status"];
                if ([cell.statusLab.text isEqualToString:@"待支付"]) {
                    cell.statusLab.textColor = [UIColor redColor];
                    [cell.goBtn setTitle:@"去支付" forState:UIControlStateNormal];
                    cell.goBtn.hidden = NO;
                }else if ([cell.statusLab.text isEqualToString:@"待处理"]||[cell.statusLab.text isEqualToString:@"预订成功等待出游"]||[cell.statusLab.text isEqualToString:@"已点评"]){
                    
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
        }else if ([self.title isEqualToString:@"景点订单"]) {
            cell.russualTitleLab.text = [currentDic valueForKey:@"ViewRUName"];
            cell.chineseTitleLab.text = [currentDic valueForKey:@"ViewCNName"];
            cell.subheadLab.text = [currentDic valueForKey:@"ViewName"];
            cell.dateLab.text = @"出游日期";
            cell.checkInLab.text = [currentDic valueForKey:@"Viewdate"];
            if ([[currentDic valueForKey:@"Status"]length]>0) {
                //        1待支付, 2待处理, 3预订成功等待使用, 4已失效,
                //        5已完成, 6已取消, 7使用中,         8已点评;
                cell.statusLab.text = [currentDic valueForKey:@"Status"];
                if ([cell.statusLab.text isEqualToString:@"待支付"]) {
                    cell.statusLab.textColor = [UIColor redColor];
                    [cell.goBtn setTitle:@"去支付" forState:UIControlStateNormal];
                    cell.goBtn.hidden = NO;
                }else if ([cell.statusLab.text isEqualToString:@"待处理"]||[cell.statusLab.text isEqualToString:@"预订成功等待使用"]||[cell.statusLab.text isEqualToString:@"已点评"]){
                    
                }else if ([cell.statusLab.text isEqualToString:@"已完成"]){
                    if ([[currentDic valueForKey:@"IsReview"]intValue]==0) {
                        [cell.goBtn setTitle:@"去点评" forState:UIControlStateNormal];
                        cell.goBtn.hidden = NO;
                    }
                }else if ([cell.statusLab.text isEqualToString:@"使用中"]){
                    
                }else if ([cell.statusLab.text isEqualToString:@"已失效"]||[cell.statusLab.text isEqualToString:@"已取消"]){
                    cell.statusLab.textColor = [UIColor grayColor];
                    [cell.goBtn setTitle:@"重新预订" forState:UIControlStateNormal];
                    cell.goBtn.hidden = NO;
                }
            }
        }else if ([self.title isEqualToString:@"酒店订单"]) {
            cell.russualTitleLab.text = [currentDic valueForKey:@"HotelRUName"];//俄文名字
            cell.chineseTitleLab.text = [currentDic valueForKey:@"HotelCNName"];//中文名字
            NSString *fittleStr=@"";
            if ([[currentDic valueForKey:@"Ftitle"] length]>0) {
                fittleStr = [NSString stringWithFormat:@"-%@",[currentDic valueForKey:@"Ftitle"]];
            }
            cell.subheadLab.text = [NSString stringWithFormat:@"%@%@",[currentDic valueForKey:@"RoomName"],fittleStr];//房间类型
            cell.dateLab.text = @"入住日期";
            cell.checkInLab.text = [currentDic valueForKey:@"Indate"];//入住日期
            if ([[currentDic valueForKey:@"Status"]length]>0) {
                //        1待支付, 2待处理, 3预订成功, 4已失效,
                //        5已完成, 6已取消, 7待入住,   8入住中,  9已点评;
                cell.statusLab.text = [currentDic valueForKey:@"Status"];
                if ([cell.statusLab.text isEqualToString:@"待支付"]) {
                    cell.statusLab.textColor = [UIColor redColor];
                    [cell.goBtn setTitle:@"去支付" forState:UIControlStateNormal];
                    cell.goBtn.hidden = NO;
                }else if ([cell.statusLab.text isEqualToString:@"待处理"]||[cell.statusLab.text isEqualToString:@"预订成功"]||[cell.statusLab.text isEqualToString:@"已点评"]){
                    
                }else if ([cell.statusLab.text isEqualToString:@"已完成"]){
                    if ([[currentDic valueForKey:@"IsReview"]intValue]==0) {
                        [cell.goBtn setTitle:@"去点评" forState:UIControlStateNormal];
                        cell.goBtn.hidden = NO;
                    }
                }else if ([cell.statusLab.text isEqualToString:@"待入住"]){
                    
                }else if ([cell.statusLab.text isEqualToString:@"入住中"]){
                    
                }else if ([cell.statusLab.text isEqualToString:@"已失效"]||[cell.statusLab.text isEqualToString:@"已取消"]){
                    cell.statusLab.textColor = [UIColor grayColor];
                    [cell.goBtn setTitle:@"重新预订" forState:UIControlStateNormal];
                    cell.goBtn.hidden = NO;
                }
            }
        }else if ([self.title isEqualToString:@"娱乐订单"]) {
            cell.russualTitleLab.text = [currentDic valueForKey:@"TicketRName"];
            cell.dateLab.text = @"预订日期";
            cell.checkInLab.text = [currentDic valueForKey:@"Viewdate"];
            if ([[currentDic valueForKey:@"Status"]length]>0) {
                //        1待支付, 2待处理, 3预订成功等待使用, 4已失效,
                //        5已完成, 6已取消, 7使用中,         8已点评;
                cell.statusLab.text = [currentDic valueForKey:@"Status"];
                if ([cell.statusLab.text isEqualToString:@"待支付"]) {
                    cell.statusLab.textColor = [UIColor redColor];
                    [cell.goBtn setTitle:@"去支付" forState:UIControlStateNormal];
                    cell.goBtn.hidden = NO;
                }else if ([cell.statusLab.text isEqualToString:@"待处理"]||[cell.statusLab.text isEqualToString:@"预订成功等待使用"]||[cell.statusLab.text isEqualToString:@"已点评"]){
                    
                }else if ([cell.statusLab.text isEqualToString:@"已完成"]){
                    if ([[currentDic valueForKey:@"IsReview"]intValue]==0) {
                        [cell.goBtn setTitle:@"去点评" forState:UIControlStateNormal];
                        cell.goBtn.hidden = NO;
                    }
                }else if ([cell.statusLab.text isEqualToString:@"使用中"]){
                    
                }else if ([cell.statusLab.text isEqualToString:@"已失效"]||[cell.statusLab.text isEqualToString:@"已取消"]){
                    cell.statusLab.textColor = [UIColor grayColor];
                    [cell.goBtn setTitle:@"重新预订" forState:UIControlStateNormal];
                    cell.goBtn.hidden = NO;
                }
            }
        }
        if ([[currentDic valueForKey:picName]length]>0) {
            [LINE_VIEW_C loadPic_tableViewDataArray:tableArr objectAtIndex:indexPath.section objectForKey:picName picHeadUrlStr:PicUrl picUrlPathStr:picPath PicLoadName:[currentDic valueForKey:picName] headView:cell.headIV];
        }
        if (![cell.goBtn isHidden]) {
            [cell.goBtn addTarget:self action:@selector(clickGoBtn:) forControlEvents:UIControlEventTouchUpInside];
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *currentDic = tableArr[indexPath.section];
    CGFloat height = 0;
    if ([self.title isEqualToString:@"导游/租车订单"] && [[currentDic valueForKey:@"ProdType"]intValue] == 1) {
        height = 235 + 45;
    }else {
        height = 235;
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{

    //NSLog(@"height:%f contentYoffset:%f frame.y:%f",height,contentYoffset,scrollView.frame.origin.y);
    if(!aicv2.isAnimating && (scrollView.contentOffset.y > ((scrollView.contentSize.height - scrollView.frame.size.height+10))))
        
        
    {
        [aicv2 startAnimating];
        NSLog(@"end of table");
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
           
            NSMutableString *urlStr =RussiaUrl4;
            if ([self.title isEqualToString:@"线路订单"]) {
                [urlStr appendString:@"LineOrderList"];
            }else if ([self.title isEqualToString:@"景点订单"]) {
                [urlStr appendString:@"ViewOrderList"];
            }else if ([self.title isEqualToString:@"酒店订单"]) {
                [urlStr appendString:@"HotelOrderList"];
            }else if ([self.title isEqualToString:@"娱乐订单"]) {
                [urlStr appendString:@"TicketOrderList"];
            }else if ([self.title isEqualToString:@"导游/租车订单"]) {
                [urlStr appendString:@"GuideOrderList"];
            }
            NSString *argumentStr = [NSMutableString stringWithFormat:@"cityid=2&userid=%@&typeid=%d&pagesize=%d&pageindex=%d",GET_USER_DEFAUT(QUSE_ID),typeId,pageSize,pageindex ];
            NSLog(@"%@",argumentStr);
            postRequestTongBu(argumentStr, urlStr, received)
            dicResultTongbu(received, result, dic)
            dispatch_async(dispatch_get_main_queue(), ^{
                [NSThread sleepForTimeInterval:.3];
                if (result.length>11) {
                    if (typeId==1) {
                        pageindex=++pageIndexOne;
                        [tableArrBtnOne addObjectsFromArray:[dic objectForKey:@"ds"]];
                        tableArr = tableArrBtnOne;
                    }else{
                        pageindex=++pageIndexTwo;
                        [tableArrBtnTwo addObjectsFromArray:[dic objectForKey:@"ds"]];
                        tableArr = tableArrBtnTwo;
                    }
                    if (self.hotelIDs.count > 0) {
                        [self.hotelIDs removeAllObjects];
                        for (NSDictionary* dic in tableArr) {
                            NSString* hotelID = @"";
                            if ([self.title isEqualToString:@"线路订单"]) {
                                hotelID = [dic valueForKey:@"LineID"];
                            }else if ([self.title isEqualToString:@"景点订单"]) {
                                hotelID = [dic valueForKey:@"ViewID"];
                            }else if ([self.title isEqualToString:@"酒店订单"]) {
                                hotelID = [dic valueForKey:@"HotelID"];
                            }else if ([self.title isEqualToString:@"娱乐订单"]) {
                                hotelID = [dic valueForKey:@"TicketID"];
                            }else if ([self.title isEqualToString:@"导游/租车订单"]) {
                                hotelID = [dic valueForKey:@"GuideID"];
                            }
                            [self.hotelIDs addObject:hotelID];
                        }
                    }
                    [_myTableview reloadData];
                }
                [aicv2 stopAnimating];
            });
            
        });        
    }
}

-(void)clickGoBtn:(UIButton*)sender {
    if ([[sender titleForState:UIControlStateNormal]isEqualToString:@"去支付"]) {
        OrderViewController* ovc = [OrderViewController sharedOrderViewController];
        ovc.presentWay = 1;
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:sender.tag];
        if ([self.title isEqualToString:@"导游/租车订单"]) {
            MyGuideAndCarOrderDetailTableViewCell* cell = (MyGuideAndCarOrderDetailTableViewCell*)[_myTableview cellForRowAtIndexPath:indexPath];
            ovc.orderNumber = cell.orderNumLab.text;
            if (cell.headIV.frame.size.height == 90) {
                ovc.prodClass = 5;
                ovc.productName = @"导游预订";
                ovc.productDescription = cell.titleLab.text;
            }else if (cell.headIV.frame.size.height == 45) {
                ovc.prodClass = 6;
                ovc.productName = @"租车预订";
                ovc.productDescription = cell.carInfoLab.text;
            }
        }else {
            MyHotelOrederListTableViewCell* cell = (MyHotelOrederListTableViewCell*)[_myTableview cellForRowAtIndexPath:indexPath];
            ovc.orderNumber = cell.orderNumLab.text;
            if ([self.title isEqualToString:@"线路订单"]) {
                ovc.prodClass = 1;
                ovc.productName = cell.russualTitleLab.text;
                NSDictionary* dictionary = tableArr[indexPath.section];
                ovc.productDescription = dictionary[@"LineType"];
            }else if ([self.title isEqualToString:@"景点订单"]) {
                ovc.prodClass = 2;
                ovc.productName = cell.chineseTitleLab.text;
                ovc.productDescription = cell.subheadLab.text;
            }else if ([self.title isEqualToString:@"酒店订单"]) {
                ovc.prodClass = 3;
                ovc.productName = cell.chineseTitleLab.text;
                ovc.productDescription = cell.subheadLab.text;
            }else if ([self.title isEqualToString:@"娱乐订单"]) {
                ovc.prodClass = 4;
                ovc.productName = cell.russualTitleLab.text;
                NSDictionary* dictionary = tableArr[indexPath.section];
                ovc.productDescription = [NSString stringWithFormat:@"%@张", dictionary[@"TCount"]];
            }
        }
        NSLog(@"ovc.presentWay:%d,orderNumber:%@,prodClass:%d,productName:%@,productDescription:%@",ovc.presentWay,ovc.orderNumber,ovc.prodClass,ovc.productName,ovc.productDescription);
        
//        1线路、2景点、3酒店、4门票、5导游、6租车
        [self.navigationController pushViewController:ovc animated:YES];
    }else if ([[sender titleForState:UIControlStateNormal]isEqualToString:@"重新预订"]) {
        if ([self.title isEqualToString:@"线路订单"]) {
            EntainDetailViewController* entainDetailVC = [EntainDetailViewController new];
            entainDetailVC.hotelID = [self.hotelIDs[sender.tag]intValue];
            NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:sender.tag];
            MyHotelOrederListTableViewCell* cell = (MyHotelOrederListTableViewCell*)[_myTableview cellForRowAtIndexPath:indexPath];
            entainDetailVC.fromeImage = cell.headIV.image;
            entainDetailVC.navName = @"线路介绍";
            [self.navigationController pushViewController:entainDetailVC animated:YES];
        }else if ([self.title isEqualToString:@"景点订单"]) {
            EntainDetailViewController* entainDetailVC = [EntainDetailViewController new];
            entainDetailVC.hotelID = [self.hotelIDs[sender.tag]intValue];
            entainDetailVC.classID = 7;
            entainDetailVC.navName = @"景点介绍";
            [self.navigationController pushViewController:entainDetailVC animated:YES];
        }else if ([self.title isEqualToString:@"酒店订单"]) {
            EntainDetailViewController* entainDetailVC = [EntainDetailViewController new];
            entainDetailVC.hotelID = [self.hotelIDs[sender.tag]intValue];
            entainDetailVC.classID = 3;
            entainDetailVC.navName = @"酒店介绍";
            [self.navigationController pushViewController:entainDetailVC animated:YES];
        }else if ([self.title isEqualToString:@"娱乐订单"]) {
            EntainDetailViewController* entainDetailVC = [EntainDetailViewController new];
            entainDetailVC.hotelID = [self.hotelIDs[sender.tag]intValue];
            entainDetailVC.classID = 4;
            entainDetailVC.tag = 1;
            entainDetailVC.navName = @"娱乐介绍";
            [self.navigationController pushViewController:entainDetailVC animated:YES];
        }else if ([self.title isEqualToString:@"导游/租车订单"]) {
            GuideDetailViewController* guideDetailVC = [GuideDetailViewController new];
            guideDetailVC.gudieID = self.hotelIDs[sender.tag];
            NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:sender.tag];
            MyHotelOrederListTableViewCell* cell = (MyHotelOrederListTableViewCell*)[_myTableview cellForRowAtIndexPath:indexPath];
            guideDetailVC.picImage = cell.headIV.image;
            if (cell.headIV.frame.size.height == 90) {
                guideDetailVC.title = @"导游介绍";
            }else if (cell.headIV.frame.size.height == 45) {
                guideDetailVC.title = @"租车介绍";
            }
            [self.navigationController pushViewController:guideDetailVC animated:YES];
        }
    }else if ([[sender titleForState:UIControlStateNormal]isEqualToString:@"去点评"]) {
        if ([self.title isEqualToString:@"线路订单"]) {
            
            
        }else if ([self.title isEqualToString:@"景点订单"]) {
            
            
        }else if ([self.title isEqualToString:@"酒店订单"]) {
            
            
        }else if ([self.title isEqualToString:@"娱乐订单"]) {
            
            
        }else if ([self.title isEqualToString:@"导游/租车订单"]) {
            
            
        }
    }
}

- (IBAction)btnSelect:(UIButton *)sender {
    if (sender.tag==0) {
        _firstBtn.selected=YES;
        _secondBtn.selected=NO;
    }else if(sender.tag==1){
        _firstBtn.selected=NO;
        _secondBtn.selected=YES;
    }
    if (sender.tag+1!=typeId) {
        if (typeId==1) {
            typeId=2;
        }else typeId=1;
        [self loadNewData:0];
    }
}

@end
