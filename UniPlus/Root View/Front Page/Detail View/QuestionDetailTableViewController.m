//
//  QuestionDetailTableViewController.m
//  UniPlus
//
//  Created by Jiahe Li on 20/10/2016.
//  Copyright © 2016 Quicky Studio. All rights reserved.
//

#import "QuestionDetailTableViewController.h"
#import "AnswerTableViewController.h"
#import "GlobalVariables.h"
#import "UPError.h"
#import "UPNavigationBarTitleView.h"
#import "ProfileTableViewController.h"
#import "ReportDialogViewController.h"
#import "SRActionSheet.h"

#import <GKFadeNavigationController/GKFadeNavigationController.h>
#import <PopupDialog/PopupDialog-Swift.h>

#define COLOR_SCHEME [UIColor colorWithRed:53/255.0 green:111/255.0 blue:177/255.0 alpha:1.0]

@interface QuestionDetailTableViewController ()<PZPullToRefreshDelegate,UIGestureRecognizerDelegate, UINavigationControllerDelegate, UpVoteViewDelegate, DownVoteViewDelegate, UITextViewDelegate, AnswerTableViewControllerDelegate, FavouriteViewDelegate, EditViewDelegate, ReportViewDelegate, AcceptAnswerCellDelegate, UPErrorDelegate, GKFadeNavigationControllerDelegate, ReportDialogViewControllerDelegate, SRActionSheetDelegate>

@property (strong, nonatomic) UPCommentAccessoryView  *commentAccView;
@property (strong, nonatomic) UITextView              *tv;
@property (strong, nonatomic) NSMutableDictionary     *cellHeightsDictionary;
@property (strong, nonatomic) NSNumber                *characterLimit;
@property (strong, nonatomic) NSIndexPath             *commentIndexPath;
@property (strong, nonatomic) Comment                 *awaitingComment;
@property (strong, nonatomic) NSString                *commentTo;
@property (strong, nonatomic) NSString                *reportMessage;
@property (strong, nonatomic) UPObject                *objectToReport;
@property (strong, nonatomic) UPObject                *objectToDelete;
@property (strong, nonatomic) NSIndexPath             *deleteAnswerIndexPath;

@property (nonatomic) BOOL userIsInTheMiddleOfComment;

@end

@implementation QuestionDetailTableViewController {
    PZPullToRefreshView *refreshControl;
    NSIndexPath *indexPathNeedsToBeScrolled;
    PopupDialog *reportDialog;
    DefaultButton *submitButton;
}
@synthesize viewModel = _viewModel;

- (NSMutableDictionary *)cellHeightsDictionary {
    if (!_cellHeightsDictionary) {
        _cellHeightsDictionary = [[NSMutableDictionary alloc]init];
    }
    return _cellHeightsDictionary;
}

- (void)setViewModel:(QuestionDetailViewModel *)viewModel {
    _viewModel = viewModel;
}

- (QuestionDetailViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[QuestionDetailViewModel alloc]init];
    }
    return _viewModel;
}

- (id)initWithStyle:(UITableViewStyle)style questionID:(NSString *)ID questionObject:(PFObject *)object setFromProfile:(BOOL)fromProfile setLoading:(BOOL)loading {
    self = [super initWithStyle:style];
    
    _questionId = ID;
    _questionObject = object;
    _isFromProfile = fromProfile;
    _isLoading = loading;
    
    return self;
}

#pragma - mark Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _viewModel = [[QuestionDetailViewModel alloc]init];
    
    [self loadNibs];
    
    _characterLimit = [NSNumber numberWithInt:200];
    _tv = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    _tv.tag = 999;
    _tv.delegate = self;
    
    if (!_preview) {
        [self loadObjects];
    }
    
    [self configureNavbar];
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.tableView.separatorStyle     = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView    = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, 0.01f)];
    self.tableView.rowHeight          = UITableViewAutomaticDimension;
    //self.tableView.contentInset = UIEdgeInsetsZero;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
        
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    __weak id weakSelf = self;
    self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.view endEditing:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIView setAnimationsEnabled:YES];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)help {
    
}

