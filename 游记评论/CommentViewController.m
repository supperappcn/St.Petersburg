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
    NSURLConnection *replyConn;
    NSURLConnection *commentConn;
    NSMutableArray *indexPathArr;
    NSMutableArray *rowHeightArr;
    UIView *footerV;
    UITableView *CommentTV;
    UITextView *CTextView;
    NSMutableData *datas;
    NSMutableArray *DataArr;
    NSInteger pageIndex;
    CGSize Csize;
    NSString *rowsCount;
    UIButton *sendOrReply;
    NSString *replyUserId;
    NSString *replyId;
    NSString *replyName;
    UIRefreshControl *refresh;
    UIView *notCommV;
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
    [self addStartConnection];
    self.title = @"游记评论";
    
}

backButton

- (void)viewDidLoad
{
    hideTabbar
    [super viewDidLoad];
    [self addTableView];
    [self addfooterView];
}

- (void)notComment
{
    notCommV = [[UIView alloc]initWithFrame:CGRectMake(0, DeviceWidth - 64 - 44 - 90, 320, 120)];
    notCommV.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [CommentTV addSubview:notCommV];
    
    UIImageView *star = [[UIImageView alloc]initWithFrame:CGRectMake(124.5, 0, 71, 71)];
    star.image = [UIImage imageNamed:@"coment_noNumber.png"];
    [notCommV addSubview:star];
    
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 90, 320, 20)];
    lab.backgroundColor = [UIColor clearColor];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.text =[NSString stringWithFormat:@"暂无点评，快来点评一下吧~"];
    lab.font = [UIFont boldSystemFontOfSize:17];
    lab.textColor = [UIColor lightGrayColor];
    [notCommV addSubview:lab];
}

- (void)addStartConnection
{
    //this one make a url object
    NSURL *url = [[NSURL alloc]initWithString:@"http://www.russia-online.cn/api/WebService.asmx/getTravelComment"];
//    http://t.russia-online.cn/api/WebService.asmx/getTravelComment
    //then that write a request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSString *str = [NSString stringWithFormat:@"ID=%@&pagesize=10&pageindex=%d",self.ID,pageIndex];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    startConn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
}

- (void)addCommentConnection
{
    NSURL *url = [[NSURL alloc]initWithString:@"http://www.russia-online.cn/api/WebService.asmx/AddTravelComment"];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSString *str = [NSString stringWithFormat:@"ID=%@&rowscount=%d&userid=%@&username=%@&content=%@",self.ID,DataArr.count + 1,GET_USER_DEFAUT(QUSE_ID),GET_USER_DEFAUT(USER_NAME),CTextView.text];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    commentConn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
}

- (void)addReplyConnection
{
    NSURL *url = [[NSURL alloc]initWithString:@"http://www.russia-online.cn/api/WebService.asmx/AddTravelReply "];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSString *str = [NSString stringWithFormat:@"ID=%@&rowscount=%@&userid=%@&username=%@&ruserid=%@&rusername=%@&content=%@",replyId,rowsCount,GET_USER_DEFAUT(QUSE_ID),GET_USER_DEFAUT(USER_NAME),replyUserId,replyName,CTextView.text];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    replyConn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
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
    NSLog(@"resule = %@",resule);
    if (![resule isEqualToString:@"0"])
    {
        [notCommV removeFromSuperview];
        if (connection == startConn)
        {
            DataArr = [dic objectForKey:@"ds"];
            [indexPathArr removeAllObjects];
            [rowHeightArr removeAllObjects];
        }
        else if (connection == commentConn)
        {
            NSArray *arr = [dic objectForKey:@"ds"][0];
            [DataArr addObject:arr];
            [indexPathArr removeAllObjects];
            [rowHeightArr removeAllObjects];
        }
        else if (connection == replyConn)
        {
            NSArray *arr = [dic objectForKey:@"ds"][0];
            NSArray *s_row = [rowsCount componentsSeparatedByString:@"-"];
            if ([DataArr[[s_row[0] integerValue] - 1] objectForKey:@"reply"])
            {
                [[DataArr[[s_row[0] integerValue] - 1] objectForKey:@"reply"] addObject:arr];
            }
            else
            {
                NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:[NSMutableArray arrayWithObjects:arr, nil],@"reply", nil];
                [DataArr[[s_row[0] integerValue] - 1] addEntriesFromDictionary:dict];
            }
        }
        NSLog(@"DataArr = %@",DataArr);
        if (DataArr)
        {
            [CommentTV reloadData];
        }
    }
    else
    {
        if (startConn == connection)
        {
            if (pageIndex == 0)
            {
                [self notComment];
            }
        }
        else if (replyConn == connection)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"回复失败" message:nil delegate:self cancelButtonTitle:@"好的" otherButtonTitles: nil];
            [alert show];
        }
        else if (commentConn == connection)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"评论失败" message:nil delegate:self cancelButtonTitle:@"好的" otherButtonTitles: nil];
            [alert show];
        }
    }
}

