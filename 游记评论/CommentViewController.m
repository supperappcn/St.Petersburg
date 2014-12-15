//
//  CommentViewController.m
//  St.Petersburg
//
//  Created by beginner on 14-12-11.
//  Copyright (c) 2014年 Jiayi. All rights reserved.
//

#import "CommentViewController.h"
#import "MessageViewController.h"
#import "CommentCell.h"
#import "GDataXMLNode.h"
#import "JSON.h"


@interface CommentViewController ()
{
    NSURLConnection *startConn;
    UITableView *CommentTV;
    UITextView *CTextView;
    NSMutableData *datas;
    NSMutableArray *DataArr;
    CGSize Csize;
}
@end

@implementation CommentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated
{
    [self addConnection];
    self.title = @"游记评论";
    
}

backButton

- (void)viewDidLoad
{
    hideTabbar
    [super viewDidLoad];
    [self addTableView];
}


- (void)addConnection
{
    //this one make a url object
    NSURL *url = [[NSURL alloc]initWithString:@"http://192.168.0.156:807/api/WebService.asmx/getTravelComment"];
    
    //then that write a request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSString *str = [NSString stringWithFormat:@"ID=62&pagesize=10&pageindex=0"];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    startConn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
}


#pragma -mark 接收数据
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    datas = [[NSMutableData alloc]init];
    [datas appendData:data];
}


