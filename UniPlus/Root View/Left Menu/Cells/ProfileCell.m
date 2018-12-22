//
//  ProfileCell.m
//  UniPlus
//
//  Created by Jiahe Li on 20/09/2016.
//  Copyright © 2016 Quicky Studio. All rights reserved.
//

#import "ProfileCell.h"

@implementation ProfileCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.profilePhotoView.layer.cornerRadius = self.profilePhotoView.frame.size.height/2;
    self.profilePhotoView.layer.masksToBounds = YES;
   
    self.profilePhotoView.image = [UIImage imageNamed:@"empty-profile"];//place holder
    
    if ([PFUser currentUser]) {
        self.nameLabel.text = [[PFUser currentUser] objectForKey:@"nickName"];
        self.profilePhotoView.file = [[PFUser currentUser] objectForKey:@"profilePhoto"];
        [self.profilePhotoView loadInBackground];
    } else {
        self.nameLabel.text = @"Login/Sign Up";
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
