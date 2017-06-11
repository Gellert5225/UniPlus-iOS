//
//  UPLeftMenuTableViewController.m
//  UniPlus
//
//  Created by Jiahe Li on 08/09/2016.
//  Copyright © 2016 Quicky Studio. All rights reserved.
//

#import "EditTopicTableViewController.h"
#import "UPLeftMenuTableViewController.h"
#import "SWRevealViewController.h"
#import "SLExpandableTableView.h"
#import "GeneralDiscussionCell.h"
#import "MainPageViewController.h"
#import "ProfileTableViewController.h"
#import "FeedsViewController.h"
#import "SectionCell.h"
#import "RowCell.h"
#import "ProfileCell.h"
#import "HeaderView.h"
#import "MainScreen.h"
#import <Parse/Parse.h>
#import <GKFadeNavigationController/GKFadeNavigationController.h>

@interface UPLeftMenuTableViewController () {
    UITableView *leftMenu;
    SWRevealViewController *revealController;
}

@property (strong, nonatomic) NSArray *generalTopics;

@end

@implementation UPLeftMenuTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    leftMenu = [[SLExpandableTableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    leftMenu.delegate   = self;
    leftMenu.dataSource = self;
    
    self.view = leftMenu;
    
    leftMenu.backgroundColor = [UIColor colorWithRed:53/255.0 green:111/255.0 blue:177/255.0 alpha:1.0];
    [leftMenu setSeparatorColor:[UIColor clearColor]];
    
    self.clearsSelectionOnViewWillAppear = YES;
    
    self.generalTopics = @[@"Living",@"Entertainments",@"Campus Life",@"Admission",@"Transfer"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - SLExpandableTableViewDataSource

- (BOOL)tableView:(SLExpandableTableView *)tableView canExpandSection:(NSInteger)section {
    switch (section) {
        case 0:
            return NO;
        default:
            return YES;
    }
}

- (BOOL)tableView:(SLExpandableTableView *)tableView needsToDownloadDataForExpandableSection:(NSInteger)section {
    return NO;
}

- (UITableViewCell<UIExpandingTableViewCell> *)tableView:(SLExpandableTableView *)tableView expandingCellForSection:(NSInteger)section {
    static NSString *CellIdentifier = @"sectionCell";
    static NSString *CellIdentifier2 = @"generalTopicCell";
    SectionCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    GeneralDiscussionCell *cell2 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
    
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SectionCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    if (!cell2) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"GeneralDiscussionCell" owner:self options:nil];
        cell2 = [nib objectAtIndex:0];
    }
    
    //set selection color
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(edit)];
    
    switch (section) {
        case 1:
            cell2.cellImg.image = [UIImage imageNamed:@"Topic"];
            cell2.cellText.text = @"General Discussion";
            cell2.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        case 2:
            cell.cellImg.image     = [UIImage imageNamed:@"Academic"];
            cell.cellText.text     = @"Coursework Q&A";
            cell.selectionStyle    = UITableViewCellSelectionStyleNone;
            cell.editImage.image   = [UIImage imageNamed:@"Edit"];
            [cell.editView addGestureRecognizer:tap];
            break;
        case 3:
            cell.cellImg.image = [UIImage imageNamed:@"Inbox"];
            cell.cellText.text = @"Inbox";
            [cell setSelectedBackgroundView:bgColorView];
            break;
        case 4:
            cell.cellImg.image = [UIImage imageNamed:@"Search"];
            cell.cellText.text = @"Discover";
            [cell setSelectedBackgroundView:bgColorView];
            break;
        case 5:
            cell.cellImg.image = [UIImage imageNamed:@"Settings"];
            cell.cellText.text = @"Settings";
            [cell setSelectedBackgroundView:bgColorView];
            break;
        case 6:
            cell.cellImg.image = [UIImage imageNamed:@"LogOut"];
            cell.cellText.text = @"Log Out";
            [cell setSelectedBackgroundView:bgColorView];
            break;
        default:
            break;
    }
    
    if (section == 1) {
        return cell2;
    }
    return cell;
}

#pragma mark - SLExpandableTableViewDelegate

- (void)tableView:(SLExpandableTableView *)tableView downloadDataForExpandableSection:(NSInteger)section {
    // download your data here
    // call [tableView expandSection:section animated:YES]; if download was successful
    // call [tableView cancelDownloadInSection:section]; if your download was NOT successful
}

