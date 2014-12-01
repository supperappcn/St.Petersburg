//
//  WriteMyTravellingViewController_2.m
//  St.Petersburg
//
//  Created by kirem-peter on 14-11-22.
//  Copyright (c) 2014年 Jiayi. All rights reserved.
//

#import "WriteMyTravellingViewController_2.h"
#import "JSON.h"
#import "GDataXMLNode.h"

@interface WriteMyTravellingViewController_2 ()
@property (nonatomic, strong)UITextField *titleTF;
@property (nonatomic, strong)GCPlaceholderTextView* textView;
@property (nonatomic, strong)UIScrollView* addPictureView;
@property (nonatomic, strong)UIScrollView* showPicView;//选择图片页面预览视图
@property (nonatomic, strong)NSMutableArray* imagesArr;//存放图片
@property (nonatomic, strong)NSMutableArray* imagesStrArr;//存放图片经过base64编码后的字符串
@property (nonatomic, strong)NSMutableArray* imagesArrNew;//更新游记时新添加的图片
@property (nonatomic, strong)NSMutableData* datas;//服务器返回的上传结果
@property (nonatomic, strong)UIButton* pictureBtn;
@property (nonatomic, strong)UIButton* pickPictureBtn;//添加图片"+"按钮
@property (nonatomic, strong)NSMutableArray* tempImagesArr;//临时存放选择照片页面中所选的照片
@property (nonatomic, copy)NSString* deleteImageName;
@property (nonatomic, copy)NSString* result;
@end

@implementation WriteMyTravellingViewController_2

#define urlStr [NSMutableString stringWithString: @"http://192.168.0.156:807/"];

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
    self.imagesArr = [NSMutableArray array];
    self.imagesStrArr = [NSMutableArray array];
    self.tempImagesArr = [NSMutableArray array];
    self.datas = [NSMutableData data];
    self.imagesArrNew = [NSMutableArray array];
    if (self.type == 0) {
        self.title = @"发布游记";
    }else {
        self.title = @"编辑游记";
        
    }
    self.view.backgroundColor = [UIColor colorWithRed:248.0/255 green:248.0/255 blue:248.0/255 alpha:1];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lostFirstResponder)];
    [self.view addGestureRecognizer:tap];
    [self addSaveBtn];
    [self addTitleTextField];
    [self addContentTextView];
}

-(void)viewWillAppear:(BOOL)animated {
    [self addPhotoView];
}

-(void)viewDidAppear:(BOOL)animated {
    float height=35;
    UIButton *backbutton = [[UIButton alloc]init];
    backbutton.frame=CGRectMake(0, (44-height)/2, 55, height);
    [backbutton addTarget:self action:@selector(remindSave) forControlEvents:UIControlEventTouchUpInside];
    UIImageView*imageView=[[UIImageView alloc]initWithFrame:CGRectMake(-5, 10, 15, 15)];
    imageView.image=[UIImage imageNamed:@"_back.png"];
    [backbutton addSubview:imageView];
    UILabel*lable=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 40, 35)];
    lable.backgroundColor=[UIColor clearColor];
    lable.font=[UIFont systemFontOfSize:15];
    lable.textColor=[UIColor whiteColor];
    lable.text=@"返回";[backbutton addSubview:lable];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backbutton];
    self.navigationItem.leftBarButtonItem =backItem;
}

//点“返回”按钮时提示是否保存
-(void)remindSave {
    if (self.titleTF.text || self.textView.text) {
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您的游记尚未保存，确定离开此页面" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"离开", nil];
        alertView.tag = 0;
        [alertView show];
    }else {
        [self backToLastVC];
    }
}

-(void)backToLastVC{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)lostFirstResponder {
    [self.titleTF resignFirstResponder];
    [self.textView resignFirstResponder];
}

