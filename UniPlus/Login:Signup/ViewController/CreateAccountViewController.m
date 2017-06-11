//
//  CreateAccountViewController.m
//  Shutteradio
//
//  Created by Jiahe Li on 08/10/2015.
//  Copyright © 2015 Quicky Studio. All rights reserved.
//

#import "CreateAccountViewController.h"
#import "LoginCellTableViewCell.h"
#import <Parse/Parse.h>
#import "MMMaterialDesignSpinner.h"
#import "ICGScaleAnimation.h"
#import "ICGSlideAnimation.h"
#import "ReviewProfileTableViewController.h"
#import <PopupDialog/PopupDialog-Swift.h>

@interface CreateAccountViewController ()

@property (weak, nonatomic) IBOutlet UITableView *SignUpTableView;

@end

@implementation CreateAccountViewController
@synthesize nameField, passField, confirmField, emailField, inputAccView, SignUp;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    self.navigationItem.title = @"Sign Up";
    
    self.SignUpTableView.delegate   = self;
    self.SignUpTableView.dataSource = self;
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:53/255.0 green:111/255.0 blue:177/255.0 alpha:1.0]];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)cancel {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"logincell";
    
    LoginCellTableViewCell *cell = [self.SignUpTableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"LoginCellTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSAttributedString *usrnamePH  = [[NSAttributedString alloc]initWithString:@"Username" attributes:@{ NSForegroundColorAttributeName : [UIColor lightGrayColor]}];
    NSAttributedString *passwordPH = [[NSAttributedString alloc]initWithString:@"Password" attributes:@{ NSForegroundColorAttributeName : [UIColor lightGrayColor]}];
    NSAttributedString *confirmPH  = [[NSAttributedString alloc]initWithString:@"Confirm Password" attributes:@{ NSForegroundColorAttributeName : [UIColor lightGrayColor]}];
    NSAttributedString *emailPH    = [[NSAttributedString alloc]initWithString:@"Email" attributes:@{ NSForegroundColorAttributeName : [UIColor lightGrayColor]}];
    
    if (indexPath.row == 0) {
        cell.loginImg.image = [UIImage imageNamed:@"user"];
        nameField = [[UITextField alloc] initWithFrame:CGRectMake(60, 5, self.SignUpTableView.frame.size.width - 70, 38)];
        nameField.autocorrectionType = UITextAutocorrectionTypeNo;
        nameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        nameField.returnKeyType = UIReturnKeyNext;
        [nameField setBorderStyle:UITextBorderStyleNone];
        nameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        nameField.attributedPlaceholder = usrnamePH;
        nameField.textColor = [UIColor blackColor];
        nameField.layer.cornerRadius = 5.0f;
        nameField.clearButtonMode  = UITextFieldViewModeWhileEditing;
        nameField.delegate = self;
        nameField.tag = 1;
        nameField.font = [UIFont fontWithName:@"Avenir-Book" size:16.0];
        [cell.contentView addSubview:nameField];
    } else if(indexPath.row == 1) {
        cell.loginImg.image = [UIImage imageNamed:@"passcode"];
        passField = [[UITextField alloc] initWithFrame:CGRectMake(60, 4, self.SignUpTableView.frame.size.width - 70, 38)];
        passField.autocorrectionType = UITextAutocorrectionTypeNo;
        passField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        passField.returnKeyType = UIReturnKeyNext;
        [passField setBorderStyle:UITextBorderStyleNone];
        passField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        passField.attributedPlaceholder = passwordPH;
        passField.textColor = [UIColor blackColor];
        passField.layer.cornerRadius = 5.0f;
        passField.clearButtonMode = UITextFieldViewModeWhileEditing;
        passField.secureTextEntry = YES;
        passField.delegate = self;
        passField.tag = 2;
        passField.font = [UIFont fontWithName:@"Avenir-Book" size:16.0];
        [cell.contentView addSubview:passField];
    } else if (indexPath.row == 2) {
        cell.loginImg.image = [UIImage imageNamed:@"passcode"];
        confirmField = [[UITextField alloc] initWithFrame:CGRectMake(60, 4, self.SignUpTableView.frame.size.width - 70, 38)];
        confirmField.autocorrectionType = UITextAutocorrectionTypeNo;
        confirmField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        confirmField.returnKeyType = UIReturnKeyNext;
        [confirmField setBorderStyle:UITextBorderStyleNone];
        confirmField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        confirmField.attributedPlaceholder = confirmPH;
        confirmField.textColor = [UIColor blackColor];
        confirmField.layer.cornerRadius = 5.0f;
        confirmField.clearButtonMode = UITextFieldViewModeWhileEditing;
        confirmField.secureTextEntry = YES;
        confirmField.delegate = self;
        confirmField.tag = 3;
        confirmField.font = [UIFont fontWithName:@"Avenir-Book" size:16.0];
        [cell.contentView addSubview:confirmField];
    } else {
        cell.loginImg.image = [UIImage imageNamed:@"email"];
        emailField = [[UITextField alloc] initWithFrame:CGRectMake(60, 4, self.SignUpTableView.frame.size.width - 70, 38)];
        emailField.autocorrectionType = UITextAutocorrectionTypeNo;
        emailField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        emailField.returnKeyType = UIReturnKeyGo;
        [emailField setBorderStyle:UITextBorderStyleNone];
        emailField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        emailField.attributedPlaceholder = emailPH;
        emailField.textColor = [UIColor blackColor];
        emailField.layer.cornerRadius = 5.0f;
        emailField.clearButtonMode = UITextFieldViewModeWhileEditing;
        emailField.secureTextEntry = NO;
        emailField.delegate = self;
        emailField.tag = 4;
        emailField.font = [UIFont fontWithName:@"Avenir-Book" size:16.0];
        [cell.contentView addSubview:emailField];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.currentResponder = textField;
    
    [self createInputAccView];
    
    [textField setInputAccessoryView:inputAccView];
}

- (void)resignOnSwipe:(id)sender {
    [nameField resignFirstResponder];
    [passField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.tag == 1) {
        [passField becomeFirstResponder];
    } else if (textField.tag == 2) {
        [confirmField becomeFirstResponder];
    } else if (textField.tag == 3) {
        [emailField becomeFirstResponder];
    } else {
        [self signUp];
    }
    
    return YES;
}

- (void)createInputAccView {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    
    inputAccView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 0.0, screenWidth, 40.0)];
    [inputAccView setBackgroundColor:[UIColor colorWithWhite:0.85 alpha:0.5]];
    
    SignUp = [UIButton buttonWithType:UIButtonTypeCustom];
    [SignUp setFrame:CGRectMake(screenWidth - 80.0f, 5.0f, 70.0, 30.0f)];
    [SignUp setTitle:@"Sign Up" forState:UIControlStateNormal];
    [SignUp setBackgroundColor:[UIColor colorWithRed:69/255.0 green:177/255.0 blue:235/255.0 alpha:1]];
    [SignUp setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    SignUp.titleLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:13];
    
    SignUp.layer.cornerRadius = 4.0f;
    SignUp.layer.masksToBounds = YES;
    
    [SignUp addTarget:self action:@selector(signUp) forControlEvents:UIControlEventTouchUpInside];
    
    [inputAccView addSubview:SignUp];
}

