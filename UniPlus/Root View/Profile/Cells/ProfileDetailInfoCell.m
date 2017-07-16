//
//  ProfileDetailInfoCell.m
//  UniPlus
//
//  Created by Jiahe Li on 09/06/2017.
//  Copyright © 2017 Quicky Studio. All rights reserved.
//

#import "ProfileDetailInfoCell.h"

@implementation ProfileDetailInfoCell

- (void)setUser:(PFUser *)user {
    _user = user;
    
    [self updateUI];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [_questionView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapQuestion)]];
    [_answerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapAnswer)]];
}

- (void)didTapQuestion {
    [_delegate didTapQuestionView];
}

- (void)didTapAnswer {
    [_delegate didTapAnswerView];
}

- (void)updateUI {
    _numberOfAnswerLabel.text = _user[@"numberOfAnswers"]?[_user[@"numberOfAnswers"] stringValue]:@"0";
    _numberOfQuestionLabel.text = _user[@"numberOfQuestions"]?[_user[@"numberOfQuestions"] stringValue]:@"0";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
