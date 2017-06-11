//
//  AddCommentCell.m
//  UniPlus
//
//  Created by Jiahe Li on 21/10/2016.
//  Copyright © 2016 Quicky Studio. All rights reserved.
//

#import "AddCommentCell.h"

@implementation AddCommentCell
@synthesize shouldAddShadow;

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [_commentButton setBackgroundColor:[UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1.0]];
    [_commentButton setTitleColor:[UIColor colorWithRed:53/255.0 green:111/255.0 blue:177/255.0 alpha:1.0] forState:UIControlStateNormal];
    [_commentButton.titleLabel setOpaque:YES];
    [_commentButton.titleLabel setBackgroundColor:[UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1.0]];
    _commentButton.titleLabel.font = [UIFont fontWithName:@"SFUIText-Regular" size:12];
    
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
