//
//  MainPageViewController.m
//  UniPlus
//
//  Created by Jiahe Li on 19/09/2016.
//  Copyright © 2016 Quicky Studio. All rights reserved.
//

#import "MainPageViewController.h"
#import "SWRevealViewController.h"
#import "NewestQueryTableViewController.h"
#import "PostQuestionTableViewController.h"
#import "CarbonKit.h"

#import <GKFadeNavigationController/GKFadeNavigationController.h>

#define COLOR_SCHEME [UIColor colorWithRed:53/255.0 green:111/255.0 blue:177/255.0 alpha:1.0]
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width

@interface MainPageViewController ()<CarbonTabSwipeNavigationDelegate, SWRevealViewControllerDelegate> {
    CarbonTabSwipeNavigation *tabSwipe;
    NewestQueryTableViewController *NQTVC;
}

@property (strong, nonatomic) NSString *topic;
@property (strong, nonatomic) NSString *parseClass;

@end

@implementation MainPageViewController

- (instancetype)initWithTopic:(NSString *)topic ParseClass:(NSString *)className {
    self = [super init];
    self.topic = topic;
    self.parseClass = className;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1];
    
    //init the segmented control
    NSArray *barItems = @[@"Newest",@"Featured",@"Unsolved"];
    tabSwipe = [[CarbonTabSwipeNavigation alloc] initWithItems:barItems delegate:self];
    [tabSwipe insertIntoRootViewController:self];
    
    [self configureNavbar];
    [self configureSegmentedControl];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

#pragma mark - CarbonTabSwipeNavigation Delegate

- (nonnull UIViewController *)carbonTabSwipeNavigation:(nonnull CarbonTabSwipeNavigation *)carbontTabSwipeNavigation viewControllerAtIndex:(NSUInteger)index {
    switch (index) {
        case 0:{
            NQTVC = [[NewestQueryTableViewController alloc]initWithStyle:UITableViewStyleGrouped Topic:self.topic ParseClass:@"Questions" sortingOrder:@"Newest"];
            NQTVC.isLoadingForTheFirstTime = YES;
            return NQTVC;
        }
        case 1:{
            NQTVC = [[NewestQueryTableViewController alloc]initWithStyle:UITableViewStyleGrouped Topic:self.topic ParseClass:@"Questions" sortingOrder:@"Featured"];
            NQTVC.isLoadingForTheFirstTime = YES;
            return NQTVC;
        }
        default:{
            NQTVC = [[NewestQueryTableViewController alloc]initWithStyle:UITableViewStyleGrouped Topic:self.topic ParseClass:@"Questions" sortingOrder:@"Unsolved"];
            NQTVC.isLoadingForTheFirstTime = YES;
            return NQTVC;
        }
    }
}

#pragma - mark SWRevealViewController Delegates

- (void)revealController:(SWRevealViewController *)revealController animateToPosition:(FrontViewPosition)position {
    if (position == FrontViewPositionRight) {
        [self setChildViewControllersUserInteractionEnabled:NO];
        tabSwipe.pagesScrollView.scrollEnabled = NO;
    } else {
        [self setChildViewControllersUserInteractionEnabled:YES];
        tabSwipe.pagesScrollView.scrollEnabled = YES;
    }
}

- (BOOL)revealControllerPanGestureShouldBegin:(SWRevealViewController *)revealController {
    return YES;
}

- (void)revealController:(SWRevealViewController *)revealController panGestureBeganFromLocation:(CGFloat)location progress:(CGFloat)progress {
    if (location == 0.0) {
        [self setChildViewControllersUserInteractionEnabled:NO];
        tabSwipe.pagesScrollView.scrollEnabled = NO;
    }
}

- (BOOL)revealController:(SWRevealViewController *)revealController panGestureRecognizerShouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer;{
    return YES;
}

#pragma - mark Helpers

- (void)setChildViewControllersUserInteractionEnabled:(BOOL)enabled {
    for (UIViewController *vc in tabSwipe.childViewControllers) {
        vc.view.userInteractionEnabled = enabled;
    }
}

- (void)configureSegmentedControl {
    //configure the segmented control
    tabSwipe.toolbar.translucent = NO;
    [tabSwipe.toolbar setBarTintColor:[UIColor whiteColor]];
    [tabSwipe setIndicatorColor:COLOR_SCHEME];
    [tabSwipe setIndicatorHeight:1.0f];
    
    [tabSwipe.carbonSegmentedControl setWidth:SCREEN_WIDTH/3 forSegmentAtIndex:0];
    [tabSwipe.carbonSegmentedControl setWidth:SCREEN_WIDTH/3 forSegmentAtIndex:1];
    [tabSwipe.carbonSegmentedControl setWidth:SCREEN_WIDTH/3 forSegmentAtIndex:2];
    
    // Custimize segmented control
    [tabSwipe setNormalColor:[COLOR_SCHEME colorWithAlphaComponent:0.9] font:[UIFont fontWithName:@"SFUIText-Regular" size:13]];
    [tabSwipe setSelectedColor:COLOR_SCHEME font:[UIFont fontWithName:@"SFUIText-SemiBold" size:13]];
}

- (void)configureNavbar {
    //custom navigation title
    NSString *classLabelText;
    if ([self.parseClass isEqualToString:@"Questions"]) {
        classLabelText = @"Coursework Q&A";
    } else if ([self.parseClass isEqualToString:@"Discussions"]){
        classLabelText = @"General Discussion";
    }
    UIView *titleLabelView   = [[UIView alloc] initWithFrame:CGRectMake(0,0,145,32)];
    UILabel *classLabel      = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 145, 16)];
    classLabel.font          = [UIFont fontWithName:@"SFUIText-Medium" size:14.5];
    classLabel.textAlignment = NSTextAlignmentCenter;
    classLabel.textColor     = COLOR_SCHEME;
    classLabel.text          = classLabelText;
    
    UILabel *topicLabel      = [[UILabel alloc] initWithFrame:CGRectMake(0, 17, 145, 15)];
    topicLabel.font          = [UIFont fontWithName:@"SFUIText-Light" size:12];
    topicLabel.textAlignment = NSTextAlignmentCenter;
    topicLabel.textColor     = COLOR_SCHEME;
    topicLabel.text          = self.topic;
    
    [titleLabelView setBackgroundColor:[UIColor clearColor]];
    [titleLabelView addSubview:classLabel];
    [titleLabelView addSubview:topicLabel];
    
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
    
    UIBarButtonItem *compose = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Compose"] style:UIBarButtonItemStylePlain target:self action:@selector(askQuestion)];
    
    //configure the navigation bar
    UIBarButtonItem *menu = [[UIBarButtonItem alloc] initWithCustomView:menuView];
    [self.navigationController.navigationBar setTintColor:COLOR_SCHEME];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barStyle    = UIBarStyleBlack;
    self.navigationItem.titleView                       = titleLabelView;
    self.navigationItem.leftBarButtonItem               = menu;
    self.navigationItem.rightBarButtonItem              = compose;
    self.navigationItem.hidesBackButton                 = YES;
}

- (void)askQuestion {
    PostQuestionTableViewController *PQTVC = [[PostQuestionTableViewController alloc]init];
    PQTVC.parseClass = self.parseClass;
    PQTVC.topic      = self.topic;
    PQTVC.delegate   = NQTVC;
    GKFadeNavigationController *nav = [[GKFadeNavigationController alloc]initWithRootViewController:PQTVC];
    [self presentViewController:nav animated:YES completion:nil];
}

@end
