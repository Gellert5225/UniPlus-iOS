//
//  MainScreen.h
//  Shutteradio
//
//  Created by Jiahe Li on 07/09/2015.
//  Copyright (c) 2015 Quicky Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICGViewController.h"

@interface MainScreen : ICGViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *loginTable;
@property (weak, nonatomic) IBOutlet UIView      *layerView;
@property (weak, nonatomic) IBOutlet UIButton    *loginButton;
@property (weak, nonatomic) IBOutlet UIView      *buttonLayer;
@property (weak, nonatomic) IBOutlet UIView      *titleLayer;
@property (weak, nonatomic) IBOutlet UIView      *mainLayer;
@property (weak, nonatomic) IBOutlet UILabel     *titleLabel;
@property (strong, nonatomic) UITextField        *nameField;
@property (strong, nonatomic) UITextField        *passField;
@property (nonatomic, assign) id                 currentResponder;

- (IBAction)login:(UIButton *)sender;
- (IBAction)CreateAccount:(UIButton *)sender;

@end
