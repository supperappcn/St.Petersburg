//
//  CheckSelectedIVViewController.h
//  St.Petersburg
//
//  Created by kirem-peter on 14-11-28.
//  Copyright (c) 2014年 Jiayi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WriteMyTravellingViewController_3.h"

@interface CheckSelectedIVViewController : UIViewController<UIScrollViewDelegate,UIActionSheetDelegate,NSURLConnectionDataDelegate>
@property (nonatomic, strong)NSMutableArray* imageViewsArr;
@property (nonatomic, strong)UIImageView* selectedIV;
@property (nonatomic, assign)int ID;//游记ID
@property (nonatomic, strong)NSMutableArray* imageNamesArr;
@end
