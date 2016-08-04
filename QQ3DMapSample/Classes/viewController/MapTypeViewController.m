//
//  MapTypeViewController.m
//  Tencent_Map_Demo_Vector
//
//  Created by WangXiaokun on 16/1/22.
//  Copyright © 2016年 WangXiaokun. All rights reserved.
//

#import "MapTypeViewController.h"
#import "QMapKit.h"

@interface MapTypeViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIStackView *stackView;

@property (nonatomic) UIView *backView;
@property (nonatomic) UISwitch *satellite;
@property (nonatomic) UISwitch *traffic;

@end

@implementation MapTypeViewController

- (void)initView {
    CGFloat WINDOW_WIDTH = self.view.frame.size.width;
    CGFloat WINDOW_HEIGHT = self.view.frame.size.height;
    CGFloat BACKVIEW_HEIGHT = 44;
    
    _satellite = [[UISwitch alloc] initWithFrame:CGRectZero];
    [_satellite addTarget:self
                   action:@selector(satelliteChanged:)
         forControlEvents:UIControlEventValueChanged];
    _traffic =[[UISwitch alloc] initWithFrame:CGRectZero];
    [_traffic addTarget:self
                 action:@selector(trafficChanged:)
       forControlEvents:UIControlEventValueChanged];
    
    
    UILabel *labelSatellite = [[UILabel alloc] initWithFrame:CGRectMake(2, 2, 72, 24)];
    labelSatellite.text = @"卫星底图";
    UILabel *labelTraffic = [[UILabel alloc] initWithFrame:CGRectMake(2, 2, 72, 24)];
    labelTraffic.text = @"实时交通";
    
    CGFloat stackSpacing = 10;
    CGFloat stackWidth = labelSatellite.frame.size.width +
    labelTraffic.frame.size.width +
    _satellite.frame.size.width +
    _traffic.frame.size.width +
    3 * stackSpacing;
    
    _backView = [[UIView alloc] initWithFrame:CGRectMake(0, WINDOW_HEIGHT - BACKVIEW_HEIGHT, WINDOW_WIDTH, BACKVIEW_HEIGHT)];
    _backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_backView];
    
    _stackView = [[UIStackView alloc] initWithFrame:CGRectMake((WINDOW_WIDTH - stackWidth) / 2, 0, stackWidth, BACKVIEW_HEIGHT)];
    _stackView.axis = UILayoutConstraintAxisHorizontal;
    _stackView.spacing = stackSpacing;
    _stackView.alignment = UIStackViewAlignmentCenter;
    [_stackView addArrangedSubview:labelSatellite];
    [_stackView addArrangedSubview:_satellite];
    [_stackView addArrangedSubview:labelTraffic];
    [_stackView addArrangedSubview:_traffic];
    [_backView addSubview:_stackView];
}

-(void) satelliteChanged:(id)sender {
    if ([_satellite isOn]) {
        self.mapView.mapType = QMapTypeSatellite;
    } else {
        self.mapView.mapType = QMapTypeStandard;
    }
}

-(void) trafficChanged:(id)sender {
    self.mapView.showTraffic = [_traffic isOn];
}

- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    
    
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    
    
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    
    UIGraphicsEndImageContext();
    return scaledImage;
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

@end
