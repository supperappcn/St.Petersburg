//
//  CheckSelectedIVViewController.m
//  St.Petersburg
//
//  Created by kirem-peter on 14-11-28.
//  Copyright (c) 2014年 Jiayi. All rights reserved.
//

#import "CheckSelectedIVViewController.h"
#import "JSON.h"
#import "GDataXMLNode.h"

@interface CheckSelectedIVViewController ()
@property (nonatomic, strong)UIScrollView* scrollView;
@property (nonatomic, strong)UIPageControl* pageControl;
@property (nonatomic, strong)NSData* datas;//请求删除图片时返回的结果
@property (nonatomic, assign)BOOL isFullScreen;//1为全屏  0为非全屏
@end

@implementation CheckSelectedIVViewController

backButton

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
    [self setFullScreen];
    [self addDeleteBtn];
    [self addScrollView];
    int temp = self.selectedIV.tag-1;
    [self scrollViewAddSubviews:temp];
}

-(void)addDeleteBtn {
    UIButton *backbutton = [[UIButton alloc]init];
    [backbutton setImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
    backbutton.frame=CGRectMake(0, 0, 25, 25);
    backbutton.layer.masksToBounds = YES;
    [backbutton.layer setCornerRadius:4];
    [backbutton addTarget:self action:@selector(showActionSheet) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backbutton];
    self.navigationItem.rightBarButtonItem =backItem;
}

-(void)addScrollView {
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollView];
}

-(void)scrollViewAddSubviews:(int )number {
    self.title = [NSString stringWithFormat:@"%d/%d",self.pageControl.currentPage+1,self.imageViewsArr.count];
    self.pageControl=[[UIPageControl alloc] initWithFrame:CGRectMake(self.scrollView.frame.origin.x, self.scrollView.frame.size.height - 20, self.scrollView.frame.size.width, 20)];
    self.pageControl.currentPage = number;
    self.pageControl.numberOfPages = self.imageViewsArr.count;
    self.pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor grayColor];
    [self.view addSubview:self.pageControl];
    for (int i = 0; i < self.imageViewsArr.count; i++) {
        UIImageView* imageView = self.imageViewsArr[i];
        imageView.frame = CGRectMake(self.view.frame.size.width*i, 0, self.view.frame.size.width, self.view.frame.size.height);
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        UITapGestureRecognizer* tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ChangeBarsStatus:)];
        [imageView addGestureRecognizer:tapGR];
        [self.scrollView addSubview:imageView];
    }
    UIImageView* firstIV = [self.imageViewsArr firstObject];
    UIImageView* lastIV = [self.imageViewsArr lastObject];
    self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width*number, 0);
//    self.pageControl.currentPage = (int)self.scrollView.contentOffset.x/self.scrollView.frame.size.width;
    self.scrollView.contentSize = CGSizeMake(lastIV.frame.origin.x + lastIV.frame.size.width - firstIV.frame.origin.x, 0);
    NSLog(@"self.scrollView.contentSize:%@",NSStringFromCGSize(self.scrollView.contentSize));
    NSLog(@"cgpoint:%@",NSStringFromCGPoint(self.scrollView.contentOffset));
}

#pragma mark-  UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.pageControl.currentPage = (scrollView.contentOffset.x/scrollView.frame.size.width);
    int page = floor((scrollView.contentOffset.x - self.scrollView.frame.size.width / 2) / self.scrollView.frame.size.width) + 1;
    self.pageControl.currentPage = page;
    self.title = [NSString stringWithFormat:@"%d/%d",self.pageControl.currentPage+1,self.imageViewsArr.count];
}

-(void)showActionSheet {
    UIActionSheet* actionSheet = [[UIActionSheet alloc]initWithTitle:@"此操作不可恢复，确定删除" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles: nil];
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self deleteSeletedImageView];
    }
}

-(void)deleteSeletedImageView {
    NSLog(@"currentPage:%d, imageNamesArr.count:%d",self.pageControl.currentPage,self.imageNamesArr.count);
    if (self.pageControl.currentPage < self.imageNamesArr.count) {
        NSMutableString* mutableStr = [NSMutableString stringWithString: @"http://192.168.0.156:807/"];
        [mutableStr appendString:@"api/WebService.asmx/getDeleteTravelPic"];
        NSString* argumentStr = [NSString stringWithFormat:@"id=%d&userid=%@&picname=%@",self.ID,GET_USER_DEFAUT(QUSE_ID),self.imageNamesArr[self.pageControl.currentPage]];
        NSLog(@"argumentStr:%@",argumentStr);
        NSURL* url=[[NSURL alloc]initWithString:mutableStr];
        NSMutableURLRequest* request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
        [request setHTTPMethod:@"POST"];
        NSData* data = [argumentStr dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:data];
        [NSURLConnection connectionWithRequest:request delegate:self];
    }else {
        UIImageView* iv = self.imageViewsArr[self.pageControl.currentPage];
        [iv removeFromSuperview];
        [self.imageViewsArr removeObject:iv];//从图片数组中删除
        int pageNumber = self.pageControl.currentPage;
        if (pageNumber != 0) {
            pageNumber = pageNumber-1;
        }else if (pageNumber == 0) {
            if (self.imageViewsArr.count == 0) {
                [self.navigationController popViewControllerAnimated:YES];
            }else {
                
            }
        }
        for (UIImageView* imageView in self.scrollView.subviews) {
            [imageView removeFromSuperview];
        }
        [self scrollViewAddSubviews:pageNumber];
    }
}

