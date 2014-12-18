//
//  TabViewViewController_2.m
//  St.Petersburg
//
//  Created by kirem-peter on 14-12-3.
//  Copyright (c) 2014年 Jiayi. All rights reserved.
//

#import "TabViewViewController_2.h"
#import "GDataXMLNode.h"
#import "JSON.h"
#import "TravelViewController_2.h"

@interface TabViewViewController_2 ()
@property (nonatomic, strong)UIActivityIndicatorView* navActivity;
@property (nonatomic, strong)NSMutableArray* tableArr;//列表游记数据
@property (nonatomic, strong)NSMutableArray* topArr;//置顶游记数据
@property (nonatomic, strong)NSMutableArray* listPicArr;//列表中的图片
@property (nonatomic, strong)NSMutableArray* userHeadPicArr;//置顶中的图片
@property (nonatomic, strong)NSMutableArray* searchArr;//搜索数据
@property (nonatomic, strong)NSMutableArray* searchPicArr;//搜索图片
@property (nonatomic, strong)NSMutableArray* searchUserHeadPicArr;//搜索头像
@property (nonatomic, strong)NSMutableData* datas;
@property (nonatomic, strong)UIRefreshControl* refresh;
@property (nonatomic, assign)int pageIndex;
@end

@implementation TabViewViewController_2

NetChange(noNetButton)
GO_NET
backButton
//游记URL
#define ListURL [NSMutableString stringWithString:@"http://192.168.0.156:807/api/WebService.asmx/"];
//游记图片URL
#define TravelPicURL [NSMutableString stringWithString:@"http://www.russia-online.cn/Upload/"];
//游记列表中的图
//#define ListPicURL [NSMutableString stringWithString:@"http://www.russia-online.cn/Upload/SelfManual/"];
//游记列表中的用户头像
//#define ListUserPicURL [NSMutableString stringWithString:@"http://www.russia-online.cn/Upload/Personal/"];
//置顶游记的图
//#define ZhiDingPicURL [NSMutableString stringWithString:@"http://www.russia-online.cn/Upload/SelfManual/big/"];

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    hideTabbar
    self.tableArr = [NSMutableArray array];
    self.topArr = [NSMutableArray array];
    self.listPicArr = [NSMutableArray array];
    self.userHeadPicArr = [NSMutableArray array];
    [self addNavActivity];
    [self addRefreshView];
    [self addSearchButton];
//    [self addSearchBar];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(netChange:) name:kReachabilityChangedNotification object:nil];
    
    if ([self.title isEqualToString:@"资讯列表"]) {
        self.pageIndex = 0;
        {//置顶资讯
            NSMutableString* urlStrTopNews = RussiaUrl2
            [urlStrTopNews appendString:@"getNewsTop"];
            NSString* canShuTopNews = @"cityid=2";
            postRequestYiBu(canShuTopNews, urlStrTopNews);
        }
        {//资讯列表
            NSMutableString* urlStrListNews = RussiaUrl2
            [urlStrListNews appendString:@"getNewsList"];
            NSString* canShuListNews = [NSString stringWithFormat:@"cityid=%d&title=&pagesize=%d&pageindex=%d",2,10,self.pageIndex];
            postRequestYiBu(canShuListNews, urlStrListNews);
        }
        self.pageIndex++;
    }else if ([self.title isEqualToString:@"游记列表"]) {
        self.pageIndex = 0;
        NSMutableString* urlStrList = ListURL
        [urlStrList appendString:@"getTravelList"];
        NSString* canShuList = [NSString stringWithFormat:@"userid=0&cityname=圣彼得堡&title=&pagesize=%d&pageindex=%d",10,self.pageIndex];
        postRequestYiBu(canShuList, urlStrList)
        self.pageIndex++;
    }
    
    
}

-(void)addNavActivity {
    self.navActivity=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.navActivity.frame=CGRectMake(60+(8-4)*10, (44- self.navActivity.frame.size.height)/2, self.navActivity.frame.size.width,  self.navActivity.frame.size.height);
    [self.navigationController.navigationBar addSubview:self.navActivity];
    [self.navActivity startAnimating];
}

//添加tableview
-(void)addTableView {
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"groupTableView.png"]];
    [self.view addSubview:self.tableView];
}

