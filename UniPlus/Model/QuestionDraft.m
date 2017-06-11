//
//  QuestionDraft.m
//  UniPlus
//
//  Created by Jiahe Li on 04/10/2016.
//  Copyright © 2016 Quicky Studio. All rights reserved.
//

#import "QuestionDraft.h"

@implementation QuestionDraft
@synthesize questionDrafts;

static QuestionDraft *draft = nil;

+ (QuestionDraft *)getDrafts {
    @synchronized(self) {
        if(draft == nil) {
            draft = [QuestionDraft new];
        }
    }
    return draft;
}

- (void)deleteDraft:(PFObject *)question {
    [questionDrafts removeObject:question];
}

- (void)addDraft:(PFObject *)question {
    [questionDrafts addObject:question];
}

- (PFObject *)getDraftAtIndex:(NSInteger)index {
    if (questionDrafts) {
        return [questionDrafts objectAtIndex:index];
    }
    return nil;
}

//Getter of the questionDrafts.
- (NSMutableArray *)questionDrafts {
    if (!questionDrafts) {
        questionDrafts = [[NSMutableArray alloc]init];
    }
    return questionDrafts;
}

@end
