//
//  UserQuestionPostTableViewController.h
//  UniPlus
//
//  Created by Jiahe Li on 09/07/2017.
//  Copyright © 2017 Quicky Studio. All rights reserved.
//

#import "PFQueryTableViewController.h"
#import <Parse/Parse.h>

@interface UserQuestionPostTableViewController : PFQueryTableViewController

@property (strong, nonatomic) PFUser *user;

- (id)initWithStyle:(UITableViewStyle)style queryUser:(PFUser *)user;

@end
