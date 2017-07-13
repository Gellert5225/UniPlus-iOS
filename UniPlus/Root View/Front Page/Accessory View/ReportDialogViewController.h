//
//  ReportDialogViewController.h
//  UniPlus
//
//  Created by Jiahe Li on 12/07/2017.
//  Copyright © 2017 Quicky Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ReportDialogViewController;

@protocol ReportDialogViewControllerDelegate

- (void)textFieldDidReturnWithText:(NSString *)text;

@end

@interface ReportDialogViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *reportInfoTextField;

@property (weak, nonatomic) id <ReportDialogViewControllerDelegate>delegate;

@end