-(void)addSaveBtn {//右上角的“保存”按钮
    UIButton *backbutton = [[UIButton alloc]init];
    backbutton.frame=CGRectMake(0, 5, 46, 26);
    backbutton.layer.masksToBounds = YES;
    [backbutton.layer setCornerRadius:4];
    [backbutton setBackgroundColor:[UIColor colorWithRed:0.37 green:0.69 blue:0.95 alpha:1]];
    [backbutton addTarget:self action:@selector(saveTraveling) forControlEvents:UIControlEventTouchUpInside];
    [backbutton setTitle:@"保存" forState:UIControlStateNormal];
    [backbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    backbutton.titleLabel.font = [UIFont systemFontOfSize:15];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backbutton];
    self.navigationItem.rightBarButtonItem =backItem;
}

-(void)addTitleTextField {//“填写标题”视图
    CGRect frame = CGRectMake(0, 10, self.view.bounds.size.width, 40);
    UIView* titleView = [[UIView alloc]initWithFrame:frame];
    titleView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:titleView];
    self.titleTF = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, self.view.bounds.size.width - 20, 40)];
    self.titleTF.placeholder = @"填写标题";
    if (self.titleText.length) {
        self.titleTF.text = self.titleText;
    }
    self.titleTF.font = [UIFont systemFontOfSize:17];
    [titleView addSubview:self.titleTF];
}

-(void)addContentTextView {//“游记内容”视图
    float contentViewHeight = 120;
    UIView* contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 10+40+10, self.view.bounds.size.width, contentViewHeight)];
    contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:contentView];
    self.textView = [[GCPlaceholderTextView alloc]initWithFrame:CGRectMake(5, 0, self.view.bounds.size.width - 10, contentViewHeight)];
    self.textView.placeholder = @"游记内容";
    if (self.textViewText.length) {
        self.textView.text = self.textViewText;
    }
    self.textView.font = [UIFont systemFontOfSize:17];
    [contentView addSubview:self.textView];
}

