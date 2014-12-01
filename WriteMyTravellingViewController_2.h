//
//  WriteMyTravellingViewController_2.h
//  St.Petersburg
//
//  Created by kirem-peter on 14-11-22.
//  Copyright (c) 2014年 Jiayi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCPlaceholderTextView.h"

@interface WriteMyTravellingViewController_2 : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate,NSURLConnectionDataDelegate,UIAlertViewDelegate,UIActionSheetDelegate>
@property (nonatomic, assign)int type;// 0发布，1更改
@property (nonatomic, assign)int ID;//游记ID
@property (nonatomic, copy)NSString *titleText;
@property (nonatomic, copy)NSString* textViewText;
@property (nonatomic, strong)NSMutableArray* imageNamesArr;//更新游记时存储图片名称
@end
