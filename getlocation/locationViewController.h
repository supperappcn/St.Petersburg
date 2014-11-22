//
//  locationViewController.h
//  St.Petersburg
//
//  Created by beginner on 14-11-18.
//  Copyright (c) 2014年 Jiayi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MineViewController.h"
@class MineViewController;

@interface locationViewController : UIViewController<CLLocationManagerDelegate,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

@property (nonatomic ,weak)MineViewController *mine;
@end
