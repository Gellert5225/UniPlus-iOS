//
//  MainScreen.m
//  Shutteradio
//
//  Created by Jiahe Li on 07/09/2015.
//  Copyright (c) 2015 Quicky Studio. All rights reserved.
//

#import "MainScreen.h"
#import <QuartzCore/QuartzCore.h>
#import "LoginCellTableViewCell.h"
#import "CreateAccountViewController.h"
#import <Parse/Parse.h>
#import "ICGScaleAnimation.h"
#import "MMMaterialDesignSpinner.h"
#import "ICGScaleAnimation.h"
#import "ICGNavigationController.h"
#import "ICGLayerAnimation.h"
#import "ReviewProfileTableViewController.h"
#import "ICGSlideAnimation.h"
#import "SWRevealViewController.h"
#import "UPLeftMenuTableViewController.h"
#import "MainPageViewController.h"
#import <PopupDialog/PopupDialog-Swift.h>

@interface MainScreen ()<SWRevealViewControllerDelegate>

@end

@implementation MainScreen
@synthesize loginTable, layerView, loginButton, buttonLayer, nameField, passField, titleLayer, mainLayer, titleLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
        
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [self setLayout];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    if (screenHeight == 480 || screenHeight == 568) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"logincell";
    
    LoginCellTableViewCell *cell = [loginTable dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"LoginCellTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSAttributedString *usrnamePH = [[NSAttributedString alloc]initWithString:@"Username" attributes:@{ NSForegroundColorAttributeName : [UIColor lightGrayColor]}];
    NSAttributedString *passwordPH = [[NSAttributedString alloc]initWithString:@"Password" attributes:@{ NSForegroundColorAttributeName : [UIColor lightGrayColor]}];
    
    if (indexPath.row == 0) {
        cell.loginImg.image = [UIImage imageNamed:@"user"];
        nameField = [[UITextField alloc] initWithFrame:CGRectMake(50, 5, loginTable.frame.size.width - 60, 38)];
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
    } else {
        cell.loginImg.image = [UIImage imageNamed:@"passcode"];
        passField = [[UITextField alloc] initWithFrame:CGRectMake(50, 4, loginTable.frame.size.width - 60, 38)];
        passField.autocorrectionType = UITextAutocorrectionTypeNo;
        passField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        passField.returnKeyType = UIReturnKeyGo;
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
    }
    
    return cell;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    CGRect  screenRect   = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    
    titleLayer.transform = CGAffineTransformMakeTranslation(titleLayer.bounds.origin.x, titleLayer.bounds.origin.y);
    mainLayer.transform  = CGAffineTransformMakeTranslation(mainLayer.bounds.origin.x, mainLayer.bounds.origin.y);
    
    if (screenHeight == 480) {
        [UIView animateWithDuration:0.5 animations:^{
            titleLayer.transform = CGAffineTransformMakeTranslation(titleLayer.bounds.origin.x ,titleLayer.bounds.origin.y-20);
            mainLayer.transform  = CGAffineTransformMakeTranslation(mainLayer.bounds.origin.x, mainLayer.bounds.origin.y-50);
        } completion:nil];
    } else {
        [UIView animateWithDuration:0.5 animations:^{
            titleLayer.transform = CGAffineTransformMakeTranslation(titleLayer.bounds.origin.x ,titleLayer.bounds.origin.y);
            mainLayer.transform  = CGAffineTransformMakeTranslation(mainLayer.bounds.origin.x, mainLayer.bounds.origin.y-30);
        } completion:nil];
    }
}

