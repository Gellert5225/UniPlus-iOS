//
//  UserActivityTableViewController.m
//  UniPlus
//
//  Created by Jiahe Li on 09/07/2017.
//  Copyright © 2017 Quicky Studio. All rights reserved.
//

#import "UserActivityTableViewController.h"
#import "QuestionDetailTableViewController.h"
#import "UPNavigationBarTitleView.h"

#import "LoadMoreCell.h"
#import "ProfileQuestionCell.h"

#import <GKFadeNavigationController/GKFadeNavigationController.h>
#import <PopupDialog/PopupDialog-Swift.h>

#import "UniPlus-Swift.h"

#define COLOR_SCHEME [UIColor colorWithRed:53/255.0 green:111/255.0 blue:177/255.0 alpha:1.0]

@interface UserActivityTableViewController ()<PZPullToRefreshDelegate>

@property (strong, nonatomic) NSMutableDictionary *cellHeightsDictionary;

@end

@implementation UserActivityTableViewController {
    PZPullToRefreshView *refreshControl;
}

#pragma - mark Accessor

- (NSMutableDictionary *)cellHeightsDictionary {
    if (!_cellHeightsDictionary) {
        _cellHeightsDictionary = [[NSMutableDictionary alloc]init];
    }
    return _cellHeightsDictionary;
}

#pragma - mark Initializers

- (id)initWithStyle:(UITableViewStyle)style queryUser:(PFUser *)user {
    self = [super initWithStyle:style];
    if (self) {
        self.parseClassName       = @"_User";
        self.pullToRefreshEnabled = NO;
        self.paginationEnabled    = YES;
        self.objectsPerPage       = 15;
        self.loadingViewEnabled   = NO;
        self.user = user;
    }
    return self;
}

#pragma - mark Inherited PFQuery

- (PFQuery *)queryForTable {
    PFRelation *feedsRelation = [self.user relationForKey:@"feeds"];
    PFQuery    *feedsQuery    = [feedsRelation query];
    [feedsQuery orderByDescending:@"createdAt"];
    [feedsQuery includeKey:@"fromUser"];
    [feedsQuery includeKey:@"toUser"];
    [feedsQuery includeKey:@"toQuestion"];
    [feedsQuery includeKey:@"toComment"];
    [feedsQuery includeKey:@"toAnswer"];
    
    return feedsQuery;
}

- (PFObject *)objectAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.objects.count) {
        return nil;
    } else {
        return [self.objects objectAtIndex:indexPath.row];
    }
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

#pragma - mark Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadNibs];
    
    [self configureNavBar];
    [self setNeedsStatusBarAppearanceUpdate];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1];
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

#pragma - mark Table View Data Source

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *key = indexPath;
    NSNumber *height = @(cell.frame.size.height);
    
    [self.cellHeightsDictionary setObject:height forKey:key];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSNumber *height = [self.cellHeightsDictionary objectForKey:indexPath];
    
    if (height) {
        return height.floatValue;
    }
    
    return UITableViewAutomaticDimension;
}

- (NSIndexPath *)_indexPathForPaginationCell {
    return [NSIndexPath indexPathForRow:self.objects.count inSection:0];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isLoading) {
        return 1;
    } else {
        if (self.paginationEnabled && self.objects.count > 0 && self.lastLoadCount >= self.objectsPerPage) {
            return self.objects.count + 1;
        }
        return self.objects.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 25.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    if (!self.isLoadingForTheFirstTime) {
        if (indexPath.row == self.objects.count) {
            LoadMoreCell *loadMoreCell  = (LoadMoreCell *)[self tableView:tableView cellForNextPageAtIndexPath:indexPath];
            loadMoreCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return loadMoreCell;
        } else {
            ProfileQuestionCell *questionCell = [self.tableView dequeueReusableCellWithIdentifier:@"profilequestioncell" forIndexPath:indexPath];
            
            questionCell.object = object;
            
            return questionCell;
        }
    } else {
        _isLoadingForTheFirstTime = NO;
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
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, tableView.frame.size.width, 25)];
    headerView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, tableView.frame.size.width - 15, 25)];
    headerLabel.text = @"Recent Activity";
    headerLabel.font = [UIFont fontWithName:@"SFUIText-Regular" size:13];
    headerLabel.textColor = [UIColor colorWithRed:64/255.0 green:132/255.0 blue:191/255.0 alpha:1.0];
    
    UIView *topSeparator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 0.5)];
    topSeparator.backgroundColor = [UIColor colorWithRed:219/255.0 green:219/255.0 blue:224/255.0 alpha:1.0];
    
    UIView *bottomSeparator = [[UIView alloc] initWithFrame:CGRectMake(0, 24.5, tableView.frame.size.width, 0.5)];
    bottomSeparator.backgroundColor = [UIColor colorWithRed:219/255.0 green:219/255.0 blue:224/255.0 alpha:1.0];
    
    if (!self.isLoading) {
        [headerView addSubview:topSeparator];
        [headerView addSubview:bottomSeparator];
        [headerView addSubview:headerLabel];
    }
    
    return headerView;
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

