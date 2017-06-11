//
//  ProfileQuestionCell.h
//  UniPlus
//
//  Created by Jiahe Li on 04/11/2016.
//  Copyright © 2016 Quicky Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ProfileQuestionCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *actionLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *questionTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *questionBodyLabel;
@property (strong, nonatomic) PFObject *object;

@end