- (void)addTableView
{
    DataArr = [[NSMutableArray alloc]init];
    indexPathArr = [[NSMutableArray alloc]init];
    rowHeightArr = [[NSMutableArray alloc]init];
    replyName = [[NSString alloc]init];
    replyUserId = [[NSString alloc]init];
    rowsCount = [[NSString alloc]init];
    pageIndex = 0;
    
    CommentTV = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight - 64 ) style:UITableViewStylePlain];
    [self changeViewFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight - 64 - 44) withView:CommentTV];
    CommentTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    CommentTV.dataSource = self;
    CommentTV.delegate = self;
    CommentTV.backgroundColor=GroupColor;
    [self.view addSubview:CommentTV];
    
    //创建下拉更多
    refresh = [[UIRefreshControl alloc]init];
    refresh.tintColor = [UIColor grayColor];
    [refresh addTarget:self action:@selector(controlEventValueChanged:) forControlEvents:UIControlEventValueChanged];
    [CommentTV addSubview:refresh];
}

- (void)controlEventValueChanged:(id)sender
{
    if (refresh.refreshing)
    {
        refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"刷新中"];
        
        [self performSelector:@selector(refreshData) withObject:nil afterDelay:0.5];
    }
}

- (void)refreshData
{
    pageIndex ++;
    [self addStartConnection];
    [refresh endRefreshing];
    refresh.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉刷新"];
}

- (void)addfooterView
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    footerV = [[UIView alloc] initWithFrame:CGRectMake(-.5, DeviceHeight - 107.5, 321, 44)];
    footerV.backgroundColor=[UIColor colorWithRed:235.0/255 green:235.0/255 blue:241.0/255 alpha:1];
    footerV.layer.borderWidth = .5;
    footerV.layer.borderColor = [UIColor grayColor].CGColor;
    [self.view addSubview:footerV];
    
    CTextView=[[UITextView alloc]initWithFrame:CGRectMake(10, 6.5, 233, 31)];
    CTextView.layer.contents = (id)([UIImage imageNamed:@"travel_reply2.png"].CGImage);
    CTextView.delegate = self;
    CTextView.textAlignment = NSTextAlignmentLeft;
    [footerV addSubview:CTextView];
    
    sendOrReply = [UIButton buttonWithType:UIButtonTypeCustom];
    sendOrReply.frame=CGRectMake(253, 6.5, 57, 31);
    sendOrReply.layer.borderWidth = .3;
    sendOrReply.layer.cornerRadius = 4;
    sendOrReply.layer.borderColor = [UIColor grayColor].CGColor;
    [sendOrReply addTarget:self action:@selector(sendOrReply) forControlEvents:UIControlEventTouchUpInside];
    [sendOrReply setTitle:@"发送" forState:UIControlStateNormal];
    [sendOrReply setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [footerV addSubview:sendOrReply];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddKeyboard)];
    [CommentTV addGestureRecognizer:tap];
}


