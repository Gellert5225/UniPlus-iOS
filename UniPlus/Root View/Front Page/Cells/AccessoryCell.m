//
//  AccessoryCell.m
//  UniPlus
//
//  Created by Jiahe Li on 21/10/2016.
//  Copyright © 2016 Quicky Studio. All rights reserved.
//

#import "AccessoryCell.h"

#define IMG_TINT_COLOR [UIColor colorWithRed:129/255.0 green:129/255.0 blue:145/255.0 alpha:1]

@implementation AccessoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _flagImageView.image = [_flagImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [_flagImageView setTintColor:IMG_TINT_COLOR];
    
    _editImageView.image = [_editImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [_editImageView setTintColor:IMG_TINT_COLOR];
    
    _reportImageView.image = [_reportImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [_reportImageView setTintColor:IMG_TINT_COLOR];
    
    _moreImageView.image = [_moreImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [_moreImageView setTintColor:IMG_TINT_COLOR];
    
    _markLabel.backgroundColor = [UIColor whiteColor];
    _moreLabel.backgroundColor = [UIColor whiteColor];
    _editLabel.backgroundColor = [UIColor whiteColor];
    _reportLabel.backgroundColor = [UIColor whiteColor];
    
    _flagImageView.layer.shouldRasterize = YES;
    _flagImageView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    _editImageView.layer.shouldRasterize = YES;
    _editImageView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    _reportImageView.layer.shouldRasterize = YES;
    _reportImageView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    _moreImageView.layer.shouldRasterize = YES;
    _moreImageView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIView *topSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 0.5)];
    topSeparatorView.layer.borderColor = [UIColor colorWithRed:209/255.0 green:209/255.0 blue:214/255.0 alpha:1].CGColor;
    topSeparatorView.layer.borderWidth = 0.5;
    [self.contentView addSubview:topSeparatorView];
    
    UIView *bottomSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-0.5, [[UIScreen mainScreen] bounds].size.width, 0.5)];
    bottomSeparatorView.backgroundColor = [UIColor colorWithRed:209/255.0 green:209/255.0 blue:214/255.0 alpha:1];
    [self.contentView addSubview:bottomSeparatorView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