-(void)addPhotoView {//“添加照片”视图
    self.addPictureView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 10 + 40 + 10 + 120 + 10, self.view.frame.size.width, 85)];//64为状态栏和navigationbar的高度
    self.addPictureView.backgroundColor = [UIColor whiteColor];
    self.addPictureView.showsHorizontalScrollIndicator = NO;
    self.addPictureView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.addPictureView];
    //选择相册按钮
    self.pickPictureBtn = [[UIButton alloc]init];
    [self.pickPictureBtn setImage:[UIImage imageNamed:@"游记_发布2_03.png"] forState:UIControlStateNormal];
    [self.pickPictureBtn addTarget:self action:@selector(showSheetView) forControlEvents:UIControlEventTouchUpInside];
    [self.addPictureView addSubview:self.pickPictureBtn];
    if (self.type == 0) {//发布游记
        if (self.imagesArr.count == 0) {
            self.pickPictureBtn.frame = CGRectMake(85, 10, 65, 65);
            self.pictureBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, 65, 65)];
            self.pictureBtn.backgroundColor = [UIColor colorWithRed:0 green:111.0/255 blue:178.0/255 alpha:1];
            [self.addPictureView addSubview:self.pictureBtn];
        }else {
            if (self.pictureBtn) {
                [self.pictureBtn removeFromSuperview];
            }
            self.pickPictureBtn.frame = CGRectMake(75*self.imagesArr.count + 10, 10, 65, 65);
            for (int i = 0; i < self.imagesArr.count; i++) {
                UIImage* image = self.imagesArr[i];
                UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10 + 75*i, 10, 65, 65)];
                imageView.image = image;
                imageView.userInteractionEnabled = YES;
                UIButton* deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(50, 0, 15, 15)];
                deleteBtn.backgroundColor = [UIColor redColor];
                [deleteBtn setTitle:@"X" forState:UIControlStateNormal];
                [deleteBtn addTarget:self action:@selector(deleteImageFromAddPictureView:) forControlEvents:UIControlEventTouchUpInside];
                [imageView addSubview:deleteBtn];
                [self.addPictureView addSubview:imageView];
            }
            self.addPictureView.contentSize = CGSizeMake(10 + 75*(self.imagesArr.count+1), 65);
        }
    }else if (self.type == 1) {//更新游记
        if (self.imageNamesArr.count == 0 && self.imagesArr.count == 0) {
            self.pickPictureBtn.frame = CGRectMake(85, 10, 65, 65);
            self.pictureBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, 65, 65)];
            self.pictureBtn.backgroundColor = [UIColor colorWithRed:0 green:111.0/255 blue:178.0/255 alpha:1];
            [self.addPictureView addSubview:self.pictureBtn];
        }else if (self.imageNamesArr.count != 0 && self.imagesArr.count == 0) {
            if (self.pictureBtn) {
                [self.pictureBtn removeFromSuperview];
            }
            self.pickPictureBtn.frame = CGRectMake(75*self.imageNamesArr.count + 10, 10, 65, 65);
            for (int i = 0; i < self.imageNamesArr.count; i++) {
                UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10 + 75*i, 10, 65, 65)];
                imageView.userInteractionEnabled = YES;
                imageView.tag = i;
                UIButton* deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(50, 0, 15, 15)];
                deleteBtn.backgroundColor = [UIColor redColor];
                [deleteBtn setTitle:@"X" forState:UIControlStateNormal];
                deleteBtn.tag = i;
                [deleteBtn addTarget:self action:@selector(deleteImageFromAddPictureView:) forControlEvents:UIControlEventTouchUpInside];
                [imageView addSubview:deleteBtn];
                [self.addPictureView addSubview:imageView];
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSString* picURL = self.imageNamesArr[i];
                    NSMutableString * mutableStr = urlStr;
                    [mutableStr appendFormat:@"Upload/SelfManual/travel/%@",picURL];
                    NSURL *url = [NSURL URLWithString:mutableStr];
                    NSData *data = [NSData dataWithContentsOfURL:url];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (data) {
                            imageView.image = [UIImage imageWithData:data];
                            [self.imagesArr addObject:imageView.image];
                        }
                    });
                });
            }
            self.addPictureView.contentSize = CGSizeMake(10 + 75*(self.imageNamesArr.count+1), 65);
        }else {
            if (self.pictureBtn) {
                [self.pictureBtn removeFromSuperview];
            }
            self.pickPictureBtn.frame = CGRectMake(75*self.imagesArr.count + 10, 10, 65, 65);
            for (int i = 0; i < self.imagesArr.count; i++) {
                UIImage* image = self.imagesArr[i];
                UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10 + 75*i, 10, 65, 65)];
                imageView.tag = i;
                imageView.image = image;
                imageView.userInteractionEnabled = YES;
                UIButton* deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(50, 0, 15, 15)];
                deleteBtn.backgroundColor = [UIColor redColor];
                [deleteBtn setTitle:@"X" forState:UIControlStateNormal];
                deleteBtn.tag = i;
                [deleteBtn addTarget:self action:@selector(deleteImageFromAddPictureView:) forControlEvents:UIControlEventTouchUpInside];
                [imageView addSubview:deleteBtn];
                [self.addPictureView addSubview:imageView];
            }
            self.addPictureView.contentSize = CGSizeMake(10 + 75*(self.imagesArr.count+1), 65);
        }
        
        /*else if (self.imageNamesArr.count == 0 && self.imagesArr.count != 0) {
            if (self.pictureBtn) {
                [self.pictureBtn removeFromSuperview];
            }
            self.pickPictureBtn.frame = CGRectMake(75*self.imagesArr.count + 10, 10, 65, 65);
            for (int i = 0; i < self.imagesArr.count; i++) {
                UIImage* image = self.imagesArr[i];
                UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10 + 75*i, 10, 65, 65)];
                imageView.image = image;
                imageView.userInteractionEnabled = YES;
                UIButton* deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(50, 0, 15, 15)];
                deleteBtn.backgroundColor = [UIColor redColor];
                [deleteBtn setTitle:@"X" forState:UIControlStateNormal];
                [deleteBtn addTarget:self action:@selector(deleteImageFromAddPictureView:) forControlEvents:UIControlEventTouchUpInside];
                [imageView addSubview:deleteBtn];
                [self.addPictureView addSubview:imageView];
            }
            self.addPictureView.contentSize = CGSizeMake(10 + 75*(self.imagesArr.count+1), 65);
        }else if (self.imageNamesArr.count != 0 && self.imagesArr.count != 0) {
         
        }*/
    }
    
}