#pragma - mark Table View Delegates

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row != self.objects.count) {
        PFObject *question = self.objects[indexPath.row][@"toQuestion"];
        QuestionDetailTableViewController *QDTVC = [[QuestionDetailTableViewController alloc]initWithStyle:UITableViewStyleGrouped];
        QDTVC.questionObject = question;
        QDTVC.questionId     = question.objectId;
        QDTVC.isLoading      = YES;
        QDTVC.isFromProfile  = YES;
        
        [self.navigationController pushViewController:QDTVC animated:YES];
    }
}

#pragma - mark ScrollView Delegates

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [refreshControl refreshScrollViewDidScroll:scrollView];
    if (scrollView.contentSize.height - scrollView.contentOffset.y < (self.view.bounds.size.height * 2)) {
        [UIView setAnimationsEnabled:NO];
        if (![self isLoading] && self.lastLoadCount >= self.objectsPerPage) {
            [self loadNextPage];
        }
        [UIView setAnimationsEnabled:YES];
    }
}

#pragma PZPullToRefresh Delegates

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [refreshControl refreshScrollViewDidEndDragging:scrollView];
}

- (void)pullToRefreshDidTrigger:(PZPullToRefreshView *)view {
    refreshControl.isLoading = YES;
    [self loadObjects:0 clear:YES completionBlock:^(NSArray * _Nonnull foundObjects, NSError * _Nonnull error) {
        if (error) {
            //[self showAlertWithErrorString:[NSString stringWithFormat:@"%@",[error userInfo][@"error"]]];
        } else {
            self.hasContent = foundObjects.count;
        }
        refreshControl.isLoading = NO;
        [refreshControl refreshScrollViewDataSourceDidFinishedLoading:self.tableView :UIEdgeInsetsZero];
    }];
}

- (NSDate *)pullToRefreshLastUpdated:(PZPullToRefreshView *)view {
    NSDate *date = [[NSDate alloc]init];
    return date;
}

#pragma - mark Private

- (void)configureNavBar {
    UPNavigationBarTitleView *titleView = [[UPNavigationBarTitleView alloc] initWithTitle:[NSString stringWithFormat:@"%@'s Activities", _user.username]
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

- (void)loadNibs {
    UINib *questionCell = [UINib nibWithNibName:@"ProfileQuestionCell" bundle:nil];
    [self.tableView registerNib:questionCell forCellReuseIdentifier:@"profilequestioncell"];
    
    UINib *profileOverviewCell = [UINib nibWithNibName:@"ProfileOverViewCell" bundle:nil];
    [self.tableView registerNib:profileOverviewCell forCellReuseIdentifier:@"profileoverviewcell"];
}

- (void)configureRefreshControl {
    CGFloat tableViewHeight = self.tableView.bounds.size.height;
    CGFloat tableViewWidth  = self.tableView.bounds.size.width;
    
    if (!refreshControl && !self.isLoading) {
        refreshControl = [[PZPullToRefreshView alloc] initWithFrame:CGRectMake(0, 0 - tableViewHeight, tableViewWidth, tableViewHeight)];
        refreshControl.statusTextColor = COLOR_SCHEME;
        refreshControl.delegate = self;
        [self.tableView addSubview:refreshControl];
    }
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
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
    
    [popup addButtons: @[ok, retry]];
    
    [self.navigationController presentViewController:popup animated:YES completion:nil];
}

@end