#pragma - mark UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
        return YES;
    } else {
        return  NO;
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return [gestureRecognizer isKindOfClass:UIScreenEdgePanGestureRecognizer.class];
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *key = indexPath;
    NSNumber *height = @(cell.frame.size.height);
    
    [self.cellHeightsDictionary setObject:height forKey:key];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSNumber *height = [self.cellHeightsDictionary objectForKey:indexPath];
    
    if (height) {
        return height.floatValue;
    }
    
    return UITableViewAutomaticDimension;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.isLoading) {
        return 2;
    }
    return _viewModel.question.answers.count + 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger sections = _viewModel.question.answers.count + 2;
    
    if (self.isLoading) {
        return 1;
    } else {
        if (section == 0) {
            return _viewModel.question.comments.count + 5;
        } else if (section == sections - 1) {
            return 1;
        } else {
            Answer *answer = _viewModel.question.answers[section - 1];
            return answer.comments.count + 4;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section != 0) {
        return 15.0f;
    }
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            QuestionDetailTitleCell *questionTitleCell = [self.tableView dequeueReusableCellWithIdentifier:questionTitleCellID forIndexPath:indexPath];
            if (self.isLoading || self.preview) {
                questionTitleCell.upImage.hidden      = YES;
                questionTitleCell.downImage.hidden    = YES;
                questionTitleCell.upVotesLabel.hidden = YES;
            } else {
                questionTitleCell.upImage.hidden      = NO;
                questionTitleCell.downImage.hidden    = NO;
                questionTitleCell.upVotesLabel.hidden = NO;
                questionTitleCell.question = _viewModel.question;
            }
            
            questionTitleCell.questionObject = _questionObject;
            questionTitleCell.upImage.delegate   = self;
            questionTitleCell.downImage.delegate = self;
            
            return questionTitleCell;
        } else if (indexPath.row == 1) {
            QuestionDetailBodyCell *questionBodyCell = [self.tableView dequeueReusableCellWithIdentifier:questionBodyCellID forIndexPath:indexPath];
            questionBodyCell.question = _viewModel.question;
            return questionBodyCell;
        } else if (indexPath.row == 2) {
            AuthorCell *authorCell = [self.tableView dequeueReusableCellWithIdentifier:authorCellID forIndexPath:indexPath];
            authorCell.delegate = self;
            authorCell.author = _viewModel.question.author;
            authorCell.askLabel.text = @"Asked";
            authorCell.creationDate = _viewModel.question.createdAt;
            return authorCell;
        } else if (indexPath.row == _viewModel.question.comments.count + 4) {
            AddCommentCell *addCommentCell = [self.tableView dequeueReusableCellWithIdentifier:addCommentCellID forIndexPath:indexPath];
            [addCommentCell.commentButton addTarget:self action:@selector(createCommentAccessoryView:withIndexPath:) forControlEvents:UIControlEventTouchUpInside];
            return addCommentCell;
        } else if (indexPath.row == 3) {
            AccessoryCell *accessoryCell = [self.tableView dequeueReusableCellWithIdentifier:accessoryCellID forIndexPath:indexPath];
            accessoryCell.belongsToAuthor = [_viewModel.question.author.objectId isEqualToString:[PFUser currentUser].objectId];
            accessoryCell.markView.delegate = self;
            accessoryCell.markView.questionToFavourite = _viewModel.question.pfObject;
            accessoryCell.markView.alreadyMarked = _viewModel.question.markedByUser;
            
            accessoryCell.editView.delegate = self;
            accessoryCell.editView.index = indexPath;
            accessoryCell.editView.objectToEdit = _viewModel.question.pfObject;
            
            accessoryCell.reportView.delegate = self;
            accessoryCell.reportView.index = indexPath;
            accessoryCell.reportView.objectToReport = _viewModel.question;
            return accessoryCell;
        } else {
            CommentCell *commentCell = [self.tableView dequeueReusableCellWithIdentifier:commentCellID forIndexPath:indexPath];
            commentCell.comment = _viewModel.question.comments[indexPath.row - 4];
            return commentCell;
        }
    } else if (indexPath.section == _viewModel.question.answers.count + 1) {
        if (self.isLoading) {
            LoadMoreCell *loadmoreCell = [self.tableView dequeueReusableCellWithIdentifier:loadMoreCellID forIndexPath:indexPath];
            [loadmoreCell.indicatorView startAnimating];
            return loadmoreCell;
        } else {
            AnswerItCell *answerItCell = [self.tableView dequeueReusableCellWithIdentifier:answerItCellID forIndexPath:indexPath];
            [answerItCell.answerButton addTarget:self action:@selector(didTapAnswerButton:) forControlEvents:UIControlEventTouchUpInside];
            return answerItCell;
        }
    } else {
        Answer *answer = _viewModel.question.answers[indexPath.section-1];
        if (indexPath.row == 0) {
            AnswerCell *answerCell = [self.tableView dequeueReusableCellWithIdentifier:answerCellID forIndexPath:indexPath];
            AcceptAnswerCell *acceptCell = [self.tableView dequeueReusableCellWithIdentifier:acceptedCellID forIndexPath:indexPath];
            
            answerCell.answer = answer;
            acceptCell.answer = answer;
            answerCell.upVoteView.delegate   = self;
            answerCell.downVoteView.delegate = self;
            acceptCell.upVoteView.delegate   = self;
            acceptCell.downVoteView.delegate = self;
            
            acceptCell.delegate = self;
            
            if ([_viewModel.question.author.objectId isEqualToString:[PFUser currentUser].objectId]) {
                acceptCell.acceptView.image = [UIImage imageNamed:[answer.objectId isEqualToString:_viewModel.question.correctAnswer.objectId]?@"medal-fill":@"medal"];
                return acceptCell;
            } else {
                if ([answer.objectId isEqualToString:_viewModel.question.correctAnswer.objectId]) {
                    acceptCell.acceptView.image = [UIImage imageNamed:@"medal-fill"];
                    acceptCell.acceptView.userInteractionEnabled = NO;
                    return acceptCell;
                } else {
                    return answerCell;
                }
            }
        } else if (indexPath.row == 1) {
            AuthorCell *authorCell = [self.tableView dequeueReusableCellWithIdentifier:authorCellID forIndexPath:indexPath];
            authorCell.delegate = self;
            authorCell.author = answer.author;
            authorCell.askLabel.text = @"Answered";
            authorCell.creationDate = answer.createdAt;
            return authorCell;
        } else if (indexPath.row == 2) {
            AnswerAccessoryCell *ansAccessoryCell = [self.tableView dequeueReusableCellWithIdentifier:answerAccId forIndexPath:indexPath];
            ansAccessoryCell.belongsToAuthor = [answer.author.objectId isEqualToString:[PFUser currentUser].objectId];
            ansAccessoryCell.editView.delegate = self;
            ansAccessoryCell.editView.index = indexPath;
            ansAccessoryCell.editView.objectToEdit = answer.pfObject;
            
            ansAccessoryCell.reportView.delegate = self;
            ansAccessoryCell.reportView.objectToReport = answer;
            ansAccessoryCell.reportView.index = indexPath;
            return ansAccessoryCell;
        } else if (indexPath.row == answer.comments.count + 3) {
            AddCommentCell *addCommentCell = [self.tableView dequeueReusableCellWithIdentifier:addCommentCellID forIndexPath:indexPath];
            [addCommentCell.commentButton addTarget:self action:@selector(createCommentAccessoryView:withIndexPath:) forControlEvents:UIControlEventTouchUpInside];
            return addCommentCell;
        } else {
            CommentCell *commentCell = [self.tableView dequeueReusableCellWithIdentifier:commentCellID forIndexPath:indexPath];
            commentCell.comment = [answer.comments objectAtIndex:indexPath.row - 3];
            return commentCell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[CommentCell class]]) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        if (!_userIsInTheMiddleOfComment) {
            CommentCell *commentCell = (CommentCell *)cell;
            _commentTo = [NSString stringWithFormat:@"Reply to %@", commentCell.comment.author[@"nickName"]];
            _awaitingComment = commentCell.comment;
            [self createCommentAccessoryView:nil withIndexPath:indexPath];
        }
    }
}

