//
//  QuestionDetailTitleCell.h
//  UniPlus
//
//  Created by Jiahe Li on 20/10/2016.
//  Copyright © 2016 Quicky Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UpVoteView.h"
#import "DownVoteView.h"
#import "Question.h"

@interface QuestionDetailTitleCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel      *titleLabel;
@property (weak, nonatomic) IBOutlet UpVoteView   *upImage;
@property (weak, nonatomic) IBOutlet DownVoteView *downImage;
@property (weak, nonatomic) IBOutlet UIView       *voteWrapperView;
@property (weak, nonatomic) IBOutlet UILabel      *upVotesLabel;

@property (strong, nonatomic) Question *question;
@property (strong, nonatomic) PFObject *questionObject;

@end
