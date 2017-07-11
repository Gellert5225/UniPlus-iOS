//
//  InboxMessageCell.h
//  UniPlus
//
//  Created by Jiahe Li on 10/07/2017.
//  Copyright © 2017 Quicky Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "ParseUI.h"

@interface InboxMessageCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *messageTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageBodyLabel;
@property (weak, nonatomic) IBOutlet PFImageView *profileImageView;

@property (strong, nonatomic) PFObject *feedObject;

@end
