//
//  WriteMyTravellingViewController_3.m
//  St.Petersburg
//
//  Created by kirem-peter on 14-11-27.
//  Copyright (c) 2014年 Jiayi. All rights reserved.
//

#import "WriteMyTravellingViewController_3.h"
#import "GCPlaceholderTextView.h"
#import "JSON.h"
#import "GDataXMLNode.h"
#import "CheckSelectedIVViewController.h"

@interface WriteMyTravellingViewController_3 ()
@property (nonatomic, strong)UITextField* titleTF;
@property (nonatomic, strong)GCPlaceholderTextView* textView;
@property (nonatomic, strong)UIScrollView* scrollView;//为了图片不被键盘遮住，使用scrollView自适应键盘的高度
@property (nonatomic, strong)UIView* photosView;//“添加照片”视图
@property (nonatomic, strong)UIView* line1;
@property (nonatomic, strong)UIView* line2;//“photosView"视图中的两条线
@property (nonatomic, strong)UIButton* addPhotoBtn;//"+"添加照片按钮
@property (nonatomic, strong)NSMutableArray* imageViewsNewArr;//“更新游记”时，存放新添加的imageview
@property (nonatomic, strong)NSMutableArray* imageStrArr;//存放base64编码字符串
@property (nonatomic, strong)NSMutableData* datas;
@end

@implementation WriteMyTravellingViewController_3

backButton
#define IMAGEVIEWWIDTH (self.view.frame.size.width-50)/4
#define urlStr [NSMutableString stringWithString: @"http://www.russia-online.cn/"];


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.imageNamesArr = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.imageViewsArr = [NSMutableArray array];
    self.imageStrArr = [NSMutableArray array];
    if (self.type == 0) {
        self.title = @"发布游记";
    }else if (self.type == 1) {
        self.title = @"更新游记";
        self.imageViewsNewArr = [NSMutableArray array];
    }
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.scrollView.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1];
    [self.view addSubview:self.scrollView];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lostFirstResponder)];
    [self.scrollView addGestureRecognizer:tap];
    [self addSaveBtn];
    [self addTitleTextField];
    [self addContentTextView];
    [self addPhotosView];
}

-(void)lostFirstResponder {
    [self.titleTF resignFirstResponder];
    [self.textView resignFirstResponder];
}

//“保存”按钮
-(void)addSaveBtn {
    UIButton *backbutton = [[UIButton alloc]init];
    backbutton.frame=CGRectMake(0, 5, 46, 26);
    backbutton.layer.masksToBounds = YES;
    [backbutton.layer setCornerRadius:4];
    [backbutton setBackgroundColor:[UIColor colorWithRed:0.37 green:0.69 blue:0.95 alpha:1]];
    [backbutton addTarget:self action:@selector(saveTravelling) forControlEvents:UIControlEventTouchUpInside];
    [backbutton setTitle:@"保存" forState:UIControlStateNormal];
    [backbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    backbutton.titleLabel.font = [UIFont systemFontOfSize:15];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backbutton];
    self.navigationItem.rightBarButtonItem =backItem;
}

//“游记标题”视图
-(void)addTitleTextField {
    CGRect frame = CGRectMake(0, 10, self.view.bounds.size.width, 40);
    UIView* titleView = [[UIView alloc]initWithFrame:frame];
    titleView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:titleView];
    self.titleTF = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, self.view.bounds.size.width - 20, 40)];
    self.titleTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.titleTF.placeholder = @"填写标题";
    if (self.titleTFText.length > 0) {
        self.titleTF.text = self.titleTFText;
    }
    self.titleTF.font = [UIFont systemFontOfSize:17];
    [titleView addSubview:self.titleTF];
    //添加上下两条线
    UIView* line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    line1.backgroundColor = [UIColor colorWithRed:217.0/255 green:217.0/255 blue:217.0/255 alpha:1];
    [titleView addSubview:line1];
    UIView* line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 39, self.view.frame.size.width, 1)];
    line2.backgroundColor = [UIColor colorWithRed:217.0/255 green:217.0/255 blue:217.0/255 alpha:1];
    [titleView addSubview:line2];
}

