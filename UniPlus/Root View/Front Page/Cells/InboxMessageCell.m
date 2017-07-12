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
    
    UIView *topSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 0.5)];
    topSeparatorView.layer.borderColor = [UIColor colorWithRed:219/255.0 green:219/255.0 blue:224/255.0 alpha:1].CGColor;
    topSeparatorView.layer.borderWidth = 0.5;
    [self.contentView addSubview:topSeparatorView];
    
    UIView *selectedBackground = [[UIView alloc] init];
    selectedBackground.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    [self setSelectedBackgroundView:selectedBackground];
}

#pragma - mark Private

- (void)updateUI {
    if ([_feedObject[@"type"] isEqualToString:@"CommentToQuestion"]) {
        [self setUpMessageTypeLabelWithString:@"commented"];
        _titleLabel.text = _feedObject[@"toQuestion"][@"title"];
        _messageBodyLabel.text = _feedObject[@"toComment"][@"commentBody"];
    } else if ([_feedObject[@"type"] isEqualToString:@"CommentToAnswer"]) {
        [self setUpMessageTypeLabelWithString:@"commented"];
        _titleLabel.text = _feedObject[@"toAnswer"][@"body"];
        _messageBodyLabel.text = _feedObject[@"toComment"][@"commentBody"];
    } else if ([_feedObject[@"type"] isEqualToString:@"Answer"]) {
        [self setUpMessageTypeLabelWithString:@"answered"];
        _titleLabel.text = _feedObject[@"toQuestion"][@"title"];
        _messageBodyLabel.text = _feedObject[@"toAnswer"][@"body"];
    }
    
    _profileImageView.file = _feedObject[@"fromUser"][@"profilePhoto80"];
    [_profileImageView loadInBackground];
    
    _profileImageView.layer.masksToBounds = YES;
    _profileImageView.layer.cornerRadius  = 5.0f;
    _profileImageView.layer.shouldRasterize = YES;
    _profileImageView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
}

- (void)setUpMessageTypeLabelWithString:(NSString *)string {
    NSString *userName = _feedObject[@"fromUser"][@"username"];
    NSString *messageString = [NSString stringWithFormat:@"%@ %@", userName, string];
    NSMutableAttributedString *attributedMessageString = [[NSMutableAttributedString alloc] initWithString:messageString];
    [attributedMessageString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"SFUIText-Regular" size:12] range:NSMakeRange(userName.length, string.length+1)];
    [attributedMessageString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:0 alpha:0.5] range:NSMakeRange(userName.length, string.length+1)];
    [attributedMessageString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:0 alpha:0.7] range:NSMakeRange(0, userName.length)];
    [attributedMessageString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"SFUIText-Medium" size:12] range:NSMakeRange(0, userName.length)];
    
    _messageTypeLabel.attributedText = attributedMessageString;
}

@end
