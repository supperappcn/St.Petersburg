//
//  MyTravelingViewController.m
//  St.Petersburg
//
//  Created by li on 14-5-9.
//  Copyright (c) 2014年 Jiayi. All rights reserved.
//

#import "MyTravelingViewController.h"
#import "MyTravelingTableViewCell.h"
#import "GDataXMLNode.h"
#import "JSON.h"
#import "MyTravelingDetailViewController.h"
#import "MyTravellingDetailViewController_2.h"
#import "WriteMyTravellingViewController_3.h"
#import "CommentViewController.h"
#import "TravelViewController_2.h"
#import "TabViewViewController_2.h"


@interface MyTravelingViewController ()
{
    NSInteger pageIndex;
    NSString *tagQ;
}
@end

@implementation MyTravelingViewController

backButton

- (void)viewWillDisappear:(BOOL)animated {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_dataArr];
    if (data.length>255) {
        NSLog(@"length %d",data.length);
        [data writeToFile:PathOfFile(@"MyTravelDatas") options:NSDataWritingAtomic error:nil];
    }
    [aiv removeFromSuperview];
}

-(void)viewDidLoad {
    datas = [NSMutableData data];
    _dataArr= [NSMutableArray array];
    tittleArr = @[@"评论(99)",@"编辑",@"删除"];
    imageNameArr = @[@"travel_say.png",@"travel_pen.png",@"travel_trash.png"];
    
    foolerView = [[UIView alloc]init];
    foolerView.frame = CGRectMake(0, 0, 320, 90);
    foolerLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, 320, 30)];
    foolerLab.backgroundColor = [UIColor clearColor];
    foolerLab.textAlignment =NSTextAlignmentCenter;
    foolerLab.text = @"上拉刷新...";
    [foolerView addSubview:foolerLab];
    
    foolerAiv = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    foolerAiv.frame = CGRectMake(145, 10, 30, 30);
    [foolerView addSubview:foolerAiv];
    
    float height=35;
    UIButton *backbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, (44-height)/2, 40, height)];
    [backbutton addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
    UIImageView*imageView=[[UIImageView alloc]initWithFrame:CGRectMake(-5, 10, 16, 16)];
    imageView.image=[UIImage imageNamed:@"sendtravel"];
    [backbutton addSubview:imageView];
    UILabel*lable=[[UILabel alloc]initWithFrame:CGRectMake(12, 0, 35, 35)];
    lable.font=[UIFont systemFontOfSize:15];
    lable.backgroundColor = [UIColor clearColor];
    lable.textColor=[UIColor whiteColor];
    lable.text=@"发布";[backbutton addSubview:lable];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backbutton];
    self.navigationItem.rightBarButtonItem =backItem;
    
    
    _myTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _myTableView.dataSource = self;
    _myTableView.delegate = self;
    _myTableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    _myTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:_myTableView];
    
    refresh = [[UIRefreshControl alloc]init];
    refresh.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉刷新..."];
    [refresh addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    [_myTableView addSubview:refresh];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self refresh];
    self.title = @"我的游记";
    hideTabbar;

    
    
    if ([[NSData dataWithContentsOfFile:PathOfFile(@"MyTravelDatas") ] length]==0) {
        aiv=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        aiv.frame=CGRectMake(65+(8-4)*10, (44- aiv.frame.size.height)/2, aiv.frame.size.width,  aiv.frame.size.height);
        [aiv startAnimating];
        [self.navigationController.navigationBar addSubview:aiv];

#pragma -mark- Changed...
        pageIndex = 0;

//        NSMutableString *urlStr = RussiaUrl4;
        NSMutableString *urlStr =[NSMutableString stringWithFormat:@"%@",@"http://www.russia-online.cn/api/WebService.asmx/"];
        
        [urlStr appendString:@"getTravelList"];
        
#pragma -mark- Changed...
        //NSString *aruStr = [NSString stringWithFormat:@"cityid=2&userid=%@&pagesize=5&pageindex=%d",GET_USER_DEFAUT(QUSE_ID),0];
        NSString *aruStr = [NSString stringWithFormat:@"title=&cityname=圣彼得堡&userid=%@&pagesize=5&pageindex=%d",GET_USER_DEFAUT(QUSE_ID),pageIndex];
        
        postRequestYiBu(aruStr, urlStr)
    }else {
        NSData *data=[NSData dataWithContentsOfFile:PathOfFile(@"MyTravelDatas") ];
        _dataArr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if (_dataArr.count>4) {
            _myTableView.tableFooterView = foolerView;
        }
    }
    noNetButton=NoNetButton(noNetButton);
    Reachability*rea2 =[Reachability reachabilityWithHostName:@"www.baidu.com"];
    if ([rea2  currentReachabilityStatus]==NotReachable)
    {
        noNetButton.hidden=NO;
    }
    else
    {
        noNetButton.hidden=YES;
    }
}

