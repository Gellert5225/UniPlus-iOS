//
//  PostQuestionTableViewController.m
//  UniPlus
//
//  Created by Jiahe Li on 25/09/2016.
//  Copyright © 2016 Quicky Studio. All rights reserved.
//

#import "PostQuestionTableViewController.h"
#import "SRActionSheet.h"
#import "SZTextView.h"
#import "STPopup.h"
#import "LoadMoreCell.h"
#import "QuestionDetailTableViewController.h"
#import "GlobalVariables.h"

#import <PopupDialog/PopupDialog-Swift.h>
#import <Parse/Parse.h>

#define COLOR_SCHEME [UIColor colorWithRed:53/255.0 green:111/255.0 blue:177/255.0 alpha:1.0]
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width

@interface PostQuestionTableViewController ()

@property (strong, nonatomic) PFObject *questionDraft;
@property (strong, nonatomic) UITextField *titleField;
@property (strong, nonatomic) SZTextView  *questionBody;

@end

@implementation PostQuestionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.allowsSelection = NO;
    
    [self configureNavbar];
    
    self.titleField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 15, 50)];
    
    self.questionBody = [[SZTextView alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 15, 150)];
    self.questionBody.scrollEnabled = NO;
    self.questionBody.allowsEditingTextAttributes = YES;
    self.questionBody.delegate = self;
}

- (void)configureNavbar {
    //custom navigation title
    NSString *classLabelText;
    if ([self.parseClass isEqualToString:@"Questions"]) {
        classLabelText = @"Coursework Q&A";
    } else if ([self.parseClass isEqualToString:@"Discussions"]){
        classLabelText = @"General Discussion";
    }
    UIView *titleLabelView   = [[UIView alloc] initWithFrame:CGRectMake(0,0,145,32)];
    UILabel *classLabel      = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 145, 16)];
    classLabel.font          = [UIFont fontWithName:@"SFUIText-Regular" size:14.5];
    classLabel.textAlignment = NSTextAlignmentCenter;
    classLabel.textColor     = COLOR_SCHEME;
    classLabel.text          = classLabelText;
    
    UILabel *topicLabel      = [[UILabel alloc] initWithFrame:CGRectMake(0, 17, 145, 15)];
    topicLabel.font          = [UIFont fontWithName:@"SFUIText-Light" size:12];
    topicLabel.textAlignment = NSTextAlignmentCenter;
    topicLabel.textColor     = COLOR_SCHEME;
    topicLabel.text          = self.topic;
    
    [titleLabelView setBackgroundColor:[UIColor clearColor]];
    [titleLabelView addSubview:classLabel];
    [titleLabelView addSubview:topicLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBottomSheet)];
    [titleLabelView addGestureRecognizer:tap];
    
    //configure the navigation bar
    UIBarButtonItem *cancel  = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Cancel"]
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(cancel)];
    UIBarButtonItem *post    = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Post"]
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(postQuestion)];
    
    [self.navigationController.navigationBar setTintColor:COLOR_SCHEME];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: COLOR_SCHEME};
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.translucent = NO;
    if (_editingQuestion) {
        self.navigationItem.title = @"Editing";
    } else {
        self.navigationItem.titleView = titleLabelView;
    }
    self.navigationItem.leftBarButtonItem               = cancel;
    self.navigationItem.rightBarButtonItem              = post;
    [self setNeedsStatusBarAppearanceUpdate];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 50.0f;
    } else if (indexPath.row == 1) {
        return self.questionBody.frame.size.height;
    }
    return 50.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *titleCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!titleCell) {
        titleCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSAttributedString *titlePH = [[NSAttributedString alloc]initWithString:@"Question Title (Be brief and clear)" attributes:@{ NSForegroundColorAttributeName: [UIColor colorWithRed:169/255.0 green:169/255.0 blue:185/255.0 alpha:1]}];
    
    if (_editingQuestion) {
        self.titleField.text = _questionToBeEdited[@"title"];
        self.questionBody.text = _questionToBeEdited[@"body"];
    } else {
        self.titleField.attributedPlaceholder = titlePH;
        self.questionBody.placeholder          = @"Enter question here...";
        self.questionBody.placeholderTextColor = [UIColor colorWithRed:169/255.0 green:169/255.0 blue:185/255.0 alpha:1];
    }
    self.titleField.font                  = [UIFont fontWithName:@"SFUIText-Regular" size:18];
    self.titleField.backgroundColor       = [UIColor clearColor];
    self.titleField.autocorrectionType    = UITextAutocorrectionTypeNo;
    self.titleField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    self.questionBody.font                 = [UIFont fontWithName:@"SFUIText-Regular" size:15];
    self.questionBody.autocorrectionType   = UITextAutocorrectionTypeNo;
    
    if (indexPath.row == 0) {
        [titleCell.contentView addSubview:self.titleField];
    } else if (indexPath.row == 1) {
        [titleCell.contentView addSubview:self.questionBody];
    }
 
    return titleCell;
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

#pragma - mark UITextView Delegate

- (void)textViewDidChange:(UITextView *)textView {
    CGFloat maxHeight = CGFLOAT_MAX;
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, CGFLOAT_MAX)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), fminf(newSize.height, maxHeight));
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:1 inSection:0];
    
    //change the row height
    if (newFrame.size.height >= 150) {
        //we need to disable the reload animation first
        [UIView setAnimationsEnabled:NO];
        [self.tableView beginUpdates];
        //set the new frame
        textView.frame = newFrame;
        [textView setFrame:newFrame];
        [textView sizeThatFits:newFrame.size];
        [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        [self.tableView endUpdates];
        //re-enable the animation after updating
        [UIView setAnimationsEnabled:YES];
    }
}

