//
//  TravelViewController_2.m
//  St.Petersburg
//
//  Created by kirem-peter on 14-12-11.
//  Copyright (c) 2014年 Jiayi. All rights reserved.
//

#import "TravelViewController_2.h"
#import "GDataXMLNode.h"
#import "JSON.h"
#import "CommentViewController.h"

@interface TravelViewController_2 ()<NSURLConnectionDataDelegate,UITextViewDelegate,UIAlertViewDelegate,UIWebViewDelegate>
@property (nonatomic, strong)UIActivityIndicatorView* naviActivity;
@property (nonatomic, strong)UIScrollView* scrollView;
@property (nonatomic, strong)UIWebView* webView;
@property (nonatomic, strong)NSURLConnection* checkLike;
@property (nonatomic, strong)NSURLConnection* checkCollect;
@property (nonatomic, strong)NSURLConnection* unLike;
@property (nonatomic, strong)NSURLConnection* unCollect;
@property (nonatomic, strong)NSURLConnection* like;
@property (nonatomic, strong)NSURLConnection* collect;
@property (nonatomic, strong)NSURLConnection* webViewConnection;
@property (nonatomic, strong)NSDictionary* dic;
@property (nonatomic, strong)NSMutableData* datas;
@property (nonatomic, assign)BOOL ISLike;
@property (nonatomic, assign)BOOL ISCollect;

@end

@implementation TravelViewController_2

backButton
#define TravelURL [NSMutableString stringWithString:@"http://192.168.0.156:807/api/WebService.asmx/"];
#define USERID [[NSUserDefaults standardUserDefaults] integerForKey:@"QuseID"];

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
    self.title = @"游记正文";
    self.ISLike = NO;
    self.ISCollect = NO;
    [self addNaviActivityView];
    [self addScrollView];
    [self addFooterBar];
    [self checkLikeMethod];
    [self checkCollectMethod];
    [self loadWebViewData];
    
}

-(void)addNaviActivityView {
    self.naviActivity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.naviActivity.frame=CGRectMake(65+(8-4)*10, (44- self.naviActivity.frame.size.height)/2, self.naviActivity.frame.size.width,  self.naviActivity.frame.size.height);
    [self.navigationController.navigationBar addSubview:self.naviActivity];
    [self.naviActivity startAnimating];
}

-(void)addScrollView {
    self.scrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:self.scrollView];
}

-(void)addFooterBar {
    UIImageView* guding = [[UIImageView alloc]initWithFrame:CGRectMake(0,  DeviceHeight-64-45, self.view.frame.size.width, 45)];
    guding.userInteractionEnabled = YES;
    guding.image = [UIImage imageNamed:@"guding.png"];
    [self.view addSubview:guding];
    NSArray* tabfootImage = @[@"Coment.png",@"Like.png",@"Collect.png",@"Share.png"];
    NSArray* tabfootImagehight = @[@"Coment_h.png",@"Like_h.png",@"Collect_h.png",@"Share_h.png"];
    for (int i=0; i<4; i++) {
        UIButton*button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.tag=400+i;
        button.frame=CGRectMake(12+80*i, 11, 56, 28);
        [button setImage:[UIImage imageNamed:[tabfootImage objectAtIndex:i]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:[tabfootImagehight objectAtIndex:i]] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(touch:) forControlEvents:UIControlEventTouchUpInside];
        [guding addSubview:button];
    }
}

