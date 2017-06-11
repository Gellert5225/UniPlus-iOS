//
//  UniPlusTests.m
//  UniPlusTests
//
//  Created by Jiahe Li on 06/09/2016.
//  Copyright © 2016 Quicky Studio. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "University.h"
#import "NewestQueryTableViewController.h"

@interface UniPlusTests : XCTestCase

@property (strong, nonatomic) University *university;
@property (strong, nonatomic) NewestQueryTableViewController *NQTVC;

@end

@implementation UniPlusTests

- (void)setUp {
    [super setUp];
    self.NQTVC = [[NewestQueryTableViewController alloc] initWithStyle:UITableViewStyleGrouped Topic:@"Computer Science" ParseClass:@"Questions" sortingOrder:@"Newest"];
    //self.university = [[University alloc]init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testGetJSON {
    [University getUniversitiesFromJSON];
}

- (void)testQuery {
    [self.NQTVC queryForTable];
}

- (void)testQueryPerformance {
    [self measureBlock:^{
        [self.NQTVC queryForTable];
    }];
}

- (void)testGetJSONPerformance {
    [self measureBlock:^{
        [University getUniversitiesFromJSON];
    }];
}

@end