-(void)addRefreshView {
    self.refresh=[[UIRefreshControl alloc]initWithFrame:CGRectMake((self.view.frame.size.width-20)/2, 10, 20, 20)];
    self.refresh.tintColor=[UIColor grayColor];
    self.refresh.attributedTitle=[[NSAttributedString alloc] initWithString:@"刷新中..."];
    [self.refresh addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    self.refresh.hidden = NO;
    [self.tableView addSubview:self.refresh];
}

//添加搜索按钮
-(void)addSearchButton {
    UIButton *backbutton2 = [[UIButton alloc]init] ;
    float height=20;
    backbutton2.frame=CGRectMake(0, (44-height)/2, height, height) ;
    backbutton2.titleLabel.font=[UIFont systemFontOfSize:14];
    [backbutton2 addTarget:self action:@selector(startSearch) forControlEvents:UIControlEventTouchUpInside];
    [backbutton2 setImage:[UIImage imageNamed:@"hotel_search.png"] forState:UIControlStateNormal];
    UIBarButtonItem *backItem2 = [[UIBarButtonItem alloc] initWithCustomView:backbutton2] ;
    self.navigationItem.rightBarButtonItem =backItem2;
}

-(void)addSearchBar {
    self.searchBar = [[UISearchBar alloc]init];//WithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0) {
        self.searchBar.frame = CGRectMake(0, 20, self.view.frame.size.width, 40);
    }else {
        self.searchBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 40);
    }
    self.searchBar.delegate = self;
    self.searchBar.tintColor = [UIColor brownColor];
    self.searchBar.placeholder = @"请输入您要搜索的游记的标题";
    self.searchDisplayC = [[UISearchDisplayController alloc]initWithSearchBar:self.searchBar contentsController:self];
    self.searchDisplayC.searchResultsTableView.backgroundColor = GroupColor;
    self.searchDisplayC.searchResultsTableView.separatorColor = [UIColor clearColor];
    self.searchDisplayC.delegate = self;
}

//开始显示搜索结果视图
-(void)startSearch {
    [self addSearchBar];
    self.searchDisplayC.searchResultsDataSource=self;
    self.searchDisplayC.searchResultsDelegate=self;
    self.navigationController.navigationBar.hidden=YES;
    self.navigationItem.hidesBackButton=YES;
    [self.view addSubview:self.searchBar];
    [self.searchBar becomeFirstResponder];
    self.searchArr = [NSMutableArray array];
    self.searchPicArr = [NSMutableArray array];
    self.searchUserHeadPicArr = [NSMutableArray array];
}


//当搜索框中内容发生变化时搜索
//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if (self.searchArr) {
        [self.searchArr removeAllObjects];
        [self.searchPicArr removeAllObjects];
        [self.searchUserHeadPicArr removeAllObjects];
    }else {
        self.searchArr = [NSMutableArray array];
        self.searchPicArr = [NSMutableArray array];
        self.searchUserHeadPicArr = [NSMutableArray array];
    }
    if ([self.title isEqualToString:@"资讯列表"]) {
        NSMutableString* urlStrSearchNews = RussiaUrl2
        [urlStrSearchNews appendString:@"getNewsList"];
        NSString* canShuListNews = [NSString stringWithFormat:@"cityid=%d&title=%@&pagesize=%d&pageindex=%d",2,self.searchBar.text,10,0];
        postRequestYiBu(canShuListNews, urlStrSearchNews)
    }else if ([self.title isEqualToString:@"游记列表"]) {
        NSMutableString* urlStrSearchTravel = ListURL
        [urlStrSearchTravel appendString:@"getTravelList"];
        NSString* canShuListTravel = [NSString stringWithFormat:@"userid=0&cityname=圣彼得堡&title=%@&pagesize=%d&pageindex=%d",self.searchBar.text,10,0];
        postRequestYiBu(canShuListTravel, urlStrSearchTravel)
    }
}

//点击置顶游记图片
-(void)tapTopImageView:(UITapGestureRecognizer* )tap {
    if ([self.title isEqualToString:@"资讯列表"]) {
        InfomDetailViewController* inform = [InfomDetailViewController new];
        inform.ID = [[self.topArr[tap.view.tag-1] valueForKey:@"ID"] integerValue];
        inform.pageName = @"资讯正文";
        [self.navigationController pushViewController:inform animated:NO];
    }else if ([self.title isEqualToString:@"游记列表"]) {
//        TravelViewController* inform = [TravelViewController new];
        TravelViewController_2* travelVC_2 = [TravelViewController_2 new];
        travelVC_2.ID = [[self.topArr[tap.view.tag-1] valueForKey:@"ID"] integerValue];
        [self.navigationController pushViewController:travelVC_2 animated:NO];
    }
}