-(void)checkLikeMethod {
    int userID = USERID
    NSMutableString* urlDomain = RussiaUrl2
    [urlDomain appendString:@"CheckColloLike"];
    NSString*canshu=[NSString stringWithFormat:@"ID=%d&userid=%d&typeid=%d&classid=%d",self.ID,userID,1,1];
    NSURL* url = [[NSURL alloc]initWithString:urlDomain];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSData *data = [canshu dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    self.checkLike = [NSURLConnection connectionWithRequest:request delegate:self];
}

-(void)checkCollectMethod {
    int userID = USERID
    NSMutableString* urlDomain = RussiaUrl2
    [urlDomain appendString:@"CheckColloLike"];
    NSString*canshu=[NSString stringWithFormat:@"ID=%d&userid=%d&typeid=%d&classid=%d",self.ID,userID,2,1];
    NSURL*url=[[NSURL alloc]initWithString:urlDomain];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSData* data = [canshu dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    self.checkCollect = [NSURLConnection connectionWithRequest:request delegate:self];
}

-(void)loadWebViewData {
    NSMutableString* urlDomain = TravelURL
    [urlDomain appendString:@"getTravelDetail"];
    NSString* canshu = [NSString stringWithFormat:@"ID=%d",self.ID];
    NSURL*url=[[NSURL alloc]initWithString:urlDomain];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSData* data = [canshu dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    self.webViewConnection = [NSURLConnection connectionWithRequest:request delegate:self];
}

-(void)touch:(UIButton* )sender {
    switch (sender.tag) {//点评
        case 400:
        {
            CommentViewController* commentVC = [CommentViewController new];
            NSLog(@"跳至点评页面时参数待写");
            commentVC.ID = [NSString stringWithFormat:@"%d",self.ID];
            [self.navigationController pushViewController:commentVC animated:YES];
        }
            break;
        case 401:
            if (self.ISLike == YES) {
                UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是不小心的吗？" delegate:self cancelButtonTitle:@"是的" otherButtonTitles:@"不是",nil];
                alertView.tag = 100;
                [alertView show];
            }else {//添加“喜欢”
                int userid = USERID
                NSString* userName = [[NSUserDefaults standardUserDefaults]valueForKey:@"useName"];
                NSString*canshu=[NSString stringWithFormat:@"cityid=%d&ID=%d&userid=%d&username=%@&typeid=%d&classid=%d",2,self.ID,userid,userName,1,1];
                NSMutableString*urlDomain2=RussiaUrl2
                [urlDomain2 appendString:@"getTravelColloLike"];
                NSURL* url = [[NSURL alloc]initWithString:urlDomain2];
                NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
                [request setHTTPMethod:@"POST"];
                NSData* data = [canshu dataUsingEncoding:NSUTF8StringEncoding];
                [request setHTTPBody:data];
                self.like = [NSURLConnection connectionWithRequest:request delegate:self];
            }
            break;
        case 402:
            if (self.ISCollect == YES) {
                UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是不小心的吗？" delegate:self cancelButtonTitle:@"是的" otherButtonTitles:@"不是",nil];
                alertView.tag = 101;
                [alertView show];
            }else {//添加“收藏”
                int userid = USERID
                NSString* userName = [[NSUserDefaults standardUserDefaults]valueForKey:@"useName"];
                NSString*canshu=[NSString stringWithFormat:@"cityid=%d&ID=%d&userid=%d&username=%@&typeid=%d&classid=%d",2,self.ID,userid,userName,2,1];
                NSMutableString*urlDomain2=RussiaUrl2
                [urlDomain2 appendString:@"getTravelColloLike"];
                NSURL* url = [[NSURL alloc]initWithString:urlDomain2];
                NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
                [request setHTTPMethod:@"POST"];
                NSData* data = [canshu dataUsingEncoding:NSUTF8StringEncoding];
                [request setHTTPBody:data];
                self.collect = [NSURLConnection connectionWithRequest:request delegate:self];
            }
            break;
        case 403://分享
        {
            NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"ShareSDK"  ofType:@"jpg"];
            //构造分享内容
            id<ISSContent> publishContent = [ShareSDK content:@"分享内容"
                                               defaultContent:@"默认分享内容，没内容时显示"
                                                        image:[ShareSDK imageWithPath:imagePath]
                                                        title:@"ShareSDK"
                                                          url:@"http://www.sharesdk.cn"
                                                  description:@"这是一条测试信息"
                                                    mediaType:SSPublishContentMediaTypeNews];
            [ShareSDK showShareActionSheet:nil
                                 shareList:nil
                                   content:publishContent
                             statusBarTips:YES
                               authOptions:nil
                              shareOptions: nil
                                    result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                        if (state == SSResponseStateSuccess)
                                        {
                                            NSLog(@"分享成功");
                                        }
                                        else if (state == SSResponseStateFail)
                                        {
                                            NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                        }
                                    }];
        }
            break;
        default:
            break;
    }
}

#pragma mark-  NSURLConnectionDataDelegate
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.datas=[[NSMutableData alloc]init];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.datas appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    dicResultYiBu(self.datas, result, dictionary)
    if ([connection isEqual:self.checkLike]) {
        if (result.intValue == 0) {
            UIButton* btn = (UIButton*)[self.view viewWithTag:401];
            [btn setImage:[UIImage imageNamed:@"Like_h.png"] forState:UIControlStateHighlighted];
            self.ISLike = YES;
        }else if (result.intValue == 1) {
            self.ISLike = NO;
        }
    }else if ([connection isEqual:self.checkCollect]) {
        if (result.intValue == 0) {
            UIButton* btn = (UIButton*)[self.view viewWithTag:402];
            [btn setImage:[UIImage imageNamed:@"Collect_h.png"] forState:UIControlStateHighlighted];
            self.ISCollect = YES;
        }else if (result.intValue == 1) {
            self.ISCollect = NO;
        }
    }else if ([connection isEqual:self.unLike]) {
        if (result.intValue == 1) {
            UIButton* btn = (UIButton*)[self.view viewWithTag:401];
            [btn setImage:[UIImage imageNamed:@"Like.png"] forState:UIControlStateHighlighted];
            self.ISLike = NO;
        }else if (result.intValue == -1) {
            UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"操作失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }
    }else if ([connection isEqual:self.unCollect]) {
        if (result.intValue == 1) {
            UIButton* btn = (UIButton*)[self.view viewWithTag:401];
            [btn setImage:[UIImage imageNamed:@"Collect.png"] forState:UIControlStateHighlighted];
            self.ISCollect = NO;
        }else if (result.intValue == -1) {
            UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"操作失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }
    }else if ([connection isEqual:self.like]) {
        if (result.intValue == 0) {
            UIButton* btn = (UIButton*)[self.view viewWithTag:401];
            [btn setImage:[UIImage imageNamed:@"Like_h.png"] forState:UIControlStateHighlighted];
            self.ISLike = YES;
        }else if (result.intValue == 1) {
            self.ISLike = NO;
        }
    }else if ([connection isEqual:self.collect]) {
        if (result.intValue == 0) {
            UIButton* btn = (UIButton*)[self.view viewWithTag:402];
            [btn setImage:[UIImage imageNamed:@"Collect_h.png"] forState:UIControlStateHighlighted];
            self.ISCollect = YES;
        }else if (result.intValue == 1) {
            self.ISCollect = NO;
        }
    }else if ([connection isEqual:self.webViewConnection]) {
        self.dic = [dictionary[@"ds"]firstObject];
        if (self.dic.count > 0) {
            [self addTitleAndUserInfoView];
            NSString *HTMLData=[NSString stringWithFormat:@"<div id='foo' style='line-height:1.5'><font size=3 line-height=25>%@</font></div>",[self.dic valueForKey:@"Content"]];
            [self.webView loadHTMLString:HTMLData baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
        }
    }
}

-(void)addTitleAndUserInfoView {
    RTLabel* titleLab = [[RTLabel alloc]initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 20, 20)];
    titleLab.text = self.dic[@"Title"];
    titleLab.font = [UIFont boldSystemFontOfSize:18];
    float titleLabHeight = titleLab.optimumSize.height;
    titleLab.frame = CGRectMake(titleLab.frame.origin.x, titleLab.frame.origin.y, titleLab.frame.size.width, titleLabHeight);
    [self.scrollView addSubview:titleLab];
    UIImageView* headIV = [[UIImageView alloc]initWithFrame:CGRectMake(10, titleLab.frame.origin.y+titleLab.frame.size.height+10, 24, 24)];
    [self.scrollView addSubview:headIV];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString* headImageStr = [NSString stringWithFormat:@"http://www.russia-online.cn/Upload/Personal/%@",self.dic[@"ImgTouX"]];
        NSURL* headImageURL = [NSURL URLWithString:headImageStr];
        NSData* imageData = [NSData dataWithContentsOfURL:headImageURL];
        UIImage* headImage;
        if (imageData.length > 11) {
            headImage = [UIImage imageWithData:imageData];
        }else {
            headImage = [UIImage imageNamed:@"defaultSmall.gif"];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            headIV.image = headImage;
        });
    });
    UILabel* nameLab = [[UILabel alloc]initWithFrame:CGRectMake(10+24+10, headIV.frame.origin.y, self.view.frame.size.width-44-10, headIV.frame.size.height)];
    nameLab.text = self.dic[@"UserName"];
    nameLab.textColor=[UIColor blueColor];
    [self.scrollView addSubview:nameLab];
    RTLabel* timeLab = [[RTLabel alloc]initWithFrame:CGRectMake(10,headIV.frame.origin.y+headIV.frame.size.height+5, self.view.frame.size.width - 20,20)];
    timeLab.backgroundColor = [UIColor clearColor];
    NSMutableString* strtime = self.dic[@"PTime"];
    [strtime replaceOccurrencesOfString:@"/" withString:@"-" options:NSCaseInsensitiveSearch range:NSMakeRange(0, strtime.length)];
    timeLab.text=strtime;
    timeLab.textColor=[UIColor grayColor];
    [self.scrollView addSubview:timeLab];
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(10, timeLab.frame.origin.y+timeLab.frame.size.height, self.view.frame.size.width - 20, 20)];
    self.webView.delegate=self;
    self.webView.scrollView.bounces=YES;
    self.webView.scrollView.scrollEnabled=NO;
    self.webView.backgroundColor = [UIColor greenColor];
    [self.scrollView addSubview:self.webView];
}

