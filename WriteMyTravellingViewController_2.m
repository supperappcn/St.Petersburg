//
//  WriteMyTravellingViewController_2.m
//  St.Petersburg
//
//  Created by kirem-peter on 14-11-22.
//  Copyright (c) 2014年 Jiayi. All rights reserved.
//

#import "WriteMyTravellingViewController_2.h"
#import "GCPlaceholderTextView.h"
#import "JSON.h"
#import "GDataXMLNode.h"

@interface WriteMyTravellingViewController_2 ()
@property (nonatomic, strong)UITextField *titleTF;
@property (nonatomic, strong)GCPlaceholderTextView* textView;
@property (nonatomic, strong)UIScrollView* addPictureView;
@property (nonatomic, strong)UIScrollView* showPicView;//选择图片页面预览视图
@property (nonatomic, strong)NSMutableArray* imagesArr;//存放图片
@property (nonatomic, strong)NSMutableArray* imagesStrArr;//存放图片经过base64编码后的字符串
@property (nonatomic, strong)NSMutableData* datas;//服务器返回的上传结果
@property (nonatomic, strong)UIButton* pictureBtn;
@property (nonatomic, strong)UIButton* pickPictureBtn;//添加图片"+"按钮
@end

@implementation WriteMyTravellingViewController_2

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
    [super viewDidLoad];
    self.title = @"发布游记";
    self.view.backgroundColor = [UIColor colorWithRed:248.0/255 green:248.0/255 blue:248.0/255 alpha:1];
    self.imagesArr = [NSMutableArray array];
    self.imagesStrArr = [NSMutableArray array];
    self.datas = [NSMutableData data];
    
    //添加监听键盘弹起和隐藏
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lostFirstResponder)];
    [self.view addGestureRecognizer:tap];
    
    [self addSaveBtn];
    [self addTitleTextField];
    [self addContentTextView];
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

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
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
    self.textView.font = [UIFont systemFontOfSize:17];
    [contentView addSubview:self.textView];
}

-(void)addPhotoView {//“添加照片”视图
    self.addPictureView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 10 + 40 + 10 + 120 + 10, self.view.frame.size.width, 85)];//64为状态栏和navigationbar的高度
    self.addPictureView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.addPictureView];
    self.pictureBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, 65, 65)];
    self.pictureBtn.backgroundColor = [UIColor colorWithRed:0 green:111.0/255 blue:178.0/255 alpha:1];
    [self.addPictureView addSubview:self.pictureBtn];
    //选择相册按钮
    self.pickPictureBtn = [[UIButton alloc]initWithFrame:CGRectMake(85, 10, 65, 65)];
    [self.pickPictureBtn setImage:[UIImage imageNamed:@"游记_发布2_03.png"] forState:UIControlStateNormal];
    [self.pickPictureBtn addTarget:self action:@selector(showSheetView) forControlEvents:UIControlEventTouchUpInside];
    [self.addPictureView addSubview:self.pickPictureBtn];
}

-(void)showSheetView {
    UIActionSheet* actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择", nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {//拍照
        [self shootPicture];
    }else if (buttonIndex == 1) {//从手机相册选择
        [self pickPicture];
    }
}

