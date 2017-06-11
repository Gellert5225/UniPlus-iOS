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

#define kGKHeaderHeight 180.f
#define kGKHeaderVisibleThreshold 30.f
#define kGKNavbarHeight 64.f
#define COLOR_SCHEME [UIColor colorWithRed:53/255.0 green:111/255.0 blue:177/255.0 alpha:1.0]

@interface ProfileTableViewController ()

@property (nonatomic) GKFadeNavigationControllerNavigationBarVisibility navigationBarVisibility;
@property (strong, nonatomic) UIImageView *menuImgView;
@property (strong, nonatomic) UIImageView *moreImgView;
@property (strong, nonatomic) UPNavigationBarTitleView *titleView;
@property (nonatomic) BOOL isLoading;

@end

@implementation ProfileTableViewController

#pragma - mark Accessors

- (void)setNavigationBarVisibility:(GKFadeNavigationControllerNavigationBarVisibility)navigationBarVisibility {
    if (_navigationBarVisibility != navigationBarVisibility) {
        // Set the value
        _navigationBarVisibility = navigationBarVisibility;
        
        // Play the change
        GKFadeNavigationController *navigationController = (GKFadeNavigationController *)self.navigationController;
        if (navigationController.topViewController) {
            [navigationController setNeedsNavigationBarVisibilityUpdateAnimated:YES];
        }
        
        self.navigationItem.titleView.hidden = _navigationBarVisibility == GKFadeNavigationControllerNavigationBarVisibilityHidden ? YES : NO;
        _menuImgView.image = [_menuImgView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        _moreImgView.image = [_moreImgView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_menuImgView setTintColor:navigationBarVisibility == GKFadeNavigationControllerNavigationBarVisibilityHidden ? [UIColor whiteColor] : COLOR_SCHEME];
        [_menuImgView addShadowWithOpacity:navigationBarVisibility == GKFadeNavigationControllerNavigationBarVisibilityHidden ? 1.0 : 0.0];
        [_moreImgView setTintColor:navigationBarVisibility == GKFadeNavigationControllerNavigationBarVisibilityHidden ? [UIColor whiteColor] : COLOR_SCHEME];
        [_moreImgView addShadowWithOpacity:navigationBarVisibility == GKFadeNavigationControllerNavigationBarVisibilityHidden ? 1.0 : 0.0];
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
    
    GKFadeNavigationController *navigationController = (GKFadeNavigationController *)self.navigationController;
    [navigationController setNeedsNavigationBarVisibilityUpdateAnimated:NO];
    
    [self loadObjects];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    GKFadeNavigationController *navigationController = (GKFadeNavigationController *)self.navigationController;
    [navigationController.navigationBar sendSubviewToBack:navigationController.visualEffectView];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    [self.navigationController setNeedsStatusBarAppearanceUpdate];
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
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, tableView.frame.size.width - 15, 25)];
    headerLabel.text = @"Recent Activity";
    headerLabel.font = [UIFont fontWithName:@"SFUIText-Regular" size:13];
    headerLabel.textColor = [UIColor colorWithRed:64/255.0 green:132/255.0 blue:191/255.0 alpha:1.0];
    
    UIView *topSeparator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 0.5)];
    topSeparator.backgroundColor = [UIColor colorWithRed:219/255.0 green:219/255.0 blue:224/255.0 alpha:1.0];
    
    UIView *bottomSeparator = [[UIView alloc] initWithFrame:CGRectMake(0, 24.5, tableView.frame.size.width, 0.5)];
    bottomSeparator.backgroundColor = [UIColor colorWithRed:219/255.0 green:219/255.0 blue:224/255.0 alpha:1.0];
    [headerView addSubview:headerLabel];
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ProfileDetailInfoCell *profileDetailInfoCell = [self.tableView dequeueReusableCellWithIdentifier:@"profiledetailinfo" forIndexPath:indexPath];
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
        PFObject *question = _viewModel.activities[indexPath.row][@"toQuestion"];
        QuestionDetailTableViewController *QDTVC = [[QuestionDetailTableViewController alloc]initWithStyle:UITableViewStyleGrouped questionID:question.objectId questionObject:question setFromProfile:YES setLoading:YES];
    
        [self.navigationController pushViewController:QDTVC animated:YES];
    }
}

#pragma - mark Scroll View Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat scrollOffsetY = kGKHeaderHeight-scrollView.contentOffset.y;
    
    // Stretch the header view if neccessary
    if (scrollOffsetY > kGKHeaderHeight) {
        _headerView.headerImageTopConstraint.constant = kGKHeaderHeight-scrollOffsetY;
    } else {
        _headerView.headerImageTopConstraint.constant = (kGKHeaderHeight-scrollOffsetY)/2.f;
        _headerView.headerImageBottomConstraint.constant = -(kGKHeaderHeight-scrollOffsetY)/2.f;
    }
    
    // Show or hide the navigaiton bar
    if (scrollOffsetY-kGKNavbarHeight < kGKHeaderVisibleThreshold) {
        self.navigationBarVisibility = GKFadeNavigationControllerNavigationBarVisibilityVisible;
    } else {
        self.navigationBarVisibility = GKFadeNavigationControllerNavigationBarVisibilityHidden;
    }
}

#pragma mark GKFadeNavigationControllerDelegate

- (GKFadeNavigationControllerNavigationBarVisibility)preferredNavigationBarVisibility {
    return self.navigationBarVisibility;
}

#pragma - mark Private

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
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    
    UITapGestureRecognizer *tapMenu = [[UITapGestureRecognizer alloc] initWithTarget:revealController action:@selector(revealToggle:)];
    UITapGestureRecognizer *tapMore = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moreMenu)];
    self.revealViewController.draggableBorderWidth = self.view.frame.size.width/7;
    
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
    
    //configure the navigation bar
    UIBarButtonItem *menu = [[UIBarButtonItem alloc] initWithCustomView:menuView];
    UIBarButtonItem *more = [[UIBarButtonItem alloc] initWithCustomView:moreView];
    [self.navigationController.navigationBar setTintColor:COLOR_SCHEME];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationItem.titleView = _titleView;
    self.navigationItem.leftBarButtonItem = menu;
    self.navigationItem.rightBarButtonItem = more;
    self.navigationItem.hidesBackButton = YES;

    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)loadObjects {
    _isLoading = YES;
    __weak typeof(self) weakSelf = self;
    [_viewModel fetchRecentActivitiesForUser:_profileUser completionBlock:^(BOOL success, NSError *error) {
        _isLoading = NO;
        [weakSelf.tableView reloadData];
        [weakSelf.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }];
}

- (void)moreMenu {
    [SRActionSheet sr_showActionSheetViewWithTitle:@"More"
                                 cancelButtonTitle:@"Cancel"
                            destructiveButtonTitle:nil
                                 otherButtonTitles:@[@"Edit Profile"]
                                  selectSheetBlock:^(SRActionSheet *actionSheetView, NSInteger actionIndex) {
                                      if (actionIndex == 0) {
                                          
                                      } else if (actionIndex == 1){
                                          
                                      }
                                  }];
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
