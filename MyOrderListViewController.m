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
static NSString* identifier = @"cell";
static const int pageSize2 = 10;
int pageindex2 = 1;

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
    self.view.backgroundColor = [UIColor colorWithRed:0.973 green:0.973 blue:0.973 alpha:1];
    self.tableArr = [NSMutableArray array];
    [self.myTableView registerClass:[MyOrderListTableViewCell class] forCellReuseIdentifier:identifier];
    self.pageIndexOne = 1;
    self.pageIndexTwo = 1;
    self.typeId = 1;
    self.aicv = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.aicv.frame = CGRectMake(65+(8-self.title.length)*10, (44- self.aicv.frame.size.height)/2, self.aicv.frame.size.width,  self.aicv.frame.size.height);
    [self.navigationController.navigationBar addSubview: self.aicv];
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    footerView.backgroundColor = [UIColor colorWithRed:0.973 green:0.973 blue:0.973 alpha:1];
    self.aicv2 = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.aicv2.frame = CGRectMake(145, 0, 40,  40);
    [footerView addSubview: self.aicv2];
    self.myTableView.tableFooterView=footerView;
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    [self.myTableView addSubview:self.refreshControl];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadNewData:0];
}

-(void)refreshData {
    [self.refreshControl beginRefreshing];
    [self loadNewData:0];
}

- (void)loadNewData:(NSInteger)index {
    [self.aicv startAnimating];
    NSMutableString *urlStr =RussiaUrl4;
    [urlStr appendString:@"GuidemyOrderList"];
    NSString *argumentStr = [NSMutableString stringWithFormat:@"cityid=2&userid=%@&typeid=%d&pagesize=%d&pageindex=%d",GET_USER_DEFAUT(QUSE_ID),self.typeId,pageSize2,index ];
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
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    if (cell.orderTimeLabHeight > 21) {//若“orderTimaLab”的高度超出，则调整cell的高度
        cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height + cell.orderTimeLabHeight - 21);
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    MyOrderDetailViewController* modVC = [MyOrderDetailViewController new];
    modVC.currentDic = self.tableArr[indexPath.section];
    [self.navigationController pushViewController:modVC animated:NO];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if(!self.aicv2.isAnimating && (scrollView.contentOffset.y > ((scrollView.contentSize.height - scrollView.frame.size.height+10)))) {
        [self.aicv2 startAnimating];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSMutableString *urlStr =RussiaUrl4;
            [urlStr appendString:@"GuidemyOrderList"];
            NSString *argumentStr = [NSMutableString stringWithFormat:@"cityid=2&userid=%@&typeid=%d&pagesize=%d&pageindex=%d",GET_USER_DEFAUT(QUSE_ID),self.typeId,pageSize2,pageindex2 ];
            postRequestTongBu(argumentStr, urlStr, received)
            dicResultTongbu(received, result, dic)
            dispatch_async(dispatch_get_main_queue(), ^{
                [NSThread sleepForTimeInterval:.3];
                if (result.length>11) {
                    if (self.typeId==1) {
                        pageindex2=++self.pageIndexOne;
                        [self.tableArrBtnOne addObjectsFromArray:[dic objectForKey:@"ds"]];
                        self.tableArr = self.tableArrBtnOne;
                    }else{
                        pageindex2=++self.pageIndexTwo;
                        [self.tableArrBtnTwo addObjectsFromArray:[dic objectForKey:@"ds"]];
                        self.tableArr = self.tableArrBtnTwo;
                    }
                    [self.myTableView reloadData];
                }
                [self.aicv2 stopAnimating];
            });
        });
    }
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