//获取置顶图片
-(void)downloadZhiDingPicWithPicPath:(NSString* )ZDpicPath Tag:(int)number {
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//    dispatch_queue_t queue0 = dispatch_queue_create("downloadZhiDing", NULL);
//    dispatch_async(queue0, ^{
        NSData* imageData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:ZDpicPath]];
        UIImage* image = [UIImage imageWithData:imageData];
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImageView* iv = (UIImageView*)[self.scrollView viewWithTag:number];
            iv.image = image;
        });
//    });
}

//获取游记列表中头像
-(void)downloadUserHeadPicWithHeadPicPath:(NSString* )headPicPath UserHeadPicName:(NSString* )userHeadPicName Tag:(int)number {
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//    dispatch_queue_t queue1 = dispatch_queue_create("downloadUserHead", NULL);
//    dispatch_async(queue1, ^{
        NSData* imageData;
        UIImageView* userHeadIV = [[UIImageView alloc]init];
        userHeadIV.tag = number;
        if (userHeadPicName.length > 4) {
             imageData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:headPicPath]];
        }
        if (self.searchBar) {
            [self.searchUserHeadPicArr addObject:userHeadIV];
        }else {
            [self.userHeadPicArr addObject:userHeadIV];
        }
        if (imageData.length > 11) {
            userHeadIV.image = [UIImage imageWithData:imageData];
        }else {
            userHeadIV.image = BACK_IMAGE;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.searchBar) {
                [self.searchDisplayC.searchResultsTableView reloadData];
            }else {
                [self.tableView reloadData];
            }
//            [self.tableView reloadRowsAtIndexPaths:self.tableView.indexPathsForVisibleRows withRowAnimation:UITableViewRowAnimationNone];
        });
//    });
}

//获取游记列表图片
-(void)downloadTravelListPicWithListPicPath:(NSString* )listPicPath PicName:(NSString* )listPicName Tag:(int)number {
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//    dispatch_queue_t queue2 = dispatch_queue_create("downloadList", NULL);
//    dispatch_async(queue2, ^{
        NSData* imageData;
        UIImageView* listIV = [[UIImageView alloc]init];
        listIV.tag = number;
        if (self.searchBar) {
            [self.searchPicArr addObject:listIV];
        }else {
            [self.listPicArr addObject:listIV];
        }
        if (listPicName.length > 4) {
            imageData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:listPicPath]];
        }
        if (imageData.length > 11) {
            listIV.image = [UIImage imageWithData:imageData];
        }else {
            listIV.image = BACK_BIG_IMAGE;
        }
//        NSLog(@"listPicPath:%@,listPicName:%@,number:%d",listPicPath,listPicName,number);
//        NSLog(@"self.listPicArr.count:%d",self.listPicArr.count);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.searchBar) {
                [self.searchDisplayC.searchResultsTableView reloadData];
            }else {
                [self.tableView reloadData];
            }
        });
//    });
}

