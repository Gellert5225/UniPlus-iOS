//
//  UserQuestionPostTableViewController.m
//  UniPlus
//
//  Created by Jiahe Li on 09/07/2017.
//  Copyright © 2017 Quicky Studio. All rights reserved.
//

#import "UserQuestionPostTableViewController.h"
#import "LoadMoreCell.h"
#import "QuestionOverviewCell.h"
#import "NoQuestionsCell.h"
#import "UPNavigationBarTitleView.h"
#import <PopupDialog/PopupDialog-Swift.h>
#import <GKFadeNavigationController/GKFadeNavigationController.h>
#import "UniPlus-Swift.h"

#define COLOR_SCHEME [UIColor colorWithRed:53/255.0 green:111/255.0 blue:177/255.0 alpha:1.0]

@interface UserQuestionPostTableViewController ()<PZPullToRefreshDelegate, GKFadeNavigationControllerDelegate>

@property (strong, nonatomic) NSMutableDictionary *cellHeightsDictionary;
@property (nonatomic) BOOL viewIsLoadingForTheFirstTime;

@end

@implementation UserQuestionPostTableViewController {
    PZPullToRefreshView *refreshControl;
}

- (NSMutableDictionary *)cellHeightsDictionary {
    if (!_cellHeightsDictionary) {
        _cellHeightsDictionary = [[NSMutableDictionary alloc]init];
    }
    return _cellHeightsDictionary;
}

- (id)initWithStyle:(UITableViewStyle)style queryUser:(PFUser *)user {
    self = [super initWithStyle:style];
    if (self) {
        self.parseClassName = @"Feeds";
        self.loadingViewEnabled = NO;
        self.pullToRefreshEnabled = NO;
        self.paginationEnabled = YES;
        self.user = user;
        self.objectsPerPage = 20;
    }
    return self;
}

- (PFQuery *)queryForTable {
    PFRelation *feedsRelation = [_user relationForKey:@"feeds"];
    PFQuery    *feedsQuery    = [feedsRelation query];
    [feedsQuery whereKey:@"type" equalTo:@"Ask"];
    [feedsQuery includeKey:@"toQuestion"];
    [feedsQuery includeKey:@"toQuestion.user"];
    return feedsQuery;
}

- (PFObject *)objectAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.objects.count) {
        return nil;
    }
    return [self.objects objectAtIndex:indexPath.row];
}

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    if (!error) {
        [self configureRefreshControl];
    } else {
        [self showAlertWithErrorString:[NSString stringWithFormat:@"%@",[error userInfo][@"error"]]];
    }
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadNibs];
    [self configureNavbar];
    
    self.viewIsLoadingForTheFirstTime         = YES;
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.tableView.tableHeaderView            = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, 0.01f)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    __weak id weakSelf = self;
    self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;
}

#pragma - mark UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
        return YES;
    } else {
        return  NO;
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return [gestureRecognizer isKindOfClass:UIScreenEdgePanGestureRecognizer.class];
}

#pragma - Tableview Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isLoading) {
        return 1;
    }
    if (self.paginationEnabled && self.objects.count > 0 && self.lastLoadCount >= self.objectsPerPage) {
        return self.objects.count + 1;
    } else if (self.objects.count == 0 && !self.hasContent) {
        return 1;
    }
    
    return self.objects.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return  CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

/* set the index path for the pagination cell */
- (NSIndexPath *)_indexPathForPaginationCell {
    return [NSIndexPath indexPathForRow:self.objects.count inSection:0];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    if (self.viewIsLoadingForTheFirstTime && self.isLoading) {
        _viewIsLoadingForTheFirstTime = NO;
        
        static NSString *cellID = @"loadmore";
        LoadMoreCell *loadcell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (loadcell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"LoadMoreCell" owner:self options:nil];
            loadcell     = [nib objectAtIndex:0];
        }
        
        loadcell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [loadcell.indicatorView startAnimating];
        
        return loadcell;
    }
    if (self.hasContent) {
        if (indexPath.row == self.objects.count) {
            LoadMoreCell *loadMoreCell  = (LoadMoreCell *)[self tableView:tableView cellForNextPageAtIndexPath:indexPath];
            loadMoreCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return loadMoreCell;
        } else {
            QuestionOverviewCell *questionCell = [self.tableView dequeueReusableCellWithIdentifier:@"questionOverview" forIndexPath:indexPath];
            questionCell.questionObject = object[@"toQuestion"];
            return questionCell;
        }
    } else {
        NoQuestionsCell *noQuestionCell = [self.tableView dequeueReusableCellWithIdentifier:@"noquestioncell" forIndexPath:indexPath];
        noQuestionCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return noQuestionCell;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"loadmore";
    LoadMoreCell *loadcell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (loadcell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"LoadMoreCell" owner:self options:nil];
        loadcell     = [nib objectAtIndex:0];
    }
    
    loadcell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [loadcell.indicatorView startAnimating];
    
    return loadcell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSNumber *key = @(indexPath.row);
    NSNumber *height = @(cell.frame.size.height);
    
    [self.cellHeightsDictionary setObject:height forKey:key];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSNumber *key = @(indexPath.row);
    NSNumber *height = [self.cellHeightsDictionary objectForKey:key];
    
    if (height) {
        return height.doubleValue;
    }
    
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

