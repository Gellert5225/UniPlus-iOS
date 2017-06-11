//
//  AcceptAnswerCell.h
//  UniPlus
//
//  Created by Jiahe Li on 16/11/2016.
//  Copyright © 2016 Quicky Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UpVoteView.h"
#import "DownVoteView.h"
#import "Answer.h"

@class AcceptAnswerCell;

@protocol AcceptAnswerCellDelegate
- (void)acceptAnswer:(Answer *)answer accepted:(BOOL)accept;
@end

@interface AcceptAnswerCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextView *answerBody;
@property (weak, nonatomic) IBOutlet UpVoteView *upVoteView;
@property (weak, nonatomic) IBOutlet DownVoteView *downVoteView;
@property (weak, nonatomic) IBOutlet UIImageView *acceptView;
@property (weak, nonatomic) IBOutlet UILabel *voteLabel;

@property (strong, nonatomic) Answer *answer;

@property (nonatomic, weak) id <AcceptAnswerCellDelegate> delegate;

@end