//“游记内容”视图
-(void)addContentTextView {
    float contentViewHeight = 120;
    UIView* contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 10+40+10, self.view.bounds.size.width, contentViewHeight)];
    contentView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:contentView];
    self.textView = [[GCPlaceholderTextView alloc]initWithFrame:CGRectMake(5, 0, self.view.bounds.size.width - 10, contentViewHeight)];
    self.textView.placeholder = @"游记内容";
    if (self.textViewText.length > 0) {
        self.textView.text = self.textViewText;
    }
    self.textView.font = [UIFont systemFontOfSize:17];
    [contentView addSubview:self.textView];
    //添加上下两条线
    UIView* line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    line1.backgroundColor = [UIColor colorWithRed:217.0/255 green:217.0/255 blue:217.0/255 alpha:1];
    [contentView addSubview:line1];
    UIView* line2 = [[UIView alloc]initWithFrame:CGRectMake(0, contentViewHeight-1, self.view.frame.size.width, 1)];
    line2.backgroundColor = [UIColor colorWithRed:217.0/255 green:217.0/255 blue:217.0/255 alpha:1];
    [contentView addSubview:line2];
}

//“添加照片”视图
-(void)addPhotosView {
    self.photosView = [[UIView alloc]initWithFrame:CGRectMake(0, 60 + 120 + 10, self.view.frame.size.width, IMAGEVIEWWIDTH+20)];
    self.photosView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.photosView];
    self.addPhotoBtn = [[UIButton alloc]init];
    [self.addPhotoBtn setImage:[UIImage imageNamed:@"游记_发布2_03.png"] forState:UIControlStateNormal];
    [self.addPhotoBtn addTarget:self action:@selector(showSheetView) forControlEvents:UIControlEventTouchUpInside];
    [self.photosView addSubview:self.addPhotoBtn];
    if (self.imageNamesArr.count > 0) {
        for (int i = 0; i < self.imageNamesArr.count; i++) {
            UIImageView* imageView = [[UIImageView alloc]init];
            [self.imageViewsArr addObject:imageView];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSString* picURL = self.imageNamesArr[i];
                NSMutableString * mutableStr = urlStr
                [mutableStr appendFormat:@"Upload/SelfManual/travel/%@",picURL];
                NSURL *url = [NSURL URLWithString:mutableStr];
                NSData *data = [NSData dataWithContentsOfURL:url];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (data) {
                        imageView.image = [UIImage imageWithData:data];
                    }
                });
            });
        }
    }
    //添加上下两条线
    self.line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    self.line1.backgroundColor = [UIColor colorWithRed:217.0/255 green:217.0/255 blue:217.0/255 alpha:1];
    [self.photosView addSubview:self.line1];
    self.line2 = [[UIView alloc]initWithFrame:CGRectMake(0, self.photosView.frame.size.height-1, self.view.frame.size.width, 1)];
    self.line2.backgroundColor = [UIColor colorWithRed:217.0/255 green:217.0/255 blue:217.0/255 alpha:1];
    [self.photosView addSubview:self.line2];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.imageViewsArr.count == 0) {
        self.addPhotoBtn.frame = CGRectMake(10, 10, IMAGEVIEWWIDTH, IMAGEVIEWWIDTH);
    }else if (self.imageViewsArr.count >=1 && self.imageViewsArr.count < 8) {
        if (self.imageViewsArr.count >= 4) {
            self.photosView.frame = CGRectMake(self.photosView.frame.origin.x, self.photosView.frame.origin.y, self.photosView.frame.size.width, 30 + IMAGEVIEWWIDTH*2);
            self.line2.frame = CGRectMake(self.line2.frame.origin.x, self.photosView.frame.size.height - 1, self.line2.frame.size.width, self.line2.frame.size.height);
        }
        for (int i = 0; i < self.imageViewsArr.count; i++) {
            UIImageView* imageView = self.imageViewsArr[i];
            UITapGestureRecognizer* tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageView:)];
            [imageView addGestureRecognizer:tapGR];
            imageView.userInteractionEnabled = YES;
            imageView.tag = i+1;
            imageView.frame = CGRectMake(10+(IMAGEVIEWWIDTH+10)*(i%4), (IMAGEVIEWWIDTH+10)*(i/4)+10, IMAGEVIEWWIDTH, IMAGEVIEWWIDTH);
            [self.photosView addSubview:imageView];
        }
        self.addPhotoBtn.frame = CGRectMake(10+(IMAGEVIEWWIDTH+10)*(self.imageViewsArr.count%4), (IMAGEVIEWWIDTH+10)*(self.imageViewsArr.count/4)+10, IMAGEVIEWWIDTH, IMAGEVIEWWIDTH);
    }else if (self.imageViewsArr.count >= 8) {
        if (self.addPhotoBtn) {
            [self.addPhotoBtn removeFromSuperview];
        }
        self.photosView.frame = CGRectMake(self.photosView.frame.origin.x, self.photosView.frame.origin.y, self.photosView.frame.size.width, 30 + IMAGEVIEWWIDTH*2);
        self.line2.frame = CGRectMake(self.line2.frame.origin.x, self.photosView.frame.size.height - 1, self.line2.frame.size.width, self.line2.frame.size.height);
        for (int i = 0; i < self.imageViewsArr.count; i++) {
            UIImageView* imageView = self.imageViewsArr[i];
            UITapGestureRecognizer* tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageView:)];
            [imageView addGestureRecognizer:tapGR];
            imageView.userInteractionEnabled = YES;
            imageView.tag = i+1;
            imageView.frame = CGRectMake(10+(IMAGEVIEWWIDTH+10)*(i%4), (IMAGEVIEWWIDTH+10)*(i/4)+10, IMAGEVIEWWIDTH, IMAGEVIEWWIDTH);
            [self.photosView addSubview:imageView];
        }
    }
}