- (void)hiddKeyboard
{
    [CTextView resignFirstResponder];
}

#pragma -mark 文本开始编辑的时候
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    CTextView.layer.contents = (id)([UIImage imageNamed:@"点评（未）_04.png"].CGImage);
}

#pragma -mark 发送或回复
- (void)sendOrReply
{
    if (GET_USER_DEFAUT(QUSE_ID))
    {
        if (CTextView.text.length)
        {
            if ([sendOrReply.titleLabel.text isEqualToString:@"回复"])
            {
                [self addReplyConnection];
            }
            else if ([sendOrReply.titleLabel.text isEqualToString:@"发送"])
            {
                [self addCommentConnection];
            }
            CTextView.text = @"";
            [sendOrReply setTitle:@"发送" forState:UIControlStateNormal];
            [CTextView resignFirstResponder];
            CTextView.layer.contents = (id)([UIImage imageNamed:@"travel_reply2.png"].CGImage);
        }
        else
        {
            UIAlertView*alertView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"评论不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];[alertView show];
        }
    }
    else
    {
        MineViewController*mine=[MineViewController new];
        mine.tag=1;
        [self.navigationController pushViewController:mine animated:NO];
    }
}

#pragma -mark 弹出键盘
-(void) keyboardWillShow:(NSNotification *)note{
	CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    keyboardBounds = [CommentTV convertRect:keyboardBounds toView:nil];
	CGRect containerFrame = CGRectMake(0, 0, DeviceWidth, DeviceHeight- 20 - 44);
    if ([UIDevice currentDevice].systemVersion.floatValue < 7.0)
    {
        containerFrame = CGRectMake(0, 0, DeviceWidth, DeviceHeight- 64 - 44);
    }
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    CommentTV.frame = CGRectMake(0, 0, containerFrame.size.width, containerFrame.size.height-keyboardBounds.size.height);
    footerV.frame = CGRectMake(-.5, DeviceHeight-keyboardBounds.size.height-107.5, 321, 44);
    
	[UIView commitAnimations];
}

#pragma -mark 收起键盘
-(void) keyboardWillHide:(NSNotification *)note{
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    keyboardBounds = [CommentTV convertRect:keyboardBounds toView:nil];
	CGRect containerFrame = CommentTV.frame;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    CommentTV.frame = CGRectMake(0, 0, containerFrame.size.width, containerFrame.size.height+keyboardBounds.size.height);
    footerV.frame = CGRectMake(-.5, DeviceHeight-107.5, 321, 44);
	[UIView commitAnimations];
    if (CTextView.text.length == 0)
    {
        [sendOrReply setTitle:@"发送" forState:UIControlStateNormal];
        CTextView.layer.contents = (id)
        ([UIImage imageNamed:@"travel_reply2.png"].CGImage);
    }
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
    if (indexPathArr.count > 0)
    {
        if (indexPath.row == 0 && indexPath.section != DataArr.count)
        {
            for (NSInteger i = 0; indexPathArr.count > i; i ++)
            {
                CGFloat rowHeight = 0;
                
                RTLabel *UserL = [[RTLabel alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth - 60 - 40, 0)];
                UserL.font = [UIFont systemFontOfSize:12];
                UserL.text = [NSString stringWithFormat:@"<b><font color='#3299cc'>%@</font><font size=10 color='#a8a8a8'>    %@</font></b>",[DataArr[indexPath.section] valueForKey:@"UserName"],[DataArr[indexPath.section] valueForKey:@"PTime"]];
                UserL.lineSpacing = 1;
                Csize = [UserL optimumSize];
                
                
                if (![indexPathArr containsObject:indexPath])
                {
                    rowHeight = 60;
                }
                else
                {
                    rowHeight = 10.0 + Csize.height +
                    [rowHeightArr[[indexPathArr indexOfObject:indexPath]] floatValue];
                }
                if (rowHeight < 60)
                {
                    rowHeight = 60;
                }

                return rowHeight;
            }
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
            
 
            if (![indexPathArr containsObject:indexPath])
            {
                rowHeight = 60;
            }
            else
            {
                rowHeight = 10.0 + Csize.height +
                [rowHeightArr[[indexPathArr indexOfObject:indexPath]] floatValue];
            }
            if (rowHeight < 60)
            {
                rowHeight = 60;
            }
            return rowHeight;
        }
    }
    return 60;
}

