//
//  QQ3DAnnotationView.h
//  QQ3DMapSample
//
//  Created by iprincewang on 16/8/3.
//  Copyright © 2016年 com.tencent.prince. All rights reserved.
//

#import "QPinAnnotationView.h"

@interface QQ3DAnnotationView : QPinAnnotationView

-(void)zoomSmallBoxViewWithScale:(CGFloat)scale;

-(void)zoomLargeBoxViewWithScale:(CGFloat)scale;

-(void)rotateBoxViewWithAngleH:(CGFloat)angle;

-(void)rotateBoxViewWithAngleV:(CGFloat)angle;

@end
