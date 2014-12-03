//
//  TabViewViewController_2.m
//  St.Petersburg
//
//  Created by kirem-peter on 14-12-3.
//  Copyright (c) 2014年 Jiayi. All rights reserved.
//

#import "TabViewViewController_2.h"

@interface TabViewViewController_2 ()
@property (nonatomic, strong)UIActivityIndicatorView* navActivity;
@property (nonatomic, strong)NSMutableArray* tableArr;
@property (nonatomic, strong)NSMutableArray* topArr;

@end

@implementation TabViewViewController_2

NetChange(noNetButton)
GO_NET
//游记列表和游记置顶URL
#define ListURL [NSMutableString stringWithString:@"http://192.168.0.156:807/api/WebService.asmx/"];
//游记图片URL
#define TravelPicURL [NSMutableString stringWithString:@"http://www.russia-online.cn/Upload/"];
//游记列表中的大图
//#define ListPicURL [NSMutableString stringWithString:@"http://www.russia-online.cn/Upload/SelfManual/"];
//游记列表中的用户头像
//#define ListUserPicURL [NSMutableString stringWithString:@"http://www.russia-online.cn/Upload/Personal/"];
//置顶游记图片URL
//#define ZhiDingURL [NSMutableString stringWithString:@"http://www.russia-online.cn/Upload/SelfManual/big/"];

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
    [self addNavActivity];
    [self addTableView];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(netChange:) name:kReachabilityChangedNotification object:nil];
    
    if ([self.title isEqualToString:@"咨询列表"]) {
        
        
    }else if ([self.title isEqualToString:@"游记列表"]) {
        NSMutableString* urlStr = ListURL;
        
    }
    
    
}

-(void)addNavActivity {
    self.navActivity=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.navActivity.frame=CGRectMake(65+(8-4)*10, (44- self.navActivity.frame.size.height)/2, self.navActivity.frame.size.width,  self.navActivity.frame.size.height);
    [self.navigationController.navigationBar addSubview:self.navActivity];
    [self.navActivity startAnimating];
}

-(void)addTableView {
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"groupTableView.png"]];
    [self.view addSubview:self.tableView];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
}

//若有置顶游记或置顶资讯  添加置顶视图
-(UIView* )addScrollViewAndPageControl {
    UIView* tableHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 180)];
    self.scrollView = [[UIScrollView alloc]initWithFrame:tableHeadView.frame];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    [tableHeadView addSubview:self.scrollView];
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake((self.view.frame.size.width-200)/2+120, self.scrollView.frame.origin.y+self.scrollView.frame.size.height-20, 200, 20)];
    self.pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    self.pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    [tableHeadView addSubview:self.pageControl];
    return tableHeadView;
}

#pragma mark- tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableArr.count;
}
 
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* str = @"cell";
    if ([self.title isEqualToString:@"咨询列表"]) {
        CustomCell2 *cell=[tableView dequeueReusableCellWithIdentifier:str];
        if (cell==nil)
        {
            cell=[[CustomCell2 alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:str];
        }
        
        
        
        return cell;
    }else if ([self.title isEqualToString:@"游记列表"]) {
        CustomCell3 *cell=[tableView dequeueReusableCellWithIdentifier:str];
        if (cell==nil)
        {
            cell=[[CustomCell3 alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:str];
        }
        
        
        
        return cell;
    }else {
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kReachabilityChangedNotification object:nil];
}

@end