#pragma -mark xml上的链接,通过Safari打开
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
{
    NSURL *requestURL = [request URL];
    if (([[requestURL scheme] isEqualToString: @"http"] || [[requestURL scheme] isEqualToString: @"https"] ||
         [[requestURL scheme] isEqualToString: @"mailto"])
        && ( navigationType == UIWebViewNavigationTypeLinkClicked))
    {
        return ![[UIApplication sharedApplication] openURL: requestURL];
    }
    return YES;
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //字体大小
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '120%'"];
    //字体颜色
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= 'black'"];
    //页面背景色
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background='#F1F1F1'"];

    CGFloat height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue] + 10;
    
    
    NSString *index = [NSString stringWithFormat:@"%d",webView.tag];
    
    if (index.length == 4)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[[index substringFromIndex:1] integerValue] inSection:[[index substringToIndex:1] integerValue] - 1];
        if (![indexPathArr containsObject:indexPath])
        {
            [indexPathArr addObject:indexPath];
            [rowHeightArr addObject:[NSString stringWithFormat:@"%f",height]];
            [CommentTV reloadData];
        }
    }
    if (index.length == 5)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[[index substringFromIndex:2] integerValue] inSection:[[index substringToIndex:2] integerValue] - 1];
        if (![indexPathArr containsObject:indexPath])
        {
            [indexPathArr addObject:indexPath];
            [rowHeightArr addObject:[NSString stringWithFormat:@"%f",height]];
            [CommentTV reloadData];
        }
    }

    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *index = [NSString stringWithFormat:@"%ld-%ld",(long)indexPath.row,(long)indexPath.section];
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
        
        if (![indexPathArr containsObject:indexPath])
        {
            CCell.ContentL.frame = CGRectMake(53,5 + [CCell.UserL optimumSize].height, DeviceWidth - 60 - 40, 20);
        }
        else
        {
            CCell.ContentL.frame = CGRectMake(53,5 + [CCell.UserL optimumSize].height, DeviceWidth - 60 - 40, [rowHeightArr[[indexPathArr indexOfObject:indexPath]] floatValue]);
        }
        
        [CCell.ContentL loadHTMLString:[NSString stringWithFormat:@"<font size=1 color='#010101'>%@</font></b>",[DataArr[indexPath.section] valueForKey:@"Content"]] baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
        CCell.ContentL.tag = (indexPath.section + 1) *1000 + indexPath.row;
        CCell.ContentL.delegate = self;
        CCell.ContentL.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        
        CGFloat replyHeight = [CCell.UserL optimumSize].height + CCell.ContentL.frame.size.height + 10;


        if (replyHeight < 60)
        {
            replyHeight = 60;
        }
        
        CCell.replyB.frame = CGRectMake(DeviceWidth - 40, (replyHeight - 20)/2, 40, 20);
        [CCell.replyB setTitle:@"回复" forState:UIControlStateNormal];
        CCell.replyB.titleLabel.font = [UIFont systemFontOfSize:14];
        [CCell.replyB setTitleColor:[UIColor colorWithRed:50.0/255 green:153.0/255 blue:221.0/255 alpha:1] forState:UIControlStateNormal];
        CCell.replyB.tag = ((indexPath.section + 1) *1000 + indexPath.row) * -1;
        [CCell.replyB addTarget:self action:@selector(cellForReply:) forControlEvents:UIControlEventTouchUpInside];

        

        if (indexPath.section != 0)
        {
            CCell.link.frame = CGRectMake(0, 0, DeviceWidth, 2);
        }
    }
    
    else if (indexPath.section == DataArr.count)
    {
        CCell.replyB.frame = CGRectZero;
        CCell.imgTouX.frame = CGRectZero;
        CCell.UserL.frame = CGRectZero;
        CCell.ContentL.frame = CGRectZero;
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

            if (![indexPathArr containsObject:indexPath])
            {
                CCell.ContentL.frame = CGRectMake(73,5 + [CCell.UserL optimumSize].height, DeviceWidth - 80 - 40, 20);
            }
            else
            {
                CCell.ContentL.frame = CGRectMake(73,5 + [CCell.UserL optimumSize].height, DeviceWidth - 80 - 40, [rowHeightArr[[indexPathArr indexOfObject:indexPath]] floatValue]);
            }
            NSArray *arr = [DataArr[indexPath.section] valueForKey:@"reply"][indexPath.row - 1];
            [CCell.ContentL loadHTMLString:[NSString stringWithFormat:@"<font size=1 color='#010101'>%@</font></b>",[arr valueForKey:@"Contents"]] baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
            CCell.ContentL.tag = (indexPath.section + 1) *1000 + indexPath.row;
            CCell.ContentL.delegate = self;
            CCell.ContentL.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
            
            CGFloat replyHeight = [CCell.UserL optimumSize].height + CCell.ContentL.frame.size.height + 10;
            if (replyHeight < 60)
            {
                replyHeight = 60;
            }
         

            CCell.replyB.frame = CGRectMake(DeviceWidth - 40, (replyHeight - 20)/2, 40, 20);
            [CCell.replyB setTitle:@"回复" forState:UIControlStateNormal];
            CCell.replyB.titleLabel.font = [UIFont systemFontOfSize:14];
            [CCell.replyB setTitleColor:[UIColor colorWithRed:50.0/255 green:153.0/255 blue:221.0/255 alpha:1] forState:UIControlStateNormal];
            CCell.replyB.tag = ((indexPath.section + 1) *1000 + indexPath.row) * -1;
            [CCell.replyB addTarget:self action:@selector(cellForReply:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    CCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return CCell;
}

#pragma - mark 回复
- (void)cellForReply:(UIButton *)sender
{
    [sendOrReply setTitle:@"回复" forState:UIControlStateNormal];
    [CTextView becomeFirstResponder];
    NSInteger section;
    NSInteger row;
    NSString *index = [NSString stringWithFormat:@"%d",sender.tag * -1];
    if (index.length == 4)
    {
        section = [index substringToIndex:1].integerValue;
        row = [index substringFromIndex:1].integerValue;
    }
    if (index.length == 5)
    {
        section = [index substringToIndex:2].integerValue;
        row = [index substringFromIndex:2].integerValue;
    }
    
    if ([DataArr[section - 1] objectForKey:@"reply"])
    {
        NSArray *arr = [DataArr[section - 1] objectForKey:@"reply"];
        rowsCount = [NSString stringWithFormat:@"%d-%d",section,arr.count + 1];
        if (row == 0)
        {
            replyUserId = [DataArr[section - 1] objectForKey:@"UserID"];
            replyName = [DataArr[section - 1] objectForKey:@"UserName"];
        }
        else
        {
            replyUserId = [arr[row - 1] objectForKey:@"UserID"];
            replyName = [arr[row - 1] objectForKey:@"UName"];

        }
        replyId = [DataArr[section - 1] objectForKey:@"ID"];
    }
    else
    {
        rowsCount = [NSString stringWithFormat:@"%d-1",section];
        replyUserId = [DataArr[section - 1] objectForKey:@"UserID"];
        replyName = [DataArr[section - 1] objectForKey:@"UserName"];
        replyId = [DataArr[section - 1] objectForKey:@"ID"];
    }
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
