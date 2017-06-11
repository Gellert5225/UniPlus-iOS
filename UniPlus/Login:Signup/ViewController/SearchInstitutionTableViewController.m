//
//  SearchInstitutionTableViewController.m
//  UniPlus
//
//  Created by Jiahe Li on 07/09/2016.
//  Copyright © 2016 Quicky Studio. All rights reserved.
//

#import "SearchInstitutionTableViewController.h"
#import "University.h"
#import "UniListCell.h"
#import "UPSearchController.h"

@interface SearchInstitutionTableViewController ()
@property(strong, nonatomic) NSMutableArray     *uniNames;
@property(strong, nonatomic) NSArray            *filterdUniversities;
@property(strong, nonatomic) UISearchController *searchController;
@property(strong, nonatomic) UPSearchController *upSearchController;
@property(nonatomic)         BOOL               shouldShowSearchResults;

@end

@implementation SearchInstitutionTableViewController
@synthesize universities;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.estimatedRowHeight = 83.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.shouldShowSearchResults = NO;
    
    self.uniNames = [[NSMutableArray alloc]init];
    
    for (University *uni in universities) {
        [self.uniNames addObject:uni.institutionName];
    }
    
    //using the default searchController
    self.searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    [self configureSearchController];
    self.searchController.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];
    self.searchController.active = NO;
    [self willDismissSearchController:self.searchController];
}

- (void)configureSearchController {
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.placeholder = @"Choose an Institution";
    self.searchController.searchBar.delegate = self;
    [self.searchController.searchBar sizeToFit];
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
}

- (void)willPresentSearchController:(UISearchController *)searchController {
    // do something before the search controller is presented
    self.navigationController.navigationBar.translucent = YES;
    [self.searchController.searchBar becomeFirstResponder];
}

-(void)willDismissSearchController:(UISearchController *)searchController {
    self.navigationController.navigationBar.translucent = NO;
}

- (void)configureCustomSearchController {
    self.upSearchController.UPDelegate = self;
}

#pragma mark - UPSearchControllerDelegate

- (void) didStartSearching {
    self.shouldShowSearchResults = YES;
    [self.tableView reloadData];
}

- (void) didTapOnSearchButton {
    if (!self.shouldShowSearchResults) {
        self.shouldShowSearchResults = YES;
        [self.tableView reloadData];
    }
}

- (void) didTapOnCancelButton {
    self.shouldShowSearchResults = NO;
    [self.tableView reloadData];
}

#pragma mark - Searchbar deleagte

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    self.shouldShowSearchResults = YES;
    [self.tableView reloadData];
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.shouldShowSearchResults = NO;
    self.searchController.active = NO;
    [self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if (!self.shouldShowSearchResults) {
        self.shouldShowSearchResults = YES;
        [self.tableView reloadData];
    }
    
    [self.searchController.searchBar resignFirstResponder];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchString = searchController.searchBar.text;
    
    NSMutableString *searchWithWildcards = [NSMutableString stringWithFormat:@"*%@*", searchString];
    if (searchWithWildcards.length > 3)
        for (int i = 2; i < searchString.length * 2; i += 2)
            [searchWithWildcards insertString:@"*" atIndex:i];
    
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF LIKE[cd] %@", searchWithWildcards];
    
    //NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"self CONTAINS[cd] %@", searchString];
    
    // Filter the university array and get only those institutions that match the search text.
    self.filterdUniversities = [self.uniNames filteredArrayUsingPredicate:resultPredicate];
    [self.tableView reloadData];
}

- (void)didChangeSearchText:(NSString *)searchText {
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.shouldShowSearchResults) {
        return [self.filterdUniversities count];
    }
    return [universities count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"unilist";
    UniListCell *cell1 = (UniListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell1 == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"UniListCell" owner:self options:nil];
        cell1 = [nib objectAtIndex:0];
    }
    
    University *university = self.universities[indexPath.row];
    
    if (self.shouldShowSearchResults) {
        cell1.uniName.text = self.filterdUniversities[indexPath.row];
    } else {
        cell1.uniName.text = university.institutionName;
    }
    
    return cell1;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.searchController.searchBar resignFirstResponder];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UniListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self.delegate addUniversity:self didFinishPickingUniversity:cell.uniName.text];
    
    self.searchController.active = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dealloc {
    [self.searchController.view removeFromSuperview]; // It works!
}

@end
