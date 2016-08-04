//
//  QQBoxViewController.m
//  QQ3DMapSample
//
//  Created by iprincewang on 16/8/3.
//  Copyright © 2016年 com.tencent.prince. All rights reserved.
//

#import "QQBoxViewController.h"
#import "QQBoxView.h"

@interface QQBoxViewController ()
@property(nonatomic,strong)QQBoxView *boxView;
@property(nonatomic,assign)CGFloat scale;
@end

@implementation QQBoxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self. scale = 1.0;
    
    self.boxView = [[QQBoxView alloc]init];
    
    self.boxView.center = self.view.center;
    
    [self.view addSubview:self.boxView];
    
    UIButton *addScaleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addScaleButton setTitle:@"放大" forState:UIControlStateNormal];
    [addScaleButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [addScaleButton addTarget:self action:@selector(addButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    addScaleButton.frame = CGRectMake(50, self.view.bounds.size.height - 100, 100, 50);
    [self.view addSubview:addScaleButton];
    
    
    UIButton *reScaleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [reScaleButton setTitle:@"缩小" forState:UIControlStateNormal];
    [reScaleButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [reScaleButton addTarget:self action:@selector(reButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    reScaleButton.frame = CGRectMake(self.view.bounds.size.width - 150, self.view.bounds.size.height - 100, 100, 50);
    [self.view addSubview:reScaleButton];
    
    UIButton *rotateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rotateButton setTitle:@"旋转" forState:UIControlStateNormal];
    [rotateButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [rotateButton addTarget:self action:@selector(rotateButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    rotateButton.frame = CGRectMake(self.view.bounds.size.width - 150, self.view.bounds.size.height - 200, 100, 50);
    [self.view addSubview:rotateButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addButtonAction:(id)sender
{
    [self.boxView zoomLarge:0.25];
    
    self.boxView.center = self.view.center;
}

-(void)reButtonAction:(id)sender
{
    [self.boxView zoomSmall:0.25];
    
    self.boxView.center = self.view.center;
}

-(void)rotateButtonAction:(id)sender
{
    [self.boxView rotateWithAngleH:10];
    [self.boxView rotateWithAngleV:10];
    self.boxView.center = self.view.center;
}

@end
