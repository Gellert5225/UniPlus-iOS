//
//  ProfileTableViewController.h
//  UniPlus
//
//  Created by Jiahe Li on 08/10/2016.
//  Copyright © 2016 Quicky Studio. All rights reserved.
//

#import "ParseUI.h"
#import "UPHeaderView.h"
#import "ProfileTableViewModel.h"
#import <GKFadeNavigationController/GKFadeNavigationController.h>
#import <Parse/Parse.h>

@interface ProfileTableViewController : UITableViewController <GKFadeNavigationControllerDelegate>

@property (strong, nonatomic) UPHeaderView *headerView;
@property (strong, nonatomic) PFUser *profileUser;
@property (strong, nonatomic) ProfileTableViewModel *viewModel;

@end

@interface UIImageView(Shadow)

- (void)addShadowWithOpacity:(float)opacity;

@end
