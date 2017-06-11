//
//  QuestionDetailBodyCell.m
//  UniPlus
//
//  Created by Jiahe Li on 20/10/2016.
//  Copyright © 2016 Quicky Studio. All rights reserved.
//

#import "QuestionDetailBodyCell.h"

@interface QuestionDetailBodyCell ()

@property (strong, nonatomic) NSMutableParagraphStyle *paragraphStyle;
@property (strong, nonatomic) NSDictionary            *bodyAttribute;

@end

@implementation QuestionDetailBodyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setUpAttributes];
    
    UIView *topSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 0.5)];
    topSeparatorView.layer.borderColor = [UIColor colorWithRed:209/255.0 green:209/255.0 blue:214/255.0 alpha:1].CGColor;
    topSeparatorView.layer.borderWidth = 0.5;
    [self.contentView addSubview:topSeparatorView];
    
    _bodyTextView.backgroundColor = [UIColor whiteColor];
    _bodyTextView.contentInset = UIEdgeInsetsMake(0,-1,0,-4);
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setQuestion:(Question *)question {
    _question = question;
    if (_question.body) {
        _bodyTextView.attributedText = [[NSAttributedString alloc] initWithString:_question.body attributes:_bodyAttribute];
    }
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

@end
