//  The MIT License (MIT)
//
//  Copyright (c) 2015 - present Ermal Kaleci
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

@import UIKit;

/*!
 The position of the indicator
 */
typedef NS_ENUM(NSUInteger, IndicatorPosition) {
    IndicatorPositionBottom = 0,
    IndicatorPositionTop
};

typedef NS_ENUM(NSUInteger, IndicatorHorizontalPositionFocus) {
    IndicatorHorizontalPositionFocusMiddle = 0,
    IndicatorHorizontalPositionFocusLeft,
    IndicatorHorizontalPositionFocusRight
};

NS_ASSUME_NONNULL_BEGIN

/**
 A custom segmented control
 */
@interface CarbonTabSwipeSegmentedControl : UISegmentedControl

/*!
 @name Properties
 */

/**
 The height of the indicator
 */
@property(nonatomic) CGFloat indicatorHeight;
/**
 The minimum height of the indicator
 */
@property(nonatomic) CGFloat indicatorMinX;
/**
 The width of the indicator
 */
@property(nonatomic) CGFloat indicatorWidth;
/**
 The position of the indicator
 
 @see IndicatorPosition
 */
@property(nonatomic) IndicatorPosition indicatorPosition;
/**
 The horizontal position focus of the indicator
 
 @see IndicatorHorizontalPositionFocus
 
 @warning This property is not yet implemented!
 */
@property(nonatomic) IndicatorHorizontalPositionFocus indicatorHorizontalPositionFocus;// TODO
/**
 The extra width of each tab
 */
@property(nonatomic) CGFloat tabExtraWidth;
/**
 The normal/unselected tint color of the image on the tab
 */
@property(nonatomic, strong, nullable) UIColor *imageNormalColor;
/**
 The selected tint color of the image on the tab
 */
@property(nonatomic, strong, nullable) UIColor *imageSelectedColor;
/**
 The indicator
 */
@property(nonatomic, strong, nonnull) UIImageView *indicator;
/**
 An array of segments
 */
@property(nonatomic, weak, readonly) NSArray<UIView *> *segments;

/*!
 @name Instance Methods
 */

/**
 A designated initializer which init the segmented control with an array of items
 
 @param items An array of items to be added into the segmented control
 
 @return An instancetype
 */
- (instancetype)initWithItems:(nullable NSArray *)items;

/**
 *  Get selected segmet view
 *
 *  @return Selected segment view
 */
- (nonnull UIView *)getSelectedSegment;

/**
 *  Get MinX of segment frame at index
 *  segment.frame.origin.x
 *
 *  @param index Segment index
 *
 *  @return MinX of segment frame
 */
- (CGFloat)getMinXForSegmentAtIndex:(NSUInteger)index;

/**
 *  Get width of segment frame at index
 *  segment.frame.size.width
 *
 *  @param index Segment index
 *
 *  @return Width of segment frame
 */
- (CGFloat)getWidthForSegmentAtIndex:(NSUInteger)index;

/**
 *  Update indicator position
 *
 *  @param animation Update position with animation
 */
- (void)updateIndicatorWithAnimation:(BOOL)animation;

/**
 *  Get segmented control width. Sum of each segment width
 *
 *  @return SegmentedControl width
 */
- (CGFloat)getWidth;

NS_ASSUME_NONNULL_END

@end