#pragma - Private methods

- (PFObject *)createQuestion {
    PFObject *question = [PFObject objectWithClassName:@"Questions"];
    [question setObject:self.topic                    forKey:@"category"];
    [question setObject:self.titleField.text          forKey:@"title"];
    [question setObject:self.questionBody.text        forKey:@"body"];
    [question setObject:[PFUser currentUser]          forKey:@"user"];
    [question setObject:[NSNumber numberWithInt:0]    forKey:@"upVotes"];
    [question setObject:[NSNumber numberWithInt:0]    forKey:@"numberOfComments"];
    [question setObject:[NSNumber numberWithInt:0]    forKey:@"numberOfFavs"];
    [question setObject:[NSNumber numberWithInt:0]    forKey:@"views"];
    [question setObject:[NSNumber numberWithBool:NO]  forKey:@"solved"];
    
    return question;
}

- (void)previewQuestion {
    QuestionDetailTableViewController *QDTVC = [[QuestionDetailTableViewController alloc]initWithStyle:UITableViewStyleGrouped];
    QDTVC.questionObject = [self createQuestion];
    QDTVC.preview = YES;
    QDTVC.isLoading = NO;
    
    Question *q = [[Question alloc]init];
    q.upVotes = [self createQuestion][@"upVotes"];
    q.author = [PFUser currentUser];
    q.body = self.questionBody.text;
    
    QDTVC.viewModel.question = q;
        
    [self.navigationController pushViewController:QDTVC animated:YES];
}

- (void)postQuestion {
    [self.view endEditing:YES];
    if (![self validQuestion]) {
        //NSLog(@"Invalid question");
    } else {
        [SRActionSheet sr_showActionSheetViewWithTitle:nil
                                     cancelButtonTitle:@"Cancel"
                                destructiveButtonTitle:nil
                                     otherButtonTitles:@[@"Post", @"Preview"]
                                      selectSheetBlock:^(SRActionSheet *actionSheetView, NSInteger actionIndex) {
                                          if (actionIndex == 0) {
                                              //post without preview
                                              if (_editingQuestion) {
                                                  [self editQuestion];
                                              } else {
                                                  [self askQuestion];
                                              }
                                              dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.4 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                                  [self dismissViewControllerAnimated:YES completion:nil];
                                              });
                                          } else if (actionIndex == 1) {
                                              //preview
                                              dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.4 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                                  [self previewQuestion];
                                              });
                                          }
                                      }];
    }
}