-(BOOL)NSStringIsValidEmail:(NSString *)checkString {
    BOOL stricterFilter = NO;
    NSString    *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString    *laxString            = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString    *emailRegex           = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest            = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.tag == 1) {
        NSCharacterSet *s = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890_."];
        s = [s invertedSet];
        NSRange r = [string rangeOfCharacterFromSet:s];
        
        if (r.location != NSNotFound) {
            return NO;
        } else {
            return YES;
        }
    }
    return YES;
}

- (void)signUp {
    [self.view endEditing:YES];
    
    PFUser *user  = [PFUser user];
    user.username = [nameField.text lowercaseString];
    user.password = passField.text;
    user.email    = [emailField.text lowercaseString];
    
    CGRect  screenRect   = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth  = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    UIView *blurView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    blurView.backgroundColor = [UIColor clearColor];
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.alpha = 1.0f;
    blurEffectView.frame = blurView.frame;
    [blurView addSubview:blurEffectView];
    
    MMMaterialDesignSpinner *spinnerView = [[MMMaterialDesignSpinner alloc] initWithFrame:CGRectMake(0, 0, 120, 120)];
    spinnerView.center = self.view.center;
    
    UILabel *signingUp = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
    [signingUp setCenter:self.view.center];
    signingUp.text          = @"Signing Up...";
    signingUp.textAlignment = NSTextAlignmentCenter;
    signingUp.textColor     = [UIColor colorWithRed:25/255.0 green:140/255.0 blue:212/255.0 alpha:1.0];
    signingUp.font          = [UIFont fontWithName:@"Avenir-Book" size:15];
    
    spinnerView.lineWidth = 2.0f;
    spinnerView.tintColor = [UIColor colorWithRed:25/255.0 green:140/255.0 blue:212/255.0 alpha:1.0];
    
    [blurView addSubview:spinnerView];
    
    if ([self NSStringIsValidEmail:emailField.text] && [passField.text isEqual:confirmField.text]) {
        [self.navigationController.view addSubview:blurView];
        [self.navigationController.view addSubview:signingUp];
        [spinnerView startAnimating];
        
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
             if (!error) {
                 NSMutableArray *majors = [[[NSMutableArray alloc]initWithObjects:@"Computer Science", nil] mutableCopy];
                 NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                 [userDefaults setObject:majors forKey:@"majorArray"];
                 [userDefaults synchronize];
                 
                 [user setObject:majors                     forKey:@"topics"];
                 [user setObject:[NSNumber numberWithInt:0] forKey:@"numberOfPosts"];
                 [user setObject:[NSNumber numberWithInt:0] forKey:@"numberOfAnswers"];
                 [user setObject:[NSNumber numberWithInt:1] forKey:@"reputation"];
                 [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error3){
                     if (!error3) {
                         ReviewProfileTableViewController *RPVC = [[ReviewProfileTableViewController alloc]initWithNibName:@"ReviewProfileTableViewController" bundle:nil];
                         RPVC.isFromSignUp = YES;
                         UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:RPVC];
                         RPVC.username = [nameField.text lowercaseString];
                         
                         RPVC.profileData = UIImageJPEGRepresentation([UIImage imageNamed:@"white.png"], 1.0);
                         
                         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                             ICGSlideAnimation *slideAnimation = [[ICGSlideAnimation alloc] init];
                             slideAnimation.type = ICGSlideAnimationFromRight;
                             self.animationController = slideAnimation;
                             
                             nav.transitioningDelegate = self.transitioningDelegate;
                             
                             [self presentViewController:nav animated:YES completion:nil];
                             
                             [spinnerView stopAnimating];
                             [signingUp removeFromSuperview];
                             
                         });
                     } else {
                         [spinnerView stopAnimating];
                         [blurView removeFromSuperview];
                         [signingUp removeFromSuperview];
                         
                         NSString *errorString = [error3 userInfo][@"error"];
                         [self showAlertWithErrorString:errorString];
                     }
                 }];
             } else {
                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                     [spinnerView stopAnimating];
                     [blurView removeFromSuperview];
                     [signingUp removeFromSuperview];
                    
                     NSString *errorString = [error userInfo][@"error"];
                     [self showAlertWithErrorString:errorString];
                });
             }
         }];
    }
    else if(![self NSStringIsValidEmail:emailField.text]) {
        [self showAlertWithErrorString:@"Please enter a valis email address"];
    } else {
        [self showAlertWithErrorString:@"Passwords don't match"];
    }
}

