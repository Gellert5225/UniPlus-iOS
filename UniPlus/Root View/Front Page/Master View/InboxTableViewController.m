//
//  InboxTableViewController.m
//  UniPlus
//
//  Created by Jiahe Li on 09/07/2017.
//  Copyright © 2017 Quicky Studio. All rights reserved.
//

#import "InboxTableViewController.h"

#import "SWRevealViewController.h"
#import "QuestionDetailTableViewController.h"

#import "InboxMessageCell.h"
#import "LoadMoreCell.h"

#import "UniPlus-Swift.h"

#import <PopupDialog/PopupDialog-Swift.h>

#define COLOR_SCHEME [UIColor colorWithRed:53/255.0 green:111/255.0 blue:177/255.0 alpha:1.0]

@interface InboxTableViewController ()<SWRevealViewControllerDelegate, PZPullToRefreshDelegate>

@property (strong, nonatomic) NSMutableDictionary *cellHeightsDictionary;

@end

@implementation InboxTableViewController {
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

- (id)initWithStyle:(UITableViewStyle)style className:(NSString *)className {
    self = [super initWithStyle:style className:className];
    if (self) {
        self.parseClassName = className;
        self.paginationEnabled = YES;
        self.objectsPerPage = 20;
        self.pullToRefreshEnabled = NO;
        self.loadingViewEnabled = NO;
    }
    return self;
}

#pragma - mark Inherited PFQuery

- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    [query whereKey:@"toUser" equalTo:[PFUser currentUser]];
    [query whereKey:@"fromUser" notEqualTo:[PFUser currentUser]];
    [query whereKey:@"type" containedIn:@[@"Answer" ,@"CommentToQuestion", @"CommentToAnswer"]];
    [query includeKey:@"fromUser"];
    [query includeKey:@"toQuestion"];
    [query includeKey:@"toAnswer"];
    [query includeKey:@"toComment"];
    [query orderByDescending:@"createdAt"];
    return query;
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
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    
    [self loadNibs];
    
    [self configureNavBar];
    [self setNeedsStatusBarAppearanceUpdate];
    
    self.tableView.contentInset = UIEdgeInsetsZero;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.automaticallyAdjustsScrollViewInsets = NO;
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

#pragma - mark UITableView Datasource

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
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(nullable PFObject *)object {
    if (indexPath.row == self.objects.count) {
        LoadMoreCell *loadMoreCell  = (LoadMoreCell *)[self tableView:tableView cellForNextPageAtIndexPath:indexPath];
        loadMoreCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return loadMoreCell;
    } else {
        InboxMessageCell *inboxCell = [tableView dequeueReusableCellWithIdentifier:@"inboxmessagecell"];
        inboxCell.feedObject = object;
        return inboxCell;
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

#pragma - mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row != self.objects.count) {
        PFObject *question = self.objects[indexPath.row][@"toQuestion"];
        QuestionDetailTableViewController *QDTVC = [[QuestionDetailTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        QDTVC.questionId = question.objectId;
        QDTVC.questionObject = question;
        QDTVC.isFromProfile = NO;
        QDTVC.isLoading = YES;
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
            [self showAlertWithErrorString:[NSString stringWithFormat:@"%@",[error userInfo][@"error"]]];
        } else {
            self.hasContent = foundObjects.count;
        }
        refreshControl.isLoading = NO;
        [refreshControl refreshScrollViewDataSourceDidFinishedLoading:self.tableView :UIEdgeInsetsZero];
    }];
}

#pragma - mark Private

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

- (void)configureNavBar {
    //SWRevealViewController
    SWRevealViewController *revealController = [self revealViewController];
    revealController.delegate = self;
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    self.revealViewController.draggableBorderWidth = self.view.frame.size.width/7;
    
    //custom barButtonItem
    UITapGestureRecognizer *tapMenu = [[UITapGestureRecognizer alloc] initWithTarget:revealController action:@selector(revealToggle:)];
    
    UIImageView *menuImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Menu"]];
    menuImgView.image = [menuImgView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [menuImgView setTintColor:COLOR_SCHEME];
    menuImgView.frame = CGRectMake(5, 5, 25, 25);
    UIView *menuView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    menuView.backgroundColor = [UIColor clearColor];
    [menuView addSubview:menuImgView];
    [menuView addGestureRecognizer:tapMenu];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{
        NSForegroundColorAttributeName:COLOR_SCHEME,
        NSFontAttributeName:[UIFont fontWithName:@"SFUIText-Medium" size:18]
    }];
    
    //configure the navigation bar
    UIBarButtonItem *menu = [[UIBarButtonItem alloc] initWithCustomView:menuView];
    [self.navigationController.navigationBar setTintColor:COLOR_SCHEME];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barStyle    = UIBarStyleBlack;
    self.navigationItem.title                           = @"Inbox";
    self.navigationItem.leftBarButtonItem               = menu;
    self.navigationItem.hidesBackButton                 = YES;
}

- (void)loadNibs {
    UINib *questionTitleCell = [UINib nibWithNibName:@"InboxMessageCell" bundle:nil];
    [self.tableView registerNib:questionTitleCell forCellReuseIdentifier:@"inboxmessagecell"];
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
