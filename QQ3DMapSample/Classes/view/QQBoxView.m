//
//  QQBoxView.m
//  QQ3DMapSample
//
//  Created by iprincewang on 16/8/3.
//  Copyright © 2016年 com.tencent.prince. All rights reserved.
//

#import "QQBoxView.h"

@interface QQBoxView ()

@property (nonatomic, readwrite, strong) CALayer *contentLayer;
@property (nonatomic, readwrite, strong) CALayer *topLayer;
@property (nonatomic, readwrite, strong) CALayer *bottomLayer;
@property (nonatomic, readwrite, strong) CALayer *leftLayer;
@property (nonatomic, readwrite, strong) CALayer *rightLayer;
@property (nonatomic, readwrite, strong) CALayer *frontLayer;
@property (nonatomic, readwrite, strong) CALayer *backLayer;

@end

@implementation QQBoxView

const CGFloat kSize = 100.;
const CGFloat kPanScale = 1./1000.;

-(instancetype)init
{
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (CALayer *)layerWithColor:(UIColor *)color transform:(CATransform3D)transform {
    
    CALayer *layer = [CALayer layer];
    layer.backgroundColor = [color CGColor];
    layer.bounds = CGRectMake(0, 0, kSize, kSize);
    layer.position = self.center;
    layer.transform = transform;
    
    [self.layer addSublayer:layer];
    return layer;
}

static CATransform3D MakePerspetiveTransform() {
    CATransform3D perspective = CATransform3DIdentity;
    perspective.m34 = -1./2000.;
    return perspective;
}


-(void)setup
{
    self.frame = CGRectMake(0, 0, kSize, kSize);
    CATransform3D transform;
    transform = CATransform3DMakeTranslation(0, -kSize/2, 0);
    transform = CATransform3DRotate(transform, M_PI_2, 1.0, 0, 0);
    self.topLayer = [self layerWithColor:[UIColor redColor] transform:transform];
    
    transform = CATransform3DMakeTranslation(0, kSize/2, 0);
    transform = CATransform3DRotate(transform, M_PI_2, 1.0, 0, 0);
    self.bottomLayer = [self layerWithColor:[UIColor greenColor] transform:transform];
    
    transform = CATransform3DMakeTranslation(kSize/2, 0, 0);
    transform = CATransform3DRotate(transform, M_PI_2, 0, 1, 0);
    self.rightLayer = [self layerWithColor:[UIColor blueColor] transform:transform];
    
    transform = CATransform3DMakeTranslation(-kSize/2, 0, 0);
    transform = CATransform3DRotate(transform, M_PI_2, 0, 1, 0);
    self.leftLayer = [self layerWithColor:[UIColor cyanColor] transform:transform];
    
    transform = CATransform3DMakeTranslation(0, 0, -kSize/2);
    transform = CATransform3DRotate(transform, M_PI_2, 0, 0, 0);
    self.backLayer = [self layerWithColor:[UIColor yellowColor] transform:transform];
    
    transform = CATransform3DMakeTranslation(0, 0, kSize/2);
    transform = CATransform3DRotate(transform, M_PI_2, 0, 0, 0);
    self.frontLayer = [self layerWithColor:[UIColor magentaColor] transform:transform];
    
    self.layer.sublayerTransform = MakePerspetiveTransform();
    
    UIGestureRecognizer *g = [[UIPanGestureRecognizer alloc]
                              initWithTarget:self
                              action:@selector(pan:)];
    [self addGestureRecognizer:g];
    
    transform = self.layer.sublayerTransform;//MakePerspetiveTransform();
    transform = CATransform3DRotate(transform,
                                    kPanScale * 500,
                                    0, 1, 0);
    transform = CATransform3DRotate(transform,
                                    -kPanScale * 500,
                                    1, 0, 0);
    self.layer.sublayerTransform = transform;
}


- (void)pan:(UIPanGestureRecognizer *)recognizer {
    CGPoint translation = [recognizer translationInView:self];
    CATransform3D transform = self.layer.sublayerTransform;//MakePerspetiveTransform();
    transform = CATransform3DRotate(transform,
                                    kPanScale * translation.x,
                                    0, 1, 0);
    transform = CATransform3DRotate(transform,
                                    -kPanScale * translation.y,
                                    1, 0, 0);
    self.layer.sublayerTransform = transform;
}

-(void)rotateWithAngleH:(CGFloat)angle
{
    CGFloat value = angle;//（控制翻转角度）
    CATransform3D transform = self.layer.sublayerTransform;
    
    CGFloat radiants = value / 360.0 * 2 * M_PI;
    
    transform = CATransform3DRotate(transform,
                                    radiants,
                                    0, 1, 0);
    
    self.layer.sublayerTransform = transform;
}

-(void)rotateWithAngleV:(CGFloat)angle
{
    CGFloat value = angle;//（控制翻转角度）
    CATransform3D transform = self.layer.sublayerTransform;
    
    CGFloat radiants = value / 360.0 * 2 * M_PI;
    
    transform = CATransform3DRotate(transform,
                                    radiants,
                                    1, 0, 0);
    
    self.layer.sublayerTransform = transform;
}

-(void)zoomSmall:(CGFloat)scale
{
    CGFloat sizeWidth = self.bounds.size.width;
    CGFloat value = sizeWidth - sizeWidth * scale;
    self.frame = CGRectMake(0, 0, value, value);
    [self updateWithValue:value];
}

-(void)zoomLarge:(CGFloat)scale
{
    CGFloat sizeWidth = self.bounds.size.width;
    CGFloat value = sizeWidth + sizeWidth * scale;
    self.frame = CGRectMake(0, 0, value, value);
    [self updateWithValue:value];
}

-(void)updateWithValue:(CGFloat)value
{
    CATransform3D origintransform = self.layer.sublayerTransform;
    
    CATransform3D transform;
    transform = CATransform3DMakeTranslation(0, -(value)/2, 0);
    transform = CATransform3DRotate(transform, M_PI_2, 1.0, 0, 0);
    self.topLayer.bounds = CGRectMake(0, 0, value, value);
    self.topLayer.position = self.center;
    self.topLayer.transform = transform;
    
    transform = CATransform3DMakeTranslation(0, (value)/2, 0);
    transform = CATransform3DRotate(transform, M_PI_2, 1.0, 0, 0);
    self.bottomLayer.bounds = CGRectMake(0, 0, value, value);
    self.bottomLayer.position = self.center;
    self.bottomLayer.transform = transform;
    
    transform = CATransform3DMakeTranslation((value)/2, 0, 0);
    transform = CATransform3DRotate(transform, M_PI_2, 0, 1, 0);
    self.rightLayer.bounds = CGRectMake(0, 0, value, value);
    self.rightLayer.position = self.center;
    self.rightLayer.transform = transform;
    
    transform = CATransform3DMakeTranslation(-(value)/2, 0, 0);
    transform = CATransform3DRotate(transform, M_PI_2, 0, 1, 0);
    self.leftLayer.bounds = CGRectMake(0, 0, value, value);
    self.leftLayer.position = self.center;
    self.leftLayer.transform = transform;
    
    transform = CATransform3DMakeTranslation(0, 0, -(value)/2);
    transform = CATransform3DRotate(transform, M_PI_2, 0, 0, 0);
    self.backLayer.bounds = CGRectMake(0, 0, value, value);
    self.backLayer.position = self.center;
    self.backLayer.transform = transform;
    
    transform = CATransform3DMakeTranslation(0, 0, (value)/2);
    transform = CATransform3DRotate(transform, M_PI_2, 0, 0, 0);
    self.frontLayer.bounds = CGRectMake(0, 0, value, value);
    self.frontLayer.position = self.center;
    self.frontLayer.transform = transform;
    
    self.layer.sublayerTransform = origintransform;
}

@end
