//
//  ReportDialogViewController.m
//  UniPlus
//
//  Created by Jiahe Li on 12/07/2017.
//  Copyright © 2017 Quicky Studio. All rights reserved.
//

#import "ReportDialogViewController.h"

@interface ReportDialogViewController ()

@end

@implementation ReportDialogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _reportInfoTextField.delegate = self;
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [_delegate textFieldDidReturnWithText:textField.text];
    return YES;
}

@end
