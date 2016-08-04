//
//  DrawOnMapViewController.m
//  Tencent_Map_Demo_Vector
//
//  Created by WangXiaokun on 16/1/22.
//  Copyright © 2016年 WangXiaokun. All rights reserved.
//

#import "DrawOnMapViewController.h"
#import "QMapKit.h"
#import "QQBoxView.h"

@interface DrawOnMapViewController () <QMapViewDelegate>

@property (nonatomic, strong) QMapView *mapView;
@property (nonatomic) BOOL isGraphAdded;
@property (nonatomic, strong) NSArray *graphs;

@end

@implementation DrawOnMapViewController


#pragma mark - init
-(void)initGraph {
    //polyline 22.540721, longitude:113.933824
    CLLocationCoordinate2D lineCoords[4];
    lineCoords[0] = CLLocationCoordinate2DMake(22.980672,113.308651);
    lineCoords[1] = CLLocationCoordinate2DMake(22.968964,113.344185);
    lineCoords[2] = CLLocationCoordinate2DMake(22.937964,113.314185);
    lineCoords[3] = CLLocationCoordinate2DMake(22.915266,113.324615);
    QPolyline *polyLine = [QPolyline polylineWithCoordinates:lineCoords count:4];
    
    //polygon
    CLLocationCoordinate2D polygonPeak[3];
    polygonPeak[0] = CLLocationCoordinate2DMake(22.969753,113.419373);
    polygonPeak[1] = CLLocationCoordinate2DMake(22.935013,113.472932);
    polygonPeak[2] = CLLocationCoordinate2DMake(22.890772,113.358948);
    QPolygon *polygon = [QPolygon polygonWithCoordinates:polygonPeak count:3];
    
    //circle
    QCircle *circle = [QCircle
                       circleWithCenterCoordinate:CLLocationCoordinate2DMake(22.770749,113.445466)
                       radius:3000];
    
    _graphs = [NSArray arrayWithObjects:polyLine, polygon, circle, nil];
}

-(void)initView {
    CGFloat WINDOW_WIDTH = self.view.frame.size.width;
    CGFloat WINDOW_HEIGHT = self.view.frame.size.height;
    
    CGFloat NAVI_BAR_Y = self.navigationController.navigationBar.frame.origin.y;
    CGFloat NAVI_BAR_HEIGHT = self.navigationController.navigationBar.frame.size.height;
    CGFloat NAVI_BAR_BOTTOM = NAVI_BAR_Y + NAVI_BAR_HEIGHT;
    _mapView = [[QMapView alloc] initWithFrame:CGRectMake(0,
                                                          NAVI_BAR_BOTTOM,
                                                          WINDOW_WIDTH,
                                                          WINDOW_HEIGHT - NAVI_BAR_BOTTOM)];

    [_mapView setUserTrackingMode:QMUserTrackingModeFollowWithHeading];
    _mapView.centerCoordinate = CLLocationCoordinate2DMake(22.922376,113.396027);
    _mapView.zoomLevel = 11;
    //[self.mapView setShowTraffic:YES];
    [self.view addSubview:_mapView];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]
                                initWithTitle:@"Add Graph"
                                style:UIBarButtonItemStylePlain
                                target:self
                                action:@selector(barButtonAction:)];
    self.navigationItem.rightBarButtonItem = barItem;
    _mapView.delegate = self;
}

-(void)barButtonAction:(UIBarButtonItem *) barButtonItem {
    _isGraphAdded = !_isGraphAdded;
    if (_isGraphAdded) {
        barButtonItem.title = @"Rm Graph";
        [_mapView addOverlays:_graphs];
    } else {
        barButtonItem.title = @"Add Graph";
        [_mapView removeOverlays:_graphs];
    }
}

-(QOverlayView *)mapView:(QMapView *)mapView
          viewForOverlay:(id<QOverlay>)overlay {
    if ([overlay isKindOfClass:[QPolyline class]]) {
        QPolylineView *polylineView = [[QPolylineView alloc] initWithPolyline:overlay];
        polylineView.lineWidth = 5.0f;
        polylineView.strokeColor = [UIColor redColor];
        return polylineView;
    }
    if ([overlay isKindOfClass:[QPolygon class]]) {
        QPolygonView *polygonView = [[QPolygonView alloc] initWithPolygon:overlay];
        polygonView.strokeColor = [UIColor colorWithRed:1.0f
                                                  green:0.0f
                                                   blue:0.0f
                                                  alpha:0.5f];
        polygonView.fillColor = [UIColor colorWithRed:0.0f
                                                green:1.0f
                                                 blue:0.0f
                                                alpha:0.3f];
        polygonView.lineWidth = 5.0f;
        
        QQBoxView *boxView = [[QQBoxView alloc]init];
        
        boxView.center = CGPointMake(polygonView.bounds.size.width/2, polygonView.bounds.size.height/2);
        
        [polygonView addSubview:boxView];
        
        return polygonView;
    }
    if ([overlay isKindOfClass:[QCircle class]]) {
        QCircleView *circleView = [[QCircleView alloc] initWithCircle:overlay];
        circleView.strokeColor = [UIColor colorWithRed:1.0f
                                                 green:0.0f
                                                  blue:0.0f
                                                 alpha:0.5f];
        circleView.fillColor = [UIColor colorWithRed:0.0f
                                               green:0.0f
                                                blue:0.5f
                                               alpha:0.3f];
        return circleView;
    }
    return nil;
}

#pragma mark - Life circle

-(instancetype)init {
    self = [super init];
    if (self != nil) {
        [self initGraph];
        _isGraphAdded = NO;
    }
    return self;
}

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
