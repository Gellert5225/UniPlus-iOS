//
//  AnswerTableViewController.m
//  UniPlus
//
//  Created by Jiahe Li on 15/11/2016.
//  Copyright © 2016 Quicky Studio. All rights reserved.
//

#import "AnswerTableViewController.h"
#import "SZTextView.h"
#import "SRActionSheet.h"
#import "GlobalVariables.h"

#define COLOR_SCHEME [UIColor colorWithRed:53/255.0 green:111/255.0 blue:177/255.0 alpha:1.0]
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width

@interface AnswerTableViewController ()

@property (strong, nonatomic) SZTextView *answerBody;

@end

@implementation AnswerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.allowsSelection = NO;
    
    [self configureNavbar];
    
    self.answerBody = [[SZTextView alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 15, 150)];
    self.answerBody.scrollEnabled = NO;
    self.answerBody.allowsEditingTextAttributes = YES;
    self.answerBody.delegate = self;
}

- (void)configureNavbar {
    //configure the navigation bar
    UIBarButtonItem *cancel  = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Cancel"]
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(cancel)];
    UIBarButtonItem *post    = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Post"]
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(postAnswer)];
    
    [self.navigationController.navigationBar setTintColor:COLOR_SCHEME];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.leftBarButtonItem               = cancel;
    self.navigationItem.rightBarButtonItem              = post;
    self.navigationItem.title                           = @"Answer";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: COLOR_SCHEME};
    [self setNeedsStatusBarAppearanceUpdate];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.answerBody.frame.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *titleCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!titleCell) {
        titleCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    self.answerBody.placeholder          = @"Answer question here...";
    self.answerBody.placeholderTextColor = [UIColor colorWithRed:169/255.0 green:169/255.0 blue:185/255.0 alpha:1];
    self.answerBody.font                 = [UIFont fontWithName:@"SFUIText-Regular" size:15];
    self.answerBody.autocorrectionType   = UITextAutocorrectionTypeNo;
    
    if (_editingAnswer) {
        self.answerBody.text = _answerToBeEdited[@"body"];
    }
    
    [titleCell.contentView addSubview:self.answerBody];
    
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
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    
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

- (PFObject *)createAnswer {
    PFObject *answer = [PFObject objectWithClassName:@"Answers"];
    answer[@"author"]     = [PFUser currentUser];
    answer[@"toQuestion"] = self.question;
    answer[@"body"]       = self.answerBody.text;
    answer[@"upVotes"]    = [NSNumber numberWithInt:0];
    
    return answer;
}

- (void)cancel {
    [self.view endEditing:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.4 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}

- (void)postAnswer {
    [self.view endEditing:YES];
    
    if (![self validAnswer]) {
        //NSLog(@"Invalid question");
    } else {
        [SRActionSheet sr_showActionSheetViewWithTitle:nil
                                     cancelButtonTitle:@"Cancel"
                                destructiveButtonTitle:nil
                                     otherButtonTitles:@[@"Post", @"Preview"]
                                      selectSheetBlock:^(SRActionSheet *actionSheetView, NSInteger actionIndex) {
                                          if (actionIndex == 0) {
                                              //post without preview
                                              if (_editingAnswer) {
                                                  [self editAnswer];
                                              } else {
                                                  [self answerQuestion];
                                              }
                                              dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.4 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                                  [self dismissViewControllerAnimated:YES completion:nil];
                                              });
                                          } else if (actionIndex == 1) {
                                              //preview
                                              dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.4 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                                  //[self previewQuestion];
                                              });
                                          }
                                      }];
    }
}

- (void)editAnswer {
    _answerToBeEdited[@"body"] = self.answerBody.text;
    [_answerToBeEdited saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            
        } else {
            NSString *parseErrorString;
            if (error.code == 100) {
                parseErrorString = @"Failed. No internet connection.(Tap to retry)";
            } else {
                parseErrorString = [error userInfo][@"error"];
            }
            [_delegate answerQuestionWithAnswerObject:_answerToBeEdited notificationTitle:@"Error when editing answer" message:parseErrorString image:nil withError:YES];
        }
    }];
}

- (void)answerQuestion {
    PFObject *answer = [self createAnswer];
    //store the question object
    GlobalVariables *GV = [GlobalVariables getInstance];
    GV.tempObject = answer;
    
    [answer saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable parseError) {
        if (succeeded) {
            //NSLog(@"Posted a new answer %@", answer);
            
            [self.delegate answerQuestionWithAnswerObject:answer notificationTitle:@"Success!" message:@"Answered!(Tap to view)" image:[UIImage imageNamed:@"tick"] withError:NO];
            
            PFRelation *answerRelation = [self.question relationForKey:@"answers"];
            [answerRelation addObject:answer];
            [self.question saveInBackground];
            
            PFObject *feed = [PFObject objectWithClassName:@"Feeds"];
            [feed setObject:@"Answer"                  forKey:@"type"];
            [feed setObject:[PFUser currentUser]       forKey:@"fromUser"];
            [feed setObject:self.question              forKey:@"toQuestion"];
            [feed setObject:self.question[@"user"]     forKey:@"toUser"];
            [feed setObject:answer                     forKey:@"toAnswer"];
            [feed setObject:[NSNumber numberWithInt:0] forKey:@"repChange"];
            [feed saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (succeeded) {
                    PFRelation *rel = [[PFUser currentUser] relationForKey:@"feeds"];
                    [rel addObject:feed];
                    [[PFUser currentUser] incrementKey:@"numberOfAnswers"];
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
            
            [self.delegate answerQuestionWithAnswerObject:answer notificationTitle:@"Error when posting answer" message:parseErrorString image:[UIImage imageNamed:@"cross"] withError:YES];
        }
    }];
}

- (BOOL)validAnswer {
    NSCharacterSet *nlSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmedbody = [self.answerBody.text stringByTrimmingCharactersInSet:nlSet];
    
    return [trimmedbody length];
}

@end