#pragma mark- UIWebViewDelegate
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.naviActivity stopAnimating];
    [QYHMeThod changeImageWidthHeight:webView];
    NSString* htmlHeight = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementById(\"foo\").offsetHeight;"];
    self.webView.frame = CGRectMake(self.webView.frame.origin.x, self.webView.frame.origin.y, self.webView.frame.size.width, htmlHeight.intValue+100);
}

#pragma mark- UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 100) {
        if (buttonIndex == 1) {//取消“喜欢”
            int userid = USERID
            NSMutableString* urlDomain2 = RussiaUrl2
            [urlDomain2 appendString:@"UnColloLike"];
            NSString* canshu = [NSString stringWithFormat:@"ID=%d&userid=%d&typeid=%d&classid=%d",self.ID,userid,1,1];
            NSURL* url = [[NSURL alloc]initWithString:urlDomain2];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
            [request setHTTPMethod:@"POST"];
            NSData* data = [canshu dataUsingEncoding:NSUTF8StringEncoding];
            [request setHTTPBody:data];
            self.unLike = [NSURLConnection connectionWithRequest:request delegate:self];
        }
    }else if (alertView.tag == 101) {
        if (buttonIndex == 1) {//取消“收藏”
            int userid = USERID
            NSMutableString* urlDomain2 = RussiaUrl2
            [urlDomain2 appendString:@"UnColloLike"];
            NSString* canshu = [NSString stringWithFormat:@"ID=%d&userid=%d&typeid=%d&classid=%d",self.ID,userid,2,1];
            NSURL* url = [[NSURL alloc]initWithString:urlDomain2];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
            [request setHTTPMethod:@"POST"];
            NSData* data = [canshu dataUsingEncoding:NSUTF8StringEncoding];
            [request setHTTPBody:data];
            self.unCollect = [NSURLConnection connectionWithRequest:request delegate:self];
        }
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
