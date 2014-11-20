//
//  WriteMyTravelingViewController.m
//  St.Petersburg
//
//  Created by kirem-peter on 14-10-10.
//  Copyright (c) 2014年 Jiayi. All rights reserved.
//

#import "WriteMyTravelingViewController.h"
#import "GCPlaceholderTextView.h"

@interface WriteMyTravelingViewController ()
@property (nonatomic, strong)UITextField *titleTF;
@property (nonatomic, retain)GCPlaceholderTextView* textView;
@property (nonatomic, retain)UIView* addPictureView;
@property (nonatomic, retain)UIImageView* imageView;
@property (nonatomic, assign)float statusHeight;
@property (nonatomic, assign)float navigationBarHeight;

@end

@implementation WriteMyTravelingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

backButton

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"发布游记";
    self.view.backgroundColor = [UIColor colorWithRed:248.0/255 green:248.0/255 blue:248.0/255 alpha:1];
    
    //添加监听键盘弹起和隐藏
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardDidHideNotification object:nil];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lostFirstResponder)];
    [self.view addGestureRecognizer:tap];
    
    [self addSaveBtn];
    [self addTitleTextField];
    [self addContentTextView];
    [self addPhotoView];
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
//    self.statusHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
//    self.navigationBarHeight = self.navigationController.navigationBar.frame.size.height;
    float contentViewHeight = self.view.frame.size.height - 10 - 40 - 10 - 40;
    UIView* contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 10+40+10, self.view.bounds.size.width, contentViewHeight)];
    contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:contentView];
    self.textView = [[GCPlaceholderTextView alloc]initWithFrame:CGRectMake(10, 0, self.view.bounds.size.width - 20, contentViewHeight)];
    self.textView.placeholder = @"游记内容";
    self.textView.font = [UIFont systemFontOfSize:17];
    [contentView addSubview:self.textView];
}

-(void)addPhotoView {//“添加照片”视图
    self.addPictureView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 40 - 64, self.view.frame.size.width, 40)];//64为状态栏和navigationbar的高度
    
    self.addPictureView.backgroundColor = [UIColor redColor];
    
    [self.view addSubview:self.addPictureView];
    //拍照按钮
    UIButton* shootPictureBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.addPictureView.frame.size.width - 25 - 41 - 25 - 41, 3, 41, 34)];
    [shootPictureBtn setImage:[UIImage imageNamed:@"take_photos.png"] forState:UIControlStateNormal];
    [shootPictureBtn addTarget:self action:@selector(shootPicture) forControlEvents:UIControlEventTouchUpInside];
    [self.addPictureView addSubview:shootPictureBtn];
    //选择相册按钮
    UIButton* pickPictureBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.addPictureView.frame.size.width - 25 - 41, 3, 41, 34)];
    [pickPictureBtn setImage:[UIImage imageNamed:@"picture.png"] forState:UIControlStateNormal];
    [pickPictureBtn addTarget:self action:@selector(pickPicture) forControlEvents:UIControlEventTouchUpInside];
    [self.addPictureView addSubview:pickPictureBtn];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

//根据键盘改变addPictureView的高度
-(void)changeAddPictureViewHeight:(float)keyboardHeight
{
    if (keyboardHeight) {
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
            self.addPictureView.frame = CGRectMake(0, self.view.bounds.size.height - 40 - keyboardHeight, self.view.bounds.size.width, 40);
        } completion:nil];
        
    }else {
        self.addPictureView.frame = CGRectMake(0, self.view.bounds.size.height - 40, self.view.bounds.size.width, 40);
//         - self.statusHeight - self.navigationBarHeight
    }
    
}

-(void)saveTraveling
{
    NSLog(@"保存");
    
}

-(void)shootPicture//拍照
{
    UIImagePickerController* ipc = [[UIImagePickerController alloc]init];
    ipc.delegate = self;
    ipc.allowsEditing = YES;
    [ipc setSourceType:UIImagePickerControllerSourceTypeCamera];
    [self presentViewController:ipc animated:YES completion:nil];
    
}

-(void)pickPicture//从相册获取图片
{
    UIImagePickerController* ipc = [[UIImagePickerController alloc]init];
    ipc.delegate = self;
    ipc.allowsEditing = YES;
    [ipc setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [self presentViewController:ipc animated:YES completion:nil];
    
}
#pragma -mark- pickPicture
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage* image = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.imageView.image = image;
    [self dismissViewControllerAnimated:YES completion:nil];
    [self addPictures];
    [self.textView becomeFirstResponder];
}

//选择完照片后添加到textView中
-(void)addPictures {
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(50, 50, 100, 100)];
    UIBezierPath* path = [UIBezierPath bezierPathWithRect:self.imageView.frame];
    self.textView.textContainer.exclusionPaths = @[path];
    [self.textView addSubview:self.imageView];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)keyboardWillShow:(NSNotification*) notification
{
    NSValue *keyboardObject = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect;
    [keyboardObject getValue:&keyboardRect];
    [self changeAddPictureViewHeight:keyboardRect.size.height];
}

-(void)keyboardWillHidden:(NSNotification*) notification
{
    [self changeAddPictureViewHeight:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
