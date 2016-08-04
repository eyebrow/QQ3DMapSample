//
//  ViewController.m
//  Tencent_Map_Demo_Vector
//
//  Created by WangXiaokun on 16/1/20.
//  Copyright © 2016年 WangXiaokun. All rights reserved.
//

#import "MapSDKDemoViewController.h"
#import "Demos.h"
#import "QMapKit.h"

@interface MapSDKDemoViewController ()

@end

@implementation MapSDKDemoViewController {
    NSArray *_demos;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _demos = [Demos loadDemos];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Back"
                                   style:UIBarButtonItemStylePlain
                                   target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    
    self.title = [NSString stringWithFormat:@"Map SDK Demos:%@",
                  [[QAppKeyCheck alloc] init].version];
    self.tableView.autoresizingMask =
            UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewController

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _demos.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *tableViewCellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:tableViewCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:tableViewCellIdentifier];
    }
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    NSDictionary *dictionary = [_demos objectAtIndex:indexPath.row];
    cell.textLabel.text = [dictionary objectForKey:@"title"];
    cell.detailTextLabel.text = [dictionary objectForKey:@"description"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self loadDemo:indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)loadDemo:(NSUInteger) index {
    NSDictionary *dictionary = [_demos objectAtIndex:index];
    UIViewController *viewController = [[[dictionary objectForKey:@"controller"] alloc] init];
    if (viewController != nil) {
        viewController.title = [dictionary objectForKey:@"title"];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

@end
