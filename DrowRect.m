//
//  DrowRect.m
//  St.Petersburg
//
//  Created by beginner on 14-11-26.
//  Copyright (c) 2014年 Jiayi. All rights reserved.
//

#import "DrowRect.h"

@implementation DrowRect

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    
    //画圆，以便以后指定可以显示图片的范围
    //获取图形上下文
    //    CGContextRef ctx=UIGraphicsGetCurrentContext();
    //    CGContextAddEllipseInRect(ctx, CGRectMake(0, 0, 300, 300));
    //
    //    //指定上下文中可以显示内容的范围就是圆的范围
    //    CGContextClip(ctx);
    [self.selectImg drawAtPoint:CGPointMake(0, 0)];
    UIImage *img = [self imageFromImage:self.selectImg inRect:CGRectMake(20, 20, 100, 100)];
    
}
- (UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect
{
    CGImageRef sourceImageRef = [image CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    return newImage;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