-(void)keyboardWillHide:(NSNotification *)notification {
    CGRect  screenRect   = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    
    if (screenHeight == 480) {
        titleLayer.transform = CGAffineTransformMakeTranslation(titleLayer.bounds.origin.x, titleLayer.bounds.origin.y-20);
        mainLayer.transform  = CGAffineTransformMakeTranslation(mainLayer.bounds.origin.x, mainLayer.bounds.origin.y-50);
        [UIView animateWithDuration:0.5 animations:^{
            titleLayer.transform = CGAffineTransformMakeTranslation(titleLayer.bounds.origin.x ,titleLayer.bounds.origin.y);
            mainLayer.transform  = CGAffineTransformMakeTranslation(mainLayer.bounds.origin.x, mainLayer.bounds.origin.y);
        } completion:nil];
    } else {
        titleLayer.transform = CGAffineTransformMakeTranslation(titleLayer.bounds.origin.x, titleLayer.bounds.origin.y-30);
        mainLayer.transform  = CGAffineTransformMakeTranslation(mainLayer.bounds.origin.x, mainLayer.bounds.origin.y-30);
        [UIView animateWithDuration:0.5 animations:^{
            titleLayer.transform = CGAffineTransformMakeTranslation(titleLayer.bounds.origin.x ,titleLayer.bounds.origin.y);
            mainLayer.transform  = CGAffineTransformMakeTranslation(mainLayer.bounds.origin.x, mainLayer.bounds.origin.y);
        } completion:nil];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.currentResponder = textField;
}

- (void)resignOnSwipe:(id)sender {
    [nameField resignFirstResponder];
    [passField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.tag == 1) {
        [passField becomeFirstResponder];
    } else if (textField.tag == 2) {
        [self login:loginButton];
    }
    return YES;
}

- (IBAction)login:(UIButton *)sender {
    [self.view endEditing:YES];
    
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
    signingUp.text = @"Loging In...";
    signingUp.textAlignment = NSTextAlignmentCenter;
    signingUp.textColor = [UIColor colorWithRed:25/255.0 green:140/255.0 blue:212/255.0 alpha:1.0];
    signingUp.font = [UIFont fontWithName:@"Avenir-Medium" size:15];
    
    spinnerView.lineWidth = 2.3f;
    spinnerView.tintColor = [UIColor colorWithRed:25/255.0 green:140/255.0 blue:212/255.0 alpha:1.0];
    
    [blurView addSubview:spinnerView];
    
    [self.view addSubview:blurView];
    [self.view addSubview:signingUp];
    [spinnerView startAnimating];
    
    ICGScaleAnimation *slideAnimation = [[ICGScaleAnimation alloc] init];
    slideAnimation.type = ICGScaleAnimationFadeIn;
    self.animationController = slideAnimation;
        
    [PFUser logInWithUsernameInBackground:[self.nameField.text lowercaseString] password:self.passField.text block:^(PFUser *user, NSError *error){
         if (user) {
             [[PFInstallation currentInstallation] setObject:user forKey:@"user"];
             [[PFInstallation currentInstallation] saveInBackground];
             
             NSMutableArray *majorArray = [[[NSMutableArray alloc]initWithArray:[user objectForKey:@"topics"]] mutableCopy];
             NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
             [defaults setObject:majorArray forKey:@"majorArray"];
             [defaults synchronize];
             [NSThread sleepForTimeInterval:1.0f];
             
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                 MainPageViewController *MPVC = [[MainPageViewController alloc]initWithTopic:@"Computer Science" ParseClass:@"Questions"];
                 UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:MPVC];
                 
                 UPLeftMenuTableViewController *leftMenuVC = [[UPLeftMenuTableViewController alloc]init];
                 leftMenuVC.menuMajorArray = majorArray;
                 SWRevealViewController *revealController = [[SWRevealViewController alloc]initWithRearViewController:leftMenuVC frontViewController:nav];
                 revealController.frontViewShadowColor = [UIColor colorWithWhite:0.4 alpha:1].CGColor;
                 revealController.frontViewShadowOpacity = 0.3;
                 revealController.frontViewShadowOffset = CGSizeMake(0.0, 0.0);
                 revealController.frontViewShadowRadius = 2.0;
                 revealController.delegate = self;
                 
                 [self presentViewController:revealController animated:YES completion:nil];
                
                 [spinnerView stopAnimating];
                 [blurView removeFromSuperview];
                 [signingUp removeFromSuperview];
            });
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
    
    [self presentViewController:popup animated:YES completion:nil];
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (IBAction)CreateAccount:(UIButton *)sender {
    CreateAccountViewController *CAVC = [[CreateAccountViewController alloc]init];
    ICGNavigationController *nav = [[ICGNavigationController alloc]initWithRootViewController:CAVC];
    ICGLayerAnimation *layerAnimation = [[ICGLayerAnimation alloc] initWithType:ICGLayerAnimationCover];
    nav.animationController = layerAnimation;
    nav.animationController.type = 1;
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)setLayout {
    loginTable.delegate            = self;
    loginTable.dataSource          = self;
    loginTable.layer.cornerRadius  = 6.0f;
    loginTable.separatorInset      = UIEdgeInsetsMake(0, 20, 0, 20);
    loginTable.layer.masksToBounds = YES;
    loginButton.layer.zPosition    = 5;
    
    layerView.layer.cornerRadius  = 6.0f;
    layerView.layer.shadowColor   = [UIColor blackColor].CGColor;
    layerView.layer.shadowOffset  = CGSizeMake(0.0f, 1.0f);
    layerView.layer.shadowRadius  = 1.0f;
    layerView.layer.shadowOpacity = 0.5f;

    loginButton.layer.cornerRadius  = 4.0f;
    loginButton.layer.masksToBounds = YES;
    [loginButton layoutIfNeeded];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = loginButton.layer.bounds;
    gradient.colors = @[(id)[[UIColor colorWithRed:53/255.0 green:111/255.0 blue:177/255.0 alpha:1.0] CGColor], (id)[[UIColor colorWithRed:33/255.0 green:91/255.0 blue:159/255.0 alpha:0.9] CGColor]];
    gradient.locations = @[@0.0, @1.0];
    
    [loginButton.layer insertSublayer:gradient atIndex:0];
    
    buttonLayer.layer.cornerRadius  = 4.0f;
    buttonLayer.layer.shadowColor   = [UIColor blackColor].CGColor;
    buttonLayer.layer.shadowOffset  = CGSizeMake(0.0f, 0.7f);
    buttonLayer.layer.shadowRadius  = 1.0f;
    buttonLayer.layer.shadowOpacity = 0.35f;
    
    titleLabel.numberOfLines = 1;
    titleLabel.adjustsFontSizeToFitWidth = YES;
    
    UISwipeGestureRecognizer *swipe1 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(resignOnSwipe:)];
    swipe1.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipe1];
    
    UISwipeGestureRecognizer *swipe2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(resignOnSwipe:)];
    swipe2.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipe2];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignOnSwipe:)];
    [self.view addGestureRecognizer:tap];
}

@end
