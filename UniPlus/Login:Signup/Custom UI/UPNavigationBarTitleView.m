//
//  UPNavigationBarTitleView.m
//  UniPlus
//
//  Created by Jiahe Li on 25/04/2017.
//  Copyright © 2017 Quicky Studio. All rights reserved.
//

#import "UPNavigationBarTitleView.h"

#define COLOR_SCHEME [UIColor colorWithRed:53/255.0 green:111/255.0 blue:177/255.0 alpha:1.0]

@interface UPNavigationBarTitleView()

@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) UILabel *subTitleLabel;

@end

@implementation UPNavigationBarTitleView

#pragma - mark Designated Initializers

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        
    }
    
    return self;
}

- (id)initWithTitle:(NSString *)title subTitle:(NSString *)subTitle {
    self = [super init];
    if (self) {
        _title = title;
        _subTitle = subTitle;
        self.frame = CGRectMake(0, 0, 160, 33);
        [self layoutViews];
    }
    return self;
}

#pragma - mark Accessors

- (void)setTitleFont:(UIFont *)titleFont {
    _titleLabel.font = titleFont;
}

- (void)setSubtitleFont:(UIFont *)subtitleFont {
    _subTitleLabel.font = subtitleFont;
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleLabel.textColor = titleColor;
}

- (void)setSubtitleColor:(UIColor *)subtitleColor {
    _subTitleLabel.textColor = subtitleColor;
}

#pragma - mark Private

- (void)layoutViews {
    _titleLabel               = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 17)];
    _titleLabel.font          = [UIFont fontWithName:@"SFUIText-Regular" size:15];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor     = COLOR_SCHEME;
    _titleLabel.text          = _title;
    
    _subTitleLabel               = [[UILabel alloc] initWithFrame:CGRectMake(0, 18, 160, 16)];
    _subTitleLabel.font          = [UIFont fontWithName:@"SFUIText-Light" size:12];
    _subTitleLabel.textAlignment = NSTextAlignmentCenter;
    _subTitleLabel.textColor     = [COLOR_SCHEME colorWithAlphaComponent:1.0];
    _subTitleLabel.text          = _subTitle;
    
    [self setBackgroundColor:[UIColor clearColor]];
    [self addSubview:_titleLabel];
    [self addSubview:_subTitleLabel];
}

@end
