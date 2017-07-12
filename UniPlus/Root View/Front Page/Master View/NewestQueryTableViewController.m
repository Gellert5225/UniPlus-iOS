//
//  NewestQueryTableViewController.m
//  UniPlus
//
//  Created by Jiahe Li on 19/09/2016.
//  Copyright © 2016 Quicky Studio. All rights reserved.
//

#import "NewestQueryTableViewController.h"
#import "QuestionOverviewCell.h"
#import "LoadMoreCell.h"
#import "NoQuestionsCell.h"
#import "GlobalVariables.h"
#import "PostQuestionTableViewController.h"
#import "QuestionDraft.h"
#import "Question.h"
#import "QuestionDetailTableViewController.h"
#import "UniPlus-Swift.h"
#import "SWRevealViewController.h"

#import <QuartzCore/QuartzCore.h>
#import <PopupDialog/PopupDialog-Swift.h>
#import <SwiftMessages/SwiftMessages-Swift.h>

#define COLOR_SCHEME [UIColor colorWithRed:53/255.0 green:111/255.0 blue:177/255.0 alpha:1.0]

@interface NewestQueryTableViewController ()<PZPullToRefreshDelegate>

@property (strong, nonatomic) NSMutableDictionary *cellHeightsDictionary;
@property (strong, nonatomic) NSString *topicFilter;

@property (nonatomic) BOOL viewIsLoadingForTheFirstTime;
@property (nonatomic) BOOL noQuestions;

@end

@implementation NewestQueryTableViewController {
    PZPullToRefreshView *refreshControl;
}

- (NSMutableDictionary *)cellHeightsDictionary {
    if (!_cellHeightsDictionary) {
        _cellHeightsDictionary = [[NSMutableDictionary alloc]init];
    }
    return _cellHeightsDictionary;
}

#pragma - initialization

- (id)initWithStyle:(UITableViewStyle)style Topic:(NSString *)topic ParseClass:(NSString *)className sortingOrder:(NSString *)order {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.parseClassName       = className;
        self.pullToRefreshEnabled = NO;
        self.paginationEnabled    = YES;
        self.objectsPerPage       = 20;
        self.loadingViewEnabled   = NO;
        self.topicFilter          = topic;
        self.sortingOrder         = order;
        self.noQuestions          = YES;
    }
    return self;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma - Load data from server

- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    [query includeKey:@"user"];
    if (!self.topicFilter) {
        [query whereKey:@"category" equalTo:@"Computer Science"];
    } else {
        [query whereKey:@"category" equalTo:self.topicFilter];
    }
    if ([self.sortingOrder isEqualToString:@"Newest"]) {
        [query orderByDescending:@"createdAt"];
    } else if ([self.sortingOrder isEqualToString:@"Featured"]){
        [query orderByDescending:@"upVotes"];
    } else if ([self.sortingOrder isEqualToString:@"Unsolved"]){
        [query orderByDescending:@"createdAt"];
        [query whereKeyDoesNotExist:@"correctAnswer"];
    }
    
    return query;
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

#pragma - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
        
    [self loadNibs];
    
    self.viewIsLoadingForTheFirstTime         = YES;
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.tableView.tableHeaderView            = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, 0.01f)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
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
    if (self.isLoadingForTheFirstTime && self.isLoading) {
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
    if (self.hasContent) {
        if (indexPath.row == self.objects.count) {
            LoadMoreCell *loadMoreCell  = (LoadMoreCell *)[self tableView:tableView cellForNextPageAtIndexPath:indexPath];
            loadMoreCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return loadMoreCell;
        } else {
            QuestionOverviewCell *questionCell = [self.tableView dequeueReusableCellWithIdentifier:@"questionOverview" forIndexPath:indexPath];
            questionCell.questionObject = object;
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

#pragma - mark Table view delegates

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row != self.objects.count) {
        PFObject *question = self.objects[indexPath.row];
        QuestionDetailTableViewController *QDTVC = [[QuestionDetailTableViewController alloc]initWithStyle:UITableViewStyleGrouped];
        QDTVC.questionObject = question;
        QDTVC.questionId     = question.objectId;
        QDTVC.isLoading      = YES;
        [self.navigationController pushViewController:QDTVC animated:YES];
    }
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
        refreshControl.isLoading = NO;
        [refreshControl refreshScrollViewDataSourceDidFinishedLoading:self.tableView :UIEdgeInsetsZero];
    }];
}

#pragma - PostQuestionTableViewControllerDelegate

- (void)postQuestionWithQuestionObject:(PFObject *)question notificationTitle:(NSString *)title message:(NSString *)messageBody image:(UIImage *)img error:(BOOL)err{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [ConfigNotification configureNotificationInViewController:self withError:err withTitle:title withBody:messageBody];
    });
}

#pragma - Helper

- (void)loadNibs {
    UINib *questionCell = [UINib nibWithNibName:@"QuestionOverviewCell" bundle:nil];
    [self.tableView registerNib:questionCell forCellReuseIdentifier:@"questionOverview"];
    
    UINib *noQuestionCell = [UINib nibWithNibName:@"NoQuestionsCell" bundle:nil];
    [self.tableView registerNib:noQuestionCell forCellReuseIdentifier:@"noquestioncell"];
}

- (void)showAlertWithErrorString:(NSString *)error {
    //UI
    NSLog(@"SHOW ALERT");
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

@end
