//
//  SearchMajorTableViewController.m
//  UniPlus
//
//  Created by Jiahe Li on 21/09/2016.
//  Copyright © 2016 Quicky Studio. All rights reserved.
//

#import "SearchMajorTableViewController.h"
#import "University.h"
#import "UniListCell.h"
#import "UPSearchController.h"

@interface SearchMajorTableViewController ()
@property(strong, nonatomic) NSArray            *filteredMajors;
@property(strong, nonatomic) UISearchController *searchController;
@property(strong, nonatomic) UPSearchController *upSearchController;
@property(nonatomic)         BOOL               shouldShowSearchResults;

@end

@implementation SearchMajorTableViewController
@synthesize majors;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.estimatedRowHeight = 83.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.shouldShowSearchResults = NO;
    
    //using the default searchController
    [self configureSearchController];
    self.searchController.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];
    self.searchController.active = NO;
    [self willDismissSearchController:self.searchController];
}

- (void)configureSearchController {
    self.searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.placeholder = @"Choose a major";
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

-(void)willDismissSearchController:(UISearchController *)searchController
{
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

- (void) didChangeSearchText:(NSString *)searchText {
    
}

#pragma mark - Searchbar deleagte

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    self.shouldShowSearchResults = YES;
    [self.tableView reloadData];
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.shouldShowSearchResults = NO;
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
    
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"self LIKE[cd] %@", searchWithWildcards];
    
    // Filter the university array and get only those institutions that match the search text.
    self.filteredMajors = [majors filteredArrayUsingPredicate:resultPredicate];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.shouldShowSearchResults) {
        return [self.filteredMajors count];
    }
    return [majors count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"unilist";
    UniListCell *cell1 = (UniListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell1 == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"UniListCell" owner:self options:nil];
        cell1 = [nib objectAtIndex:0];
    }
    
    //sort the array alphabetically
    if (self.shouldShowSearchResults) {
        cell1.uniName.text = [[self.filteredMajors sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.row];
    } else {
        cell1.uniName.text = [[self.majors sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.row];
    }
    
    return cell1;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.searchController.searchBar resignFirstResponder];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UniListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self.delegate addMajor:self didFinishPickingMajor:cell.uniName.text];
    
    self.searchController.active = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dealloc {
    [self.searchController.view removeFromSuperview];
}

@end
