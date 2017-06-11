//
//  UPHeaderView.m
//  UniPlus
//
//  Created by Jiahe Li on 09/06/2017.
//  Copyright © 2017 Quicky Studio. All rights reserved.
//

#import "UPHeaderView.h"

@implementation UPHeaderView

#pragma - mark Accessor

- (void)setUser:(PFUser *)user {
    _userNameLabel.text = user[@"nickName"];
    _institutionLabel.text = user[@"institution"];
    _reputationLabel.text = [NSString stringWithFormat:@"%@ Renown", [user[@"reputation"] stringValue]];
    _profileImageView.file = user[@"profilePhoto80"];
    [_profileImageView loadInBackground];
    
    [self setNeedsDisplay];
}

#pragma - mark Designated Initializer

- (id)initWithNibName:(NSString *)nibName {
    self = [super init];
    
    if (self) {
        CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
        
        self = [[[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil] objectAtIndex:0];
        self.frame = CGRectMake(0, 0, screenWidth, self.frame.size.height);
    }
    
    return self;
}

#pragma - mark Custom Drawing

- (void)drawRect:(CGRect)rect {
    _userNameLabel.layer.masksToBounds = NO;
    _userNameLabel.layer.shadowOpacity = 1.0;
    _userNameLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    _userNameLabel.layer.shadowRadius = 3.0f;
    _userNameLabel.layer.shadowOffset = CGSizeMake(1, 1);
    
    _institutionLabel.layer.masksToBounds = NO;
    _institutionLabel.layer.shadowOpacity = 1.0;
    _institutionLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    _institutionLabel.layer.shadowRadius = 3.0f;
    _institutionLabel.layer.shadowOffset = CGSizeMake(1, 1);
    
    _reputationLabel.layer.masksToBounds = NO;
    _reputationLabel.layer.shadowOpacity = 1.0;
    _reputationLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    _reputationLabel.layer.shadowRadius = 3.0f;
    _reputationLabel.layer.shadowOffset = CGSizeMake(1, 1);
    
    _profileImageView.layer.cornerRadius = _profileImageView.frame.size.height/2;
    _profileImageView.layer.masksToBounds = YES;
}

@end
