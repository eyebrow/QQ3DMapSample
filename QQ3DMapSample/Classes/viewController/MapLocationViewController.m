//
//  MapLocationViewController.m
//  Tencent_Map_Demo_Vector
//
//  Created by WangXiaokun on 16/1/22.
//  Copyright © 2016年 WangXiaokun. All rights reserved.
//

#import "MapLocationViewController.h"
#import "QMapKit.h"

@interface MapLocationViewController () <QMapViewDelegate>

@property (nonatomic, strong) QMapView *mapView;
@property (nonatomic, strong) UISegmentedControl *segmentedLocation;
@property (nonatomic, strong) UISwitch *switchLocation;
@property (nonatomic, strong) UISwitch *switchAccuracy;

@end

@implementation MapLocationViewController

- (void)initView {
#define barHeight 44
    //添加地图
    CGFloat WINDOW_WIDTH = self.view.frame.size.width;
    CGFloat WINDOW_HEIGHT = self.view.frame.size.height;
    
    CGFloat NAVI_BAR_Y = self.navigationController.navigationBar.frame.origin.y;
    CGFloat NAVI_BAR_HEIGHT = self.navigationController.navigationBar.frame.size.height;
    CGFloat NAVI_BAR_BOTTOM = NAVI_BAR_Y + NAVI_BAR_HEIGHT;
    
    _mapView = [[QMapView alloc] initWithFrame:CGRectMake(0,
                                                          NAVI_BAR_BOTTOM,
                                                          WINDOW_WIDTH,
                                                          WINDOW_HEIGHT - NAVI_BAR_BOTTOM - barHeight * 3)];
    [self.view addSubview:_mapView];
    _mapView.delegate = self;
    //设置更新位置的最小变化距离
    _mapView.distanceFilter = 10;
    //添加开启定位switch
    UIStackView *stackViewLocation = [[UIStackView alloc]
                                      initWithFrame:CGRectMake(20,
                                                               WINDOW_HEIGHT - barHeight * 3,
                                                               WINDOW_WIDTH - 40,
                                                               barHeight)];
    stackViewLocation.axis = UILayoutConstraintAxisHorizontal;
    stackViewLocation.alignment = UIStackViewDistributionEqualCentering;
    [self.view addSubview:stackViewLocation];
    
    UILabel *labelLocation = [[UILabel alloc] initWithFrame:CGRectZero];
    labelLocation.text = @"UserLocation";
    labelLocation.font = [UIFont systemFontOfSize:25];
    [stackViewLocation addArrangedSubview:labelLocation];
    
    _switchLocation = [[UISwitch alloc] initWithFrame:CGRectZero];
    _switchLocation.tag = 0;
    [_switchLocation addTarget:self action:@selector(switchLocationAction:)
              forControlEvents:UIControlEventValueChanged];
    [stackViewLocation addArrangedSubview:_switchLocation];
    //添加开启定位精度范围显示
    UIStackView *stackViewAccuracy = [[UIStackView alloc]
                                      initWithFrame:CGRectMake(20,
                                                               WINDOW_HEIGHT - barHeight * 2,
                                                               WINDOW_WIDTH - 40,
                                                               barHeight)];
    stackViewAccuracy.axis = UILayoutConstraintAxisHorizontal;
    stackViewAccuracy.alignment = UIStackViewDistributionEqualCentering;
    [self.view addSubview:stackViewAccuracy];
    UILabel *labelAccuracy = [[UILabel alloc] initWithFrame:CGRectZero];
    labelAccuracy.text = @"LocationAccuracy";
    labelAccuracy.font = [UIFont systemFontOfSize:25];
    [stackViewAccuracy addArrangedSubview:labelAccuracy];
    
    _switchAccuracy = [[UISwitch alloc] initWithFrame:CGRectZero];
    _switchAccuracy.tag = 1;
    _switchAccuracy.on = _mapView.hideAccuracyCircle;
    [_switchAccuracy addTarget:self action:@selector(switchLocationAction:)
              forControlEvents:UIControlEventValueChanged];
    [stackViewAccuracy addArrangedSubview:_switchAccuracy];
    
    //添加定位类型控制
    _segmentedLocation = [[UISegmentedControl alloc]
                          initWithItems:@[@"None", @"Follow", @"FollowWithHeading"]];
    _segmentedLocation.frame = CGRectMake(20,
                                          WINDOW_HEIGHT - 40,
                                          WINDOW_WIDTH - 40,
                                          36);
    _segmentedLocation.tintColor = [UIColor colorWithRed:0.8f
                                                   green:0.1f
                                                    blue:0.1f
                                                   alpha:1.0f];
    _segmentedLocation.enabled = _switchLocation.isOn;
    _switchAccuracy.enabled = _switchLocation.isOn;
    _segmentedLocation.selectedSegmentIndex = _mapView.userTrackingMode;
    [_segmentedLocation addTarget:self action:@selector(segmentedLocationAction:)
                 forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_segmentedLocation];
    
}

- (void)switchLocationAction:(UISwitch *) switcher {
    switch (switcher.tag) {
        case 0:
            _mapView.showsUserLocation = switcher.on;
            _segmentedLocation.enabled = switcher.on;
            _switchAccuracy.enabled = switcher.on;
            break;
        case 1:
            _mapView.hideAccuracyCircle = switcher.on;
            break;
            
        default:
            break;
    }
}

- (void)segmentedLocationAction:(UISegmentedControl *) segmentedControl {
    _mapView.userTrackingMode = segmentedControl.selectedSegmentIndex;
}

#pragma mark - map location delegate
-(void)mapViewWillStartLocatingUser:(QMapView *)mapView {
    NSLog(@"%s", __func__);
}

-(void)mapViewDidStopLocatingUser:(QMapView *)mapView {
    NSLog(@"%s", __func__);
}

-(void)mapView:(QMapView *)mapView didUpdateUserLocation:(QUserLocation *)userLocation {
    NSLog(@"%s:\n location:(%f, %f)",
          __func__,
          userLocation.location.longitude,
          userLocation.location.latitude);
}

-(void)mapView:(QMapView *)mapView didFailToLocateUserWithError:(NSError *)error {
    NSLog(@"%s:\n error no:%ld", __func__, error.code);
}

#pragma mark - Life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
