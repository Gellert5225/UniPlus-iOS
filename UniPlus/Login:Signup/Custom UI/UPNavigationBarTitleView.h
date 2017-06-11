//
//  UPNavigationBarTitleView.h
//  UniPlus
//
//  Created by Jiahe Li on 25/04/2017.
//  Copyright © 2017 Quicky Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UPNavigationBarTitleView : UIView

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *subTitle;
@property (strong, nonatomic) UIFont *titleFont;
@property (strong, nonatomic) UIFont *subtitleFont;
@property (strong, nonatomic) UIColor *titleColor;
@property (strong, nonatomic) UIColor *subtitleColor;

- (id)initWithTitle:(NSString *)title subTitle:(NSString *)subTitle;

@end
