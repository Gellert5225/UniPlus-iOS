//
//  ProfileCell.h
//  UniPlus
//
//  Created by Jiahe Li on 20/09/2016.
//  Copyright © 2016 Quicky Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "ParseUI.h"

@interface ProfileCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet PFImageView *profilePhotoView;

@end