#pragma - mark PZPullToRefresh

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.isLoading) {
        [refreshControl refreshScrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [refreshControl refreshScrollViewDidEndDragging:scrollView];
}

- (void)pullToRefreshDidTrigger:(PZPullToRefreshView *)view {
    [self loadObjects];
}

#pragma - mark UITextView Delegates

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if (textView.tag == 999) {
        _commentAccView = [[UPCommentAccessoryView alloc]initWithNibName:@"UPCommentAccessoryView"];
        _commentAccView.replyLabel.text = _commentTo;
        _commentAccView.delegate = self;
        [_tv setInputAccessoryView:_commentAccView];
        _tv.inputAccessoryView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    }
    
    return YES;
}

#pragma - mark AuthorCellDelegate

- (void)didTapAuthorInfo:(PFUser *)author {
    ProfileTableViewController *PTVC = [[ProfileTableViewController alloc]initWithStyle:UITableViewStylePlain];
    PTVC.profileUser = author;
    //GKFadeNavigationController *nav = [[GKFadeNavigationController alloc]initWithRootViewController:PTVC];
    [self.navigationController pushViewController:PTVC animated:YES];
}

#pragma - mark UPCommentAccessoryViewDelegate

- (void)userShouldChangeText:(BOOL)should withText:(NSString *)text {
    if (!should) {
        if (_commentIndexPath.section == 0) {
            if (_commentIndexPath.row == _viewModel.question.comments.count + 4) { //comment to question.
                [self commentToObject:_viewModel.question withCommentBody:text replyToComment:nil];
            } else { //comment to comment.
                [self commentToObject:_viewModel.question withCommentBody:[NSString stringWithFormat:@"@%@ %@",_awaitingComment.author.username,text] replyToComment:_awaitingComment.pfObject];
            }
        } else {
            Answer *answer = [_viewModel.question.answers objectAtIndex:_commentIndexPath.section-1];
            if (_commentIndexPath.row == answer.comments.count + 3) { //comment to answer.
                [self commentToObject:answer withCommentBody:text replyToComment:nil];
            } else { //comment to comment.
                [self commentToObject:answer withCommentBody:[NSString stringWithFormat:@"@%@ %@",_awaitingComment.author.username,text] replyToComment:_awaitingComment.pfObject];
            }
        }
        [_commentAccView.commentView resignFirstResponder];
        [_tv removeFromSuperview];
        _userIsInTheMiddleOfComment = NO;
    } else {
        [UIView setAnimationsEnabled:NO];
    }
}

