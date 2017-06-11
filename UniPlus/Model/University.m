//
//  University.m
//  UniPlus
//
//  Created by Jiahe Li on 07/09/2016.
//  Copyright © 2016 Quicky Studio. All rights reserved.
//

#import "University.h"

@implementation University

+ (NSMutableArray *)getUniversitiesFromJSON {
    NSMutableArray *universities = [[NSMutableArray alloc]init];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"US_Degree_Institution" ofType:@"json"];
    NSData   *content  = [[NSData alloc] initWithContentsOfFile:filePath];
    NSArray  *json     = [NSJSONSerialization JSONObjectWithData:content options:kNilOptions error:nil];
    
    int count = 0;
    
    for (NSDictionary *dic in json) {
        University *university = [[University alloc]init];
        
        university.institutionName         = [dic objectForKey:@"institution_name"];
        university.institutionNameAlias    = [dic objectForKey:@"institution_name_alias"];
        university.institutionCityLocation = [dic objectForKey:@"city_location_of_institution"];
        university.institutionWebsite      = [dic objectForKey:@"institutions_internet_website"];
        
        [universities addObject:university];
        count ++;
    }
    
    return universities;
}

@end
