//
//  ProfileTableViewController.m
//  UniPlus
//
//  Created by Jiahe Li on 08/10/2016.
//  Copyright © 2016 Quicky Studio. All rights reserved.
//

#import "ProfileTableViewController.h"
#import "LoadMoreCell.h"
#import "SWRevealViewController.h"
#import "UPNavigationBarTitleView.h"
#import "ProfileDetailInfoCell.h"
#import "ProfileQuestionCell.h"
#import "LoadMoreCell.h"
#import "SRActionSheet.h"
#import "QuestionDetailTableViewController.h"
#import "ReviewProfileTableViewController.h"
#import "UserQuestionPostTableViewController.h"
#import "UserActivityTableViewController.h"
#import "ReportDialogViewController.h"

#import "UniPlus-Swift.h"

#import <PopupDialog/PopupDialog-Swift.h>

#define kGKHeaderHeight 180.f
#define kGKHeaderVisibleThreshold 30.f
#define kGKNavbarHeight 64.f
#define COLOR_SCHEME [UIColor colorWithRed:53/255.0 green:111/255.0 blue:177/255.0 alpha:1.0]
#define kRefreshControlThreshold 40.0f

@interface ProfileTableViewController () <PZPullToRefreshDelegate, SRActionSheetDelegate, ProfileDetailInfoCellDelegate, ReportDialogViewControllerDelegate>

@property (nonatomic) GKFadeNavigationControllerNavigationBarVisibility navigationBarVisibility;
@property (nonatomic) GKFadeNavigationControllerNavigationBarVisibility previousNavBarVisibility;
@property (strong, nonatomic) UIImageView *menuImgView;
@property (strong, nonatomic) UIImageView *moreImgView;
@property (strong, nonatomic) UIImageView *backImgView;
@property (strong, nonatomic) NSString    *reportMessage;
@property (strong, nonatomic) UPNavigationBarTitleView *titleView;
@property (nonatomic) BOOL isLoading;

@end

@implementation ProfileTableViewController {
    PZPullToRefreshView *refreshControl;
    PopupDialog *reportDialog;
    DefaultButton *submitButton;
}

#pragma - mark Accessors

