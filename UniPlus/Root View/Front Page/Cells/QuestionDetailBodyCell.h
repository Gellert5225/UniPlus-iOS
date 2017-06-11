//
//  QuestionDetailBodyCell.h
//  UniPlus
//
//  Created by Jiahe Li on 20/10/2016.
//  Copyright © 2016 Quicky Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Question.h"

@interface QuestionDetailBodyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextView *bodyTextView;

@property (strong, nonatomic) Question *question;

@end
