//
//  ProfileOverViewCell.m
//  UniPlus
//
//  Created by Jiahe Li on 08/04/2017.
//  Copyright © 2017 Quicky Studio. All rights reserved.
//

#import "ProfileOverViewCell.h"

#define IMG_TINT_COLOR [UIColor colorWithRed:129/255.0 green:129/255.0 blue:145/255.0 alpha:1]

@implementation ProfileOverViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _editProfileButton.layer.cornerRadius = 8.0;
    _editProfileButton.layer.borderWidth = 1.0;
    _editProfileButton.layer.borderColor = [UIColor colorWithRed:109/255.0 green:109/255.0 blue:125/255.0 alpha:1].CGColor;
    _editProfileButton.layer.masksToBounds = YES;
    
    _profileImageView.layer.cornerRadius = 10.0;
    _profileImageView.layer.borderColor = [UIColor colorWithRed:159/255.0 green:159/255.0 blue:164/255.0 alpha:1.0].CGColor;
    _profileImageView.layer.borderWidth = 0.5;
    _profileImageView.layer.masksToBounds = YES;
    
    [_infoLabel sizeToFit];
    
    _locationImageView.image = [_locationImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [_locationImageView setTintColor:IMG_TINT_COLOR];
}

- (void)setProfileUser:(PFUser *)profileUser {
    _profileUser = profileUser;
    [self updateUI];
}

- (void)updateUI {
    _userNameLabel.text = [NSString stringWithFormat:@"@%@", _profileUser.username];
    _nickNameLabel.text = _profileUser[@"nickName"];
    _collegeLabel.text = _profileUser[@"institution"];
    _renownLabel.text = [_profileUser[@"reputation"] stringValue];
    _numberOfQuestionsLabel.text = [_profileUser[@"numberOfPosts"] stringValue];
    _numberOfAnswersLabel.text = [_profileUser[@"numberOfAnswers"] stringValue];
    _profileImageView.image = [UIImage imageNamed:@"empty-profile"];//placeholder
    _profileImageView.file = _profileUser[@"profilePhoto80"];
    [_profileImageView loadInBackground];
}

@end