NetChange(noNetButton)
GO_NET

//static int a = 0 ;
- (void)send{
    WriteMyTravellingViewController_3* wmtVC = [WriteMyTravellingViewController_3 new];
    wmtVC.type = 0;
    [self.navigationController pushViewController:wmtVC animated:NO];
}

postRequestAgency(datas)
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    dicResultYiBu(datas, result, dic)
    [aiv stopAnimating];
    if (result.length>11&&[dic objectForKey:@"ds"]) {
       _dataArr = [dic objectForKey:@"ds"];
        NSLog(@"_dataArr.count == %d",_dataArr.count);
//        [aiv stopAnimating];
       if (_dataArr.count>4) {
            _myTableView.tableFooterView = foolerView;
        }
        [_myTableView reloadData];
    }
    if (_dataArr.count==0) {
        bv = [[UIView alloc]initWithFrame:CGRectMake(0, 80, 320, 120)];
        bv.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self.view addSubview:bv];
        
        UIImageView *star = [[UIImageView alloc]initWithFrame:CGRectMake(130, 0, 71, 71)];
        star.image = [UIImage imageNamed:@"travel_book.png"];
        [bv addSubview:star];
        
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 90, 320, 20)];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.backgroundColor = [UIColor clearColor];
        lab.text =[NSString stringWithFormat:@"您还没有发布过游记"];
        lab.font = [UIFont boldSystemFontOfSize:16.5];
        lab.textColor = [UIColor lightGrayColor];
        [bv addSubview:lab];
    }else {
        [bv removeFromSuperview];
    }
}

