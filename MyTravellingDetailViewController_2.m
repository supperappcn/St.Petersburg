//
//  MyTravellingDetailViewController_2.m
//  St.Petersburg
//
//  Created by kirem-peter on 14-11-25.
//  Copyright (c) 2014年 Jiayi. All rights reserved.
//

#import "MyTravellingDetailViewController_2.h"

@interface MyTravellingDetailViewController_2 ()
@property (nonatomic, strong)NSArray* imageNames;
@property (nonatomic, strong)UIScrollView* scrollView;
@property (nonatomic, strong)UITextView* textView;
@end

@implementation MyTravellingDetailViewController_2

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
    self.title = @"游记详情";
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollView];
    NSString* imageStr = self.dic[@"Piclist"];
    self.imageNames = [imageStr componentsSeparatedByString:@","];
    for (int i = 0; i < self.imageNames.count; i++) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10 + 250*i, self.view.frame.size.width - 10 - 10, 240)];
            [self.scrollView addSubview:imageView];
            UIActivityIndicatorView* aiv = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            aiv.frame = CGRectMake((imageView.frame.size.width - 20)/2, 110 + 10 + 250*i, 20, 20);
            [imageView addSubview:aiv];
            [aiv startAnimating];
            NSString* picURL = self.imageNames[i];
            NSString *urlStr = [NSString stringWithFormat:@"http://192.168.0.156:807/Upload/SelfManual/travel/%@",picURL];
            NSURL *url = [NSURL URLWithString:urlStr];
            NSData *data = [NSData dataWithContentsOfURL:url];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (data) {
                    imageView.image = [UIImage imageWithData:data];
                    [aiv stopAnimating];
                    [aiv removeFromSuperview];
                }
            });
        });
}
    [self addTextLab];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.textView.frame.size.height + self.textView.frame.origin.y+20);
}
/*
-(void)addImageView:(int)number {
    UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10 + 250*number, self.view.frame.size.width - 10 - 10, 240)];
    [self.scrollView addSubview:imageView];
    UIActivityIndicatorView* aiv = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    aiv.frame = CGRectMake((imageView.frame.size.width - 20)/2, 110 + 10 + 250*number, 20, 20);
    NSLog(@"aiv.frame:%@",NSStringFromCGRect(aiv.frame));
    [imageView addSubview:aiv];
    [aiv startAnimating];
    NSString* picURL = self.imageNames[number];
    NSString *urlStr = [NSString stringWithFormat:@"http://192.168.0.156:807/Upload/SelfManual/travel/%@",picURL];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSData *data = [NSData dataWithContentsOfURL:url];
    if (data) {
        imageView.image = [UIImage imageWithData:data];
        [aiv stopAnimating];
        [aiv removeFromSuperview];
    }
}
*/
-(void)addTextLab {
    self.textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 10 + 250*self.imageNames.count, self.view.frame.size.width - 10 - 10, 100)];
    self.textView.text = self.dic[@"Content"];
    self.textView.allowsEditingTextAttributes = NO;
    self.textView.editable = NO;
    CGSize size = [self.textView.text sizeWithFont:[UIFont systemFontOfSize:17]];
    float height = size.height;
    self.textView.frame = CGRectMake(self.textView.frame.origin.x, self.textView.frame.origin.y, self.textView.frame.size.width, height);
    [self.scrollView addSubview:self.textView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
