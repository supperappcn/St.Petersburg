//
//  MyOrderListViewController.m
//  St.Petersburg
//
//  Created by kirem-peter on 14-11-18.
//  Copyright (c) 2014年 Jiayi. All rights reserved.
//

#import "MyOrderListViewController.h"
#import "MyOrderListTableViewCell.h"
#import "MyOrderDetailViewController.h"
#import "GDataXMLNode.h"
#import "JSON.h"

static const int pageSize = 10;
int pageindex = 1;
@interface MyOrderListViewController ()
@property (assign, nonatomic) int typeId;
@property (assign, nonatomic) int pageIndexOne;
@property (assign, nonatomic) int pageIndexTwo;
@property (strong, nonatomic) UIActivityIndicatorView* aicv;
@property (strong, nonatomic) UIActivityIndicatorView* aicv2;
@property (strong, nonatomic) UIRefreshControl* refreshControl;
@property (strong, nonatomic) NSMutableData* datas;
@property (strong, nonatomic) NSMutableArray* tableArrBtnOne;//待出游订单
@property (strong, nonatomic) NSMutableArray* tableArrBtnTwo;//已完成订单
@end

@implementation MyOrderListViewController

backButton
static NSString* identifier = @"Cell";
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    hideTabbar
    self.view.backgroundColor = [UIColor colorWithRed:0.847 green:0.847 blue:0.847 alpha:1];
    self.tableArr = [NSMutableArray array];
    [self.myTableView registerClass:[MyOrderListTableViewCell class] forCellReuseIdentifier:identifier];
    self.pageIndexOne = 1;
    self.pageIndexTwo = 1;
    self.typeId = 1;
    self.aicv = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.aicv.frame = CGRectMake(65+(8-self.title.length)*10, (44- self.aicv.frame.size.height)/2, self.aicv.frame.size.width,  self.aicv.frame.size.height);
    [self.navigationController.navigationBar addSubview: self.aicv];
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    footerView.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    self.aicv2 = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.aicv2.frame = CGRectMake(145, 0, 40,  40);
    [footerView addSubview: self.aicv2];
    self.myTableView.tableFooterView=footerView;
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    [self.myTableView addSubview:self.refreshControl];
    
}

-(void)refreshData {
    [self.refreshControl beginRefreshing];
    [self loadNewData:0];
}

- (void)loadNewData:(NSInteger)index {
    [self.aicv startAnimating];
    NSMutableString *urlStr =RussiaUrl4;
    [urlStr appendString:@"GuidemyOrderList"];
    NSString *argumentStr = [NSMutableString stringWithFormat:@"cityid=2&userid=%@&typeid=%d&pagesize=%d&pageindex=%d",GET_USER_DEFAUT(QUSE_ID),self.typeId,pageSize,index ];
    postRequestYiBu(argumentStr, urlStr);
}

postRequestAgency(self.datas)
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    dicResultYiBu(self.datas, result, dic)
    if (result.length>11) {
        if (self.typeId==1) {
            self.tableArr=self.tableArrBtnOne=[dic valueForKey:@"ds"];
            self.pageIndexOne=1;
        }else {
            self.tableArr=self.tableArrBtnTwo = [dic valueForKey:@"ds"];
            self.pageIndexTwo=1;
        }
        //tableArr = [dic valueForKey:@"ds"];
    }else self.tableArr=nil;
    [self.aicv stopAnimating];
    [self.refreshControl endRefreshing];
    [self.myTableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.tableArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 104;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyOrderListTableViewCell* cell = [self.myTableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MyOrderListTableViewCell alloc]init];
    }
    NSDictionary* dic = self.tableArr[indexPath.section];
    [cell setModel:dic];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell.orderTimeLabHeight > 21) {//若“orderTimaLab”的高度超出，则调整cell的高度
        cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height + cell.orderTimeLabHeight - 21);
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MyOrderDetailViewController* modVC = [MyOrderDetailViewController new];
//    modVC.currentDic = ;
    [self.navigationController pushViewController:modVC animated:YES];
}

- (IBAction)selectBtn:(UIButton *)sender {
    if (sender.tag==0) {
        _firstBtn.selected=YES;
        _secondBtn.selected=NO;
    }else if(sender.tag==1){
        _firstBtn.selected=NO;
        _secondBtn.selected=YES;
    }
    if (sender.tag+1!=self.typeId) {
        if (self.typeId==1) {
            self.typeId=2;
        }else self.typeId=1;
        [self loadNewData:0];
    }
}


@end
