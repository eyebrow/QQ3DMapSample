//
//  BasicMapViewController.m
//  Tencent_Map_Demo_Vector
//
//  Created by WangXiaokun on 16/1/20.
//  Copyright © 2016年 WangXiaokun. All rights reserved.
//

#import "BasicMapViewController.h"
#import "QMapKit.h"

@interface BasicMapViewController ()<UIGestureRecognizerDelegate>

//@property (nonatomic, strong) QMapView *mapView;

@end

@implementation BasicMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGFloat WINDOW_WIDTH = self.view.frame.size.width;
    CGFloat WINDOW_HEIGHT = self.view.frame.size.height;
    
    CGFloat NAVI_BAR_Y = self.navigationController.navigationBar.frame.origin.y;
    CGFloat NAVI_BAR_HEIGHT = self.navigationController.navigationBar.frame.size.height;
    CGFloat NAVI_BAR_BOTTOM = NAVI_BAR_Y + NAVI_BAR_HEIGHT;
    
    self.mapView.frame = CGRectMake(0,
                                    NAVI_BAR_BOTTOM,
                                    WINDOW_WIDTH,
                                    WINDOW_HEIGHT - NAVI_BAR_BOTTOM);
    
//    _mapView = [[QMapView alloc] initWithFrame:CGRectMake(0,
//                                                          NAVI_BAR_BOTTOM,
//                                                          WINDOW_WIDTH,
//                                                          WINDOW_HEIGHT - NAVI_BAR_BOTTOM)];
//    [self.view addSubview:_mapView];
//    
//    //[self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(39.920269,116.390533)];
//    //开启定位
//    [self.mapView setShowsUserLocation:YES];
//    
//    [self.mapView setZoomLevel:13];
    
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                                 initWithTarget:self
                                                 action:@selector(gestureRecognizerAction:)];
    
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(gestureRecognizerAction:)];
    UIRotationGestureRecognizer *rotationGestureRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(gestureRecognizerAction:)];
    
    tapGestureRecognizer.delegate = self;
    longPressGestureRecognizer.delegate = self;
    rotationGestureRecognizer.delegate = self;
    [self.mapView addGestureRecognizer:tapGestureRecognizer];
    [self.mapView addGestureRecognizer:longPressGestureRecognizer];
    [self.mapView addGestureRecognizer:rotationGestureRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)gestureRecognizerAction:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isKindOfClass: [UITapGestureRecognizer class]]) {
        CGPoint point = [gestureRecognizer locationOfTouch:0 inView:self.mapView];
        NSLog(@"tap at:(%f,%f)", point.x, point.y);
    }
    if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
        CGPoint point = [gestureRecognizer locationOfTouch:0 inView:self.mapView];
        NSLog(@"long press at:(%f,%f)", point.x, point.y);
    }
    if ([gestureRecognizer isKindOfClass:[UIRotationGestureRecognizer class]]) {
        if (self.mapView.show3D) {
            return;
        }
        CGFloat degree = - 180 *
        ((UIRotationGestureRecognizer *)gestureRecognizer).rotation / M_PI;
        [self.mapView setRotate:degree animated:NO];
    }
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
