//
//  WriteMyTravellingViewController_3.h
//  St.Petersburg
//
//  Created by kirem-peter on 14-11-27.
//  Copyright (c) 2014年 Jiayi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYQAssetPickerController.h"

@interface WriteMyTravellingViewController_3 : UIViewController<UINavigationControllerDelegate,ZYQAssetPickerControllerDelegate,NSURLConnectionDataDelegate,UIAlertViewDelegate,UIActionSheetDelegate>
@property (nonatomic, assign)int type;// 0发布，1更改
@property (nonatomic, assign)int ID;//游记ID
@property (nonatomic, copy)NSString *titleTFText;
@property (nonatomic, copy)NSString* textViewText;
@property (nonatomic, strong)NSMutableArray* imageViewsArr;//存放imageview
@property (nonatomic, strong)NSMutableArray* imageNamesArr;//更新游记时存储图片名称
@end
