//
//  HeatMapViewController.m
//  Tencent_Map_Demo_Vector
//
//  Created by WangXiaokun on 16/3/14.
//  Copyright © 2016年 WangXiaokun. All rights reserved.
//

#import "HeatMapViewController.h"
#import "QMapKit.h"
#import "CustomHeatTileOverlay.h"

@interface HeatMapViewController () <QMapViewDelegate>

@property (strong, nonatomic) QMapView *mapView;
@property (weak, nonatomic) CustomHeatTileOverlay *custHeatOverlay;

@end

@implementation HeatMapViewController

- (void)initView {
    CGFloat WINDOW_WIDTH = self.view.bounds.size.width;
    CGFloat WINDOW_HEIGHT = self.view.bounds.size.height;
    
    CGFloat NAVI_BAR_Y = self.navigationController.navigationBar.frame.origin.y;
    CGFloat NAVI_BAR_HEIGHT = self.navigationController.navigationBar.frame.size.height;
    CGFloat NAVI_BAR_BOTTOM = NAVI_BAR_Y + NAVI_BAR_HEIGHT;
    
    _mapView = [[QMapView alloc] initWithFrame:CGRectMake(0,
                                                          NAVI_BAR_BOTTOM,
                                                          WINDOW_WIDTH,
                                                          WINDOW_HEIGHT - NAVI_BAR_BOTTOM)];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]
                                initWithTitle:@"Add HeatOverlay"
                                style:UIBarButtonItemStylePlain
                                target:self
                                action:@selector(barButtonAciton:)];
    self.navigationItem.rightBarButtonItem = barItem;
    
    [self.view addSubview:_mapView];
}

- (void) barButtonAciton:(UIBarButtonItem *)barButtonItem {
    if (_custHeatOverlay == nil) {
        [self addHeatOverlay];
        barButtonItem.title = @"Remove HeatOverlay";
    } else {
        [_mapView removeTileOverlay:_custHeatOverlay];
        _custHeatOverlay = nil;
        barButtonItem.title = @"Add HeatOverlay";
    }
}

- (void) addHeatOverlay {
    //从resource文件heat_map_nodes.txt读取热力图节点
    NSMutableArray *heatNots = [NSMutableArray arrayWithCapacity:10];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"heat_map_nodes"
                                                         ofType:@"txt"];
    NSString *fileContent = [NSString stringWithContentsOfFile:filePath
                                                      encoding:NSUTF8StringEncoding
                                                         error:nil];
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"\t\n"];
    NSArray *datas = [fileContent componentsSeparatedByCharactersInSet:characterSet];
    QHeatTileNode *node = nil;
    CLLocationDegrees latitude = 0;
    CLLocationDegrees longitude = 0;
    CGFloat hotValue;
    double scanedDouble;
    for (int i = 0; i < [datas count]; i++) {
        NSScanner *scanner = [NSScanner scannerWithString:(NSString *)datas[i]];
        if (![scanner scanDouble:&scanedDouble]) {
            break;
        }
        
        switch (i % 3) {
            case 0:
                longitude = scanedDouble;
                break;
            case 1:
                latitude = scanedDouble;
                break;
            case 2:
                hotValue = scanedDouble;
                node = [[QHeatTileNode alloc] init];
                node.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
                node.value = hotValue;
                [heatNots addObject:node];
                break;
                
            default:
                break;
        }
    }
    
    //使用自定义HeatOverlay展示热力图
    _custHeatOverlay = [[CustomHeatTileOverlay alloc] initWithHeatTileNodes:heatNots];
    [_mapView addTileOverlay:_custHeatOverlay];
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