- (void)userDidTapDiscardView {
    [_commentAccView.commentView resignFirstResponder];
    [_commentAccView removeFromSuperview];
    [_tv removeFromSuperview];
    
    _userIsInTheMiddleOfComment = NO;
}

#pragma - mark AnswerTableViewControllerDelegate

- (void)answerQuestionWithAnswerObject:(PFObject *)answer notificationTitle:(NSString *)title message:(NSString *)message image:(UIImage *)img withError:(BOOL)err {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [ConfigNotification configureNotificationInViewController:self withError:err withTitle:title withBody:message];
    });
}

- (void)didTapFavouriteView {
    _viewModel.question.markedByUser = !_viewModel.question.markedByUser;
}

#pragma - mark EditViewDelegate

- (void)didTapEditViewAtIndex:(NSIndexPath *)index objectToEdit:(PFObject *)object {
    if (index.section == 0) {
        //present question editor
        PostQuestionTableViewController *PQTVC = [[PostQuestionTableViewController alloc]init];
        PQTVC.questionToBeEdited = _viewModel.question.pfObject;
        PQTVC.editingQuestion = YES;
        GKFadeNavigationController *nav = [[GKFadeNavigationController alloc]initWithRootViewController:PQTVC];
        [self presentViewController:nav animated:YES completion:nil];
    } else {
        //present answer editor
        AnswerTableViewController *ATVC = [[AnswerTableViewController alloc]init];
        ATVC.answerToBeEdited = object;
        ATVC.editingAnswer = YES;
        GKFadeNavigationController *nav = [[GKFadeNavigationController alloc]initWithRootViewController:ATVC];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

#pragma - mark ReportView Delegate

- (void)didTapReportViewAtIndex:(NSIndexPath *)index objectToReport:(UPObject *)object {
    if ([object.author.objectId isEqualToString:[PFUser currentUser].objectId]) { //cannot report yourself, delete here
        self.objectToDelete = object;
        if (object.type == TypeAnswer) {
            self.deleteAnswerIndexPath = index;
        }
        [self shrinkViewControllerWithDuration:0.2 transformScale:CGAffineTransformMakeScale(0.93, 0.93)];
        
        SRActionSheet *actionSheet = [[SRActionSheet alloc]initWithTitle:@"Delete this post?" cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete" otherButtonTitles:nil delegate:self];
        
        [actionSheet show];
        
    } else {
        ReportDialogViewController *reportVC = [[ReportDialogViewController alloc] initWithNibName:@"ReportDialogViewController" bundle:nil];
        reportVC.delegate = self;
        
        self.objectToReport = object;
        
        reportDialog = [[PopupDialog alloc] initWithViewController:reportVC buttonAlignment:UILayoutConstraintAxisHorizontal transitionStyle:PopupDialogTransitionStyleZoomIn gestureDismissal:NO completion:^{}];
        
        DefaultButton *btnAppearance = [DefaultButton appearance];
        btnAppearance.titleFont = [UIFont fontWithName:@"SFUIText-Regular" size:14];
        btnAppearance.titleColor = [UIColor colorWithRed:53/255.0 green:111/255.0 blue:177/255.0 alpha:1.0];
        
        submitButton = [[DefaultButton alloc] initWithTitle:@"Submit" dismissOnTap:YES action:^{
            self.reportMessage = reportVC.reportInfoTextField.text;
            [self postReportMessage];
        }];
                
        CancelButton *cancel = [[CancelButton alloc] initWithTitle:@"Cancel" dismissOnTap:YES action:nil];
        
        [reportDialog addButtons: @[submitButton, cancel]];
        
        [self.navigationController presentViewController:reportDialog animated:YES completion:nil];
    }
}

#pragma - mark SRActionSheet Delegate

- (void)actionSheet:(SRActionSheet *)actionSheet didSelectSheet:(NSInteger)index {
    if (index == 0) {
        if (self.objectToDelete.type == TypeQuestion) { //delete question
            [self.navigationController popViewControllerAnimated:YES];
            [_viewModel.question deleteQuestion];
            [_delegate deleteObjectWithId:self.objectToDelete.objectId indexPath:_indexPathOfQuestion];
        } else {
            //delete answer
            Answer *answer = _viewModel.question.answers[self.deleteAnswerIndexPath.section - 1];
            [_viewModel.question.answers removeObjectAtIndex:self.deleteAnswerIndexPath.section - 1];
            [self.tableView beginUpdates];
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:self.deleteAnswerIndexPath.section] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView endUpdates];
            [answer deleteAnswer];
            
            [PFCloud callFunctionInBackground:@"deleteAnswerFeed" withParameters:@{@"answerID" : answer.objectId}];
        }
    }
}

- (void)actionSheet:(SRActionSheet *)actionSheet willDismissFromSuperView:(UIView *)superView {
    [self shrinkViewControllerWithDuration:0.2 transformScale:CGAffineTransformMakeScale(1.0, 1.0)];
}

#pragma - mark ReportDialog Delegate

- (void)textFieldDidReturnWithText:(NSString *)text {
    [reportDialog dismiss:nil];
    self.reportMessage = text;
    [self postReportMessage];
}

#pragma - mark AcceptAnswerCell delegate

- (void)acceptAnswer:(Answer *)answer accepted:(BOOL)accept {
    [_viewModel acceptAnswer:answer accepted:accept];
}

- (void)didTapRetryButton {
    [self loadObjects];
}

#pragma - mark Helpers

- (void)shrinkViewControllerWithDuration:(NSTimeInterval)duration transformScale:(CGAffineTransform)scale {
    [UIView animateWithDuration:duration animations:^{
        self.navigationController.view.transform = scale;
    } completion:^(BOOL finished) { }];
}

- (void)postReportMessage {
    [PFCloud callFunctionInBackground:@"postReportMessage" withParameters:@{
        @"message"          :self.reportMessage,
        @"reportObjectId"   :self.objectToReport.objectId,
        @"reportObjectType" :[NSNumber numberWithInteger:self.objectToReport.type],
        @"toUserId"         :self.objectToReport.author.objectId,
        @"fromUserId"       :[PFUser currentUser].objectId
    }];
}

- (void)didTapAnswerButton:(UIButton *)sender {
    AnswerTableViewController *ATVC = [[AnswerTableViewController alloc]initWithStyle:UITableViewStylePlain];
    ATVC.question = _viewModel.question.pfObject;
    ATVC.delegate = self;
    GKFadeNavigationController *nav = [[GKFadeNavigationController alloc]initWithRootViewController:ATVC];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)commentToObject:(UPObject *)object withCommentBody:(NSString *)body replyToComment:(PFObject *)toComment {
    [_viewModel commentToObject:object withCommentBody:body replyToComment:toComment];
    
    NSIndexPath *indexPathThatNeedsToBeScrolled = [NSIndexPath indexPathForRow:[self.tableView numberOfRowsInSection:_commentIndexPath.section] inSection:_commentIndexPath.section];
    NSIndexPath *insertIndexPath = [NSIndexPath indexPathForRow:[self.tableView numberOfRowsInSection:_commentIndexPath.section]-1 inSection:_commentIndexPath.section];
    
    [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(insertCellWithTimer:) userInfo:insertIndexPath repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(scrollTableWithTimer:) userInfo:indexPathThatNeedsToBeScrolled repeats:NO];
}

- (void)createCommentAccessoryView:(UIButton *)sender withIndexPath:(NSIndexPath *)indexPath {
    if (!_userIsInTheMiddleOfComment) {
        //NSLog(@"not commenting!");
        _userIsInTheMiddleOfComment = YES;
        
        if (sender) {
            CGPoint center= sender.center;
            CGPoint rootViewPoint = [sender.superview convertPoint:center toView:self.tableView];
            NSIndexPath *senderIndexPath = [self.tableView indexPathForRowAtPoint:rootViewPoint];
            
            _commentIndexPath = senderIndexPath;
            if (_commentIndexPath.section == 0) {
                _commentTo = [NSString stringWithFormat:@"Comment to %@'s question", _viewModel.question.author[@"nickName"]];
                indexPathNeedsToBeScrolled = [NSIndexPath indexPathForRow:1 inSection:0];
            } else {
                Answer *answer = _viewModel.question.answers[_commentIndexPath.section - 1];
                _commentTo = [NSString stringWithFormat:@"Comment to %@'s answer", answer.author[@"nickName"]];
                indexPathNeedsToBeScrolled = [NSIndexPath indexPathForRow:0 inSection:_commentIndexPath.section];
            }
        } else {
            _commentIndexPath = indexPath;
            indexPathNeedsToBeScrolled = _commentIndexPath;
        }
        
        [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(scrollTableWithTimer:) userInfo:indexPathNeedsToBeScrolled repeats:NO];
        
        [self.view addSubview:_tv];
        [_tv becomeFirstResponder];
        [_commentAccView.commentView becomeFirstResponder];
    }
}

- (void)scrollTableWithTimer:(NSTimer *)timer {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [self.tableView scrollToRowAtIndexPath:timer.userInfo atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    [UIView commitAnimations];
}

- (void)insertCellWithTimer:(NSTimer *)timer {
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[timer.userInfo] withRowAnimation:UITableViewRowAnimationRight];
    [self.tableView endUpdates];
}

- (void)configureNavbar {
    UPNavigationBarTitleView *titleView = [[UPNavigationBarTitleView alloc] initWithTitle:_questionObject[@"title"] subTitle:_questionObject[@"category"]];
    
    GKFadeNavigationController *navigationController = (GKFadeNavigationController *)self.navigationController;
    
    self.navigationItem.titleView = titleView;
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    //UIBarButtonItem *helpButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"help"] style:UIBarButtonItemStyleDone target:self action:@selector(help)];
    
    self.navigationItem.leftBarButtonItem = backButtonItem;
    //self.navigationItem.rightBarButtonItem = helpButtonItem;
    [self.navigationController.navigationBar setTintColor:COLOR_SCHEME];
    [navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    navigationController.navigationBar.translucent = NO;
    
    [navigationController setNeedsStatusBarAppearanceUpdate];
}

- (void)loadNibs {
    UINib *questionTitleCell = [UINib nibWithNibName:@"QuestionDetailTitleCell" bundle:nil];
    [self.tableView registerNib:questionTitleCell forCellReuseIdentifier:questionTitleCellID];
    
    UINib *questionBodyCell = [UINib nibWithNibName:@"QuestionDetailBodyCell" bundle:nil];
    [self.tableView registerNib:questionBodyCell forCellReuseIdentifier:questionBodyCellID];
    
    UINib *addCommentCell = [UINib nibWithNibName:@"AddCommentCell" bundle:nil];
    [self.tableView registerNib:addCommentCell forCellReuseIdentifier:addCommentCellID];
    
    UINib *accessoryCell = [UINib nibWithNibName:@"AccessoryCell" bundle:nil];
    [self.tableView registerNib:accessoryCell forCellReuseIdentifier:accessoryCellID];
    
    UINib *loadmoreCell = [UINib nibWithNibName:@"LoadMoreCell" bundle:nil];
    [self.tableView registerNib:loadmoreCell forCellReuseIdentifier:loadMoreCellID];
    
    UINib *answerItCell = [UINib nibWithNibName:@"AnswerItCell" bundle:nil];
    [self.tableView registerNib:answerItCell forCellReuseIdentifier:answerItCellID];
    
    UINib *commentCell = [UINib nibWithNibName:@"CommentCell" bundle:nil];
    [self.tableView registerNib:commentCell forCellReuseIdentifier:commentCellID];
    
    UINib *authorCell = [UINib nibWithNibName:@"AuthorCell" bundle:nil];
    [self.tableView registerNib:authorCell forCellReuseIdentifier:authorCellID];
    
    UINib *answerCell = [UINib nibWithNibName:@"AnswerCell" bundle:nil];
    [self.tableView registerNib:answerCell forCellReuseIdentifier:answerCellID];
    
    UINib *acceptAnswerCell = [UINib nibWithNibName:@"AcceptAnswerCell" bundle:nil];
    [self.tableView registerNib:acceptAnswerCell forCellReuseIdentifier:acceptedCellID];
    
    UINib *answerAccCell = [UINib nibWithNibName:@"AnswerAccessoryCell" bundle:nil];
    [self.tableView registerNib:answerAccCell forCellReuseIdentifier:answerAccId];
}

- (void)loadObjects {
    CGFloat tableViewHeight = self.tableView.bounds.size.height;
    CGFloat tableViewWidth  = self.tableView.bounds.size.width;
    __weak typeof(self) weakSelf = self;
    [_viewModel fetchQuestionWithQuestionID:_questionId completionBlock:^(BOOL success, NSError *error) {
        if (success) {
            weakSelf.isLoading = NO;
            [_viewModel incrementNumberOfViews];
            [weakSelf.tableView reloadData];
            if (!refreshControl && !weakSelf.isLoading) {
                refreshControl = [[PZPullToRefreshView alloc] initWithFrame:CGRectMake(0, 0 - tableViewHeight, tableViewWidth, tableViewHeight)];
                refreshControl.thresholdValue = 40.0;
                refreshControl.statusTextColor = COLOR_SCHEME;
                refreshControl.delegate = weakSelf;
                [weakSelf.tableView addSubview:refreshControl];
            }
        } else {
            if ([[weakSelf.navigationController visibleViewController] isKindOfClass:[QuestionDetailTableViewController class]]) {
                UPError *upError = [[UPError alloc] initWithErrorString:[NSString stringWithFormat:@"%@",[error userInfo][@"error"]]];
                upError.delegate = weakSelf;
                [weakSelf.navigationController presentViewController:[upError configurePopupDialog] animated:YES completion:nil];
            }
        }
        refreshControl.isLoading = NO;
        [refreshControl refreshScrollViewDataSourceDidFinishedLoading:weakSelf.tableView];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        weakSelf.tableView.contentInset = UIEdgeInsetsMake(self.navigationController.navigationBar.translucent?64:0, 0, 0, 0);
        [UIView commitAnimations];
    }];
}

- (GKFadeNavigationControllerNavigationBarVisibility)preferredNavigationBarVisibility {
    return GKFadeNavigationControllerNavigationBarVisibilitySystem;
}

- (void)upVoteObject:(UPObject *)object {
    
}

- (void)downVoteObject:(UPObject *)object {
    
}

@end
