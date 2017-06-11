//
//  ProfileOverViewCell.h
//  UniPlus
//
//  Created by Jiahe Li on 08/04/2017.
//  Copyright © 2017 Quicky Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "ParseUI.h"

@interface ProfileOverViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet PFImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIButton *editProfileButton;
@property (weak, nonatomic) IBOutlet UILabel *collegeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *locationImageView;
@property (weak, nonatomic) IBOutlet UILabel *renownLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberOfQuestionsLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberOfAnswersLabel;

@property (weak, nonatomic) PFUser *profileUser;

@end
