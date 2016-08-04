//
//  AnnotationViewController.m
//  Tencent_Map_Demo_Vector
//
//  Created by WangXiaokun on 16/1/21.
//  Copyright © 2016年 WangXiaokun. All rights reserved.
//

#import "AnnotationViewController.h"
#import "QMapKit.h"
#import "CustomAnnotationView.h"
#import "QQ3DAnnotationView.h"

@interface AnnotationViewController () <QMapViewDelegate>

@property (nonatomic, strong) QMapView *mapView;
@property (nonatomic, strong) NSArray *annotations;
@property (nonatomic) BOOL isAnnotationAdded;

@property (nonatomic, strong)QQ3DAnnotationView *qq3DAnnotationView;
@property (nonatomic, assign)NSInteger oldZoomLevel;

@end

@implementation AnnotationViewController

- (void)initAnnotations {
    QPointAnnotation *disanji = [[QPointAnnotation alloc] init];
    disanji.coordinate = CLLocationCoordinate2DMake(22.984174,113.307632);
    disanji.title = @"中国技术交易大厦";
    disanji.subtitle = @"北京市海淀区彩和坊路北四环西路66号";
    
    
    QPointAnnotation *yinke = [[QPointAnnotation alloc] init];
    yinke.coordinate = CLLocationCoordinate2DMake(22.982127,113.306291);
    yinke.title = @"银科大厦";
    yinke.subtitle = @"北京市海淀区海淀大街38号";
    
    QPointAnnotation *custAnnotation = [[QPointAnnotation alloc] init];
    custAnnotation.coordinate = CLLocationCoordinate2DMake(22.908831,113.397486);
    custAnnotation.title = @"天安门";
    custAnnotation.subtitle = @"北京市东城区东长安街";
    
    QPointAnnotation *qq3DAnnotation = [[QPointAnnotation alloc] init];
    qq3DAnnotation.coordinate = CLLocationCoordinate2DMake(22.958831,113.357486);
    qq3DAnnotation.title = @"QQ3D";
    qq3DAnnotation.subtitle = @"QQ3D模型测试";
    
    _annotations = [NSArray arrayWithObjects:disanji, yinke, custAnnotation, qq3DAnnotation,nil];
}

- (void)initView {
    CGFloat WINDOW_WIDTH = self.view.frame.size.width;
    CGFloat WINDOW_HEIGHT = self.view.frame.size.height;
    
    CGFloat NAVI_BAR_Y = self.navigationController.navigationBar.frame.origin.y;
    CGFloat NAVI_BAR_HEIGHT = self.navigationController.navigationBar.frame.size.height;
    CGFloat NAVI_BAR_BOTTOM = NAVI_BAR_Y + NAVI_BAR_HEIGHT;
    
    UIBarButtonItem *btnAnnotation = [[UIBarButtonItem alloc]
                                      initWithTitle:@"Add Annotations"
                                      style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(annotationButtonAction:)];
    self.navigationItem.rightBarButtonItem = btnAnnotation;
    
    _mapView = [[QMapView alloc] initWithFrame:CGRectMake(0,
                                                          NAVI_BAR_BOTTOM,
                                                          WINDOW_WIDTH,
                                                          WINDOW_HEIGHT - NAVI_BAR_BOTTOM)];
    [self.view addSubview:_mapView];
    
    [_mapView setUserTrackingMode:QMUserTrackingModeFollowWithHeading];
    _mapView.delegate = self;
    _mapView.zoomLevel = 11;
    self.oldZoomLevel = 11;
    _mapView.centerCoordinate = CLLocationCoordinate2DMake(22.915003,113.394654);
}

