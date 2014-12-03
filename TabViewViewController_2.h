//
//  TabViewViewController_2.h
//  St.Petersburg
//
//  Created by kirem-peter on 14-12-3.
//  Copyright (c) 2014年 Jiayi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabViewViewController_2 : UIViewController<UITableViewDataSource,UITableViewDelegate,NSURLConnectionDataDelegate,UIScrollViewDelegate,UISearchDisplayDelegate>
{
    UIButton* noNetButton;
}
@property (nonatomic, strong)UITableView* tableView;
@property (nonatomic, strong)UIScrollView* scrollView;
@property (nonatomic, strong)UIPageControl* pageControl;
@property (nonatomic, strong)UISearchBar* searchBar;
@property (nonatomic, strong)UISearchDisplayController* searchDisplayC;
//@property (nonatomic, strong)
//@property (nonatomic, copy)NSString*
@end