- (void)setNavigationBarVisibility:(GKFadeNavigationControllerNavigationBarVisibility)navigationBarVisibility {
    if (navigationBarVisibility != _navigationBarVisibility) {
        // Set the value
        _navigationBarVisibility = navigationBarVisibility;
        
        // Play the change
        GKFadeNavigationController *navigationController = (GKFadeNavigationController *)self.navigationController;
        if (navigationController.topViewController) {
            //[navigationController setNeedsNavigationBarVisibilityUpdateAnimated:YES];
        }
        [navigationController setNeedsNavigationBarVisibilityUpdateAnimated:YES];
        
        self.navigationItem.titleView.hidden = _navigationBarVisibility == GKFadeNavigationControllerNavigationBarVisibilityHidden ? YES : NO;
        _menuImgView.image = [_menuImgView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        _moreImgView.image = [_moreImgView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        _backImgView.image = [_backImgView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_menuImgView setTintColor:navigationBarVisibility == GKFadeNavigationControllerNavigationBarVisibilityHidden ? [UIColor whiteColor] : COLOR_SCHEME];
        [_menuImgView addShadowWithOpacity:navigationBarVisibility == GKFadeNavigationControllerNavigationBarVisibilityHidden ? 1.0 : 0.0];
        [_moreImgView setTintColor:navigationBarVisibility == GKFadeNavigationControllerNavigationBarVisibilityHidden ? [UIColor whiteColor] : COLOR_SCHEME];
        [_moreImgView addShadowWithOpacity:navigationBarVisibility == GKFadeNavigationControllerNavigationBarVisibilityHidden ? 1.0 : 0.0];
        [_backImgView setTintColor:navigationBarVisibility == GKFadeNavigationControllerNavigationBarVisibilityHidden ? [UIColor whiteColor] : COLOR_SCHEME];
        [_backImgView addShadowWithOpacity:navigationBarVisibility == GKFadeNavigationControllerNavigationBarVisibilityHidden ? 1.0 : 0.0];
        [self.navigationController setNeedsStatusBarAppearanceUpdate];
    }
}

- (void)setProfileUser:(PFUser *)profileUser {
    _profileUser = profileUser;
    _headerView = [[UPHeaderView alloc]initWithNibName:@"UPHeaderView"];
    _headerView.user = profileUser;
}

#pragma - mark Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    if (@available(iOS 11.0, *)) {
//        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//        //[NSLayoutConstraint activateConstraints:@[[self.tableView.topAnchor constraintEqualToSystemSpacingBelowAnchor:self.tableView.safeAreaLayoutGuide.topAnchor multiplier:1]]];
//    }
    
    _viewModel = [[ProfileTableViewModel alloc]init];
    
    [self loadNibs];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tableView.estimatedRowHeight = 64.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableHeaderView = _headerView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1];
    
    [self.tableView sendSubviewToBack:_headerView];
    
    [self configureNavbar];
    
    self.navigationBarVisibility = GKFadeNavigationControllerNavigationBarVisibilityHidden;
    _previousNavBarVisibility = GKFadeNavigationControllerNavigationBarVisibilityHidden;
    
    GKFadeNavigationController *navigationController = (GKFadeNavigationController *)self.navigationController;
    [navigationController setNeedsNavigationBarVisibilityUpdateAnimated:NO];
    
    [self loadObjects];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    CGFloat scrollOffsetY = kGKHeaderHeight-self.tableView.contentOffset.y;
    if (scrollOffsetY-kGKNavbarHeight < kGKHeaderVisibleThreshold) {
        self.navigationBarVisibility = GKFadeNavigationControllerNavigationBarVisibilitySystem;
    } else {
        self.navigationBarVisibility = GKFadeNavigationControllerNavigationBarVisibilityHidden;
    }
    
    GKFadeNavigationController *navigationController = (GKFadeNavigationController *)self.navigationController;
    [navigationController.navigationBar sendSubviewToBack:navigationController.view];
    if (_isFromMenu) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    } else {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        __weak id weakSelf = self;
        self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;
    }
    [self.navigationController setNeedsStatusBarAppearanceUpdate];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    self.navigationController.navigationBar.translucent = NO;
    self.navigationBarVisibility = GKFadeNavigationControllerNavigationBarVisibilitySystem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    CGFloat scrollOffsetY = kGKHeaderHeight-self.tableView.contentOffset.y;
    if (scrollOffsetY-kGKNavbarHeight < kGKHeaderVisibleThreshold) {
        self.navigationBarVisibility = GKFadeNavigationControllerNavigationBarVisibilitySystem;
    } else {
        self.navigationBarVisibility = GKFadeNavigationControllerNavigationBarVisibilityHidden;
    }
}

#pragma - mark Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return _isLoading ? 1 : _viewModel.activities.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0?0:25.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, tableView.frame.size.width, 25)];
    headerView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 25)];
    headerLabel.text = @"Recent Activity";
    headerLabel.font = [UIFont fontWithName:@"SFUIText-Regular" size:13];
    headerLabel.textColor = [UIColor colorWithRed:64/255.0 green:132/255.0 blue:191/255.0 alpha:1.0];
    
    UIButton *viewAllButton = [[UIButton alloc] initWithFrame:CGRectMake(tableView.frame.size.width - 100, 0, 100, 25)];
    [viewAllButton setTitle:@"View All" forState:UIControlStateNormal];
    [viewAllButton setTitleColor:[UIColor colorWithRed:64/255.0 green:132/255.0 blue:191/255.0 alpha:1.0] forState:UIControlStateNormal];
    viewAllButton.titleLabel.font = [UIFont fontWithName:@"SFUIText-Regular" size:13];
    [viewAllButton addTarget:self action:@selector(viewAll) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *topSeparator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 0.5)];
    topSeparator.backgroundColor = [UIColor colorWithRed:219/255.0 green:219/255.0 blue:224/255.0 alpha:1.0];
    
    UIView *bottomSeparator = [[UIView alloc] initWithFrame:CGRectMake(0, 24.5, tableView.frame.size.width, 0.5)];
    bottomSeparator.backgroundColor = [UIColor colorWithRed:219/255.0 green:219/255.0 blue:224/255.0 alpha:1.0];
    [headerView addSubview:headerLabel];
    [headerView addSubview:viewAllButton];
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ProfileDetailInfoCell *profileDetailInfoCell = [self.tableView dequeueReusableCellWithIdentifier:@"profiledetailinfo" forIndexPath:indexPath];
        profileDetailInfoCell.selectionStyle = UITableViewCellSelectionStyleNone;
        profileDetailInfoCell.delegate = self;
        profileDetailInfoCell.user = _profileUser;
        return profileDetailInfoCell;
    } else {
        if (_isLoading) {
            LoadMoreCell *loadmoreCell = [self.tableView dequeueReusableCellWithIdentifier:@"loadmore" forIndexPath:indexPath];
            loadmoreCell.selectionStyle = UITableViewCellSelectionStyleNone;
            [loadmoreCell.indicatorView startAnimating];
            return loadmoreCell;
        } else {
            ProfileQuestionCell *questionCell = [self.tableView dequeueReusableCellWithIdentifier:@"profilequestioncell" forIndexPath:indexPath];
            questionCell.object = _viewModel.activities[indexPath.row];
            return questionCell;
        }
    }
}

