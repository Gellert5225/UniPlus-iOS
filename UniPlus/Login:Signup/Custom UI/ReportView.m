//
//  ReportView.m
//  UniPlus
//
//  Created by Jiahe Li on 12/07/2017.
//  Copyright © 2017 Quicky Studio. All rights reserved.
//

#import "ReportView.h"

@implementation ReportView

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTap)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)didTap {
    [_delegate didTapReportViewAtIndex:_index objectToReport:_objectToReport];
}

- (void)setIndex:(NSIndexPath *)index {
    _index = index;
}

- (void)setObjectToReport:(UPObject *)objectToReport {
    _objectToReport = objectToReport;
}

@end
