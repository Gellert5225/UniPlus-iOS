//
//  QuestionDetailTitleCell.m
//  UniPlus
//
//  Created by Jiahe Li on 20/10/2016.
//  Copyright © 2016 Quicky Studio. All rights reserved.
//

#import "QuestionDetailTitleCell.h"

@interface QuestionDetailTitleCell ()

@property (strong, nonatomic) NSMutableParagraphStyle *paragraphStyle;
@property (strong, nonatomic) NSDictionary            *titleAtrribute;

@end

@implementation QuestionDetailTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self setUpAttributes];
    
    UIView *topSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 0.5)];
    topSeparatorView.layer.borderColor = [UIColor colorWithRed:209/255.0 green:209/255.0 blue:214/255.0 alpha:1].CGColor;
    topSeparatorView.layer.borderWidth = 0.5;
    [self.contentView addSubview:topSeparatorView];
    
    _titleLabel.backgroundColor = [UIColor whiteColor];
    _upVotesLabel.backgroundColor = [UIColor colorWithRed:244/255.0 green:246/255.0 blue:249/255.0 alpha:1];
    
    _upImage.backgroundColor = [UIColor colorWithRed:244/255.0 green:246/255.0 blue:249/255.0 alpha:1];
    _downImage.backgroundColor = [UIColor colorWithRed:244/255.0 green:246/255.0 blue:249/255.0 alpha:1];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setQuestion:(Question *)question {
    _question = question;
    
    _upImage.object = _question;
    _upImage.own = [_question.author.objectId isEqualToString:[PFUser currentUser].objectId];
    _upImage.type = @"Questions";
    
    _downImage.object = _question;
    _downImage.own = [_question.author.objectId isEqualToString:[PFUser currentUser].objectId];
    _downImage.type = @"Questions";
    
    [self updateUI];
}

- (void)setQuestionObject:(PFObject *)questionObject {
    _questionObject = questionObject;
    _titleLabel.attributedText = [[NSMutableAttributedString alloc] initWithString:questionObject[@"title"] attributes:_titleAtrribute];
}

- (void)updateUI {    
    if ([_question.currentUserVote isEqualToString:@"upVote"]) {
        _upImage.image = [UIImage imageNamed:@"tri-up-sel"];
        _downImage.image = [UIImage imageNamed:@"tri-down"];
    } else if ([_question.currentUserVote isEqualToString:@"downVote"]) {
        _upImage.image = [UIImage imageNamed:@"tri-up"];
        _downImage.image = [UIImage imageNamed:@"tri-down-sel"];
    } else {
        _upImage.image = [UIImage imageNamed:@"tri-up"];
        _downImage.image = [UIImage imageNamed:@"tri-down"];
    }
    
    _upVotesLabel.text = [_question.upVotes stringValue];
}

- (void)setUpAttributes {
    _paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    _paragraphStyle.lineHeightMultiple = 16.0f;
    _paragraphStyle.maximumLineHeight  = 16.0f;
    
    _titleAtrribute = @{
        NSParagraphStyleAttributeName:  _paragraphStyle,
        NSForegroundColorAttributeName: [UIColor colorWithRed:53/255.0 green:111/255.0 blue:177/255.0 alpha:1.0],
        NSFontAttributeName:            [UIFont fontWithName:@"SFUIText-Regular" size:13]
    };
}

@end
