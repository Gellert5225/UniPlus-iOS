//
//  ProfileTableViewController.h
//  UniPlus
//
//  Created by Jiahe Li on 08/10/2016.
//  Copyright © 2016 Quicky Studio. All rights reserved.
//

#import "ParseUI.h"

@interface FeedsViewController : PFQueryTableViewController

@property (strong, nonatomic) PFUser *user;
@property (nonatomic) BOOL isLoadingForFirstTime;

@end
