//
//  MapStatusViewController.m
//  Tencent_Map_Demo_Vector
//
//  Created by WangXiaokun on 16/1/22.
//  Copyright © 2016年 WangXiaokun. All rights reserved.
//

#import "MapStatusViewController.h"
#import "QMapKit.h"

@interface MapStatusViewController () <QMapViewDelegate>

@property (nonatomic, strong) UILabel *labelZoomLevel;
@property (nonatomic, strong) UILabel *labelCenter;
@property (nonatomic, strong) UILabel *labelRegion;
@property (nonatomic, strong) UILabel *labelRect;

@end

@implementation MapStatusViewController

- (void) initView {
    CGFloat WINDOW_WIDTH = self.view.frame.size.width;
    CGFloat WINDOW_HEIGHT = self.view.frame.size.height;
    
    CGFloat NAVI_BAR_Y = self.navigationController.navigationBar.frame.origin.y;
    CGFloat NAVI_BAR_HEIGHT = self.navigationController.navigationBar.frame.size.height;

    UIStackView *stackView = [[UIStackView alloc]
                              initWithFrame:CGRectMake(0,
                                                       WINDOW_HEIGHT - 250,
                                                       WINDOW_WIDTH,
                                                       250)];
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.spacing = 5;
    stackView.distribution = UIStackViewDistributionFillProportionally;
    [self.view addSubview:stackView];
    
    _labelZoomLevel = [[UILabel alloc] initWithFrame:
                       CGRectMake(5, 0, WINDOW_WIDTH, 36)];
    _labelZoomLevel.numberOfLines = 0;
    [stackView addArrangedSubview:_labelZoomLevel];
    
    _labelCenter = [[UILabel alloc] initWithFrame:
                    CGRectMake(5, 0, WINDOW_WIDTH, 36)];
    [stackView addArrangedSubview:_labelCenter];
    
    _labelRegion = [[UILabel alloc] initWithFrame:CGRectMake(5,
                                                             0,
                                                             WINDOW_WIDTH,
                                                             36)];
    _labelRegion.numberOfLines = 0;
    [stackView addArrangedSubview:_labelRegion];
    
    _labelRect = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                           0,
                                                           WINDOW_WIDTH,
                                                           36)];
    _labelRect.numberOfLines = 0;
    [stackView addArrangedSubview:_labelRect];
    [self setLabelText];
}

- (void)setLabelText{
    _labelZoomLevel.text = [NSString stringWithFormat:
                            @"ZoomLevel：%ld\n",
                            (long)self.mapView.zoomLevel];
    
    _labelCenter.text = [NSString stringWithFormat:@"MapCenter：%f,%f",
                         self.mapView.centerCoordinate.latitude,
                         self.mapView.centerCoordinate.longitude];
    
    _labelRegion.text = [NSString stringWithFormat:
                         @"Region:\ncenter:[%f,%f]\nspan:[%f,%f]",
                         self.mapView.region.center.latitude,
                         self.mapView.region.center.longitude,
                         self.mapView.region.span.latitudeDelta,
                         self.mapView.region.span.longitudeDelta];
    _labelRect.text = [NSString stringWithFormat:
                       @"Rect:\norigion:[%f,%f]\nsize:[%f,%f]",
                       self.mapView.visibleMapRect.origin.x,
                       self.mapView.visibleMapRect.origin.y,
                       self.mapView.visibleMapRect.size.width,
                       self.mapView.visibleMapRect.size.height];
    
}

#pragma mark - Map Delegate

- (void)mapView:(QMapView *)mapView regionWillChangeAnimated:(BOOL)animated gesture:(BOOL)bGesture {
    [self setLabelText];
}

-(void)mapView:(QMapView *)mapView regionDidChangeAnimated:(BOOL)animated gesture:(BOOL)bGesture {
    [self setLabelText];
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
    [self initView];
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