- (void)tableView:(SLExpandableTableView *)tableView willExpandSection:(NSUInteger)section animated:(BOOL)animated {
    if (section == 6) {
        //log out and go to login screen.
        revealController = self.revealViewController;
        
        PFInstallation *currentInstall = [PFInstallation currentInstallation];
        [currentInstall removeObjectForKey:@"user"];
        [currentInstall saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
             if (succeeded) {
                 [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
                     if (!error) {
                         //NSLog(@"Logged out");
                     } else {
                         NSLog(@"%@", [NSString stringWithFormat:@"%@",[error userInfo][@"error"]]);
                     }
                 }];

             } else {
                 NSString *errorString = [error userInfo][@"error"];
                 NSLog(@"%@", errorString);
             }
        }];
        
        MainScreen *MS = [[MainScreen alloc]initWithNibName:@"MainScreen" bundle:nil];
        [revealController pushFrontViewController:MS animated:YES];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 80;
    } else {
        if (indexPath.row == 0) {
            return 50;
        } else {
            return 40;
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 1:
            return [self.generalTopics count] + 1;//number of topics + 1
        case 2:
            return [self.menuMajorArray count] + 1;//number of majors + 1
        default:
            return 1;
    };
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier1 = @"rowCell";
    static NSString *CellIdentifier2 = @"profileCell";
    
    RowCell     *cell1 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
    ProfileCell *cell2 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
    
    if (!cell1) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RowCell" owner:self options:nil];
        cell1 = [nib objectAtIndex:0];
    }
    
    if (!cell2) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ProfileCell" owner:self options:nil];
        cell2 = [nib objectAtIndex:0];
    }
    
    //set selection color
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2];
    [cell1 setSelectedBackgroundView:bgColorView];
    
    cell2.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell2.profilePhotoView.layer.cornerRadius = cell2.profilePhotoView.frame.size.height/2;
    cell2.profilePhotoView.layer.masksToBounds = YES;
    
    cell2.nameLabel.text = [[PFUser currentUser] objectForKey:@"nickName"];
    cell2.profilePhotoView.image = [UIImage imageNamed:@"empty-profile"];//place holder
    cell2.profilePhotoView.file = [[PFUser currentUser] objectForKey:@"profilePhoto"];
    [cell2.profilePhotoView loadInBackground];
    
    if (indexPath.row == 0) {
        return cell2;
    }
    
    if (indexPath.section == 1) {
        cell1.cellText.text = [self.generalTopics objectAtIndex:indexPath.row - 1];
    } else if (indexPath.section == 2) {
        cell1.cellText.text = [self.menuMajorArray objectAtIndex:indexPath.row - 1];
    }
    return cell1;
}

#pragma - Tableview delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    revealController = self.revealViewController;
    if (indexPath.section == 0) {
        //profile page
        ProfileTableViewController *PTVC = [[ProfileTableViewController alloc]initWithStyle:UITableViewStylePlain];
        PTVC.profileUser = [PFUser currentUser];
        GKFadeNavigationController *nav = [[GKFadeNavigationController alloc]initWithRootViewController:PTVC];
        [revealController pushFrontViewController:nav animated:YES];
    } else if (indexPath.section == 1) {
        //present general discussion
        MainPageViewController *MPVC = [[MainPageViewController alloc]initWithTopic:[self.generalTopics objectAtIndex:indexPath.row - 1] ParseClass:@"Discussions"];
        GKFadeNavigationController *nav  = [[GKFadeNavigationController alloc]initWithRootViewController:MPVC];
        [revealController pushFrontViewController:nav animated:YES];
    } else if (indexPath.section == 2) {
        //present coursework q&a
        MainPageViewController *MPVC = [[MainPageViewController alloc]initWithTopic:[self.menuMajorArray objectAtIndex:indexPath.row - 1] ParseClass:@"Questions"];
        GKFadeNavigationController *nav  = [[GKFadeNavigationController alloc]initWithRootViewController:MPVC];
        [revealController pushFrontViewController:nav animated:YES];
    }
}

- (void)edit {
    EditTopicTableViewController *ETTVC = [[EditTopicTableViewController alloc]init];
    ETTVC.delegate = self;
    ETTVC.editableMajorArray = [self.menuMajorArray mutableCopy];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:ETTVC];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)passMajorArrayToLeftMenu:(NSMutableArray *)array {
    self.menuMajorArray = array;
}

@end