#pragma mark- NSURLConnectionDelegate
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.datas=[NSMutableData data];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.datas appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"error:%@", error);
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if (self.navActivity.isAnimating) {
        [self.navActivity stopAnimating];
    }
    if (self.refresh.isFirstResponder) {
        [self.refresh endRefreshing];
    }
    dicResultYiBu(self.datas, result, dic)

    NSArray* array = [dic valueForKey:@"ds"];

    if (self.searchBar) {//搜索状态时
        [self.searchArr addObjectsFromArray:array];
        if ([self.title isEqualToString:@"资讯列表"]) {
            if (self.searchArr > 0) {
                [self.searchDisplayC.searchResultsTableView reloadData];
                {//获取搜索时资讯列表图片
                    NSMutableString* listPicStr = PicUrl;
                    [listPicStr appendString:@"news"];
                    dispatch_queue_t queue2 = dispatch_queue_create("downloadList", NULL);
                    dispatch_async(queue2, ^{
                        for (int i = 0; i < self.searchArr.count; i++) {
                            NSString* listPicName = [self.searchArr[i] valueForKey:@"Pic"];
                            NSString* listPicPath = [NSString stringWithFormat:@"%@/%@",listPicStr,listPicName];
                            //[self downloadTravelListPicWithListPicPath:listPicPath Tag:i+1];
                            [self downloadTravelListPicWithListPicPath:listPicPath PicName:listPicName Tag:i+1];
                        }
                    });
                }
            }
        }else if ([self.title isEqualToString:@"游记列表"]) {
            if (self.searchArr > 0) {
                {//获取搜索时游记列表用户头像
                    NSMutableString* userHeadStr = TravelPicURL
                    [userHeadStr appendString:@"Personal"];
                    dispatch_queue_t queue1 = dispatch_queue_create("downloadUserHead", NULL);
                    dispatch_async(queue1, ^{
                        for (int i = 0; i < self.searchArr.count; i++) {
                            NSString* userHeadPicName;
                            if ([self.searchArr[i] valueForKey:@"CompanyID"] == 0) {//个人
                                userHeadPicName = [self.searchArr[i] valueForKey:@"ImgTouX"];
                            }else {//企业
                                userHeadPicName = [self.searchArr[i] valueForKey:@"LogoImage"];
                            }
                            NSString* userHeadPicPath = [NSString stringWithFormat:@"%@/%@",userHeadStr,userHeadPicName];
                            //[self downloadUserHeadPicWithHeadPicPath:userHeadPicPath Tag:i+1];
                            [self downloadUserHeadPicWithHeadPicPath:userHeadPicPath UserHeadPicName:userHeadPicName Tag:i+1];
                        }
                    });
                }
                {//获取搜索时游记列表图片
                    NSMutableString* listPicStr = TravelPicURL;
                    [listPicStr appendString:@"SelfManual"];
                    dispatch_queue_t queue2 = dispatch_queue_create("downloadList", NULL);
                    dispatch_async(queue2, ^{
                        for (int i = 0; i < self.searchArr.count; i++) {
                            NSString* listPicName = [self.searchArr[i] valueForKey:@"PicUrl"];
                            NSString* listPicPath = [NSString stringWithFormat:@"%@/%@",listPicStr,listPicName];
                            //[self downloadTravelListPicWithListPicPath:listPicPath Tag:i+1];
                            [self downloadTravelListPicWithListPicPath:listPicPath PicName:listPicName Tag:i+1];
                        }
                    });
                }
            }
        }
    }else {//非搜索状态时
        if ([self.title isEqualToString:@"资讯列表"]) {
            if (self.userHeadPicArr.count > 0) {
                [self.topArr removeAllObjects];
                [self.tableArr removeAllObjects];
                [self.userHeadPicArr removeAllObjects];
                [self.listPicArr removeAllObjects];
            }
            for (int i = 0; i < array.count; i++) {
                if ([[array[i] valueForKey:@"IsTop"]intValue] == 1) {
                    [self.topArr addObject:array[i]];
                }else if ([[array[i] valueForKey:@"IsTop"]intValue] == 0) {
                    [self.tableArr addObject:array[i]];
                }
            }
            [self addTableView];
            if (self.topArr.count > 0) {//获取资讯置顶图片
                self.tableView.tableHeaderView = [self addScrollViewAndPageControl];
                self.pageControl.numberOfPages = self.topArr.count;
                self.pageControl.currentPage = 0;
                self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width*self.topArr.count, 0);
                NSMutableString* ZhiDingStr = PicUrl;
                [ZhiDingStr appendString:@"news"];
                dispatch_queue_t queue0 = dispatch_queue_create("downloadZhiDing", NULL);
                dispatch_async(queue0, ^{
                    for (int i = 0; i < self.topArr.count; i++) {
                        UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
                        imageView.tag = i+1;
                        imageView.userInteractionEnabled = YES;
                        UITapGestureRecognizer* tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTopImageView:)];
                        [imageView addGestureRecognizer:tapGR];
                        [self.scrollView addSubview:imageView];
                        RTLabel* titleLab=[[RTLabel alloc]initWithFrame:CGRectMake(5, imageView.frame.size.height-20, 200, 20)];
                        titleLab.backgroundColor = [UIColor clearColor];
                        titleLab.text=[self.topArr[i] valueForKey:@"Title"];
                        titleLab.font=[UIFont systemFontOfSize:15];
                        titleLab.textColor=[UIColor whiteColor];
                        [imageView addSubview:titleLab];
                        NSString* picName = [self.topArr[i] valueForKey:@"Pic"];
                        NSString* picPath = [NSString stringWithFormat:@"%@/big/%@",ZhiDingStr,picName];
                        [self downloadZhiDingPicWithPicPath:picPath Tag:imageView.tag];
                    }
                });
            }
            if (self.tableArr.count > 0) {
                {//获取资讯列表图片
                    NSMutableString* listPicStr = PicUrl;
                    [listPicStr appendString:@"news"];
                    dispatch_queue_t queue2 = dispatch_queue_create("downloadList", NULL);
                    dispatch_async(queue2, ^{
                    for (int i = 0; i < self.tableArr.count; i++) {
                        NSString* listPicName = [self.tableArr[i] valueForKey:@"Pic"];
                        NSString* listPicPath = [NSString stringWithFormat:@"%@/%@",listPicStr,listPicName];
//                        NSLog(@"picPath:%@,picName:%@,tag:%d",listPicPath,listPicName,i+1);
                        [self downloadTravelListPicWithListPicPath:listPicPath PicName:listPicName Tag:i+1];
                    }
                    });
                }
            }
        }else if ([self.title isEqualToString:@"游记列表"]) {
            [self.topArr removeAllObjects];
            [self.tableArr removeAllObjects];
            [self.userHeadPicArr removeAllObjects];
            [self.listPicArr removeAllObjects];
            for (int i = 0; i < array.count; i++) {
                if ([[array[i] valueForKey:@"Recom"]intValue] == 1) {
                    [self.topArr addObject:array[i]];//置顶游记的数据
                }else if ([[array[i] valueForKey:@"Recom"]intValue] == 0) {
                    [self.tableArr addObject:array[i]];//非置顶游记的数据
                }
            }
            [self addTableView];
            if (self.topArr.count > 0) {//获取游记置顶图片
                self.tableView.tableHeaderView = [self addScrollViewAndPageControl];
                self.pageControl.numberOfPages = self.topArr.count;
                self.pageControl.currentPage = 0;
                self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width*self.topArr.count, 0);
                NSMutableString* ZhiDingStr = TravelPicURL
                [ZhiDingStr appendString:@"SelfManual"];
                dispatch_queue_t queue0 = dispatch_queue_create("downloadZhiDing", NULL);
                dispatch_async(queue0, ^{
                    for (int i = 0; i < self.topArr.count; i++) {
                        UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
                        imageView.tag = i+1;
                        imageView.userInteractionEnabled = YES;
                        UITapGestureRecognizer* tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTopImageView:)];
                        [imageView addGestureRecognizer:tapGR];
                        [self.scrollView addSubview:imageView];
                        RTLabel* titleLab=[[RTLabel alloc]initWithFrame:CGRectMake(5, imageView.frame.size.height-20, 200, 20)];
                        titleLab.backgroundColor = [UIColor clearColor];
                        titleLab.text=[self.topArr[i] valueForKey:@"Title"];
                        titleLab.font=[UIFont systemFontOfSize:15];
                        titleLab.textColor=[UIColor whiteColor];
                        [imageView addSubview:titleLab];
                        NSString* picName = [self.topArr[i] valueForKey:@"PicUrl"];
                        NSString* picPath = [NSString stringWithFormat:@"%@/big/%@",ZhiDingStr,picName];
                        [self downloadZhiDingPicWithPicPath:picPath Tag:imageView.tag];
                    }
                });
            }
            if (self.tableArr.count > 0) {
                {//获取游记列表用户头像
                    NSMutableString* userHeadStr = TravelPicURL
                    [userHeadStr appendString:@"Personal"];
                    dispatch_queue_t queue1 = dispatch_queue_create("downloadUserHead", NULL);
                    dispatch_async(queue1, ^{
                        for (int i = 0; i < self.tableArr.count; i++) {
                            NSString* userHeadPicName;
                            if ([self.tableArr[i] valueForKey:@"CompanyID"] == 0) {//个人
                                userHeadPicName = [self.tableArr[i] valueForKey:@"ImgTouX"];
                            }else {//企业
                                userHeadPicName = [self.tableArr[i] valueForKey:@"LogoImage"];
                            }
                            NSString* userHeadPicPath = [NSString stringWithFormat:@"%@/%@",userHeadStr,userHeadPicName];
                            //[self downloadUserHeadPicWithHeadPicPath:userHeadPicPath Tag:i+1];
                            [self downloadUserHeadPicWithHeadPicPath:userHeadPicPath UserHeadPicName:userHeadPicName Tag:i+1];
                        }
                    });
                }
                {//获取游记列表图片
                    NSMutableString* listPicStr = TravelPicURL;
                    [listPicStr appendString:@"SelfManual"];
                    dispatch_queue_t queue2 = dispatch_queue_create("downloadList", NULL);
                    dispatch_async(queue2, ^{
                    for (int i = 0; i < self.tableArr.count; i++) {
                        NSString* listPicName = [self.tableArr[i] valueForKey:@"PicUrl"];
                        NSString* listPicPath = [NSString stringWithFormat:@"%@/%@",listPicStr,listPicName];
                        //[self downloadTravelListPicWithListPicPath:listPicPath Tag:i+1];
                        [self downloadTravelListPicWithListPicPath:listPicPath PicName:listPicName Tag:i+1];
                    }
                    });
                }
            }
        }
    }
}

