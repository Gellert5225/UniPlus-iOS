//
//  ProfileQuestionCell.m
//  UniPlus
//
//  Created by Jiahe Li on 04/11/2016.
//  Copyright © 2016 Quicky Studio. All rights reserved.
//

#import "ProfileQuestionCell.h"

@interface ProfileQuestionCell ()

@property (strong, nonatomic) NSMutableParagraphStyle *paragraphStyle;
@property (strong, nonatomic) NSMutableParagraphStyle *bodyParagraphStyle;
@property (strong, nonatomic) NSDictionary            *bodyAttribute;
@property (strong, nonatomic) NSDictionary            *titleAtrribute;

@end

@implementation ProfileQuestionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setUpAttributes];
    [_questionBodyLabel sizeToFit];
    [_questionTitleLabel sizeToFit];
    [_actionLabel sizeToFit];
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    [self setSelectedBackgroundView:bgColorView];
}

- (void)setObject:(PFObject *)object {
    _object = object;
    [self updateUI];
}

- (void)updateUI {
    if ([_object[@"type"] isEqualToString:@"Ask"]) {
        _actionLabel.text       = [NSString stringWithFormat:@"Asked"];
        _questionBodyLabel.attributedText = [[NSAttributedString alloc] initWithString:_object[@"toQuestion"][@"body"] attributes:_bodyAttribute];
    } else if ([_object[@"type"] isEqualToString:@"CommentToQuestion"]) {
        _actionLabel.text       = [NSString stringWithFormat:@"Commented on %@'s question",_object[@"toUser"][@"nickName"]];
        _questionBodyLabel.attributedText = [[NSAttributedString alloc] initWithString:_object[@"toComment"][@"commentBody"] attributes:_bodyAttribute];
    } else if ([_object[@"type"] isEqualToString:@"CommentToAnswer"]) {
        _actionLabel.text       = [NSString stringWithFormat:@"Commented on %@'s answer",_object[@"toUser"][@"nickName"]];
        _questionBodyLabel.attributedText = [[NSAttributedString alloc] initWithString:_object[@"toComment"][@"commentBody"] attributes:_bodyAttribute];
    } else if ([_object[@"type"] isEqualToString:@"CommentToComment"]) {
        _actionLabel.text       = [NSString stringWithFormat:@"Replied to %@", _object[@"toUser"][@"nickName"]];
        _questionBodyLabel.attributedText = [[NSAttributedString alloc] initWithString:_object[@"toComment"][@"commentBody"] attributes:_bodyAttribute];
    } else if ([_object[@"type"] isEqualToString:@"Answer"]) {
        _actionLabel.text       = @"Answered";
        _questionBodyLabel.attributedText = [[NSAttributedString alloc] initWithString:_object[@"toAnswer"][@"body"] attributes:_bodyAttribute];
    }
    
    _timeLabel.text = [self getTimeWithPostDate:_object.createdAt];
    _questionTitleLabel.attributedText = [[NSAttributedString alloc] initWithString:_object[@"toQuestion"][@"title"] attributes:_titleAtrribute];
}

- (void)setUpAttributes {
    _paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    _paragraphStyle.lineHeightMultiple = 16.0f;
    _paragraphStyle.maximumLineHeight  = 16.0f;
    
    _bodyParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    _bodyParagraphStyle.lineHeightMultiple = 14.0f;
    _bodyParagraphStyle.maximumLineHeight  = 14.0f;
    
    _bodyAttribute = @{
        NSParagraphStyleAttributeName:  _bodyParagraphStyle,
        NSForegroundColorAttributeName: [UIColor colorWithWhite:0 alpha:1.0],
        NSFontAttributeName:            [UIFont fontWithName:@"SFUIText-Regular" size:10]
    };
    
    _titleAtrribute = @{
        NSParagraphStyleAttributeName:  _paragraphStyle,
        NSForegroundColorAttributeName: [UIColor colorWithRed:33/255.0 green:91/255.0 blue:157/255.0 alpha:1.0],
        NSFontAttributeName:            [UIFont fontWithName:@"SFUIText-Regular" size:11]
    };
}

- (NSString *)getTimeWithPostDate:(NSDate *)postDate {
    NSDate *currentDate = [NSDate date];
    long min  = (long)([currentDate timeIntervalSinceDate:postDate]/60);
    long hour = min/60;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MMM dd, yyyy"];
    NSString *date = [dateFormat stringFromDate:postDate];
    
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"HH:mm"];
    NSString *time = [timeFormat stringFromDate:postDate];
    
    if ([currentDate timeIntervalSinceDate:postDate]<60) {
        return [NSString stringWithFormat:@"Just now"];
    } else {
        if (hour < 24) {
            return [NSString stringWithFormat:@"%@", time];
        } else {
            return [NSString stringWithFormat:@"%@", date];
        }
    }
}

@end