#pragma mark-  NSURLConnectionDataDelegate
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    self.datas = data;
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    dicResultYiBu(self.datas, result, dic)
    NSLog(@"self.result:%@",result);
    if ([result isEqualToString:@"yes"]) {//删除成功
        int pageNumber = self.pageControl.currentPage;
        UIImageView* iv = self.imageViewsArr[self.pageControl.currentPage];
        [iv removeFromSuperview];
        [self.imageViewsArr removeObject:iv];//从图片数组中删除
        [self.imageNamesArr removeObjectAtIndex:self.pageControl.currentPage];//从图片名数组中删除
        NSLog(@"self.imageViewsArr:%@ \n,self.imageNamesArr:%@",self.imageViewsArr,self.imageNamesArr);
        if (pageNumber != 0) {
            pageNumber = pageNumber-1;
        }else if (pageNumber == 0) {
            if (self.imageViewsArr.count == 0) {
                [self.navigationController popViewControllerAnimated:YES];
            }else {
                
            }
        }
        for (UIImageView* imageView in self.scrollView.subviews) {
            [imageView removeFromSuperview];
        }
        [self scrollViewAddSubviews:pageNumber];

    }else if ([result isEqualToString:@"no"]) {
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"删除照片失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    }
}

-(void)ChangeBarsStatus:(UITapGestureRecognizer* )tapGR {
    if (self.isFullScreen) {
        [self showBars];
    }else {
        [self setFullScreen];
    }
}

-(void)setFullScreen {
    self.isFullScreen = YES;
    [[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)showBars {
    self.isFullScreen = NO;
    [[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
    //UIStatusBarStyleDefault = 0 黑色文字，浅色背景时使用
    //UIStatusBarStyleLightContent = 1 白色文字，深色背景时使用
}

-(BOOL)prefersStatusBarHidden {
    return self.isFullScreen; //返回NO表示要显示，返回YES将hiden
}

-(void)viewWillLayoutSubviews {
//    NSLog(@"111self.view.frame:%@,self.view.bounds:%@,self.scrollView.frame:%@",NSStringFromCGRect(self.view.frame),NSStringFromCGRect(self.view.bounds),NSStringFromCGRect(self.scrollView.frame));
//
//    if (!self.isFullScreen) {
//        CGRect viewFrame = self.view.bounds;
//        viewFrame.origin.y = -64;
//        self.view.frame = viewFrame;
//        self.scrollView.frame = viewFrame;
//        for (UIImageView* iv in self.imageViewsArr) {
//            if (iv.tag == self.pageControl.currentPage+1) {
//                NSLog(@"tag:%d,currentPage:%d",iv.tag,self.pageControl.currentPage);
//                iv.frame = CGRectMake(iv.frame.origin.x, iv.frame.origin.y-64, iv.frame.size.width, iv.frame.size.height);
//                
//            };
//        }
//    }else {
//        CGRect viewFrame = self.view.bounds;
//        viewFrame.origin.y = 64;
//        self.view.frame = viewFrame;
//        self.scrollView.frame = viewFrame;
//        for (UIImageView* iv in self.imageViewsArr) {
//            if (iv.tag == self.pageControl.currentPage+1) {
//                NSLog(@"tag:%d,currentPage:%d",iv.tag,self.pageControl.currentPage);
//                iv.frame = CGRectMake(iv.frame.origin.x, iv.frame.origin.y+64, iv.frame.size.width, iv.frame.size.height);
//            };
//        }
//    }
//    NSLog(@"222self.view.frame:%@,self.view.bounds:%@,self.scrollView.frame:%@",NSStringFromCGRect(self.view.frame),NSStringFromCGRect(self.view.bounds),NSStringFromCGRect(self.scrollView.frame));
//    CGRect viewBounds = self.view.bounds;
//    CGFloat topBarOffset = 20.0;
//    viewBounds.origin.y = -topBarOffset;
//    self.view.bounds = viewBounds;
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];//for status bar style
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