//下拉刷新
-(void)refreshData {
    if ([self.title isEqualToString:@"资讯列表"]) {
        [self.refresh beginRefreshing];
        self.pageIndex = 0;
        [self.userHeadPicArr addObject:@"isRefresh"];//这里给self.userHeadPicArr赋值是为了区分是否是刷新状态
        {//置顶资讯
            NSMutableString* urlStrTopNews = RussiaUrl2
            [urlStrTopNews appendString:@"getNewsTop"];
            NSString* canShuTopNews = @"cityid=2";
            postRequestYiBu(canShuTopNews, urlStrTopNews);
        }
        {//资讯列表
            NSMutableString* urlStrListNews = RussiaUrl2
            [urlStrListNews appendString:@"getNewsList"];
            NSString* canShuListNews = [NSString stringWithFormat:@"cityid=%d&title=&pagesize=%d&pageindex=%d",2,10,self.pageIndex];
            postRequestYiBu(canShuListNews, urlStrListNews);
        }
        self.pageIndex++;
    }else if ([self.title isEqualToString:@"游记列表"]) {
        [self.refresh beginRefreshing];
        self.pageIndex = 0;
        NSMutableString* urlStrList = ListURL
        [urlStrList appendString:@"getTravelList"];
        NSString* canShuList = [NSString stringWithFormat:@"userid=0&cityname=圣彼得堡&title=&pagesize=%d&pageindex=%d",10,self.pageIndex];
        postRequestYiBu(canShuList, urlStrList)
        self.pageIndex++;
    }
}

