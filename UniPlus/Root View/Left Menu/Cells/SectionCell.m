//
//  SectionCell.m
//  UniPlus
//
//  Created by Jiahe Li on 11/09/2016.
//  Copyright © 2016 Quicky Studio. All rights reserved.
//

#import "SectionCell.h"

@implementation SectionCell

- (NSString *)accessibilityLabel {
    return self.textLabel.text;
}

- (void)setLoading:(BOOL)loading {
    if (loading != _loading) {
        _loading = loading;
        [self _updateDetailTextLabel];
    }
}

- (void)setExpansionStyle:(UIExpansionStyle)expansionStyle animated:(BOOL)animated {
    if (expansionStyle != _expansionStyle) {
        _expansionStyle = expansionStyle;
        [self _updateDetailTextLabel];
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self _updateDetailTextLabel];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)_updateDetailTextLabel {
    if (self.isLoading) {
        self.detailTextLabel.text = @"Loading data";
    } else {
        switch (self.expansionStyle) {
            case UIExpansionStyleExpanded:
                self.detailTextLabel.text = @"Click to collapse";
                break;
            case UIExpansionStyleCollapsed:
                self.detailTextLabel.text = @"Click to expand";
                break;
        }
    }
}

@end
