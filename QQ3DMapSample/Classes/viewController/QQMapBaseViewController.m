//
//  QQMapBaseViewController.m
//  QQ3DMapSample
//
//  Created by iprincewang on 16/8/3.
//  Copyright © 2016年 com.tencent.prince. All rights reserved.
//

#import "QQMapBaseViewController.h"
#import "QMapKit.h"

@interface QQMapBaseViewController ()<QMapViewDelegate>

@end

@implementation QQMapBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupMapView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupMapView
{
    CGFloat WINDOW_WIDTH = self.view.frame.size.width;
    CGFloat WINDOW_HEIGHT = self.view.frame.size.height;
    
    CGFloat NAVI_BAR_Y = self.navigationController.navigationBar.frame.origin.y;
    CGFloat NAVI_BAR_HEIGHT = self.navigationController.navigationBar.frame.size.height;
    CGFloat NAVI_BAR_BOTTOM = NAVI_BAR_Y + NAVI_BAR_HEIGHT;
    
    CGRect rect = CGRectMake(0,
                             NAVI_BAR_BOTTOM,
                             WINDOW_WIDTH,
                             WINDOW_HEIGHT - NAVI_BAR_BOTTOM);
    
    self.mapView = [[QMapView alloc] initWithFrame:rect];
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    
    //开启定位
    [self.mapView setShowsUserLocation:YES];
    
    [self.mapView setUserTrackingMode:QMUserTrackingModeFollowWithHeading];
    
    //缩放级别设置为10时才开始显示路况
    [self.mapView setZoomLevel:13];
    //显示路况
    [self.mapView setShowTraffic:YES];
}

#pragma mark -- QMapViewDelegate
- (void)mapView:(QMapView *)mapView didUpdateUserLocation:(QUserLocation *)userLocation {
    NSLog(@"latitude:%f, longitude:%f", userLocation.location.latitude, userLocation.location.longitude);
    
    CLLocationDegrees loc = userLocation.location.latitude;
    CLLocationDegrees lon = userLocation.location.longitude;
    
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(loc,lon)];
    
}

@end