//根据键盘改变addPictureView的高度
//-(void)changeAddPictureViewHeight:(float)keyboardHeight
//{
//    if (keyboardHeight) {
//        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
//        [UIView setAnimationDuration:0.23];
//        self.addPictureView.frame = CGRectMake(0, self.view.bounds.size.height - 40 - keyboardHeight, self.view.bounds.size.width, 40);
//        [UIView commitAnimations];
//    }else {
//        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
//        [UIView setAnimationDuration:0.23];
//        self.addPictureView.frame = CGRectMake(0, self.view.bounds.size.height - 40, self.view.bounds.size.width, 40);
//        [UIView commitAnimations];
//    }
//}

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
    }//else {
    
    
    NSMutableString* urlStr = [NSMutableString stringWithString: @"http://192.168.0.156:807/api/WebService.asmx/"];
    [urlStr appendString: @"getAddTravelInfo"];
    
    for (UIImage* image in self.imagesArr) {
        NSData* imageData = UIImageJPEGRepresentation(image, 1.0);
        NSString* imageStr = [imageData base64EncodedStringWithOptions:0];
        [self.imagesStrArr addObject:imageStr];
    }
    NSString* imagesString = [self.imagesStrArr componentsJoinedByString:@","];
    
    NSString* argumentStr = [NSString stringWithFormat:@"userid=%@&username=%@&title=%@&piclist=%@&content=%@&cityid=%d&typeid=%d",GET_USER_DEFAUT(QUSE_ID),GET_USER_DEFAUT(USER_NAME),self.titleTF.text,imagesString,self.textView.text,2,1];
    
    NSLog(@"argumentStr:%@",argumentStr);
    NSURL*url=[[NSURL alloc]initWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSData *data = [argumentStr dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    [NSURLConnection connectionWithRequest:request delegate:self];
    //}
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage* image = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(65*self.imagesArr.count, 0, 65, 65)];
    imageView.image = image;
    imageView.userInteractionEnabled = YES;
    [self.imagesArr addObject:image];
    UIButton* deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(50, 0, 15, 15)];
    deleteBtn.backgroundColor = [UIColor redColor];
    [deleteBtn setTitle:@"X" forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(deleteImageFromShowPicView:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:deleteBtn];
    [self.showPicView addSubview:imageView];
    self.showPicView.contentSize = CGSizeMake(65*self.imagesArr.count, 65);
//    [self addPictures];
}

-(void)deleteImageFromShowPicView:(UIButton*)sender {
    UIImageView* iv = (UIImageView*)sender.superview;
    [self.imagesArr removeObject:iv.image];
    [iv removeFromSuperview];
    [self updateImage];
}

-(void)updateImage {
    NSArray* subViews = self.showPicView.subviews;
    for (int i = 0; i < subViews.count; i++) {
        UIImageView* iv = subViews[i];
        [UIView animateWithDuration:0.5 animations:^{
            iv.frame = CGRectMake(65*i, 0, 65, 65);
        }];
    }
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (navigationController.viewControllers.count == 2) {
        UIView* selectPicView = [[UIView alloc]initWithFrame:CGRectMake(0, viewController.view.bounds.size.height - 85, viewController.view.bounds.size.width, 85)];
        selectPicView.backgroundColor = [UIColor greenColor];
        [viewController.view addSubview:selectPicView];
        UIButton* queDingBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 40, 0, 40, 20)];
        queDingBtn.backgroundColor = [UIColor redColor];
        [queDingBtn setTitle:@"确定" forState:UIControlStateNormal];
        [selectPicView addSubview:queDingBtn];
        self.showPicView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 65)];
        self.showPicView.backgroundColor = [UIColor whiteColor];
        self.showPicView.showsHorizontalScrollIndicator = NO;
        self.showPicView.showsVerticalScrollIndicator = NO;
        [selectPicView addSubview:self.showPicView];
        
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    self.datas = [NSMutableData dataWithData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    dicResultYiBu(self.datas, result, dic)
    NSLog(@"rijiResult:%@",result);
    if (result.intValue == 1) {
        NSLog(@"发布日记成功");
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"日记发布成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        alertView.tag = 1;
        [alertView show];
    }else if (result.intValue == 0) {
        NSLog(@"发布日记失败");
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ((alertView.tag==0 && buttonIndex==1) || alertView.tag==1) {
        [self backToLastVC];//离开此页面
    }else if (alertView.tag == 2) {
        [self.titleTF becomeFirstResponder];//标题或者标题和内容均为空，撰写标题
    }else if (alertView.tag == 3) {
        [self.textView becomeFirstResponder];//内容为空，撰写内容
    }
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
    [self presentViewController:ipc animated:YES completion:nil];
}

//选择完照片后添加到addPictureView中
-(void)addPictures {
    
//    UIImageView* imageView = [UIImageView alloc]initWithFrame:CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)keyboardWillShow:(NSNotification*) notification
{
//    NSValue *keyboardObject = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
//    CGRect keyboardRect;
//    [keyboardObject getValue:&keyboardRect];
//    NSLog(@"keyboardHeight:%f",keyboardRect.size.height);
//    [self changeAddPictureViewHeight:keyboardRect.size.height];
}

-(void)keyboardWillHidden:(NSNotification*) notification
{
//    NSValue *keyboardObject = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
//    CGRect keyboardRect;
//    [keyboardObject getValue:&keyboardRect];
//    NSLog(@"keyboardHeight:%f",keyboardRect.size.height);
//    [self changeAddPictureViewHeight:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