-(void)deleteImageFromAddPictureView:(UIButton* )sender {
    if (self.type == 0) {//发布游记
        UIImageView* iv = (UIImageView*)sender.superview;
        [self.imagesArr removeObject:iv.image];
        [iv removeFromSuperview];
        [self updateImage2];
    }else if (self.type == 1){//更新游记
        if (sender.tag < self.imageNamesArr.count) {//删除原游记中图片
            self.deleteImageName = self.imageNamesArr[sender.tag];
            UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"此操作不可恢复，确定删除？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
            alertView.tag = 5;
            [alertView show];
            
//            if ([self.result isEqualToString:@"yes"]) {
//                UIImageView* iv = (UIImageView*)sender.superview;
//                [self.imageNamesArr removeObjectAtIndex:sender.tag];
//                [self.imagesArr removeObject:iv.image];
//                [iv removeFromSuperview];
//                [self updateImage2];
//            }else if ([self.result isEqualToString:@"no"]) {
//                UIAlertView* alertVi = [[UIAlertView alloc]initWithTitle:@"提示" message:@"删除照片失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
//                alertVi.tag = 6;
//                [alertVi show];
//            }
        }else {//删除新添加的图片
            UIImageView* iv = (UIImageView*)sender.superview;
            [self.imagesArr removeObject:iv.image];
            [self.imagesArrNew removeObject:iv.image];
            [iv removeFromSuperview];
            [self updateImage2];
        }
    }
}

-(void)updateImage2 {
    NSArray* subViews = self.addPictureView.subviews;
    for (int i = 1; i < subViews.count; i++) {
        UIView* vi = subViews[i];
        [UIView animateWithDuration:0.5 animations:^{
            self.pickPictureBtn.frame = CGRectMake(75*(subViews.count-1) + 10, 10, 65, 65);
            vi.frame = CGRectMake(75*(i-1)+10, 10, 65, 65);
        }];
    }
    if (self.imagesArr.count == 0) {
        self.pickPictureBtn.frame = CGRectMake(85, 10, 65, 65);
        self.pictureBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, 65, 65)];
        self.pictureBtn.backgroundColor = [UIColor colorWithRed:0 green:111.0/255 blue:178.0/255 alpha:1];
        [self.addPictureView addSubview:self.pictureBtn];
    }
    self.addPictureView.contentSize = CGSizeMake(10 + 75*(self.imagesArr.count+1), 65);
}

