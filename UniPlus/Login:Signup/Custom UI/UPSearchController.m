//
//  UPSearchController.m
//  UniPlus
//
//  Created by Jiahe Li on 07/09/2016.
//  Copyright © 2016 Quicky Studio. All rights reserved.
//

#import "UPSearchController.h"

@interface UPSearchController ()<UISearchBarDelegate>

@end

@implementation UPSearchController

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        
    }
    return self;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [self.UPDelegate didStartSearching];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    [self.UPDelegate didTapOnSearchButton];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    [self.UPDelegate didTapOnCancelButton];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self.UPDelegate didChangeSearchText:searchText];
}

@end