- (void)refresh{
    [refresh beginRefreshing];
    
#pragma mark-  Changed...
//    [NSThread sleepForTimeInterval:.5];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
#pragma -mark-  Changed...
//        NSMutableString *urlStr = RussiaUrl4;
//        [urlStr appendString:@"getTravelList"];
//        NSString *aruStr = [NSString stringWithFormat:@"cityid=2&userid=%@&pagesize=5&pageindex=%d",GET_USER_DEFAUT(QUSE_ID),0];
        pageIndex = 0;
        NSMutableString *urlStr =[NSMutableString stringWithFormat:@"%@",@"http://www.russia-online.cn/api/WebService.asmx/"];
        [urlStr appendString:@"getTravelList"];
        NSString *aruStr = [NSString stringWithFormat:@"title=&cityname=圣彼得堡&userid=%@&pagesize=5&pageindex=%d",GET_USER_DEFAUT(QUSE_ID),pageIndex];
        
        postRequestTongBu(aruStr, urlStr, received)
        dicResultTongbu(received, result, dic)
        if (result.length>11&&[dic objectForKey:@"ds"]) {
            _dataArr = [dic objectForKey:@"ds"];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            footerTag=0;
            [refresh endRefreshing];
            [_myTableView reloadData];
            refresh.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉刷新..."];
            return ;
        });
    });
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    if (targetContentOffset->y==-82) [refresh setAttributedTitle:[[NSAttributedString alloc]initWithString:@"加载中..."]];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (_myTableView.tableFooterView&&scrollView.contentOffset.y>scrollView.contentSize.height-_myTableView.frame.size.height+20) {
        [foolerAiv startAnimating];
        foolerLab.text = @"加载中...";
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
#pragma -mark-  Changed...
//            NSMutableString *urlStr = RussiaUrl4;
//            [urlStr appendString:@"getTravelList"];
//            NSString *aruStr = [NSString stringWithFormat:@"cityid=2&userid=%@&pagesize=5&pageindex=%d",GET_USER_DEFAUT(QUSE_ID),++footerTag];
            NSMutableString *urlStr =[NSMutableString stringWithFormat:@"%@",@"http://www.russia-online.cn/api/WebService.asmx/"];
            [urlStr appendString:@"getTravelList"];
            pageIndex ++;
            NSString *aruStr = [NSString stringWithFormat:@"title=&cityname=圣彼得堡&userid=%@&pagesize=5&pageindex=%d",GET_USER_DEFAUT(QUSE_ID),pageIndex];
            
            postRequestTongBu(aruStr, urlStr, received)
            dicResultTongbu(received, result, dic)
            if (_dataArr.count >= 20)
            {
                NSRange range = NSMakeRange(0, 5);
                [_dataArr removeObjectsInRange:range];
            }
            if (result.length>11&&[dic objectForKey:@"ds"]) {
                for (NSDictionary *dic2 in [dic objectForKey:@"ds"]) {
                    [_dataArr addObject:dic2];//接上数据  加上缓存
                }
            }else footerTag--;
            [NSThread sleepForTimeInterval:.5];
            dispatch_async(dispatch_get_main_queue(), ^{
                [foolerAiv stopAnimating];
                [_myTableView reloadData];
                foolerLab.text = @"上拉刷新...";
            });
        });
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"Cell";
    MyTravelingTableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!myCell) {
        myCell = [[MyTravelingTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    for (UIView *v in myCell.contentView.subviews) {
        [v removeFromSuperview];
    }
    if (_dataArr.count>0) {
        UIImageView*headIV=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 100, 75)];
//        headIV.backgroundColor = [UIColor grayColor];
        [myCell.contentView addSubview:headIV];
        UIActivityIndicatorView *headAiv = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        headAiv.frame = CGRectMake(35, 25, 30, 30);
        [headIV addSubview:headAiv];
        UILabel *headLab = [[UILabel alloc]initWithFrame:CGRectMake(115, 0, 200, 50)];
        headLab.backgroundColor = [UIColor clearColor];
        headLab.numberOfLines = 2;
        headLab.font = [UIFont boldSystemFontOfSize:14];
        headLab.text = [[_dataArr objectAtIndex:indexPath.row] objectForKey:@"Title"];
        [myCell.contentView addSubview:headLab];
        
//        NSData *pathData = [NSData dataWithContentsOfFile:PathOfFile(headLab.text)];
        
#pragma -mark- Changed...
//        if ([[[_dataArr objectAtIndex:indexPath.row] objectForKey:@"Pic"] length]>4) {
        [LINE_VIEW_C loadPic_tableViewDataArray:_dataArr objectAtIndex:indexPath.row objectForKey:@"PicUrl" picHeadUrlStr:PicUrlWWW picUrlPathStr:@"SelfManual" PicLoadName:headLab.text headView:headIV];

     /*
        if ([[[_dataArr objectAtIndex:indexPath.row] objectForKey:@"PicUrl"] length]>4) {
            if (pathData.length==0) {
                [headAiv  startAnimating];
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    
#pragma -mark- Changed...
//                    NSString *urlStr = [NSString stringWithFormat:@"%@%@",PicUrlTravel,[[_dataArr objectAtIndex:indexPath.row] objectForKey:@"Pic"]];
                    NSString* picURL = [[_dataArr objectAtIndex:indexPath.row] objectForKey:@"PicUrl"];
                    NSString *urlStr = [NSString stringWithFormat:@"http://www.russia-online.cn/Upload/SelfManual/%@",picURL];
                    
                    
                    NSURL *url = [NSURL URLWithString:urlStr];
                    NSData *data = [NSData dataWithContentsOfURL:url];
                   // [NSThread sleepForTimeInterval:2];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (data) {
                            [data writeToFile:PathOfFile(headLab.text) atomically:YES];
                            headIV.image = [UIImage imageWithData:data];
                            [NSThread sleepForTimeInterval:1];
                            
                        }else headIV.image = [UIImage imageNamed:@"lack.jpg"];
                        [headAiv stopAnimating];
                    });
                });
            }else headIV.image = [UIImage imageWithData:pathData];
        }else  headIV.image = [UIImage imageNamed:@"lack.jpg"];
       */ 
        
        
        UILabel *dateLab = [[UILabel alloc]initWithFrame:CGRectMake(115, 42, 200, 25)];
        dateLab.backgroundColor = [UIColor clearColor];
        dateLab.font = [UIFont systemFontOfSize:13];
        dateLab.textColor = [UIColor grayColor];
        dateLab.text =[[_dataArr objectAtIndex:indexPath.row] objectForKey:@"PTime"];
        [myCell.contentView addSubview:dateLab];
        
        NSString *title = [NSString stringWithFormat:@"评论(%@)",[[_dataArr objectAtIndex:indexPath.row] objectForKey:@"ReyCount"]];//Msgcount
        int isPhone = [[[_dataArr objectAtIndex:indexPath.row] objectForKey:@"IsPhone"]intValue];
        if (isPhone == 1) {//手机端发布的游记 能在手机端修改
            for (int i = 0; i < 3; i++) {
                UIButton *say = [UIButton buttonWithType:UIButtonTypeCustom];
                
                [say setTitle:i==0?title:[tittleArr objectAtIndex:i] forState:UIControlStateNormal];
                say.tag = (indexPath.row + 1)*10 + i;
                [say addTarget:self action:@selector(btnTouch:) forControlEvents:UIControlEventTouchUpInside];
                say.titleLabel.font = [UIFont systemFontOfSize:13];
                [say setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                say.showsTouchWhenHighlighted=YES;
                say.titleLabel.textAlignment = NSTextAlignmentLeft;
                say.frame = i==0?CGRectMake(120, 65, 70, 25):CGRectMake(160+55*i, 65, 30, 25);
                [myCell.contentView addSubview:say];
                
                UIImageView *tittleIV=[[UIImageView alloc]init];
                tittleIV.frame =i==0?CGRectMake(115, 70, 15, 15):CGRectMake(145+55*i, 70, 15, 15);
                tittleIV.image = [UIImage imageNamed:[imageNameArr objectAtIndex:i]];
                tittleIV.backgroundColor = [UIColor blueColor];
                [myCell.contentView addSubview:tittleIV];
            }
        }else {//PC端发布的游记 不能在手机端修改
            for (int i = 0; i < 1; i++) {
                UIButton *say = [UIButton buttonWithType:UIButtonTypeCustom];
                
                [say setTitle:i==0?title:[tittleArr objectAtIndex:2] forState:UIControlStateNormal];
                say.tag = (indexPath.row + 1)*10 + i;
                [say addTarget:self action:@selector(btnTouch:) forControlEvents:UIControlEventTouchUpInside];
                say.titleLabel.font = [UIFont systemFontOfSize:13];
                [say setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                say.showsTouchWhenHighlighted=YES;
                say.titleLabel.textAlignment = NSTextAlignmentLeft;
                say.frame = i==0?CGRectMake(126, 65, 70, 25):CGRectMake(160+55*i, 65, 30, 25);
                [myCell.contentView addSubview:say];
                
                UIImageView *tittleIV=[[UIImageView alloc]init];
                tittleIV.frame =i==0?CGRectMake(115, 70, 15, 15):CGRectMake(145+55*i, 70, 15, 15);
                NSString* imageName = i==0?[imageNameArr objectAtIndex:0]:[imageNameArr objectAtIndex:2];
                tittleIV.image = [UIImage imageNamed:imageName];
                tittleIV.backgroundColor = [UIColor blueColor];
                [myCell.contentView addSubview:tittleIV];
            }
        }
    }
    return myCell;
}

- (void)btnTouch:(UIButton*)btn
{
    NSString *btnTag = [NSString stringWithFormat:@"%d",btn.tag];
    tagQ = [btnTag substringToIndex:btnTag.length - 1];
    NSDictionary* dic1 = [_dataArr objectAtIndex:tagQ.integerValue - 1];
    if ([btn.currentTitle isEqualToString:@"编辑"])
    {
        WriteMyTravellingViewController_3* wmtVC = [WriteMyTravellingViewController_3 new];
        wmtVC.type = 1;
        wmtVC.ID = [[dic1 valueForKey:@"ID"]intValue];
        wmtVC.titleTFText = dic1[@"Title"];
        wmtVC.textViewText = dic1[@"Content"];
        NSString* imageNames = dic1[@"Piclist"];
        if (imageNames.length > 4) {
            if ([imageNames rangeOfString:@","].location != NSNotFound) {
                wmtVC.imageNamesArr = [NSMutableArray arrayWithArray:[imageNames componentsSeparatedByString:@","]];
            }else {
                [wmtVC.imageNamesArr addObject:dic1[@"Piclist"]];
            }
        }else {
            wmtVC.imageNamesArr = nil;
        }
        NSLog(@"imageNames.length:%d,imageNames:%@,imageNamesArr.count:%d,imageNamesArr:%@",imageNames.length,imageNames,wmtVC.imageNamesArr.count, wmtVC.imageNamesArr);
        [self.navigationController pushViewController:wmtVC animated:NO];
    }else if
        ([btn.currentTitle isEqualToString:@"删除"])
    {
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil message:@"亲，真的要删除游记吗？？" delegate:self cancelButtonTitle:@"噢，不" otherButtonTitles:@"是的", nil];
        alertView.tag = 1000;
        [alertView show];
    }else {
        CommentViewController* text = [CommentViewController new];
        text.ID = [dic1 valueForKey:@"ID"];
        [self.navigationController pushViewController:text animated:NO];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSDictionary* dic = [_dataArr objectAtIndex:indexPath.row];
    if ([[dic valueForKey:@"IsPhone"]intValue] == 1)
    {
        TravelViewController_2* travelVC_2 = [TravelViewController_2 new];
        travelVC_2.ID = [[_dataArr[indexPath.row] objectForKey:@"ID"] integerValue];
        travelVC_2.dic = dic;
        travelVC_2.presentWay = 1;
        [self.navigationController pushViewController:travelVC_2 animated:NO];
        
        
    }
    else
    {

        
        TravelViewController_2* travelVC = [TravelViewController_2 new];
        travelVC.ID = [[_dataArr[indexPath.row] objectForKey:@"ID"] integerValue];
        travelVC.presentWay = 0;
        [self.navigationController pushViewController:travelVC animated:NO];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSDictionary* dic1 = [_dataArr objectAtIndex:tagQ.integerValue - 1];

    if (alertView.tag == 1000 && buttonIndex == 0)
    {
        NSLog(@"no");
    }
    else if (alertView.tag == 1000 && buttonIndex == 1)
    {
        NSLog(@"yes");
        NSMutableString *urlStr =[NSMutableString stringWithFormat:@"%@",@"http://www.russia-online.cn/api/WebService.asmx/"];
        [urlStr appendString:@"DeleteTravelInfo"];
        NSString *aruStr = [NSString stringWithFormat:@"userid=%@&id=%@",GET_USER_DEFAUT(QUSE_ID),dic1[@"ID"]];
        postRequestTongBu(aruStr, urlStr, received)
        dicResultTongbuNoDic(received,result)
        if (result.intValue == 1) {
            UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"删除游记成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            alertView.tag = 1001;
            [alertView show];
            }else if (result.intValue == 0) {
            UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"删除游记失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }
    }
    if (alertView.tag == 1001 && buttonIndex == 0)
    {
        [_dataArr removeObjectAtIndex:tagQ.integerValue - 1];
        [_myTableView reloadData];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