-(void)tapImageView:(UIGestureRecognizer*)tap {
    UIImageView* iv = (UIImageView*)tap.view;
    CheckSelectedIVViewController* cSIVVC = [CheckSelectedIVViewController new];
    cSIVVC.imageViewsArr = self.imageViewsArr;
    cSIVVC.selectedIV = iv;
    cSIVVC.ID = self.ID;
    cSIVVC.imageNamesArr = self.imageNamesArr;
    [self.navigationController pushViewController:cSIVVC animated:NO];
}

-(void)pickPhotos {
    ZYQAssetPickerController* picker =  [[ZYQAssetPickerController alloc] init];
    picker.maximumNumberOfSelection = 8 - self.imageViewsArr.count;
    picker.minimumNumberOfSelection = 0;
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups=NO;
    picker.delegate=self;
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
            NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
            return duration >= 5;
        } else {
            return YES;
        }
    }];
    [self presentViewController:picker animated:NO completion:nil];
}

-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets {
    for (int i=0; i<assets.count; i++) {
        ALAsset *asset=assets[i];
        UIImage *tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, IMAGEVIEWWIDTH, IMAGEVIEWWIDTH)];
        imageView.image = tempImg;
        [self.imageViewsArr addObject:imageView];
        [self.imageViewsNewArr addObject:imageView];
    }
}

