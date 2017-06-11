//
//  AuthorCell.h
//  UniPlus
//
//  Created by Jiahe Li on 22/10/2016.
//  Copyright © 2016 Quicky Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "ParseUI.h"

@interface AuthorCell : UITableViewCell

@property (weak, nonatomic) IBOutlet PFImageView *profilePhotoView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *renownLabel;
@property (weak, nonatomic) IBOutlet UILabel *askLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (strong, nonatomic) PFUser *author;
@property (strong, nonatomic) NSDate *creationDate;

@end
