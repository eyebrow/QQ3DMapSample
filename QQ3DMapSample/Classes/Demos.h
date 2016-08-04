//
//  Demos.h
//  Tencent_Map_Demo_Vector
//
//  Created by WangXiaokun on 16/1/20.
//  Copyright © 2016年 WangXiaokun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Demos : NSObject

+(NSArray *)loadDemos;
+(NSDictionary *)newDemo:(Class)class withTitle:(NSString *)title andDescription:(NSString *)description;

@end
