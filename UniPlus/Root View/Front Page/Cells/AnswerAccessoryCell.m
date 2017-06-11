//
//  AnswerAccessoryCell.m
//  UniPlus
//
//  Created by Jiahe Li on 28/11/2016.
//  Copyright © 2016 Quicky Studio. All rights reserved.
//

#import "AnswerAccessoryCell.h"

#define IMG_TINT_COLOR [UIColor colorWithRed:129/255.0 green:129/255.0 blue:145/255.0 alpha:1]

@implementation AnswerAccessoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _editImageView.image = [_editImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [_editImageView setTintColor:IMG_TINT_COLOR];
    
    _reportImageView.image = [_reportImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [_reportImageView setTintColor:IMG_TINT_COLOR];
    
    _moreImageView.image = [_moreImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [_moreImageView setTintColor:IMG_TINT_COLOR];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIView *topSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 0.5)];
    topSeparatorView.layer.borderColor = [UIColor colorWithRed:209/255.0 green:209/255.0 blue:214/255.0 alpha:1].CGColor;
    topSeparatorView.layer.borderWidth = 0.5;
    [self.contentView addSubview:topSeparatorView];
    
    UIView *bottomSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-0.5, [[UIScreen mainScreen] bounds].size.width, 0.5)];
    bottomSeparatorView.backgroundColor = [UIColor colorWithRed:209/255.0 green:209/255.0 blue:214/255.0 alpha:1];
    [self.contentView addSubview:bottomSeparatorView];
}

@end
