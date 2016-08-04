//
//  CustomAnnotationView.h
//  Tencent_Map_Demo_Vector
//
//  Created by WangXiaokun on 16/1/21.
//  Copyright © 2016年 WangXiaokun. All rights reserved.
//

#import "QPinAnnotationView.h"

@interface CustomAnnotationView : QPinAnnotationView

-(void)setCalloutImage:(UIImage *)image;

-(void)setCalloutBtnTitle:(NSString *)title
                 forState:(UIControlState)state;

-(void)addCalloutBtnTarget:(id)target
                    action:(SEL)action
          forControlEvents:(UIControlEvents)events;
@end
