//
//  AcceptAnswerCell.m
//  UniPlus
//
//  Created by Jiahe Li on 16/11/2016.
//  Copyright © 2016 Quicky Studio. All rights reserved.
//

#import "AcceptAnswerCell.h"

@interface AcceptAnswerCell ()<UIGestureRecognizerDelegate>

@property (strong, nonatomic) NSMutableParagraphStyle *paragraphStyle;
@property (strong, nonatomic) NSDictionary            *bodyAttribute;

@end

@implementation AcceptAnswerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setUpAttributes];
    
    _voteLabel.backgroundColor = [UIColor colorWithRed:244/255.0 green:246/255.0 blue:249/255.0 alpha:1];
    
    UIView *topSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 0.5)];
    topSeparatorView.layer.borderColor = [UIColor colorWithRed:209/255.0 green:209/255.0 blue:214/255.0 alpha:1].CGColor;
    topSeparatorView.layer.borderWidth = 0.5;
    [self.contentView addSubview:topSeparatorView];
    
    [_answerBody sizeToFit];
    _answerBody.contentInset = UIEdgeInsetsMake(0,-1,0,-4);
    
    UITapGestureRecognizer *tapOnMedal = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnAccept)];
    [_acceptView addGestureRecognizer:tapOnMedal];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)tapOnAccept {
    if ([self image:_acceptView.image isEqualTo:[UIImage imageNamed:@"medal"]]) {
        //accept the answer
        _acceptView.image = [UIImage imageNamed:@"medal-fill"];
        [self.contentView setNeedsDisplay];
        [_delegate acceptAnswer:_answer accepted:YES];
    } else {
        _acceptView.image = [UIImage imageNamed:@"medal"];
        [self.contentView setNeedsDisplay];
        [_delegate acceptAnswer:_answer accepted:NO];
    }
}

- (void)setAnswer:(Answer *)answer {
    _answer = answer;
    
    if ([answer.currentUserVote isEqualToString:@"upVote"]) {
        _upVoteView.image = [UIImage imageNamed:@"tri-up-sel"];
        _downVoteView.image = [UIImage imageNamed:@"tri-down"];
    } else if ([answer.currentUserVote isEqualToString:@"downVote"]) {
        _upVoteView.image = [UIImage imageNamed:@"tri-up"];
        _downVoteView.image = [UIImage imageNamed:@"tri-down-sel"];
        
    } else {
        _upVoteView.image = [UIImage imageNamed:@"tri-up"];
        _downVoteView.image = [UIImage imageNamed:@"tri-down"];
    }
    
    if (_answer.body) {
        _answerBody.attributedText = [[NSAttributedString alloc] initWithString:_answer.body attributes:_bodyAttribute];
    }
    
    _voteLabel.text      = [_answer.upVotes stringValue];
    _upVoteView.object   = _answer;
    _upVoteView.own      = [_answer.author.objectId isEqualToString:[PFUser currentUser].objectId];
    _upVoteView.type     = @"Answers";
    _downVoteView.object = _answer;
    _downVoteView.own    = [_answer.author.objectId isEqualToString:[PFUser currentUser].objectId];
    _downVoteView.type   = @"Answers";
}

- (void)setUpAttributes {
    _paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    _paragraphStyle.lineHeightMultiple = 16.0f;
    _paragraphStyle.maximumLineHeight  = 16.0f;
    
    _bodyAttribute = @{
       NSParagraphStyleAttributeName:  _paragraphStyle,
       NSForegroundColorAttributeName: [UIColor colorWithWhite:0 alpha:0.9],
       NSFontAttributeName:            [UIFont fontWithName:@"SFUIText-Regular" size:12]
    };
}

- (BOOL)image:(UIImage *)image1 isEqualTo:(UIImage *)image2 {
    NSData *data1 = UIImagePNGRepresentation(image1);
    NSData *data2 = UIImagePNGRepresentation(image2);
    
    return [data1 isEqual:data2];
}

@end