- (void)showAlertWithErrorString:(NSString *)error {
    //UI
    PopupDialogDefaultView *dialogAppearance = [PopupDialogDefaultView appearance];
    dialogAppearance.titleFont   = [UIFont fontWithName:@"SFUIText-Medium" size:15];
    dialogAppearance.messageFont = [UIFont fontWithName:@"SFUIText-Regular" size:14];
    [dialogAppearance setFrame:CGRectMake(dialogAppearance.frame.origin.x, dialogAppearance.frame.origin.y
                                          , 100, dialogAppearance.frame.size.height)];
    
    PopupDialog *popup = [[PopupDialog alloc] initWithTitle:@"Error"
                                                    message:error
                                                      image:nil
                                            buttonAlignment:UILayoutConstraintAxisHorizontal
                                            transitionStyle:PopupDialogTransitionStyleZoomIn
                                           gestureDismissal:YES
                                                 completion:nil];
    //buttons
    DefaultButton *btnAppearance = [DefaultButton appearance];
    btnAppearance.titleFont = [UIFont fontWithName:@"SFUIText-Regular" size:14];
    
    DefaultButton *ok = [[DefaultButton alloc] initWithTitle:@"OK" dismissOnTap:YES action:^{
        
    }];
    
    [popup addButtons: @[ok]];
    
    [self.navigationController presentViewController:popup animated:YES completion:nil];
}

@end
