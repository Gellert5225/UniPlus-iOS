//
//  UPHeaderView.h
//  UniPlus
//
//  Created by Jiahe Li on 09/06/2017.
//  Copyright © 2017 Quicky Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParseUI.h"

@interface UPHeaderView : UIView

@property (weak, nonatomic) IBOutlet PFImageView *headerImageView;
@property (weak, nonatomic) IBOutlet PFImageView *profileImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerImageTopConstraint;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *institutionLabel;
@property (weak, nonatomic) IBOutlet UILabel *reputationLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerImageBottomConstraint;
@property (weak, nonatomic) IBOutlet UIView *contentWrapperView;

@property (strong, nonatomic) PFUser *user;

- (id)initWithNibName:(NSString *)nibName;

@end