#pragma - mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section != 0 && indexPath.row != _viewModel.activities.count) {
        GKFadeNavigationController *navigationController = (GKFadeNavigationController *)self.navigationController;
        PFObject *question = _viewModel.activities[indexPath.row][@"toQuestion"];
        QuestionDetailTableViewController *QDTVC = [[QuestionDetailTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        QDTVC.questionId = question.objectId;
        QDTVC.questionObject = question;
        QDTVC.isFromProfile = YES;
        QDTVC.isLoading = YES;
        [navigationController pushViewController:QDTVC animated:YES];
    }
}

#pragma - mark Scroll View Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat scrollOffsetY = kGKHeaderHeight-scrollView.contentOffset.y;
    
    // Stretch the header view if neccessary
    if (scrollOffsetY > kGKHeaderHeight) {
        _headerView.headerImageTopConstraint.constant = kGKHeaderHeight-scrollOffsetY;
        _headerView.contentWrapperView.alpha = scrollOffsetY;
    } else {
        //_headerView.headerImageTopConstraint.constant = (kGKHeaderHeight-scrollOffsetY)/2.f;
        //_headerView.headerImageBottomConstraint.constant = -(kGKHeaderHeight-scrollOffsetY)/2.f;
    }
    
    // Show or hide the navigaiton bar
    if (scrollOffsetY-kGKNavbarHeight < kGKHeaderVisibleThreshold) {
        self.navigationBarVisibility = GKFadeNavigationControllerNavigationBarVisibilitySystem;
    } else {
        self.navigationBarVisibility = GKFadeNavigationControllerNavigationBarVisibilityHidden;
    }
    
    [refreshControl refreshScrollViewDidScroll:scrollView];
}

#pragma mark GKFadeNavigationControllerDelegate

- (GKFadeNavigationControllerNavigationBarVisibility)preferredNavigationBarVisibility {
    return self.navigationBarVisibility;
}

#pragma - mark SRActionSheet Delegate

- (void)actionSheet:(SRActionSheet *)actionSheet willDismissFromSuperView:(UIView *)superView {
    [self shrinkViewControllerWithDuration:0.2 transformScale:CGAffineTransformMakeScale(1.0, 1.0)];
}

- (void)actionSheet:(SRActionSheet *)actionSheet didSelectSheet:(NSInteger)index {
    if (index == 0) {
        if ([_profileUser.objectId isEqualToString:[PFUser currentUser].objectId]) { //edit profile
            ReviewProfileTableViewController *RPTVC = [[ReviewProfileTableViewController alloc] initWithNibName:@"ReviewProfileTableViewController" bundle:nil];
            RPTVC.isFromSignUp = NO;
            RPTVC.institution = [[PFUser currentUser] objectForKey:@"institution"];
            RPTVC.topic = [[PFUser currentUser] objectForKey:@"major"];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:RPTVC];
            [self presentViewController:nav animated:YES completion:nil];
        } else { //report user
            ReportDialogViewController *reportVC = [[ReportDialogViewController alloc] initWithNibName:@"ReportDialogViewController" bundle:nil];
            reportVC.delegate = self;
            
            reportDialog = [[PopupDialog alloc] initWithViewController:reportVC buttonAlignment:UILayoutConstraintAxisHorizontal transitionStyle:PopupDialogTransitionStyleZoomIn gestureDismissal:NO completion:^{}];
            
            DefaultButton *btnAppearance = [DefaultButton appearance];
            btnAppearance.titleFont = [UIFont fontWithName:@"SFUIText-Regular" size:14];
            btnAppearance.titleColor = [UIColor colorWithRed:53/255.0 green:111/255.0 blue:177/255.0 alpha:1.0];
            
            submitButton = [[DefaultButton alloc] initWithTitle:@"Submit" dismissOnTap:YES action:^{
                self.reportMessage = reportVC.reportInfoTextField.text;
                [self postReportMessage];
            }];
            
            CancelButton *cancel = [[CancelButton alloc] initWithTitle:@"Cancel" dismissOnTap:YES action:nil];
            
            [reportDialog addButtonsWithButtons:@[submitButton, cancel]];
            
            [self.navigationController presentViewController:reportDialog animated:YES completion:nil];
        }
    }
}