-(void)showSheetView {
    if (self.imagesArr.count < 8) {
        UIActionSheet* actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择", nil];
        [actionSheet showInView:self.view];
    }else {
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"图片数量已达到一篇游记最多只能包含8张的上限" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {//拍照
//        [self shootPicture];
    }else if (buttonIndex == 1) {//从手机相册选择
        [self pickPicture];
    }
}

-(void)saveTraveling
{
    NSString* tempStr = self.textView.placeholder;
    if (!self.titleTF.text) {
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请撰写游记标题" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        alertView.tag = 2;
        [alertView show];
    }else if (self.titleTF.text && [self.textView.text isEqualToString:tempStr]) {
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请撰写游记内容" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        alertView.tag = 3;
        [alertView show];
    }else {
        NSMutableString* mutableStr = urlStr
        NSString* argumentStr;
        if (self.type == 0) {//发布游记
            [mutableStr appendString:@"api/WebService.asmx/getAddTravelInfo"];
            for (UIImage* image in self.imagesArr) {
                NSData* imageData = UIImageJPEGRepresentation(image, 0.5);
                NSString* imageStr = [imageData base64EncodedStringWithOptions:0];
                [self.imagesStrArr addObject:imageStr];
            }
            NSString* imagesString = [self.imagesStrArr componentsJoinedByString:@","];
            argumentStr = [NSString stringWithFormat:@"userid=%@&username=%@&title=%@&piclist=%@&content=%@&cityid=%d&typeid=%d",GET_USER_DEFAUT(QUSE_ID),GET_USER_DEFAUT(USER_NAME),self.titleTF.text,imagesString,self.textView.text,2,1];
            
        }else if (self.type == 1) {//更新游记
            [mutableStr appendString:@"api/WebService.asmx/getEditTravelInfo"];
            for (UIImage* image in self.imagesArrNew) {
                NSData* imageData = UIImageJPEGRepresentation(image, 0.5);
                NSString* imageStr = [imageData base64EncodedStringWithOptions:0];
                [self.imagesStrArr addObject:imageStr];
            }
            NSString* imagesString = [self.imagesStrArr componentsJoinedByString:@","];
            argumentStr = [NSString stringWithFormat:@"userid=%@&id=%d&title=%@&piclist=%@&content=%@&cityid=%d",GET_USER_DEFAUT(QUSE_ID),self.ID,self.titleText,imagesString,self.textView.text,2];
        }
        NSURL*url=[[NSURL alloc]initWithString:mutableStr];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
        [request setHTTPMethod:@"POST"];
        NSData *data = [argumentStr dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:data];
        [NSURLConnection connectionWithRequest:request delegate:self];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if (self.imagesArr.count < 8) {
        UIImage* image = [info objectForKey:UIImagePickerControllerOriginalImage];
        UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10 + 75*self.tempImagesArr.count, 10, 65, 65)];
        int h = image.size.height;
        int w = image.size.width;
        if (h <= 488 && w <= 650) {
            imageView.image = image;
        }else {
            float b = (float)650/w < (float)488/h ? (float)650/w : (float)488/h;
            CGSize imageSize = CGSizeMake(b*w, b*h);
            UIGraphicsBeginImageContext(imageSize);
            CGRect imageRect = CGRectMake(0, 0, b*w, b*h);
            [image drawInRect:imageRect];
            imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
        imageView.userInteractionEnabled = YES;
        [self.tempImagesArr addObject:imageView.image];
        [self.imagesArr addObject:imageView.image];
        if (self.type == 1) {
            [self.imagesArrNew addObject:imageView.image];
        }
        UIButton* deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(50, 0, 15, 15)];
        deleteBtn.backgroundColor = [UIColor redColor];
        [deleteBtn setTitle:@"X" forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(deleteImageFromShowPicView:) forControlEvents:UIControlEventTouchUpInside];
        [imageView addSubview:deleteBtn];
        [self.showPicView addSubview:imageView];
        self.showPicView.contentSize = CGSizeMake(10 + 75*self.imagesArr.count, 65);
    }else {
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"图片数量已达到一篇游记最多只能包含8张的上限" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    }
}

-(void)deleteImageFromShowPicView:(UIButton*)sender {
    UIImageView* iv = (UIImageView*)sender.superview;
    [self.tempImagesArr removeObject:iv.image];
    [self.imagesArr removeObject:iv.image];
    if (self.type == 1) {
        [self.imagesArrNew removeObject:iv.image];
    }
    [iv removeFromSuperview];
    [self updateImage];
}

