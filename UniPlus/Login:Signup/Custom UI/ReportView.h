//
//  ReportView.h
//  UniPlus
//
//  Created by Jiahe Li on 12/07/2017.
//  Copyright © 2017 Quicky Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "UPObject.h"

@class ReportView;

@protocol ReportViewDelegate <NSObject>

- (void)didTapReportViewAtIndex:(NSIndexPath *)index objectToReport:(UPObject *)object;

@end

@interface ReportView : UIView<UIGestureRecognizerDelegate>

@property (weak, nonatomic) id <ReportViewDelegate>delegate;
@property (strong, nonatomic) NSIndexPath *index;
@property (strong, nonatomic) UPObject *objectToReport;

@end