//保存游记
-(void)saveTravelling {
    NSLog(@"self.titleTF.text:%@,self.textView.text:%@",self.titleTF.text,self.textView.text);
    
    if (self.titleTF.text.length == 0) {
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"游记标题不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    }
    if ([self.textView.text isEqualToString:@"游记内容"]) {
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"游记内容不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    }
    NSMutableString* mutableStr = urlStr
    NSString* argumentStr;
    NSString* imagesString;
    if (self.type == 0) {//发布游记
        for (UIImageView* iv in self.imageViewsArr) {
            int h = iv.image.size.height;
            int w = iv.image.size.width;
            if (h <= 488 && w <= 650) {
                
            }else {
                float b = (float)650/w < (float)488/h ? (float)650/w : (float)488/h;
                CGSize imageSize = CGSizeMake(b*w, b*h);
                UIGraphicsBeginImageContext(imageSize);
                CGRect imageRect = CGRectMake(0, 0, b*w, b*h);
                [iv.image drawInRect:imageRect];
                iv.image = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
            }
            NSData* imageData = UIImageJPEGRepresentation(iv.image, 0.5);
            NSString* imageStr = [imageData base64EncodedStringWithOptions:0];
            [self.imageStrArr addObject:imageStr];
        }
        imagesString = [self.imageStrArr componentsJoinedByString:@","];
        [mutableStr appendString:@"api/WebService.asmx/getAddTravelInfo"];
        argumentStr = [NSString stringWithFormat:@"userid=%@&username=%@&title=%@&piclist=%@&content=%@&cityid=%d",GET_USER_DEFAUT(QUSE_ID),GET_USER_DEFAUT(USER_NAME),self.titleTF.text,imagesString,self.textView.text,2];
    }else if (self.type == 1) {//更新游记
        for (UIImageView* iv in self.imageViewsNewArr) {
            int h = iv.image.size.height;
            int w = iv.image.size.width;
            if (h <= 488 && w <= 650) {
                
            }else {
                float b = (float)650/w < (float)488/h ? (float)650/w : (float)488/h;
                CGSize imageSize = CGSizeMake(b*w, b*h);
                UIGraphicsBeginImageContext(imageSize);
                CGRect imageRect = CGRectMake(0, 0, b*w, b*h);
                [iv.image drawInRect:imageRect];
                iv.image = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
            }
            NSLog(@"self.imageViewsNewArr:%@  \n  iv.image:%@",self.imageViewsNewArr,iv.image);
            NSData* imageData = UIImageJPEGRepresentation(iv.image, 0.5);
            NSString* imageStr = [imageData base64EncodedStringWithOptions:0];
            [self.imageStrArr addObject:imageStr];
        }
        imagesString = [self.imageStrArr componentsJoinedByString:@","];
        [mutableStr appendString:@"api/WebService.asmx/getEditTravelInfo"];
        argumentStr = [NSString stringWithFormat:@"userid=%@&id=%d&title=%@&piclist=%@&content=%@&cityid=%d",GET_USER_DEFAUT(QUSE_ID),self.ID,self.titleTF.text,imagesString,self.textView.text,2];
    }
    NSURL*url=[[NSURL alloc]initWithString:mutableStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSData *data = [argumentStr dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    [NSURLConnection connectionWithRequest:request delegate:self];
    
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.datas=[[NSMutableData alloc]init];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [self.datas appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    dicResultYiBu(self.datas, result, dic)
    NSLog(@"self.result:%@",result);
    if (result.intValue == 1) {
        if (self.type == 0) {
            UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"发布成功，等待管理员审核中..." delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            alertView.tag = 1;
            [alertView show];
        }else if (self.type == 1) {
            UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"更新成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            alertView.tag = 1;
            [alertView show];
        }
    }else if (result.intValue == 0) {
        if (self.type == 0) {
            UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"发布失败！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }else if (self.type == 1) {
            UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"更新失败！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }
    }
}

#pragma mark- UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag==1 && buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:NO];
    }
    
}

-(void)showSheetView {
    [self lostFirstResponder];
    UIActionSheet* actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择", nil];
    [actionSheet showInView:self.view];
}

#pragma mark- UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {//拍照
        [self shootPhoto];
    }else if (buttonIndex == 1) {//从手机相册选择
        [self pickPhotos];
    }
}

//拍照
-(void)shootPhoto {
    UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    imagePicker.allowsEditing = YES;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImage *tempImage= [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, IMAGEVIEWWIDTH, IMAGEVIEWWIDTH)];
        imageView.image = tempImage;
        [self.imageViewsArr addObject:imageView];
        [self.imageViewsNewArr addObject:imageView];
    }    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
