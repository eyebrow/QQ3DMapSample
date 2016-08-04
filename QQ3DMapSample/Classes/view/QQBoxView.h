//
//  QQBoxView.h
//  QQ3DMapSample
//
//  Created by iprincewang on 16/8/3.
//  Copyright © 2016年 com.tencent.prince. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QQBoxView : UIView

-(void)rotateWithAngleH:(CGFloat)angle;//水平旋转
-(void)rotateWithAngleV:(CGFloat)angle;//垂直旋转

-(void)zoomSmall:(CGFloat)scale;//缩小
-(void)zoomLarge:(CGFloat)scale;//放大
@end
