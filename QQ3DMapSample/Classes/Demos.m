//
//  Demos.m
//  Tencent_Map_Demo_Vector
//
//  Created by WangXiaokun on 16/1/20.
//  Copyright © 2016年 WangXiaokun. All rights reserved.
//

#import "Demos.h"
#import "QQMap3DViewController.h"
#import "BasicMapViewController.h"
#import "MapLocationViewController.h"
#import "AnnotationViewController.h"
#import "MapTypeViewController.h"
#import "MapStatusViewController.h"
#import "MapInteractionViewController.h"
#import "DrawOnMapViewController.h"
#import "NavigationViewController.h"
#import "HeatMapViewController.h"

#import "QQBoxViewController.h"

@implementation Demos

+(NSArray *)loadDemos {
    NSArray *mapDemos =
    @[[self newDemo:[QQMap3DViewController class]
          withTitle:@"Current Location" andDescription:@"当前位置"],
    [self newDemo:[BasicMapViewController class]
        withTitle:@"Basic Map" andDescription:@"显示地图"],
    [self newDemo:[MapTypeViewController class]
        withTitle:@"Map Type" andDescription:@"底图设置及实时交通"],
    [self newDemo:[MapInteractionViewController class]
        withTitle:@"Map Interaction" andDescription:@"地图交互控制"],
    [self newDemo:[MapStatusViewController class]
        withTitle:@"Map Status" andDescription:@"获取地图当前视图及地图视图变化委托设置"],
    [self newDemo:[MapLocationViewController class]
        withTitle:@"Map Location" andDescription:@"腾讯地图封装的定位接口"],
    [self newDemo:[DrawOnMapViewController class]
        withTitle:@"Draw On Map" andDescription:@"在地图上绘制几何图形"],
    [self newDemo:[AnnotationViewController class]
        withTitle:@"Annotations" andDescription:@"Annotation的使用"],
    [self newDemo:[NavigationViewController class]
        withTitle:@"Navigation" andDescription:@"地图SDK提供的导航功能"],
    [self newDemo:[HeatMapViewController class]
        withTitle:@"Heat Map" andDescription:@"地图提供的热力图功能的展示"],
    [self newDemo:[QQBoxViewController class]
        withTitle:@"Box View" andDescription:@"正立方体图形"]];
    
    return mapDemos;
}

+(NSDictionary *)newDemo:(Class)class withTitle:(NSString *)title andDescription:(NSString *)description {
    return [[NSDictionary alloc] initWithObjectsAndKeys:
            class, @"controller",
            title, @"title",
            description, @"description", nil];
}

@end