-(QAnnotationView *)mapView:(QMapView *)mapView viewForAnnotation:(id<QAnnotation>)annotation {
    if ([annotation isKindOfClass:[QPointAnnotation class]]) {
        static NSString *annotationViewIdentifier = @"pointvView";
        static NSString *customAnnotationViewItentifier = @"custView";
        static NSString *qq3DAnnotationViewItentifier = @"qq3dView";
        if (![annotation isEqual:[_annotations objectAtIndex:2]] && ![annotation isEqual:[_annotations objectAtIndex:3]]) {
            QAnnotationView *annotationView = [_mapView dequeueReusableAnnotationViewWithIdentifier:annotationViewIdentifier];
            if (annotationView == nil) {
                annotationView = [[QPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationViewIdentifier];
                annotationView.canShowCallout = YES;
            }
            return annotationView;
        }
        if ([annotation isEqual:[_annotations objectAtIndex:2]]) {
            CustomAnnotationView *annotationView = (CustomAnnotationView *)[_mapView dequeueReusableAnnotationViewWithIdentifier:customAnnotationViewItentifier];
            if (annotationView == nil) {
                annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:customAnnotationViewItentifier];
                NSString *path = [[NSBundle mainBundle]
                                  pathForResource:@"redflag"
                                  ofType:@"png"];
                UIImage *image = [UIImage imageWithContentsOfFile:path];
                annotationView.image = image;
                annotationView.centerOffset = CGPointMake(image.size.width / 2, - image.size.height / 2);
                NSString *path1 = [[NSBundle mainBundle]
                                   pathForResource:@"tiananmen"
                                   ofType:@"png"];
                UIImage *image1 = [UIImage imageWithContentsOfFile:path1];
                [annotationView setCalloutImage:image1];
                [annotationView setCalloutBtnTitle:@"到这里去"
                                          forState:UIControlStateNormal];
                [annotationView addCalloutBtnTarget:self
                                             action:@selector(calloutButtonAction)
                                   forControlEvents:UIControlEventTouchUpInside];
                return annotationView;
            }
        }
        
        if ([annotation isEqual:[_annotations objectAtIndex:3]]) {
            self.qq3DAnnotationView = (QQ3DAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:qq3DAnnotationViewItentifier];
            if (self.qq3DAnnotationView == nil) {
                self.qq3DAnnotationView = [[QQ3DAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:qq3DAnnotationViewItentifier];
                //[self.qq3DAnnotationView updateBoxViewWithScale:0.2];
            }
           
             NSLog(@"viewForAnnotation self.mapView.rotation = %f",self.mapView.rotation);
            
            NSLog(@"viewForAnnotation self.oldZoomLevel = %zd , self.mapView.zoomLevel = %zd",self.oldZoomLevel,self.mapView.zoomLevel);
            if (self.oldZoomLevel < self.mapView.zoomLevel) {
                CGFloat value = self.mapView.zoomLevel - self.oldZoomLevel;
                [self.qq3DAnnotationView zoomLargeBoxViewWithScale:value * 0.1];
            }
            else if (self.oldZoomLevel > self.mapView.zoomLevel){
                CGFloat value = self.oldZoomLevel - self.mapView.zoomLevel;
                [self.qq3DAnnotationView zoomSmallBoxViewWithScale:value * 0.1];
            }
            
            self.oldZoomLevel = self.mapView.zoomLevel;
            
            [self.qq3DAnnotationView rotateBoxViewWithAngleH:self.mapView.rotation];
            
            return self.qq3DAnnotationView;
        }
    }
    return nil;
}

#pragma mark - actions
- (void)annotationButtonAction:(UIBarButtonItem *) barButtonItem {
    _isAnnotationAdded = !_isAnnotationAdded;
    if (_isAnnotationAdded) {
        barButtonItem.title = @"Rm Annotations";
        [_mapView addAnnotations:_annotations];
    } else {
        barButtonItem.title = @"Add Annotations";
        [_mapView removeAnnotations:_annotations];
    }
}

-(void)calloutButtonAction{
    NSString *url = @"http://apis.map.qq.com/uri/v1/routeplan?type=bus&from=我的家&fromcoord=39.980683,116.302&to=中关村&tocoord=39.9836,116.3164&policy=1&referer=myapp";
    NSMutableCharacterSet *allowedCharacters = [NSMutableCharacterSet alphanumericCharacterSet];
    [allowedCharacters addCharactersInString:@".:/,&?="];
    NSString *encodedUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
    NSLog(@"%@", encodedUrl);
    if (![[UIApplication sharedApplication] openURL:[NSURL URLWithString:encodedUrl]]) {
        NSLog(@"Failed to open url");
    }
}

#pragma mark - Life Circle
-(instancetype)init {
    self = [super init];
    if (self != nil) {
        [self initAnnotations];
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

- (void)mapView:(QMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    NSLog(@"didAddAnnotationViews");
}

- (void)mapView:(QMapView *)mapView annotationView:(QAnnotationView *)view didChangeDragState:(QAnnotationViewDragState)newState
   fromOldState:(QAnnotationViewDragState)oldState
{
    NSLog(@"didChangeDragState");
}

//- (void)mapView:(QMapView *)mapView regionWillChangeAnimated:(BOOL)animated gesture:(BOOL)bGesture
//{
//    NSLog(@"regionWillChangeAnimated zoomLevel = %zd , rotation = %f",self.mapView.zoomLevel,self.mapView.rotation);
//}
//
//-(void)mapView:(QMapView *)mapView regionDidChangeAnimated:(BOOL)animated gesture:(BOOL)bGesture
//{
//    NSLog(@"regionDidChangeAnimated zoomLevel = %zd , rotation = %f",self.mapView.zoomLevel,self.mapView.rotation);
//}

- (void)mapRegionChanged:(QMapView*)mapView
{
    NSLog(@"mapRegionChanged zoomLevel = %zd , rotation = %f",self.mapView.zoomLevel,self.mapView.rotation);
    
    //QQ3DAnnotationView *annotationView = (QQ3DAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"qq3dView"];
    
    if (self.qq3DAnnotationView) {
        NSLog(@"updateBoxViewWithScale");
        //[self.qq3DAnnotationView updateBoxViewWithScale:(1 + self.mapView.zoomLevel * 0.1)];
        
        
        [_mapView removeAnnotations:_annotations];
        
        [_mapView addAnnotations:_annotations];
    }
}

@end
