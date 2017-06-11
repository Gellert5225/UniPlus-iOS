//
//  UniListCell.m
//  UniPlus
//
//  Created by Jiahe Li on 07/09/2016.
//  Copyright © 2016 Quicky Studio. All rights reserved.
//

#import "UniListCell.h"

@implementation UniListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _uniName.adjustsFontSizeToFitWidth = NO;
    _uniName.numberOfLines = 0;
    _uniName.lineBreakMode = NSLineBreakByWordWrapping;
    [_uniName sizeToFit];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
