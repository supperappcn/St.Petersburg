//
//  NewsViewController.m
//  St.Petersburg
//
//  Created by 刘 吕琴 on 14-2-19.
//  Copyright (c) 2014年 Jiayi. All rights reserved.
//

#import "NewsViewController.h"

@interface NewsViewController ()

@end

@implementation NewsViewController

backButton

- (void)viewDidLoad
{
    [super viewDidLoad];
    hideTabbar
    self.title = @"消息中心";
    [self addEditButton];
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    dataArray = [NSMutableArray arrayWithArray:[defaults valueForKey:@"currentArray"]];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (dataArray.count == 0) {
        [self addNONewsPic];
    }else {
        [self addTableView];
    }
}

//添加“编辑”按钮
-(void)addEditButton {
    UIButton *backbutton =[UIButton buttonWithType:UIButtonTypeCustom];
    backbutton.frame=CGRectMake(0, 5, 46, 26) ;
    [backbutton addTarget:self action:@selector(setEditing:animated:) forControlEvents:UIControlEventTouchUpInside];
    backbutton.layer.cornerRadius = 4;
    backbutton.layer.masksToBounds = YES;
    backbuttonlable=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, backbutton.frame.size.width, backbutton.frame.size.height)] ;
    backbuttonlable.backgroundColor = [UIColor colorWithRed:0.37 green:0.69 blue:0.95 alpha:1];
    backbuttonlable.text=@"编辑";
    backbuttonlable.textAlignment=NSTextAlignmentCenter;
    backbuttonlable.textColor=[UIColor whiteColor];
    backbuttonlable.font = [UIFont systemFontOfSize:15];
    [backbutton addSubview:backbuttonlable];
    UIImage *imgSelected = [UIImage imageNamed:@"submit.png"];[backbutton setBackgroundImage:[imgSelected stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backbutton] ;
    self.navigationItem.rightBarButtonItem =backItem;
}

//无消息时显示“目前没有推送给您的消息”
-(void)addNONewsPic {
    UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake((DeviceWidth-71)/2, (DeviceWidth-71)/2, 71, 71)];
    imageView.image = [UIImage imageNamed:@"no_news.png"];
    [self.view addSubview:imageView];
    UILabel* lab = [[UILabel alloc]initWithFrame:CGRectMake((DeviceWidth-220)/2, imageView.frame.origin.y+imageView.frame.size.height, 220, 40)];
    lab.text = @"目前没有推送给您的消息";
    lab.textColor = [UIColor grayColor];
    lab.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:lab];
}

-(void)addTableView {
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, -35, 320, DeviceHeight) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];// colorWithRed:248.0/255 green:248.0/255 blue:248.0/255 alpha:1];
    _tableView.separatorColor=[UIColor clearColor];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString*str=@"cell";
    NewsCell*cell=[tableView dequeueReusableCellWithIdentifier:str];
    if (cell==nil) {
        cell=[[NewsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* ID = [[[dataArray objectAtIndex:indexPath.row]valueForKey:@"ID"]stringValue];
    cell.title.text = [[dataArray objectAtIndex:indexPath.row]valueForKey:@"Title"];
    cell.summary.text = [[dataArray objectAtIndex:indexPath.row]valueForKey:@"Summary"];
    CGFloat summaryHeight = cell.summary.optimumSize.height;
    cell.summary.frame = CGRectMake(10, 35,DeviceWidth-10-16-10, summaryHeight);
    NSString* strtime = [[dataArray objectAtIndex:indexPath.row]valueForKey:@"PTime"];
    cell.time.text = [strtime stringByReplacingOccurrencesOfString:@"/" withString:@"."];
    if ([defaults valueForKey:ID]) {
        cell.weidu.hidden = YES;
    }else {
        cell.weidu.hidden = NO;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 87.5;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    NewsCell* cell = (NewsCell*)[tableView cellForRowAtIndexPath:indexPath];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    //      NSMutableArray*dataArray=[defaults valueForKey:@"dataArray"];
    NSString*ID=[[[dataArray objectAtIndex:indexPath.row]valueForKey:@"ID"]stringValue];
    [defaults setBool:YES forKey:ID];
    [defaults synchronize];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    InfomDetailViewController* form = [InfomDetailViewController new];
    form.ID = indexPath.row;
    form.pageName = @"消息中心";
    [self.navigationController pushViewController:form animated:NO];
}

//设置是否可编辑性
-(void)setEditing:(BOOL)editing animated:(BOOL)animated {
    if (self.editing==YES) {
        backbuttonlable.text=@"编辑";
        [super setEditing:NO animated:animated];
        for (int i = 0; i < dataArray.count; i++) {
            NSIndexPath* index = [NSIndexPath indexPathForRow:i inSection:0];
            NewsCell* cell = (NewsCell*)[_tableView cellForRowAtIndexPath:index];
            cell.jianTouIV.frame =CGRectMake(DeviceWidth-16, 35, 16, 16);
            if (cell.weidu.hidden == NO) {
                cell.weidu.frame = CGRectMake(DeviceWidth-40, 63, 30, 15);
            }
            cell.line.frame = CGRectMake(0, 87.5-2, DeviceWidth, 2);
        }
        [_tableView setEditing:NO animated:animated];
    }else {
        backbuttonlable.text=@"完成";
        [super setEditing:YES animated:animated];
        for (int i = 0; i < dataArray.count; i++) {
            NSIndexPath* index = [NSIndexPath indexPathForRow:i inSection:0];
            NewsCell* cell = (NewsCell*)[_tableView cellForRowAtIndexPath:index];
            cell.jianTouIV.frame = CGRectMake(self.view.frame.size.width-53, 35, 16, 16);
            if (cell.weidu.hidden == NO) {
                cell.weidu.frame = CGRectMake(DeviceWidth-40-38, 63, 30, 15);
            }
            cell.line.frame = CGRectMake(0, 87.5-2, self.view.frame.size.width-38, 2);
        }
        [_tableView setEditing:YES animated:animated];
    }
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

//返回编辑样式的方法
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        //对数组的删除
        //对cell的删除
        if (dataArray) {
            [dataArray removeObjectAtIndex:indexPath.row];
        }
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
        NSUserDefaults*defaults=[NSUserDefaults standardUserDefaults];
//      NSMutableArray*dataArray=[defaults valueForKey:@"dataArray"];
//        NSString*ID=[[[dataArray objectAtIndex:indexPath.row]valueForKey:@"ID"]stringValue];
        [defaults removeObjectForKey:@"currentArray"];
        [defaults setObject:dataArray forKey:@"currentArray"];
        [defaults synchronize];
    }
}

-(NSString*)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
