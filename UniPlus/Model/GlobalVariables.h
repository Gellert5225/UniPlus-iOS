//
//  GlobalVariables.h
//  UniPlus
//
//  Created by Jiahe Li on 07/09/2016.
//  Copyright © 2016 Quicky Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

/**
 This class can store multiple variable/properties across the application. However, the data will be lost if the application is terminated.
 <br/>
 For example, to get the question stored, simply create an instance of this class, then access the property using:
 
 ```[GlobalVariables getInstance].tempObject```

*/
@interface GlobalVariables : NSObject

/** 
 @name Properties
 */

/** The question object stored within current application lifecycle */
@property (strong, nonatomic)PFObject *tempObject;

/** 
 @name Class Methods
 */

/**
 Create an instance of the GlobalVariables class
 
 @return It returns a GlobalVariables instance
 */
+(GlobalVariables *)getInstance;

@end
