//
//  EditTopicTableViewController.m
//  UniPlus
//
//  Created by Jiahe Li on 22/09/2016.
//  Copyright © 2016 Quicky Studio. All rights reserved.
//

#import "EditTopicTableViewController.h"
#import "SearchMajorTableViewController.h"
#import "UniListCell.h"
#import <Parse/Parse.h>
#import <PopupDialog/PopupDialog-Swift.h>

@interface EditTopicTableViewController ()
@property(strong, nonatomic) NSMutableArray *majors;

@end

@implementation EditTopicTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Edit Topic";
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
    self.navigationItem.leftBarButtonItem = cancel;
    
    UIBarButtonItem *add = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addTopic)];
    self.navigationItem.rightBarButtonItem = add;
    
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 48, 0, 0);
    self.tableView.editing = YES;
    
    self.majors = [[NSMutableArray alloc]initWithObjects:@"Argriculture",@"Anthropology",@"Archeaology",@"Architecture and Design", @"Area Studies",@"Biology",@"Business", @"Chemical Engineering",@"Chemistry", @"Civil Engineering", @"Computer Science", @"Cultural and Ethic Studies", @"Divinity", @"Earch Science",@"Economics",@"Electrical Engineering", @"Geography", @"Human History", @"Law", @"Linguistic", @"Literature", @"Logic", @"Mathmatics",@"Mechanical Engineering", @"Medicine", @"Millitary Science", @"Philosophy",@"Physics", @"Political  Science", @"Psychology",@"Public Administration", @"Sociology", @"Space Science", @"Statistics", @"System Science",nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self resetMajorArray];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.editableMajorArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier1 = @"unilist";
    
    UniListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
    
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"UniListCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.uniName.text = [self.editableMajorArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)addTopic {
    SearchMajorTableViewController *SMTVC = [[SearchMajorTableViewController alloc]init];
    SMTVC.delegate = self;
    SMTVC.majors = self.majors;
    [self.navigationController pushViewController:SMTVC animated:YES];
}

- (void)done {
    if ([self.editableMajorArray count] == 0) {
        [self showAlertWithErrorString:@"Please select at least one topic"];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:self.editableMajorArray forKey:@"majorArray"];
        [[PFUser currentUser] setObject:self.editableMajorArray forKey:@"topics"];
        [[PFUser currentUser] saveInBackground];
        [self.delegate passMajorArrayToLeftMenu:self.editableMajorArray];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)addMajor:(SearchMajorTableViewController *)search didFinishPickingMajor:(NSString *)major {
    [self.editableMajorArray addObject:major];
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.majors addObject:[self.editableMajorArray objectAtIndex:indexPath.row]];
        [self.editableMajorArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    NSString *majorToMove = [self.editableMajorArray objectAtIndex:fromIndexPath.row];
    [self.editableMajorArray removeObjectAtIndex:fromIndexPath.row];
    [self.editableMajorArray insertObject:majorToMove atIndex:toIndexPath.row];
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)resetMajorArray {
    for (int i = 0; i < [self.majors count]; i++) {
        for (int j = 0; j < [self.editableMajorArray count]; j++) {
            NSString *m = [self.editableMajorArray objectAtIndex:j];
            NSString *n = [self.majors objectAtIndex:i];
            if ([m isEqualToString:n]) {
                //delete n from majors
                [self.majors removeObject:n];
            }
        }
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
    
    [popup addButtonsWithButtons:@[ok]];
    
    [self.navigationController presentViewController:popup animated:YES completion:nil];
}

@end
