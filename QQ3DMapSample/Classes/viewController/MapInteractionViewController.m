//
//  MapInteractionViewController.m
//  Tencent_Map_Demo_Vector
//
//  Created by WangXiaokun on 16/1/22.
//  Copyright © 2016年 WangXiaokun. All rights reserved.
//

#import "MapInteractionViewController.h"
#import "QMapKit.h"

@interface MapInteractionViewController ()

@property (nonatomic, strong) NSArray *controls;

@end

@implementation MapInteractionViewController

enum {
    SwitchTypeScroll,
    SwitchTypeZoom,
    SwitchTypeCompass,
    SwitchTypePintch,
    SwitchTypeCentered
};

- (void)initControlPanel {
#define cellmargin 5
#define cellheight  44
#define cellwidth 72
#define switchY 5
    
    UILabel *labelScroll = [[UILabel alloc] initWithFrame:
                            CGRectMake(cellmargin,
                                       0,
                                       cellwidth,
                                       cellheight)];
    labelScroll.text = @"平移";
    UISwitch *switchScroll = [[UISwitch alloc] initWithFrame:
                              CGRectMake(cellmargin + cellwidth,
                                         switchY,
                                         cellwidth,
                                         cellheight)];
    switchScroll.tag = SwitchTypeScroll;
    switchScroll.on = YES;
    [switchScroll addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    
    UILabel *labelZoom = [[UILabel alloc] initWithFrame:
                          CGRectMake(cellmargin + 2 * cellwidth,
                                     0,
                                     cellwidth,
                                     cellheight)];
    labelZoom.text = @"缩放";
    UISwitch *switchZoom = [[UISwitch alloc] initWithFrame:
                            CGRectMake(cellmargin + 3 * cellwidth,
                                       switchY,
                                       cellwidth,
                                       cellheight)];
    switchZoom.tag = SwitchTypeZoom;
    switchZoom.on = YES;
    [switchZoom addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    
    UILabel *labelCompass = [[UILabel alloc] initWithFrame:
                             CGRectMake(cellmargin + 4 * cellwidth,
                                        0,
                                        cellwidth,
                                        cellheight)];
    labelCompass.text = @"指南针";
    UISwitch *switchCompass = [[UISwitch alloc] initWithFrame:
                            CGRectMake(cellmargin + 5 * cellwidth,
                                       switchY,
                                       cellwidth,
                                       cellheight)];
    switchCompass.tag = SwitchTypeCompass;
    switchCompass.on = YES;
    [switchCompass addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    
    UILabel *labelPintch = [[UILabel alloc] initWithFrame:
                            CGRectMake(cellmargin + 6 * cellwidth,
                                       0,
                                       cellwidth,
                                       cellheight)];
    labelPintch.text = @"3D手势";
    UISwitch *switchPintch = [[UISwitch alloc] initWithFrame:
                              CGRectMake(cellmargin + 7 * cellwidth,
                                         switchY,
                                         cellwidth,
                                         cellheight)];
    switchPintch.tag = SwitchTypePintch;
    switchPintch.on = YES;
    [switchPintch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    
    UILabel *labelCentered = [[UILabel alloc] initWithFrame:
                              CGRectMake(cellmargin + 8 * cellwidth,
                                         0,
                                         cellwidth,
                                         cellheight)];
    labelCentered.text = @"中心点缩放";
    UISwitch *switchCentered = [[UISwitch alloc] initWithFrame:
                                CGRectMake(cellmargin + 9 * cellwidth,
                                           switchY,
                                           cellwidth,
                                           cellheight)];
    switchCentered.tag = SwitchTypeCentered;
    switchCentered.on = NO;
    [switchCentered addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    
    _controls = [NSArray arrayWithObjects:labelScroll, switchScroll, labelZoom, switchZoom, labelCompass, switchCompass, labelPintch, switchPintch, labelCentered, switchCentered, nil];
    
    for (UIView *view in _controls) {
        [view sizeToFit];
    }
}

- (void)initView {
    CGFloat WINDOW_WIDTH = self.view.frame.size.width;
    CGFloat WINDOW_HEIGHT = self.view.frame.size.height;
    CGFloat BACKVIEW_HEIGHT = 44;
    
    CGFloat NAVI_BAR_Y = self.navigationController.navigationBar.frame.origin.y;
    CGFloat NAVI_BAR_HEIGHT = self.navigationController.navigationBar.frame.size.height;
    
    UIScrollView *panel = [[UIScrollView alloc] initWithFrame:
                           CGRectMake(0,
                                      WINDOW_HEIGHT - BACKVIEW_HEIGHT,
                                      WINDOW_WIDTH,
                                      BACKVIEW_HEIGHT)];
    
    [panel setPagingEnabled:true];
    [panel setContentSize:CGSizeMake(cellwidth * 10, cellheight)];
    UIEdgeInsets insets = UIEdgeInsetsMake(5, 5, 0, 5);
    panel.contentInset = insets;
    
    UIStackView *stackView = [[UIStackView alloc] initWithFrame:CGRectZero];
    for (UIView *view in _controls) {
        [stackView addArrangedSubview:view];
    }
    stackView.axis = UILayoutConstraintAxisHorizontal;
    stackView.distribution = UIStackViewDistributionEqualSpacing;
    stackView.spacing = 5;
    stackView.alignment = UIStackViewAlignmentCenter;
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    [panel addSubview:stackView];
    NSDictionary *viewDict = NSDictionaryOfVariableBindings(stackView);
    [panel addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[stackView]|" options:0 metrics:0 views:viewDict]];
    [panel addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[stackView]|" options:0 metrics:0 views:viewDict]];
    [self.view addSubview:panel];
}

- (void)switchAction:(UISwitch *) switcher {
    switch (switcher.tag) {
        case SwitchTypeScroll:
            self.mapView.scrollEnabled = switcher.isOn;
            break;
        case SwitchTypeZoom:
            self.mapView.zoomEnabled = switcher.isOn;
            break;
        case SwitchTypeCompass:
            self.mapView.showsCompass = switcher.isOn;
            break;
        case SwitchTypePintch:
            self.mapView.pitchEnabled = switcher.isOn;
            break;
        case SwitchTypeCentered:
            self.mapView.stayCenteredDuringZoom = switcher.isOn;
        default:
            break;
    }
}

#pragma mark - Life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initControlPanel];
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