-(void)updateImage {
    NSArray* subViews = self.showPicView.subviews;
    for (int i = 0; i < subViews.count; i++) {
        UIImageView* iv = subViews[i];
        [UIView animateWithDuration:0.5 animations:^{
            iv.frame = CGRectMake(75*i+10, 10, 65, 65);
        }];
    }
    self.showPicView.contentSize = CGSizeMake(10 + 75*self.imagesArr.count, 65);
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (navigationController.viewControllers.count == 2) {
        UIView* selectPicView = [[UIView alloc]initWithFrame:CGRectMake(0, viewController.view.bounds.size.height - 105, viewController.view.bounds.size.width, 105)];
        selectPicView.backgroundColor = [UIColor greenColor];
        [viewController.view addSubview:selectPicView];
        UIButton* queDingBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 40, 0, 40, 20)];
        queDingBtn.backgroundColor = [UIColor redColor];
        [queDingBtn setTitle:@"确定" forState:UIControlStateNormal];
        [queDingBtn addTarget:self action:@selector(clickQueDingBtn:) forControlEvents:UIControlEventTouchUpInside];
        [selectPicView addSubview:queDingBtn];
        self.showPicView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 85)];
        self.showPicView.backgroundColor = [UIColor whiteColor];
        self.showPicView.showsHorizontalScrollIndicator = NO;
        self.showPicView.showsVerticalScrollIndicator = NO;
        [selectPicView addSubview:self.showPicView];
    }
}

-(void)clickQueDingBtn:(UIButton* )sender {//选择完照片后点击“确定”按钮返回游记页面
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    self.datas = [NSMutableData dataWithData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    dicResultYiBu(self.datas, resu, dic)
    self.result = resu;
    NSLog(@"self.result:%@",self.result);
    if (self.result.intValue == 1) {
        if (self.type == 0) {
            UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"发布成功，等待管理员审核中..." delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            alertView.tag = 1;
            [alertView show];
        }else if (self.type == 1) {
            UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"更新成功，等待管理员审核中..." delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            alertView.tag = 1;
            [alertView show];
        }
    }else if ([self.result isEqualToString:@"yes"]) {
        NSString* imageNam = self.deleteImageName;
        for (int i = 0; i < self.imageNamesArr.count; i++) {
            NSString* name = self.imageNamesArr[i];
            if ([name isEqualToString:imageNam]) {
                UIImageView* iv = (UIImageView*)[self.addPictureView viewWithTag:i];
                [self.imageNamesArr removeObjectAtIndex:i];
                [self.imagesArr removeObject:iv.image];
                [iv removeFromSuperview];
                [self updateImage2];
            }
        }
    }else if ([self.result isEqualToString:@"no"]) {
        UIAlertView* alertVi = [[UIAlertView alloc]initWithTitle:@"提示" message:@"删除照片失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        alertVi.tag = 6;
        [alertVi show];
    }else if (self.result.intValue == 0) {
        if (self.type == 0) {
            UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"发布失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }else if (self.type == 1) {
            UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"更新失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ((alertView.tag==0 && buttonIndex==1) || alertView.tag==1) {
        [self backToLastVC];//离开此页面
    }else if (alertView.tag == 2) {
        [self.titleTF becomeFirstResponder];//标题或者标题和内容均为空，撰写标题
    }else if (alertView.tag == 3) {
        [self.textView becomeFirstResponder];//内容为空，撰写内容
    }else if (alertView.tag == 5 && buttonIndex == 1) {//删除原游记中的照片
        [self deleteImageFromOriginalTravelling];
    }
}

-(void)deleteImageFromOriginalTravelling {
    NSMutableString* mutableStr = urlStr
    [mutableStr appendString:@"api/WebService.asmx/getDeleteTravelPic"];
    NSString* argumentStr = [NSString stringWithFormat:@"id=%d&userid=%@&picname=%@",self.ID,GET_USER_DEFAUT(QUSE_ID),self.deleteImageName];
    NSLog(@"argumentStr:%@",argumentStr);
    NSURL*url=[[NSURL alloc]initWithString:mutableStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSData *data = [argumentStr dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

-(void)shootPicture//拍照
{
    UIImagePickerController* ipc = [[UIImagePickerController alloc]init];
    ipc.delegate = self;
    [ipc setSourceType:UIImagePickerControllerSourceTypeCamera];
    [self presentViewController:ipc animated:YES completion:nil];
}

-(void)pickPicture//从相册获取图片
{
    UIImagePickerController* ipc = [[UIImagePickerController alloc]init];
    ipc.delegate = self;
    [ipc setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [self.tempImagesArr removeAllObjects];
    [self presentViewController:ipc animated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