- (void)editQuestion {
    _questionToBeEdited[@"title"] = self.titleField.text;
    _questionToBeEdited[@"body"]  = self.questionBody.text;
    [_questionToBeEdited saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            //NSLog(@"Edited a new question %@", _questionToBeEdited);
        } else {
            NSString *parseErrorString;
            if (error.code == 100) {
                parseErrorString = @"Failed. No internet connection.(Tap to retry)";
            } else {
                parseErrorString = [error userInfo][@"error"];
            }
            [_delegate postQuestionWithQuestionObject:_questionToBeEdited notificationTitle:@"Error when posting question" message:parseErrorString image:[UIImage imageNamed:@"cross"] error:YES];
        }
    }];
}

- (void)askQuestion {
    PFObject *question = [self createQuestion];
    //store the question object
    GlobalVariables *GV = [GlobalVariables getInstance];
    GV.tempObject = question;
    
    [question saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable parseError) {
        if (succeeded) {
            //NSLog(@"Posted a new question %@", question);
            
            [_delegate postQuestionWithQuestionObject:question notificationTitle:@"Success!" message:@"Posted!(Tap to view)" image:[UIImage imageNamed:@"tick"] error:NO];
            
            PFObject *feed = [PFObject objectWithClassName:@"Feeds"];
            [feed setObject:@"Ask"               forKey:@"type"];
            [feed setObject:[PFUser currentUser] forKey:@"fromUser"];
            [feed setObject:question             forKey:@"toQuestion"];
            [feed setObject:[NSNumber numberWithInt:0] forKey:@"repChange"];
            [feed setObject:question.objectId forKey:@"toQuestionID"];
            [feed saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (succeeded) {
                    PFRelation *rel = [[PFUser currentUser] relationForKey:@"feeds"];
                    [rel addObject:feed];
                    [[PFUser currentUser] incrementKey:@"numberOfPosts" byAmount:[NSNumber numberWithInt:1]];
                    [[PFUser currentUser] saveInBackground];
                }
            }];
        } else {
            NSString *parseErrorString;
            if (parseError.code == 100) {
                parseErrorString = @"Failed. No internet connection.(Tap to retry)";
            } else {
                parseErrorString = [parseError userInfo][@"error"];
            }
            [_delegate postQuestionWithQuestionObject:question notificationTitle:@"Error when posting question" message:parseErrorString image:[UIImage imageNamed:@"cross"] error:YES];
        }
    }];
}

- (void)cancel {
    [self.view endEditing:YES];
    
    NSCharacterSet *charSet = [NSCharacterSet whitespaceCharacterSet];
    NSCharacterSet *nlSet   = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmedTitle  = [self.titleField.text stringByTrimmingCharactersInSet:charSet];
    NSString *trimmedbody   = [self.questionBody.text stringByTrimmingCharactersInSet:nlSet];
    
    if ([trimmedTitle isEqualToString:@""] && ![trimmedbody length]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [SRActionSheet sr_showActionSheetViewWithTitle:@"Do you want to save the draft?"
                                     cancelButtonTitle:@"Cancel"
                                destructiveButtonTitle:@"Delete"
                                     otherButtonTitles:@[@"Save"]
                                      selectSheetBlock:^(SRActionSheet *actionSheetView, NSInteger actionIndex) {
                                          if (actionIndex == 0) {
                                              //save the draft and dismiss
                                              QuestionDraft *draft = [QuestionDraft getDrafts];
                                              [draft.questionDrafts addObject:[self createQuestion]];
                                              dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.4 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                                  [self dismissViewControllerAnimated:YES completion:nil];
                                              });
                                          } else if (actionIndex == 1){
                                              //dismiss without saving
                                              dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.4 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                                  [self dismissViewControllerAnimated:YES completion:nil];
                                              });
                                          }
                                      }];
    }
}

- (void)showBottomSheet {
    STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:self];
    popupController.style = STPopupStyleBottomSheet;
    [popupController presentInViewController:self];
}

- (BOOL)validQuestion {
    NSCharacterSet *charSet = [NSCharacterSet whitespaceCharacterSet];
    NSCharacterSet *nlSet   = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmedTitle  = [self.titleField.text stringByTrimmingCharactersInSet:charSet];
    NSString *trimmedbody   = [self.questionBody.text stringByTrimmingCharactersInSet:nlSet];
    
    if ([trimmedTitle isEqualToString:@""] || ![trimmedbody length]) {
        return NO;
    } else {
        return YES;
    }
}

@end
