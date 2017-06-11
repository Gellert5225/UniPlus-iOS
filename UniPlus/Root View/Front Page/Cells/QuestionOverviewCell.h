//
//  QuestionOverviewCell.h
//  UniPlus
//
//  Created by Jiahe Li on 26/09/2016.
//  Copyright © 2016 Quicky Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParseUI.h"
#import <Parse/Parse.h>

@interface QuestionOverviewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *questionTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@property (weak, nonatomic) IBOutlet UILabel *upvoteLabel;
@property (weak, nonatomic) IBOutlet UILabel *replyLabel;
@property (weak, nonatomic) IBOutlet UILabel *viewLabel;

@property (weak, nonatomic) IBOutlet UIImageView *thumbupImgView;
@property (weak, nonatomic) IBOutlet UIImageView *replyImgView;
@property (weak, nonatomic) IBOutlet UIImageView *viewImgView;
@property (weak, nonatomic) IBOutlet PFImageView *profileImageView;

@property (strong, nonatomic) PFObject *questionObject;

@end