#pragma -mark 数据接收完成
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *error = nil;
    GDataXMLDocument *document = [[GDataXMLDocument alloc]initWithData:datas options:0 error:&error];
    GDataXMLElement *element = [document rootElement];
    NSString *resule = [element stringValue];
    
    NSData *data = [resule dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]JSONValue];
    if (connection == startConn)
    {
        DataArr = [dic objectForKey:@"ds"];
    }
    NSLog(@"DataArr = %@",DataArr);
    if (DataArr)
    {
        [CommentTV reloadData];
    }
}
- (void)addTableView
{
    DataArr = [[NSMutableArray alloc]init];
    
    CTextView = [[UITextView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:CTextView];
    
    
    CommentTV = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight - 64) style:UITableViewStylePlain];
    CommentTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    CommentTV.dataSource = self;
    CommentTV.delegate = self;
    CommentTV.backgroundColor=GroupColor;
    [self.view addSubview:CommentTV];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (DataArr.count == 0)
    {
        return 0;
    }
    return DataArr.count + 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section != DataArr.count)
    {
        if ([[DataArr[section] valueForKey:@"reply"] count] > 0 )
        {
            return  [[DataArr[section] valueForKey:@"reply"] count] + 1;
        }
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 && indexPath.section != DataArr.count)
    {
        CGFloat rowHeight = 0;
        
        RTLabel *UserL = [[RTLabel alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth - 60 - 40, 0)];
        UserL.font = [UIFont systemFontOfSize:12];
        UserL.text = [NSString stringWithFormat:@"<b><font color='#3299cc'>%@</font><font size=10 color='#a8a8a8'>    %@</font></b>",[DataArr[indexPath.section] valueForKey:@"UserName"],[DataArr[indexPath.section] valueForKey:@"PTime"]];
        UserL.lineSpacing = 1;
        Csize = [UserL optimumSize];
        rowHeight = 10.0 + Csize.height;
        
        RTLabel *ContentL = [[RTLabel alloc]initWithFrame: CGRectMake(0, 0, DeviceWidth - 60 - 40, 0)];
        ContentL.font = [UIFont systemFontOfSize:12];
        ContentL.text = [NSString stringWithFormat:@"%@",[DataArr[indexPath.section] valueForKey:@"Content"]];
        ContentL.lineSpacing = 5;
        Csize = [ContentL optimumSize];
        rowHeight =rowHeight + Csize.height + 10;
        
        if (rowHeight < 60)
        {
            rowHeight = 60;
        }
        return rowHeight;
    }
    else if (indexPath.section == DataArr.count)
    {
        return 2;
    }
    else
    {
        CGFloat rowHeight = 0;
        NSDictionary * dic = [NSDictionary dictionaryWithDictionary:[DataArr[indexPath.section] valueForKey:@"reply"][0]];
        
        RTLabel *UserL = [[RTLabel alloc]initWithFrame: CGRectMake(0, 0, DeviceWidth - 40 - 80, 0)];
        UserL.frame = CGRectMake(0, 0, DeviceWidth - 40 - 80, 0);
        UserL.font = [UIFont systemFontOfSize:12];
        UserL.text = [NSString stringWithFormat:@"<b><font color='#3299cc'>%@</font><font size=10 color='#a8a8a8'>  回复  </font><font color='#3299cc'>%@</font><font size=10 color='#a8a8a8'>    %@</font></b>",[dic valueForKey:@"UName"],[dic valueForKey:@"ToUserName"],[dic valueForKey:@"RPTime"]];
        UserL.lineSpacing = 1;
        Csize = [UserL optimumSize];
        rowHeight = 10.0 + Csize.height;
        
        RTLabel *ContentL = [[RTLabel alloc]initWithFrame: CGRectMake(0, 0, DeviceWidth - 40 - 80, 0)];
        ContentL.font = [UIFont systemFontOfSize:12];
        ContentL.text = [NSString stringWithFormat:@"%@",[dic valueForKey:@"Contents"]];
        ContentL.lineSpacing = 5;
        Csize = [ContentL optimumSize];
        rowHeight =rowHeight + Csize.height + 10.0;
        
        if (rowHeight < 60)
        {
            rowHeight = 60;
        }
        return 60;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *index = @"commentCell";
    CommentCell *CCell = [tableView dequeueReusableCellWithIdentifier:index];
    if (CCell == nil)
    {
        CCell = [[CommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:index];
    }

    if (indexPath.row == 0 && indexPath.section != DataArr.count)
    {
        CCell.imgTouX.frame = CGRectMake(10, 10, 40, 40);
        [[MessageViewController new] loadDataWithType_ID:@"1" andImgName:[DataArr[indexPath.section] valueForKey:@"ImgTouX"] headView:CCell.imgTouX];
        
        CCell.UserL.frame = CGRectMake(0, 0, DeviceWidth - 60 - 40, 0);
        CCell.UserL.font = [UIFont systemFontOfSize:12];
        CCell.UserL.text = [NSString stringWithFormat:@"<b><font color='#3299cc'>%@</font><font size=10 color='#a8a8a8'>    %@</font></b>",[DataArr[indexPath.section] valueForKey:@"UserName"],[DataArr[indexPath.section] valueForKey:@"PTime"]];
        CCell.UserL.lineSpacing = 1;
        Csize = [CCell.UserL optimumSize];
        CCell.UserL.frame = CGRectMake(60, 10, Csize.width, Csize.height);
        
        CCell.ContentL.frame = CGRectMake(0, 0, DeviceWidth - 60 - 40, 0);
        CCell.ContentL.font = [UIFont systemFontOfSize:12];
        CCell.ContentL.text = [NSString stringWithFormat:@"%@",[DataArr[indexPath.section] valueForKey:@"Content"]];
        CCell.ContentL.lineSpacing = 5;
        Csize = [CCell.ContentL optimumSize];
        CCell.ContentL.frame = CGRectMake(60,CCell.UserL.frame.size.height + 15, Csize.width, Csize.height);
        
        CGFloat replyHeight = [CCell.UserL optimumSize].height + [CCell.ContentL optimumSize].height;
        if (replyHeight < 40)
        {
            replyHeight = 40;
        }
        
        CCell.replyB.frame = CGRectMake(DeviceWidth - 40, (replyHeight)/2, 40, 20);
        CCell.replyB.tag = [[NSString stringWithFormat:@"dsa"] integerValue];
        [CCell.replyB setTitle:@"回复" forState:UIControlStateNormal];
        CCell.replyB.titleLabel.font = [UIFont systemFontOfSize:14];
        [CCell.replyB setTitleColor:[UIColor colorWithRed:50.0/255 green:153.0/255 blue:221.0/255 alpha:1] forState:UIControlStateNormal];
        

        
        if (indexPath.section != 0)
        {
            CCell.link.frame = CGRectMake(0, 0, DeviceWidth, 2);
        }
    }
    else if (indexPath.section == DataArr.count)
    {
        CCell.link.frame = CGRectMake(0, 0, DeviceWidth, 2);
    }
    else
    {
        if ([[DataArr[indexPath.section] valueForKey:@"reply"] count]>0)
        {
            CCell.link.frame = CGRectMake(20, 0, DeviceWidth - 20, 2);
            CCell.imgTouX.frame = CGRectMake(30, 10, 40, 40);
            [[MessageViewController new] loadDataWithType_ID:@"1" andImgName:[[[DataArr[indexPath.section] valueForKey:@"reply"] objectAtIndex:indexPath.row - 1] valueForKey:@"Headimg"]headView:CCell.imgTouX];
            
            NSDictionary * dic = [NSDictionary dictionaryWithDictionary:[DataArr[indexPath.section] valueForKey:@"reply"][0]];
            
            CCell.UserL.frame = CGRectMake(0, 0, DeviceWidth - 40 - 80, 0);
            CCell.UserL.font = [UIFont systemFontOfSize:12];
            CCell.UserL.text = [NSString stringWithFormat:@"<b><font color='#3299cc'>%@</font><font size=10 color='#a8a8a8'>  回复  </font><font color='#3299cc'>%@</font><font size=10 color='#a8a8a8'>    %@</font></b>",[dic valueForKey:@"UName"],[dic valueForKey:@"ToUserName"],[dic valueForKey:@"RPTime"]];
            CCell.UserL.lineSpacing = 1;
            Csize = [CCell.UserL optimumSize];
            CCell.UserL.frame = CGRectMake(80, 10, Csize.width, Csize.height);
            
            CCell.ContentL.frame = CGRectMake(0, 0, DeviceWidth - 40 - 80, 0);
            CCell.ContentL.font = [UIFont systemFontOfSize:12];
            CCell.ContentL.text = [NSString stringWithFormat:@"%@",[dic valueForKey:@"Contents"]];
            CCell.ContentL.lineSpacing = 5;
            Csize = [CCell.ContentL optimumSize];
            CCell.ContentL.frame = CGRectMake(80,CCell.UserL.frame.size.height + 15, Csize.width, Csize.height);
            
            CCell.replyB.frame = CGRectMake(DeviceWidth - 40, (([CCell.UserL optimumSize].height + [CCell.ContentL optimumSize].height))/2, 40, 20);
            [CCell.replyB setTitle:@"回复" forState:UIControlStateNormal];
            CCell.replyB.titleLabel.font = [UIFont systemFontOfSize:14];
            [CCell.replyB setTitleColor:[UIColor colorWithRed:50.0/255 green:153.0/255 blue:221.0/255 alpha:1] forState:UIControlStateNormal];
        }
    }
    
    CCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return CCell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
