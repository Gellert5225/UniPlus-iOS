//
//  AnswerItCell.m
//  UniPlus
//
//  Created by Jiahe Li on 21/10/2016.
//  Copyright © 2016 Quicky Studio. All rights reserved.
//

#import "AnswerItCell.h"

@implementation AnswerItCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [_answerButton setBackgroundColor:[UIColor colorWithRed:53/255.0 green:111/255.0 blue:177/255.0 alpha:1.0]];
    [_answerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _answerButton.titleLabel.font = [UIFont fontWithName:@"SFUIText-Regular" size:18];
    
    [_answerButton.titleLabel setOpaque:YES];
    [_answerButton.titleLabel setBackgroundColor:[UIColor colorWithRed:53/255.0 green:111/255.0 blue:177/255.0 alpha:1.0]];
    
    [_answerButton setOpaque:YES];
    
    _answerButton.layer.masksToBounds = YES;
    _answerButton.layer.cornerRadius  = 4.0f;
    _answerButton.layer.shouldRasterize = YES;
    _answerButton.layer.rasterizationScale = [[UIScreen mainScreen] scale];

    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)didTapAnswerButton:(UIButton *)sender {
    
}

@end
