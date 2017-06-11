//
//  UPError.m
//  UniPlus
//
//  Created by Jiahe Li on 25/04/2017.
//  Copyright © 2017 Quicky Studio. All rights reserved.
//

#import "UPError.h"

@interface UPError()

@end

@implementation UPError

- (NSString *)errorString {
    if (!_errorString) {
        return @"Unknown Error";
    }
    return _errorString;
}

- (id)initWithErrorString:(NSString *)error {
    self = [super init];
    if (self) {
        _errorString = error;
    }
    return self;
}

- (PopupDialog *)configurePopupDialog {
    //UI
    PopupDialogDefaultView *dialogAppearance = [PopupDialogDefaultView appearance];
    dialogAppearance.titleFont   = [UIFont fontWithName:@"SFUIText-Medium" size:15];
    dialogAppearance.messageFont = [UIFont fontWithName:@"SFUIText-Regular" size:14];
    [dialogAppearance setFrame:CGRectMake(dialogAppearance.frame.origin.x, dialogAppearance.frame.origin.y
                                          , 100, dialogAppearance.frame.size.height)];
    
    PopupDialog *popup = [[PopupDialog alloc] initWithTitle:@"Error"
                                                    message:_errorString
                                                      image:nil
                                            buttonAlignment:UILayoutConstraintAxisHorizontal
                                            transitionStyle:PopupDialogTransitionStyleZoomIn
                                           gestureDismissal:YES
                                                 completion:nil];
    //buttons
    DefaultButton *btnAppearance = [DefaultButton appearance];
    btnAppearance.titleFont = [UIFont fontWithName:@"SFUIText-Regular" size:14];
    btnAppearance.titleColor = [UIColor colorWithRed:53/255.0 green:111/255.0 blue:177/255.0 alpha:1.0];
    
    DefaultButton *ok = [[DefaultButton alloc] initWithTitle:@"OK" dismissOnTap:YES action:nil];
    
    DefaultButton *retry = [[DefaultButton alloc] initWithTitle:@"RETRY" dismissOnTap:YES action:^{
        [_delegate didTapRetryButton];
    }];
    
    [popup addButtons: @[ok, retry]];
    
    return popup;
}

@end