//若有置顶游记或置顶资讯  添加置顶视图
-(UIView* )addScrollViewAndPageControl {
    UIView* tableHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 180)];
    self.scrollView = [[UIScrollView alloc]initWithFrame:tableHeadView.frame];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    [tableHeadView addSubview:self.scrollView];
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake((self.view.frame.size.width-200)/2+120, self.scrollView.frame.origin.y+self.scrollView.frame.size.height-20, 200, 20)];
    self.pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    self.pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    [tableHeadView addSubview:self.pageControl];
    return tableHeadView;
}

#pragma mark- UISearchDisplayDelegate
- (void) searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller {
    [self.searchBar resignFirstResponder];
    [self.searchBar removeFromSuperview];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    
    
    return YES;
}

#pragma mark- tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        return self.tableArr.count;
    }else if (tableView == self.searchDisplayC.searchResultsTableView) {
        return self.searchArr.count;
    }else {
        return self.tableArr.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* str = @"cell";
    NSMutableArray* tempArr;
    NSMutableArray* tempPicArr;
    NSMutableArray* tempUserHeadArr;
    if ([self.title isEqualToString:@"资讯列表"]) {
        CustomCell2* cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (cell == nil)
        {
            cell = [[CustomCell2 alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:str];
        }
        if (tableView == self.tableView) {
            tempArr = [NSMutableArray arrayWithArray:self.tableArr];
            tempPicArr = [NSMutableArray arrayWithArray:self.listPicArr];
        }else if (tableView == self.searchDisplayC.searchResultsTableView) {
            if (self.searchArr) {
                tempArr = [NSMutableArray arrayWithArray:self.searchArr];
                tempPicArr = [NSMutableArray arrayWithArray:self.searchPicArr];
            }
        }
        if (tempPicArr.count>0)
        {
            if (indexPath.row < tempPicArr.count) {
                UIImageView* iv = tempPicArr[indexPath.row];
                cell._imageView.image = iv.image;
            }
        }
        cell.lableHead.text=[[tempArr objectAtIndex:indexPath.row]valueForKey:@"Title"];
        cell.lableDetail.text=[[tempArr objectAtIndex:indexPath.row]valueForKey:@"Summary"];
        cell.lableDetail.frame=CGRectMake(8+100+5, 30+8, 310-100-15, 30);
        NSString*_str1=[[tempArr objectAtIndex:indexPath.row]valueForKey:@"PTime"];
        _str1=[_str1 stringByReplacingOccurrencesOfRegex:@"/" withString:@"."];
        cell.data.text=_str1;
        UIImageView*jiantou=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 10 - 20, 40, 20, 20)];
        jiantou.image=[UIImage imageNamed:@"cellJianTou.png"];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        return cell;
    }else if ([self.title isEqualToString:@"游记列表"]) {
        CustomCell3* cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (cell == nil)
        {
            cell = [[CustomCell3 alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:str];
        }
        if (tableView == self.tableView) {
            tempArr = [NSMutableArray arrayWithArray:self.tableArr];
            tempPicArr = [NSMutableArray arrayWithArray:self.listPicArr];
            tempUserHeadArr = [NSMutableArray arrayWithArray:self.userHeadPicArr];
        }else if (tableView == self.searchDisplayC.searchResultsTableView) {
            tempArr = [NSMutableArray arrayWithArray:self.searchArr];
            tempPicArr = [NSMutableArray arrayWithArray:self.searchPicArr];
            tempUserHeadArr = [NSMutableArray arrayWithArray:self.searchUserHeadPicArr];            
        }
        cell._imageView.image=[UIImage imageNamed:@"homePic_1.jpg"];
        if (tempPicArr.count>0)
        {
            if (indexPath.row < tempPicArr.count && indexPath.row < tempUserHeadArr.count) {
                UIImageView* iv = tempPicArr[indexPath.row];
                UIImageView* userHeadiv = tempUserHeadArr[indexPath.row];
                cell._imageView.image = iv.image;
                cell.headImage.image = userHeadiv.image;
            }
        }
        cell.lableHead.text = [[tempArr objectAtIndex:indexPath.row]valueForKey:@"Title"];
        CGSize size = [cell.lableHead sizeThatFits:CGSizeMake(195, 0)];
        cell.lableHead.frame = CGRectMake(115,15, 195, size.height);
        if ([[[tempArr objectAtIndex:indexPath.row] valueForKey:@"CompanyID"]intValue] == 0) {//个人
            cell.useName.text = [[tempArr objectAtIndex:indexPath.row]valueForKey:@"UserName"];
        }else {//企业
            if ([[[tempArr objectAtIndex:indexPath.row] valueForKey:@"SimpleName"] length] > 0) {//有简称
                cell.useName.text = [[tempArr objectAtIndex:indexPath.row]valueForKey:@"SimpleName"];
            }else {
                cell.useName.text = [[tempArr objectAtIndex:indexPath.row]valueForKey:@"Name"];
            }
        }
        NSString*_str1 = [[tempArr objectAtIndex:indexPath.row]valueForKey:@"PTime"];
        _str1 = [_str1 stringByReplacingOccurrencesOfString:@"/" withString:@"."];
        cell.data.text = _str1;
        return cell;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }else {
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSMutableArray* tempArr;
    if (tableView == self.tableView) {
        tempArr = [NSMutableArray arrayWithArray:self.tableArr];
    }else {
        tempArr = [NSMutableArray arrayWithArray:self.searchArr];
    }
    if ([self.title isEqualToString:@"资讯列表"]) {
        InfomDetailViewController*inform=[InfomDetailViewController new];
        inform.ID=[[[tempArr objectAtIndex:indexPath.row]valueForKey:@"ID"]intValue];
        inform.pageName = @"资讯正文";
        [self.navigationController pushViewController:inform animated:NO];
    }else if ([self.title isEqualToString:@"游记列表"]) {
//        TravelViewController* inform = [TravelViewController new];
        
        TravelViewController_2* travelVC_2 = [TravelViewController_2 new];
        travelVC_2.ID=[[[tempArr objectAtIndex:indexPath.row]valueForKey:@"ID"]intValue];
        travelVC_2.presentWay = 0;
        [self.navigationController pushViewController:travelVC_2 animated:NO];
    }
}

#pragma mark-  UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.pageControl.currentPage = (scrollView.contentOffset.x/scrollView.frame.size.width);
    self.pageControl.currentPage = floor((scrollView.contentOffset.x - self.scrollView.frame.size.width / 2) / self.scrollView.frame.size.width) + 1;
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView!=self.scrollView) {
        if ([self.title isEqualToString:@"资讯列表"]) {
            if (scrollView.contentOffset.y < self.tableView.frame.origin.y-40) {
                [self refreshData];
            }
            if (scrollView.contentOffset.y > scrollView.contentSize.height-self.tableView.frame.size.height+40) {//上拉加载更多
                self.tableView.tableFooterView = [self addTableFooterView];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSMutableString* urlStrListNews = RussiaUrl2
                    [urlStrListNews appendString:@"getNewsList"];
                    NSString* canShuListNews = [NSString stringWithFormat:@"cityid=%d&title=&pagesize=%d&pageindex=%d",2,10,self.pageIndex];
                    
                    postRequestTongBu(canShuListNews, urlStrListNews, received)
                    dicResultTongbu(received, result, dic)
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (result.length > 11) {
                            NSArray* arr = [dic valueForKey:@"ds"];
                            [self.tableArr addObjectsFromArray:arr];
                            {
                                NSMutableString* listPicStr = PicUrl;
                                [listPicStr appendString:@"news"];
                                dispatch_queue_t queue2 = dispatch_queue_create("downloadList", NULL);
                                dispatch_async(queue2, ^{
                                    for (int i = 0; i < self.tableArr.count; i++) {
                                        NSString* listPicName = [self.tableArr[i] valueForKey:@"Pic"];
                                        NSString* listPicPath = [NSString stringWithFormat:@"%@/%@",listPicStr,listPicName];
                                        //[self downloadTravelListPicWithListPicPath:listPicPath Tag:i+1+self.tableArr.count-arr.count];
                                        [self downloadTravelListPicWithListPicPath:listPicPath PicName:listPicName Tag:i+1+self.tableArr.count-arr.count];
                                    }
                                });
                            }
                            self.pageIndex++;
                            [self.tableView.tableFooterView removeFromSuperview];
                        }
                    });
                });
            }
        }else if ([self.title isEqualToString:@"游记列表"]) {
            if (scrollView.contentOffset.y < self.tableView.frame.origin.y-40) {
                [self refreshData];
            }
            if (scrollView.contentOffset.y > scrollView.contentSize.height-self.tableView.frame.size.height+40) {//上拉加载更多
                self.tableView.tableFooterView = [self addTableFooterView];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSMutableString* urlStrList = ListURL
                    [urlStrList appendString:@"getTravelList"];
                    NSString* canShuList = [NSString stringWithFormat:@"userid=0&cityname=圣彼得堡&title=&pagesize=%d&pageindex=%d",10,self.pageIndex];
                    
                    postRequestTongBu(canShuList, urlStrList, received)
                    dicResultTongbu(received, result, dic)

                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (result.length > 11) {
                            NSArray* arr = [dic valueForKey:@"ds"];
                            [self.tableArr addObjectsFromArray:arr];
                            {
                                NSMutableString* userHeadStr = TravelPicURL
                                [userHeadStr appendString:@"Personal"];
                                dispatch_queue_t queue1 = dispatch_queue_create("downloadUserHead", NULL);
                                dispatch_async(queue1, ^{
                                    for (int i = 0; i < arr.count; i++) {
                                        NSString* userHeadPicName;
                                        if ([arr[i] valueForKey:@"CompanyID"] == 0) {//个人
                                            userHeadPicName = [arr[i] valueForKey:@"ImgTouX"];
                                        }else {//企业
                                            userHeadPicName = [arr[i] valueForKey:@"LogoImage"];
                                        }
                                        NSString* userHeadPicPath = [NSString stringWithFormat:@"%@/%@",userHeadStr,userHeadPicName];
                                        //[self downloadUserHeadPicWithHeadPicPath:userHeadPicPath Tag:i+1+self.tableArr.count-arr.count];
                                        [self downloadUserHeadPicWithHeadPicPath:userHeadPicPath UserHeadPicName:userHeadPicName Tag:i+1+self.tableArr.count-arr.count];
                                    }
                                });
                            }
                            {
                                NSMutableString* listPicStr = TravelPicURL;
                                [listPicStr appendString:@"SelfManual"];
                                dispatch_queue_t queue2 = dispatch_queue_create("downloadList", NULL);
                                dispatch_async(queue2, ^{
                                    for (int i = 0; i < arr.count; i++) {
                                        NSString* listPicName = [arr[i] valueForKey:@"PicUrl"];
                                        NSString* listPicPath = [NSString stringWithFormat:@"%@/%@",listPicStr,listPicName];
                                        //[self downloadTravelListPicWithListPicPath:listPicPath Tag:i+1+self.tableArr.count-arr.count];
                                        [self downloadTravelListPicWithListPicPath:listPicPath PicName:listPicName Tag:i+1+self.tableArr.count-arr.count];
                                    }
                                });
                            }
                            self.pageIndex++;
                            [self.tableView.tableFooterView removeFromSuperview];
                        }
                    });
                });
            }
        }
    }
}

-(UIView* )addTableFooterView {
    UIView* footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    UIActivityIndicatorView* aiv = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    aiv.frame = CGRectMake((self.view.frame.size.width-90)/2, 10, aiv.frame.size.width, aiv.frame.size.height);
    [aiv startAnimating];
    [footerView addSubview:aiv];
    UILabel* lab = [[UILabel alloc]initWithFrame:CGRectMake(aiv.frame.origin.x+20, aiv.frame.origin.y, 70, aiv.frame.size.height)];
    lab.backgroundColor = [UIColor clearColor];
    lab.text = @"加载中...";
    lab.textColor = [UIColor grayColor];
    lab.font = [UIFont systemFontOfSize:14];
    [footerView addSubview:lab];
    return footerView;
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kReachabilityChangedNotification object:nil];
    if ([self.navActivity isAnimating]) {
        [self.navActivity stopAnimating];
        [self.navActivity removeFromSuperview];
    }
}

@end
