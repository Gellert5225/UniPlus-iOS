//
//  ReviewProfileTableViewController.m
//  Shutteradio
//
//  Created by Jiahe Li on 11/10/2015.
//  Copyright © 2015 Quicky Studio. All rights reserved.
//

#import "ReviewProfileTableViewController.h"
#import "SWRevealViewController.h"
#import "UPLeftMenuTableViewController.h"
#import "MMMaterialDesignSpinner.h"
#import "MainPageViewController.h"
#import "ChooseMajorCell.h"
#import "PreviewCell1.h"
#import "PreviewCell2.h"
#import "PreviewCell3.h"
#import "University.h"
#import "SRActionSheet.h"
#import <PopupDialog/PopupDialog-Swift.h>
#import <GKFadeNavigationController/GKFadeNavigationController.h>

@interface ReviewProfileTableViewController ()<SRActionSheetDelegate>

@property(strong, nonatomic) NSMutableArray *universities;
@property(strong, nonatomic) NSArray *majors;

@end

@implementation ReviewProfileTableViewController
@synthesize finish, inputAccView, currentResponder, username, profileData, isFromSignUp, nickName;

- (NSString *)topic {
    if (!_topic) {
        return [[PFUser currentUser] objectForKey:@"major"];
    }
    
    return _topic;
}

- (NSString *)institution {
    if (!_institution) {
        return [[PFUser currentUser] objectForKey:@"institution"];
    }
    return _institution;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.scrollEnabled = YES;
    
    self.universities   = [University getUniversitiesFromJSON];
    self.majors         = [[NSArray alloc]init];
    
    self.majors = @[@"Argriculture",@"Anthropology",@"Archeaology",@"Architecture and Design", @"Area Studies",@"Biology",@"Business", @"Chemical Engineering",@"Chemistry", @"Civil Engineering", @"Computer Science", @"Cultural and Ethic Studies", @"Divinity", @"Earch Science",@"Economics",@"Electrical Engineering", @"Geography", @"Human History", @"Law", @"Linguistic", @"Literature", @"Logic", @"Mathmatics",@"Mechanical Engineering", @"Medicine", @"Millitary Science", @"Philosophy",@"Physics", @"Political  Science", @"Psychology",@"Public Administration", @"Sociology", @"Space Science", @"Statistics", @"System Science"];
    
    self.tableView.separatorInset          = UIEdgeInsetsMake(0, 46, 0, 0);
    self.navigationItem.hidesBackButton    = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Finish" style:UIBarButtonItemStylePlain target:self action:@selector(finishProfile)];
    
    if (isFromSignUp) {
        self.navigationItem.title              = @"Profile";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Finish" style:UIBarButtonItemStylePlain target:self action:@selector(finishProfile)];
    } else {
        self.navigationItem.title              = @"Edit Profile";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(finishProfile)];
        self.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelProfile)];
    }
    
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    NSIndexPath *majorIndex       = [NSIndexPath indexPathForRow:2 inSection:0];
    NSIndexPath *institutionIndex = [NSIndexPath indexPathForRow:3 inSection:0];
    NSArray *indexPaths = [[NSArray alloc] initWithObjects:majorIndex, institutionIndex, nil];
    [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.currentResponder = textField;
}

