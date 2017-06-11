//
//  CommentCell.m
//  UniPlus
//
//  Created by Jiahe Li on 24/10/2016.
//  Copyright © 2016 Quicky Studio. All rights reserved.
//

#import "CommentCell.h"

@interface CommentCell ()

@property (strong, nonatomic) NSMutableParagraphStyle *paragraphStyle;

@end

@implementation CommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    _paragraphStyle.lineHeightMultiple = 16.0f;
    _paragraphStyle.maximumLineHeight  = 16.0f;
    
    _commentLabel.backgroundColor = [UIColor colorWithRed:244/255.0 green:246/255.0 blue:249/255.0 alpha:1.0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setComment:(Comment *)comment {
    _comment = comment;
    _commentLabel.attributedText = [self configureCommentLabelWithComment:comment];
}

- (NSMutableAttributedString *)configureCommentLabelWithComment:(Comment *)comment {
    NSString *commentBody = comment.body;
    NSString *username    = comment.author[@"nickName"];
    
    NSMutableAttributedString *body = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ - %@", commentBody, username]];
    
    [body addAttribute:NSForegroundColorAttributeName
                 value:[UIColor colorWithRed:89/255.0 green:89/255.0 blue:105/255.0 alpha:1.0]
                 range:NSMakeRange(0, commentBody.length+3)];
    
    [body addAttribute:NSForegroundColorAttributeName
                 value:[UIColor colorWithRed:53/255.0 green:111/255.0 blue:177/255.0 alpha:1]
                 range:NSMakeRange(commentBody.length+3, username.length)];
    
    [body addAttribute:NSFontAttributeName
                 value:[UIFont fontWithName:@"SFUIText-Regular" size:11]
                 range:NSMakeRange(0, commentBody.length+3)];
    
    [body addAttribute:NSFontAttributeName
                 value:[UIFont fontWithName:@"SFUIText-Medium" size:11]
                 range:NSMakeRange(commentBody.length+3, username.length)];
    
    [body addAttribute:NSParagraphStyleAttributeName
                 value:_paragraphStyle
                 range:NSMakeRange(0, body.length)];
    
    return body;
}

@end
