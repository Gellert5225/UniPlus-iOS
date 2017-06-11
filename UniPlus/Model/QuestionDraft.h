//
//  QuestionDraft.h
//  UniPlus
//
//  Created by Jiahe Li on 04/10/2016.
//  Copyright © 2016 Quicky Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

/**
 The data model for saving a draft.
 
 Each time when a user dismiss a PostQuestionTableViewController, the draft will be automatically saved.
 
  - If there is no drafts, then it will initialize a new questionDrafts array, then store the current draft.
  - If the user has a draft composed previously, then append the current draft to the array.
  - If the user successfully posts this draft, then it will be deleted from the array.
  - If the user makes any changes to the draft, then it will be considered as a new draft.
 
 @warning *This is only used to store the draft within the application lifecycle!*
 
 */
@interface QuestionDraft : NSObject

/*! 
 @name Properties
 */

/**
 An array of [PFObject](http://github.com/parse-community/Parse-SDK-iOS-OSX/blob/master/Parse/PFObject.m ) used to store drafts
 */
@property (strong, nonatomic) NSMutableArray *questionDrafts;

/*! 
 @name Instance Methods
 */

/**
  Delete this draft when a user successfully posts a draft.
 
  @param question The question object that has been saved as draft
 */
- (void)deleteDraft:(PFObject *)question;

/**
 Add this draft when a user dismiss the PostQuestionTableViewChontroller.
 
 @param question The question object that has been saved as draft
 */
- (void)addDraft:(PFObject *)question;

/**
 Get the draft when a user click on a draft.
 
 @param index The index of the draft
 */
- (PFObject *)getDraftAtIndex:(NSInteger)index;

/*! 
 @name Factory Methods
 */

/**
 Create an instance of the `QuestionDraft` class.
 
 @return It returns a QuestionDraft instance.
 */
+(QuestionDraft *)getDrafts;

@end