- (BOOL)textFieldShouldBeginEditing:(UITextView *)textField {
    [self.view endEditing:YES];
    
    if (textField.tag == 4) {
        [self addMajor];
        return NO;
    } else if (textField.tag == 5) {
        [self addInstitution];
        return NO;
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.tag == 2) {
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    PreviewCell1 *cell1 = (PreviewCell1 *)[self.view viewWithTag:10];
    PreviewCell2 *cell2 = (PreviewCell2 *)[self.view viewWithTag:11];
    
    if (textField.tag == 1) {
        [cell1.usernameField becomeFirstResponder];
    } else if (textField.tag == 2) {
        [cell2.webField becomeFirstResponder];
    }
    
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 88.0f;
    }
    return 44.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier1 = @"previewcell1";
    static NSString *CellIdentifier2 = @"previewcell2";
    static NSString *CellIdentifier3 = @"previewcell3";
    static NSString *CellIdentifier4 = @"chooseMajorCell";
    
    PreviewCell1    *profileInfoCell = (PreviewCell1 *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
    PreviewCell2    *websiteInfoCell = (PreviewCell2 *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
    PreviewCell3    *institutionCell = (PreviewCell3 *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier3];
    ChooseMajorCell *chooseMajorCell = (ChooseMajorCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier4];
    
    if (!profileInfoCell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PreviewCell1" owner:self options:nil];
        profileInfoCell = [nib objectAtIndex:0];
    }
    
    if (!websiteInfoCell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PreviewCell2" owner:self options:nil];
        websiteInfoCell = [nib objectAtIndex:0];
    }
    
    if (!institutionCell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PreviewCell3" owner:self options:nil];
        institutionCell = [nib objectAtIndex:0];
    }
    
    if (!chooseMajorCell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ChooseMajorCell" owner:self options:nil];
        chooseMajorCell = [nib objectAtIndex:0];
    }
    
    profileInfoCell.selectionStyle = UITableViewCellSelectionStyleNone;
    websiteInfoCell.selectionStyle = UITableViewCellSelectionStyleNone;
    institutionCell.selectionStyle = UITableViewCellSelectionStyleNone;
    chooseMajorCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //profile photo round shape
    profileInfoCell.profilePhotoView.layer.cornerRadius  = profileInfoCell.profilePhotoView.frame.size.height/2;
    profileInfoCell.profilePhotoView.layer.borderColor   = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
    profileInfoCell.profilePhotoView.layer.borderWidth   = 1.0f;
    profileInfoCell.profilePhotoView.layer.masksToBounds = YES;
    
    profileInfoCell.profilePhotoView.image = [UIImage imageNamed:@"empty-profile"];
    profileInfoCell.profilePhotoView.file = [[PFUser currentUser] objectForKey:@"profilePhoto"];
    [profileInfoCell.profilePhotoView loadInBackground];
    
    if (isFromSignUp) {
        profileInfoCell.usernameField.text    = username;
        institutionCell.institutionText.text  = _institution ? _institution : @"";
        chooseMajorCell.majorText.text        = _topic ? _topic : @"";
    } else {
        profileInfoCell.usernameField.text    = [PFUser currentUser].username;
        profileInfoCell.nameField.text        = [[PFUser currentUser] objectForKey:@"nickName"];
        websiteInfoCell.webField.text         = [[PFUser currentUser] objectForKey:@"website"];
        institutionCell.institutionText.text  = _institution;
        chooseMajorCell.majorText.text        = _topic;
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(editPhoto)];
    [profileInfoCell.profilePhotoView addGestureRecognizer:tap];
    tap.delegate = self;
    
    [profileInfoCell.editButton addTarget:self action:@selector(editPhoto) forControlEvents:UIControlEventTouchUpInside];
   
    if (indexPath.row == 0) {
        return profileInfoCell;
    } else if (indexPath.row == 1) {
        return websiteInfoCell;
    } else if (indexPath.row == 2) {
        return chooseMajorCell;
    } else {
        return institutionCell;
    }
}

- (void)addInstitution{
    SearchInstitutionTableViewController *SIVC = [[SearchInstitutionTableViewController alloc]init];
    SIVC.universities = self.universities;
    SIVC.delegate     = self;
    [self.navigationController pushViewController:SIVC animated:YES];
}

- (void)addMajor {
    SearchMajorTableViewController *SMTVC = [[SearchMajorTableViewController alloc]init];
    SMTVC.majors = self.majors;
    SMTVC.delegate = self;
    [self.navigationController pushViewController:SMTVC animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 3) {
        [self addInstitution];
    } else if (indexPath.row == 2) {
        [self addMajor];
    }
}

//scale the image to a smaller size
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)editPhoto {
    [self.view endEditing:YES];
    
    [SRActionSheet sr_showActionSheetViewWithTitle:@"Change Profile Photo"
                                 cancelButtonTitle:@"Cancel"
                            destructiveButtonTitle:nil
                                 otherButtonTitles:@[@"Take Photo", @"Choose From Library"]
                                          delegate:self];
}

- (void)actionSheet:(SRActionSheet *)actionSheet didSelectSheet:(NSInteger)index {
    if (index == 0) {
        [self takePhoto];
    } else if (index == 1) {
        [self choosePhoto];
    }
}

- (void)finishProfile {
    [self.view endEditing:YES];
    
    CGRect  screenRect   = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth  = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    UIView *blurView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    blurView.backgroundColor = [UIColor clearColor];
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    
    if (isFromSignUp) {
        blurEffectView.alpha = 1.0;
    }
    
    blurEffectView.frame = blurView.frame;
    [blurView addSubview:blurEffectView];
    
    MMMaterialDesignSpinner *spinnerView = [[MMMaterialDesignSpinner alloc] initWithFrame:CGRectMake(0, 0, 120, 120)];
    spinnerView.center = self.view.center;
    
    UILabel *signingUp = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
    [signingUp setCenter:self.view.center];
    
    signingUp.text = isFromSignUp ? @"Finishing..." : @"Saving";
    
    signingUp.textAlignment = NSTextAlignmentCenter;
    signingUp.textColor     = [UIColor colorWithRed:33/255.0 green:150/255.0 blue:243/255.0 alpha:0.7];
    signingUp.font          = [UIFont fontWithName:@"Avenir-Book" size:15];
    
    spinnerView.lineWidth = 2.0f;
    spinnerView.tintColor = [UIColor colorWithRed:33/255.0 green:150/255.0 blue:243/255.0 alpha:0.7];
    
    [blurView addSubview:spinnerView];
    
    PreviewCell1 *cell1 = (PreviewCell1 *)[self.view viewWithTag:10];
    PreviewCell2 *cell2 = (PreviewCell2 *)[self.view viewWithTag:11];
    PreviewCell3 *cell3 = (PreviewCell3 *)[self.view viewWithTag:12];
    
    NSCharacterSet *charSet = [NSCharacterSet whitespaceCharacterSet];
    NSString *trimmedUserName = [cell1.usernameField.text stringByTrimmingCharactersInSet:charSet];
    NSString *trimmedNickName = [cell1.nameField.text stringByTrimmingCharactersInSet:charSet];
    
    if ((![trimmedUserName isEqualToString:@""])) {
        //username is not empty or full of spaces
        [self.navigationController.view addSubview:blurView];
        [self.navigationController.view addSubview:signingUp];
        [spinnerView startAnimating];
        
        PFUser *user = [PFUser currentUser];
        
        NSData *smallPhotoData   = UIImageJPEGRepresentation([self imageWithImage:cell1.profilePhotoView.image scaledToSize:CGSizeMake(80, 80)], 1);
        PFFile *smallProfileFile = [PFFile fileWithName:@"SmallProfileIMG" data:smallPhotoData contentType:@"image/png"];
        PFFile *profileIMGFile   = [PFFile fileWithName:@"ProfileIMG" data:UIImagePNGRepresentation(cell1.profilePhotoView.image) contentType:@"image/png"];
        
        [user setObject:profileIMGFile forKey:@"profilePhoto"];
        [user setObject:smallProfileFile forKey:@"profilePhoto80"];
        if (![trimmedNickName isEqualToString:@""]) {
            [user setObject:cell1.nameField.text forKey:@"nickName"];
        } else {
            [user setObject:cell1.usernameField.text forKey:@"nickName"];
        }
        [user setObject:[cell1.usernameField.text lowercaseString] forKey:@"username"];
        [user setObject:cell2.webField.text forKey:@"website"];
        [user setObject:cell3.institutionText.text forKey:@"institution"];
        [user setObject:_topic?_topic:@"" forKey:@"major"];
        [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
            if (!error) {
                if (isFromSignUp) {
                    NSMutableArray *topicArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"majorArray"];
                    
                    MainPageViewController *MPVC = [[MainPageViewController alloc]initWithTopic:@"Living" ParseClass:@"Questions"];
                    GKFadeNavigationController *nav3 = [[GKFadeNavigationController alloc]initWithRootViewController:MPVC];
                    
                    UPLeftMenuTableViewController *leftMenuVC = [[UPLeftMenuTableViewController alloc]init];
                    leftMenuVC.menuMajorArray = topicArray;
                    SWRevealViewController *revealController = [[SWRevealViewController alloc]initWithRearViewController:leftMenuVC frontViewController:nav3];
                    revealController.delegate = self;
                    
                    [self presentViewController:revealController animated:YES completion:nil];
                } else {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
            } else {
                NSString *errorString = [error userInfo][@"error"];
                [self showAlertWithErrorString:errorString];
            }
            [spinnerView stopAnimating];
            [blurView removeFromSuperview];
            [signingUp removeFromSuperview];
        }];
    } else {
        [self showAlertWithErrorString:@"Please provide a username for logging in"];
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

- (void)takePhoto {
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.sourceType    = UIImagePickerControllerSourceTypeCamera;
    picker.delegate      = self;
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)choosePhoto {
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.sourceType    = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate      = self;
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *selectedIMG = [info objectForKey:UIImagePickerControllerEditedImage];
    profileData = UIImageJPEGRepresentation(selectedIMG, 1.0);
    
    PreviewCell1 *cell1 = (PreviewCell1 *)[self.view viewWithTag:10];
    cell1.profilePhotoView.image = [UIImage imageWithData:profileData];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancelProfile {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)actionSheet:(SRActionSheet *)actionSheet willDismissFromSuperView:(UIView *)superView {
    
}

#pragma mark - SearchInstitutionTableViewControllerDelegate method

- (void)addUniversity:(SearchInstitutionTableViewController *)search didFinishPickingUniversity:(NSString *)university{
    _institution = university;
}

- (void)addMajor:(SearchMajorTableViewController *)search didFinishPickingMajor:(NSString *)major {
    _topic = major;
}

@end
