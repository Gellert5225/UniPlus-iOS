//
//  SWRevealViewController.h
//  UniPlus
//
//  Created by Jiahe Li on 27/09/2014.
//  Copyright (c) 2014 Jiahe Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SWRevealViewController;
@protocol SWRevealViewControllerDelegate;

#pragma mark - SWRevealViewController Class

typedef enum {
    FrontViewPositionLeftSideMostRemoved,
    
    FrontViewPositionLeftSideMost,
    
    FrontViewPositionLeftSide,

	FrontViewPositionLeft,
    
	FrontViewPositionRight,
    
	FrontViewPositionRightMost,
    
    FrontViewPositionRightMostRemoved,
    
} FrontViewPosition;

@interface SWRevealViewController : UIViewController

- (id)initWithRearViewController:(UIViewController *)rearViewController frontViewController:(UIViewController *)frontViewController;

@property (nonatomic) UIViewController *rearViewController;
- (void)setRearViewController:(UIViewController *)rearViewController animated:(BOOL)animated;

@property (nonatomic) UIViewController *rightViewController;
- (void)setRightViewController:(UIViewController *)rightViewController animated:(BOOL)animated;

@property (nonatomic) UIViewController *frontViewController;
- (void)setFrontViewController:(UIViewController *)frontViewController animated:(BOOL)animated;

- (void)pushFrontViewController:(UIViewController *)frontViewController animated:(BOOL)animated;

@property (nonatomic) FrontViewPosition frontViewPosition;

- (void)setFrontViewPosition:(FrontViewPosition)frontViewPosition animated:(BOOL)animated;

- (void)revealToggleAnimated:(BOOL)animated;
- (void)rightRevealToggleAnimated:(BOOL)animated;

- (IBAction)revealToggle:(id)sender;
- (IBAction)rightRevealToggle:(id)sender;

- (UIPanGestureRecognizer*)panGestureRecognizer;

- (UITapGestureRecognizer*)tapGestureRecognizer;

@property (nonatomic) CGFloat rearViewRevealWidth;
@property (nonatomic) CGFloat rightViewRevealWidth;

@property (nonatomic) CGFloat rearViewRevealOverdraw;
@property (nonatomic) CGFloat rightViewRevealOverdraw;

@property (nonatomic) CGFloat rearViewRevealDisplacement;
@property (nonatomic) CGFloat rightViewRevealDisplacement;

@property (nonatomic) CGFloat draggableBorderWidth;

@property (nonatomic) BOOL bounceBackOnOverdraw;
@property (nonatomic) BOOL bounceBackOnLeftOverdraw;

@property (nonatomic) BOOL stableDragOnOverdraw;
@property (nonatomic) BOOL stableDragOnLeftOverdraw;

@property (nonatomic) BOOL presentFrontViewHierarchically;

@property (nonatomic) CGFloat quickFlickVelocity;

@property (nonatomic) NSTimeInterval toggleAnimationDuration;

@property (nonatomic) NSTimeInterval replaceViewAnimationDuration;

@property (nonatomic) CGFloat frontViewShadowRadius;

@property (nonatomic) CGSize frontViewShadowOffset;

@property (nonatomic) CGFloat frontViewShadowOpacity;

@property (nonatomic) CGColorRef frontViewShadowColor;

@property (nonatomic,weak) id<SWRevealViewControllerDelegate> delegate;

@end

#pragma mark - SWRevealViewControllerDelegate Protocol
typedef enum {
    SWRevealControllerOperationReplaceRearController,
    SWRevealControllerOperationReplaceFrontController,
    SWRevealControllerOperationReplaceRightController,
    
} SWRevealControllerOperation;


@protocol SWRevealViewControllerDelegate<NSObject>

@optional

- (void)revealController:(SWRevealViewController *)revealController willMoveToPosition:(FrontViewPosition)position;
- (void)revealController:(SWRevealViewController *)revealController didMoveToPosition:(FrontViewPosition)position;

- (void)revealController:(SWRevealViewController *)revealController animateToPosition:(FrontViewPosition)position;

- (BOOL)revealControllerPanGestureShouldBegin:(SWRevealViewController *)revealController;

- (BOOL)revealControllerTapGestureShouldBegin:(SWRevealViewController *)revealController;

- (BOOL)revealController:(SWRevealViewController *)revealController
    panGestureRecognizerShouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer;

- (BOOL)revealController:(SWRevealViewController *)revealController
    tapGestureRecognizerShouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer;

- (void)revealControllerPanGestureBegan:(SWRevealViewController *)revealController;
- (void)revealControllerPanGestureEnded:(SWRevealViewController *)revealController;

- (void)revealController:(SWRevealViewController *)revealController panGestureBeganFromLocation:(CGFloat)location progress:(CGFloat)progress;
- (void)revealController:(SWRevealViewController *)revealController panGestureMovedToLocation:(CGFloat)location progress:(CGFloat)progress;
- (void)revealController:(SWRevealViewController *)revealController panGestureEndedToLocation:(CGFloat)location progress:(CGFloat)progress;

- (void)revealController:(SWRevealViewController *)revealController willAddViewController:(UIViewController *)viewController
    forOperation:(SWRevealControllerOperation)operation animated:(BOOL)animated;
- (void)revealController:(SWRevealViewController *)revealController didAddViewController:(UIViewController *)viewController
    forOperation:(SWRevealControllerOperation)operation animated:(BOOL)animated;

- (id<UIViewControllerAnimatedTransitioning>)revealController:(SWRevealViewController *)revealController
    animationControllerForOperation:(SWRevealControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC;

@end

#pragma mark - UIViewController(SWRevealViewController) Category

@interface UIViewController(SWRevealViewController)

- (SWRevealViewController*)revealViewController;

@end

extern NSString* const SWSegueRearIdentifier;
extern NSString* const SWSegueFrontIdentifier;
extern NSString* const SWSegueRightIdentifier;

#pragma mark - SWRevealViewControllerSegueSetController Classes

@interface SWRevealViewControllerSegueSetController : UIStoryboardSegue
@end

#pragma mark - SWRevealViewControllerSeguePushController Classes

@interface SWRevealViewControllerSeguePushController : UIStoryboardSegue
@end

#pragma mark - SWRevealViewControllerSegue (Deprecated)

@interface SWRevealViewControllerSegue : UIStoryboardSegue
@property (nonatomic, strong) void(^performBlock)( SWRevealViewControllerSegue* segue, UIViewController* svc, UIViewController* dvc );
@end
