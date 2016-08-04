//
//  NavigationViewController.m
//  Tencent_Map_Demo_Vector
//
//  Created by WangXiaokun on 16/2/23.
//  Copyright © 2016年 WangXiaokun. All rights reserved.
//

#import "NavigationViewController.h"
#import "QMapKit.h"
#import <QMapSearchKit/QMapSearchKit.h>

@interface NavigationViewController () <QMapViewDelegate, QSearchDelegate, QMapNavigationDelegate, UIGestureRecognizerDelegate, UISearchBarDelegate,
UITableViewDelegate, UITableViewDataSource, QMSSearchDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITableView *tvSuggestion;

@property (nonatomic, strong) QMapView *mapView;
@property (nonatomic, strong) QMSSearcher *searcher;
@property (nonatomic, strong) QSearch *qSearch;

@property (nonatomic, strong) QPlaceInfo *startInfo;
@property (nonatomic, strong) QPlaceInfo *endInfo;
@property (nonatomic, strong) QMSSuggestionResult *suggestionResult;

@end

@implementation NavigationViewController

#pragma mark - QMSSearchDelegate

-(void)searchWithSuggestionSearchOption:(QMSSuggestionSearchOption *)suggestionSearchOption didReceiveResult:(QMSSuggestionResult *)suggestionSearchResult {
    _suggestionResult = suggestionSearchResult;
    [_tvSuggestion reloadData];
}

#pragma mark - UITableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _suggestionResult.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"TableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:cellIdentifier];
    }
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    QMSSuggestionPoiData *suggestionData =(QMSSuggestionPoiData *)[_suggestionResult.dataArray objectAtIndex:indexPath.row];
    cell.textLabel.text = suggestionData.title;
    cell.detailTextLabel.text = suggestionData.address;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_searchBar resignFirstResponder];
    QMSSuggestionPoiData *data =(QMSSuggestionPoiData *)[_suggestionResult.dataArray objectAtIndex:indexPath.row];
    _searchBar.text = data.title;
    if (_endInfo == nil) {
        _endInfo = [[QPlaceInfo alloc] init];
    }
    _endInfo.coordinate = data.location;
    if (_mapView.isNavigation) {
        [_mapView stopNavigation];
    }
    [_qSearch navRouteSearchWithLocation:_startInfo end:_endInfo withDriveSearchType:QDriveSearchShortTime noHighway:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    tableView.hidden = YES;
    _suggestionResult = [[QMSSuggestionResult alloc] init];
    [tableView reloadData];
}

#pragma mark - UISearchBarDelegate

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    _searchBar.text = @"";
    [self showTvSuggestion];
    return YES;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        return;
    }
    QMSSuggestionSearchOption *suggestionOption = [[QMSSuggestionSearchOption alloc] init];
    suggestionOption.keyword = searchText;
    [_searcher searchWithSuggestionSearchOption:suggestionOption];
}

#pragma mark - UIGestureRecognizerDelegate

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return ![touch.view isDescendantOfView:_tvSuggestion];
}

#pragma mark - QSearchDelegate

-(void)userTrackingModeNone {
    
}

-(void)showRouteFinished {
    
}

-(void)userLocationErr:(NSString *)locationErr {
    
}

- (void)userNavigationEnd:(BOOL)bFinished {
    _mapView.navDelegate = nil;
}

-(void)updateRouteResult:(QRoute *)routeResult{
    
}

- (void)returnTTSValue:(NSString *)ttsValue {
    NSLog(@"%@", ttsValue);
}

-(void)notifyNavRouteSearchDidFailWithError:(NSError *)error {
    switch (error.code) {
        case QNotFound:
            NSLog(@"route not found");
            break;
        case QNetError:
            NSLog(@"route search net error");
            
        default:
            break;
    }
}

-(void)notifyNavRouteSearchResult:(QRouteResult *)routeSearchResult {
    if (routeSearchResult == nil) {
        return;
    }
    if (routeSearchResult.isTypeCar) {
        [_mapView showSearchRoute:routeSearchResult routeColor:RC_TRAFFIC];
        [_mapView startNavigation];
        _mapView.navDelegate = self;
    }
}

#pragma mark - QMapViewDelegate

-(void)mapView:(QMapView *)mapView didUpdateUserLocation:(QUserLocation *)userLocation {
    if (_startInfo == nil) {
        _startInfo = [[QPlaceInfo alloc] init];
    }
    _startInfo.coordinate = userLocation.coordinate;
    _mapView.userTrackingMode = QMUserTrackingModeNone;
}

#pragma mark - set view

- (void)showTvSuggestion {
    if (_tvSuggestion == nil) {
        _tvSuggestion = [[UITableView alloc] init];
        [self.view addSubview:_tvSuggestion];
        _tvSuggestion.translatesAutoresizingMaskIntoConstraints = NO;
        [_tvSuggestion.topAnchor constraintEqualToAnchor:_searchBar.bottomAnchor].active = YES;
        [_tvSuggestion.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
        [_tvSuggestion.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = YES;
        [_tvSuggestion.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = YES;
        _tvSuggestion.dataSource = self;
        _tvSuggestion.delegate = self;
        _tvSuggestion.backgroundColor = [UIColor whiteColor];
    }
    _tvSuggestion.hidden = NO;
}

- (void)initView {
    [self setUpSearchBar];
    [self setUpMap];
}

- (void)setUpSearchBar {
    if (_searchBar != nil) {
        return;
    }
    CGFloat ySearch = self.navigationController.navigationBar.frame.origin.y +
    self.navigationController.navigationBar.bounds.size.height;
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0,
                                                               ySearch,
                                                               self.view.bounds.size.width,
                                                               44)];
    [self.view addSubview:_searchBar];
    _searchBar.delegate = self;
}

- (void)setUpMap {
    if (_mapView != nil) {
        return;
    }
    
    CGFloat yMapView = _searchBar.frame.origin.y + _searchBar.frame.size.height;
    _mapView = [[QMapView alloc] initWithFrame:CGRectMake(0,
                                                          yMapView,
                                                          self.view.bounds.size.width,
                                                          self.view.bounds.size.height - yMapView)];
    [self.view addSubview:_mapView];
    _mapView.zoomLevel = 13;
    _mapView.delegate = self;
    
    _searcher = [[QMSSearcher alloc] init];
    _searcher.delegate = self;
    
    _qSearch = [[QSearch alloc] init];
    _qSearch.delegate = self;
    
    _mapView.showsUserLocation = YES;
    [_mapView setUserTrackingMode:QMUserTrackingModeFollow];
    
    UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc]
                                                initWithTarget:self
                                                action:@selector(singleTapAction:)];
    singleTapGesture.delegate = self;
    [self.view addGestureRecognizer:singleTapGesture];
}

#pragma mark - actions

- (void)singleTapAction:(UITapGestureRecognizer *) tapGestureRecognizer {
    BOOL isTapInSearchBar = [_searchBar pointInside:[tapGestureRecognizer locationInView:_searchBar] withEvent:UIEventTypeTouches];
    if (isTapInSearchBar) {
        [_searchBar becomeFirstResponder];
    } else {
        [_searchBar resignFirstResponder];
        _tvSuggestion.hidden = YES;
    }
}

#pragma mark - Life Cicle

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
