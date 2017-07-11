//
//  InboxMessageCell.m
//  UniPlus
//
//  Created by Jiahe Li on 10/07/2017.
//  Copyright © 2017 Quicky Studio. All rights reserved.
//

#import "InboxMessageCell.h"

@implementation InboxMessageCell

#pragma - mark Accessors

- (void)setFeedObject:(PFObject *)feedObject {
    _feedObject = feedObject;
    [self updateUI];
}

#pragma - mark Inherited

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [_messageTypeLabel sizeToFit];
    [_titleLabel sizeToFit];
    [_messageBodyLabel sizeToFit];
    
    UIView *selectedBackground = [[UIView alloc] init];
    selectedBackground.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    [self setSelectedBackgroundView:selectedBackground];
}

#pragma - mark Private

- (void)updateUI {
    if ([_feedObject[@"type"] isEqualToString:@"commentToQuestion"]) {
        [self setUpMessageTypeLabelWithString:@"commented on your question"];
        _titleLabel.text = _feedObject[@"toQuestion"][@"title"];
        _messageBodyLabel.text = _feedObject[@"toComment"][@"commentBody"];
    } else if ([_feedObject[@"type"] isEqualToString:@"commentToAnswer"]) {
        [self setUpMessageTypeLabelWithString:@"commented on your answer"];
        _titleLabel.text = _feedObject[@"toAnswer"][@"body"];
        _messageBodyLabel.text = _feedObject[@"toComment"][@"commentBody"];
    } else if ([_feedObject[@"type"] isEqualToString:@"Answer"]) {
        [self setUpMessageTypeLabelWithString:@"answered your question"];
        _titleLabel.text = _feedObject[@"toQuestion"][@"title"];
        _messageBodyLabel.text = _feedObject[@"toAnswer"][@"body"];
    }
}

- (void)setUpMessageTypeLabelWithString:(NSString *)string {
    NSString *userName = _feedObject[@"fromUser"][@"username"];
    NSString *messageString = [NSString stringWithFormat:@"%@ %@", userName, string];
    NSMutableAttributedString *attributedMessageString = [[NSMutableAttributedString alloc] initWithString:messageString];
    [attributedMessageString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"SFUIText-Regular" size:11] range:NSMakeRange(userName.length+1, messageString.length)];
    [attributedMessageString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:149/255.0 green:149/255.0 blue:165/255.0 alpha:1] range:NSMakeRange(userName.length+1, messageString.length)];
    [attributedMessageString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, userName.length)];
    [attributedMessageString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"SFUIText-Medium" size:11] range:NSMakeRange(0, userName.length)];
    
    _messageTypeLabel.attributedText = attributedMessageString;
}

@end
