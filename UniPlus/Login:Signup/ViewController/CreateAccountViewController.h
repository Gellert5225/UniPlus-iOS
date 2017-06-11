//
//  CreateAccountViewController.h
//  Shutteradio
//
//  Created by Jiahe Li on 08/10/2015.
//  Copyright © 2015 Quicky Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICGViewController.h"

@interface CreateAccountViewController : ICGViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) UITextField *nameField;
@property (strong, nonatomic) UITextField *passField;
@property (strong, nonatomic) UITextField *confirmField;
@property (strong, nonatomic) UITextField *emailField;
@property (strong, nonatomic) UIView      *inputAccView;
@property (strong, nonatomic) UIButton    *SignUp;
@property (nonatomic, assign) id          currentResponder;

@end