#pragma - mark UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (!_isFromMenu) {
        if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
            return YES;
        } else {
            return  NO;
        }
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (_isFromMenu) {
        return NO;
    }
    return [gestureRecognizer isKindOfClass:UIScreenEdgePanGestureRecognizer.class];
}

#pragma - mark ReportDialog Delegate

- (void)textFieldDidReturnWithText:(NSString *)text {
    [reportDialog dismissWithCompletion:nil];
    self.reportMessage = text;
    [self postReportMessage];
}

#pragma - mark Private

- (void)postReportMessage {
    [PFCloud callFunctionInBackground:@"postReportMessage" withParameters:@{
        @"message"          :self.reportMessage,
        @"reportObjectId"   :_profileUser.objectId,
        @"reportObjectType" :[NSNumber numberWithInteger:10],
        @"toUserId"         :_profileUser.objectId,
        @"fromUserId"       :[PFUser currentUser].objectId
    }];
}


- (void)viewAll {
    UserActivityTableViewController *UATVC = [[UserActivityTableViewController alloc] initWithStyle:UITableViewStyleGrouped queryUser:_profileUser];
    UATVC.isLoadingForTheFirstTime = YES;
    [self.navigationController pushViewController:UATVC animated:YES];
}

- (void)loadNibs {
    UINib *profileDetailInfoCell = [UINib nibWithNibName:@"ProfileDetailInfoCell" bundle:nil];
    [self.tableView registerNib:profileDetailInfoCell forCellReuseIdentifier:@"profiledetailinfo"];
    
    UINib *profileQuestionCell = [UINib nibWithNibName:@"ProfileQuestionCell" bundle:nil];
    [self.tableView registerNib:profileQuestionCell forCellReuseIdentifier:@"profilequestioncell"];
    
    UINib *loadmoreCell = [UINib nibWithNibName:@"LoadMoreCell" bundle:nil];
    [self.tableView registerNib:loadmoreCell forCellReuseIdentifier:@"loadmore"];
}

- (void)configureNavbar {
    //custom navigation title
    
    _titleView = [[UPNavigationBarTitleView alloc]initWithTitle:_profileUser[@"nickName"] subTitle:[_profileUser[@"reputation"] stringValue]];
    _titleView.titleFont = [UIFont fontWithName:@"SFUIText-Medium" size:16];
    _titleView.subtitleFont = [UIFont fontWithName:@"SFUIText-Light" size:12];
    _titleView.titleColor = COLOR_SCHEME;
    _titleView.subtitleColor = COLOR_SCHEME;
    
    //SWRevealViewController
    SWRevealViewController *revealController = [self revealViewController];
    if (_isFromMenu) {
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
        self.revealViewController.draggableBorderWidth = self.view.frame.size.width/7;
    }
    
    UITapGestureRecognizer *tapMenu = [[UITapGestureRecognizer alloc] initWithTarget:revealController action:@selector(revealToggle:)];
    UITapGestureRecognizer *tapMore = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moreMenu)];
    UITapGestureRecognizer *tapBack = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back)];
    
    _menuImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Menu"]];
    _menuImgView.frame = CGRectMake(5, 5, 25, 25);
    UIView *menuView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    menuView.backgroundColor = [UIColor clearColor];
    [menuView addSubview:_menuImgView];
    [menuView addGestureRecognizer:tapMenu];
    
    _moreImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"more"]];
    _moreImgView.frame = CGRectMake(5, 5, 25, 25);
    UIView *moreView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    moreView.backgroundColor = [UIColor clearColor];
    [moreView addSubview:_moreImgView];
    [moreView addGestureRecognizer:tapMore];
    
    _backImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back"]];
    _backImgView.frame = CGRectMake(0, 8, 12.28, 17);
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    backView.backgroundColor = [UIColor clearColor];
    [backView addSubview:_backImgView];
    [backView addGestureRecognizer:tapBack];
    
    //configure the navigation bar
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithCustomView:backView];
    UIBarButtonItem *menu = [[UIBarButtonItem alloc] initWithCustomView:menuView];
    UIBarButtonItem *more = [[UIBarButtonItem alloc] initWithCustomView:moreView];
    [self.navigationController.navigationBar setTintColor:COLOR_SCHEME];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationItem.titleView = _titleView;
    self.navigationItem.leftBarButtonItem = _isFromMenu ? menu : back;
    self.navigationItem.rightBarButtonItem = more;
    if (@available(iOS 11.0, *)) {
        self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
        [NSLayoutConstraint activateConstraints:@[[self.tableView.topAnchor constraintEqualToSystemSpacingBelowAnchor:self.tableView.safeAreaLayoutGuide.topAnchor multiplier:1.0]]];
    } else {
        // Fallback on earlier versions
    }

    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [refreshControl refreshScrollViewDidEndDragging:scrollView];
}

