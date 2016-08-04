//
//  CustomCalloutView.h
//  Tencent_Map_Demo_Vector
//
//  Created by WangXiaokun on 16/1/21.
//  Copyright © 2016年 WangXiaokun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCalloutView : UIView

-(void)setTitle:(NSString *)title;

-(void)setSubtitle:(NSString *)subtitle;

-(void)setImage:(UIImage *)image;

-(void)setBtnTitle:(NSString *)text forState:(UIControlState)state;

-(void)btnAddTarget:(id)target
             action:(SEL)action
   forControlEvents:(UIControlEvents)evnets;

@end
