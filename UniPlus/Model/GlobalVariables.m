//
//  GlobalVariables.m
//  UniPlus
//
//  Created by Jiahe Li on 07/09/2016.
//  Copyright © 2016 Quicky Studio. All rights reserved.
//

#import "GlobalVariables.h"

@implementation GlobalVariables
@synthesize tempObject;

static GlobalVariables *instance = nil;

+ (GlobalVariables *)getInstance {
    @synchronized(self) {
        if(instance==nil) {
            instance= [GlobalVariables new];
        }
    }
    return instance;
}

@end
