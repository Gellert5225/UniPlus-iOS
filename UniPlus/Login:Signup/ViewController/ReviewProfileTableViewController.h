//
//  ReviewProfileTableViewController.h
//  Shutteradio
//
//  Created by Jiahe Li on 11/10/2015.
//  Copyright © 2015 Quicky Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICGViewController.h"
#import "SearchInstitutionTableViewController.h"
#import "SWRevealViewController.h"
#import "SearchMajorTableViewController.h"
#import <Parse/Parse.h>

@interface ReviewProfileTableViewController : UITableViewController<UITextFieldDelegate, UIGestureRecognizerDelegate, UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,SearchInstitutionTableViewControllerDelegate, SearchMajorTableViewControllerDelegate, SWRevealViewControllerDelegate>

@property (strong, nonatomic) UIButton *finish;
@property (strong, nonatomic) UIView   *inputAccView;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *nickName;
@property (strong, nonatomic) NSString *institution;
@property (strong, nonatomic) NSString *topic;
@property (strong, nonatomic) NSData   *profileData;
@property (nonatomic, assign) id       currentResponder;
@property (nonatomic)         BOOL     isFromSignUp;
@property (strong, nonatomic) PFUser *user;

@end
