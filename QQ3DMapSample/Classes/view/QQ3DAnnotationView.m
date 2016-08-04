//
//  QQ3DAnnotationView.m
//  QQ3DMapSample
//
//  Created by iprincewang on 16/8/3.
//  Copyright © 2016年 com.tencent.prince. All rights reserved.
//

#import "QQ3DAnnotationView.h"
#import "QQBoxView.h"

@interface QQ3DAnnotationView ()
@property(nonatomic,strong)QQBoxView *boxView;
@end

@implementation QQ3DAnnotationView

-(id)initWithAnnotation:(id<QAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

-(void)setup
{
    self.boxView = [[QQBoxView alloc]init];
    //UIImage *image = [self imageWithUIView:self.boxView];
    //self.image = image;
    [self addSubview:self.boxView];
    [self.boxView zoomSmall:0.5];
    //self.centerOffset = CGPointMake(image.size.width / 2, - image.size.height / 2);
}

- (UIImage*) imageWithUIView:(UIView*) view{
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(view.bounds.size);
    CGContextRef currnetContext = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:currnetContext];
    // 从当前context中创建一个改变大小后的图片
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    return image;
}

-(void)zoomSmallBoxViewWithScale:(CGFloat)scale
{
    [self.boxView zoomSmall:scale];
}

-(void)zoomLargeBoxViewWithScale:(CGFloat)scale
{
    [self.boxView zoomLarge:scale];
}

-(void)rotateBoxViewWithAngleH:(CGFloat)angle
{
    [self.boxView rotateWithAngleH:angle];
}

-(void)rotateBoxViewWithAngleV:(CGFloat)angle
{
    [self.boxView rotateWithAngleV:angle];
}

@end
