//
//  UIViewController+Adagter.m
//  圣彼得堡旅游攻略
//
//  Created by kirem-peter on 14-9-11.
//  Copyright (c) 2014年 jiayi. All rights reserved.
//

#import "UIViewController+Adagter.h"

@implementation UIViewController (Adagter)
- (void)adagter
{
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

- (void)changeViewFrame:(CGRect)frame withView:(UIView*)view
{
    if ([UIDevice currentDevice].systemVersion.floatValue < 7.0)
    {
        view.frame = frame;
    }
}
@end
