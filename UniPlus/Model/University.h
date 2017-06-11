//
//  University.h
//  UniPlus
//
//  Created by Jiahe Li on 07/09/2016.
//  Copyright © 2016 Quicky Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
  Parse university objects from JSON file into this class.
 */
@interface University : NSObject

/*!
 @name Properties
 */

/**
 The name of the institution.
 */
@property(strong, nonatomic)NSString *institutionName;
/**
 The alias of the institution.
 */
@property(strong, nonatomic)NSString *institutionNameAlias;
/**
 The website of the institution.
 */
@property(assign, nonatomic)NSString *institutionWebsite;
/**
 The city location of the institution.
 */
@property(assign, nonatomic)NSString *institutionCityLocation;

/*!
 @name Factory Methods
 */

/**
 Get a list of universities from a JSON file
 
 @return An array of University objects.
 */
+ (NSMutableArray *)getUniversitiesFromJSON;

@end