- (void)pullToRefreshDidTrigger:(PZPullToRefreshView *)view {
    [self loadObjects];
}

- (NSDate *)pullToRefreshLastUpdated:(PZPullToRefreshView *)view {
    NSDate *date = [[NSDate alloc]init];
    return date;
}

- (void)didTapQuestionView {
    UserQuestionPostTableViewController *UQPTVC = [[UserQuestionPostTableViewController alloc] initWithStyle:UITableViewStyleGrouped queryUser:_profileUser];
    [self.navigationController pushViewController:UQPTVC animated:YES];
}

- (void)didTapAnswerView {
    
}

- (void)configureRefreshView {
    refreshControl.arrow = [UIImage imageNamed:@"arrow"];
    refreshControl.bgColor = [UIColor clearColor];
    refreshControl.statusTextColor = [UIColor whiteColor];
}

- (void)loadObjects {
//    CGFloat tableViewHeight = self.tableView.bounds.size.height;
//    CGFloat tableViewWidth  = self.tableView.bounds.size.width;
    _isLoading = YES;
    __weak typeof(self) weakSelf = self;
    [_viewModel fetchRecentActivitiesForUser:_profileUser completionBlock:^(BOOL success, NSError *error) {
        if (success) {
            weakSelf.isLoading = NO;
            if (!self->refreshControl && !weakSelf.isLoading) {
//                refreshControl = [[PZPullToRefreshView alloc]initWithFrame:CGRectMake(0, 0 - tableViewHeight, tableViewWidth, tableViewHeight)];
//                [self configureRefreshView];
//                refreshControl.thresholdValue = 40.0;
//                refreshControl.delegate = weakSelf;
//                [weakSelf.tableView addSubview:refreshControl];
            }
        }
        self->refreshControl.isLoading = NO;
        [weakSelf.tableView reloadData];
        [weakSelf.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self->refreshControl refreshScrollViewDataSourceDidFinishedLoading:weakSelf.tableView];
//        [UIView beginAnimations:nil context:nil];
//        [UIView setAnimationDuration:0.3];
//        [weakSelf.tableView setContentOffset:CGPointZero animated:YES];
//        [UIView commitAnimations];
    }];
}

- (void)moreMenu {
    [self shrinkViewControllerWithDuration:0.2 transformScale:CGAffineTransformMakeScale(0.93, 0.93)];
    
    SRActionSheet *actionSheet = [[SRActionSheet alloc]initWithTitle:@"More"
                                                   cancelButtonTitle:@"Cancel"
                                              destructiveButtonTitle:nil
                                                   otherButtonTitles:@[[_profileUser.objectId isEqualToString:[PFUser currentUser].objectId]?@"Edit Profile":@"Report User"]
                                                            delegate:self];
    
    [actionSheet show];
}

- (void)shrinkViewControllerWithDuration:(NSTimeInterval)duration transformScale:(CGAffineTransform)scale {
    [UIView animateWithDuration:duration animations:^{
        self.navigationController.view.transform = scale;
    } completion:^(BOOL finished) { }];
}

@end

@implementation UIImageView (Shadow)

- (void)addShadowWithOpacity:(float)opacity {
    self.layer.masksToBounds = NO;
    self.layer.shadowOpacity = opacity;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowRadius = 3.0f;
    self.layer.shadowOffset = CGSizeMake(1, 1);
}

@end