#pragma - mark PZPullToRefresh

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [refreshControl refreshScrollViewDidScroll:scrollView];
    //auto pagination
    if (scrollView.contentSize.height - scrollView.contentOffset.y < (self.view.bounds.size.height * 2)) {
        [UIView setAnimationsEnabled:NO];
        if (![self isLoading] && self.lastLoadCount >= self.objectsPerPage) {
            [self loadNextPage];
        }
        [UIView setAnimationsEnabled:YES];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [refreshControl refreshScrollViewDidEndDragging:scrollView];
}

- (void)pullToRefreshDidTrigger:(PZPullToRefreshView *)view {
    [self loadObjects:0 clear:YES completionBlock:^(NSArray * _Nonnull foundObjects, NSError * _Nonnull error) {
        if (error) {
            [self showAlertWithErrorString:[NSString stringWithFormat:@"%@",[error userInfo][@"error"]]];
        } else {
            self.hasContent = foundObjects.count;
        }
        self->refreshControl.isLoading = NO;
        [self->refreshControl refreshScrollViewDataSourceDidFinishedLoading:self.tableView :UIEdgeInsetsZero];
    }];
}

- (void)configureNavbar {
    UPNavigationBarTitleView *titleView = [[UPNavigationBarTitleView alloc] initWithTitle:[NSString stringWithFormat:@"%@'s Questions", _user.username]
                                                                                 subTitle:[NSString stringWithFormat:@"%@ posts", _user[@"numberOfPosts"]]];
    
    GKFadeNavigationController *navigationController = (GKFadeNavigationController *)self.navigationController;
    
    self.navigationItem.titleView = titleView;
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    //UIBarButtonItem *helpButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"help"] style:UIBarButtonItemStyleDone target:self action:@selector(help)];
    
    self.navigationItem.leftBarButtonItem = backButtonItem;
    //self.navigationItem.rightBarButtonItem = helpButtonItem;
    [self.navigationController.navigationBar setTintColor:COLOR_SCHEME];
    [navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    navigationController.navigationBar.translucent = NO;
    
    [navigationController setNeedsStatusBarAppearanceUpdate];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadNibs {
    UINib *questionCell = [UINib nibWithNibName:@"QuestionOverviewCell" bundle:nil];
    [self.tableView registerNib:questionCell forCellReuseIdentifier:@"questionOverview"];
    
    UINib *noQuestionCell = [UINib nibWithNibName:@"NoQuestionsCell" bundle:nil];
    [self.tableView registerNib:noQuestionCell forCellReuseIdentifier:@"noquestioncell"];
}

- (void)showAlertWithErrorString:(NSString *)error {
    //UI
    PopupDialogDefaultView *dialogAppearance = [PopupDialogDefaultView appearance];
    dialogAppearance.titleFont   = [UIFont fontWithName:@"SFUIText-Medium" size:15];
    dialogAppearance.messageFont = [UIFont fontWithName:@"SFUIText-Regular" size:14];
    [dialogAppearance setFrame:CGRectMake(dialogAppearance.frame.origin.x, dialogAppearance.frame.origin.y
                                          , 100, dialogAppearance.frame.size.height)];
    
    PopupDialog *popup = [[PopupDialog alloc] initWithTitle:@"Error"
                                                    message:error
                                                      image:nil
                                            buttonAlignment:UILayoutConstraintAxisHorizontal
                                            transitionStyle:PopupDialogTransitionStyleZoomIn
                                           gestureDismissal:YES
                                                 completion:nil];
    //buttons
    DefaultButton *btnAppearance = [DefaultButton appearance];
    btnAppearance.titleFont = [UIFont fontWithName:@"SFUIText-Regular" size:14];
    btnAppearance.titleColor = [UIColor colorWithRed:53/255.0 green:111/255.0 blue:177/255.0 alpha:1.0];
    
    DefaultButton *ok = [[DefaultButton alloc] initWithTitle:@"OK" dismissOnTap:YES action:nil];
    
    DefaultButton *retry = [[DefaultButton alloc] initWithTitle:@"RETRY" dismissOnTap:YES action:^{
        [self loadObjects:self.pageToLoad clear:self.clearing];
    }];
    
    [popup addButtonsWithButtons:@[ok, retry]];
    
    [self.navigationController presentViewController:popup animated:YES completion:nil];
}

- (void)configureRefreshControl {
    CGFloat tableViewHeight = self.tableView.bounds.size.height;
    CGFloat tableViewWidth  = self.tableView.bounds.size.width;
    
    if (!refreshControl) {
        refreshControl = [[PZPullToRefreshView alloc] initWithFrame:CGRectMake(0, 0 - tableViewHeight, tableViewWidth, tableViewHeight)];
        refreshControl.statusTextColor = COLOR_SCHEME;
        refreshControl.delegate = self;
        [self.tableView addSubview:refreshControl];
    }
}

- (GKFadeNavigationControllerNavigationBarVisibility)preferredNavigationBarVisibility {
    return GKFadeNavigationControllerNavigationBarVisibilitySystem;
}

@end
