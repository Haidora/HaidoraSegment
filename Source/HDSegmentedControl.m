//
//  HDSegmentedControl.m
//  HaidoraSegment
//
//  Created by DaiLingchi on 14-10-17.
//  Copyright (c) 2014年 Haidora. All rights reserved.
//

#import "HDSegmentedControl.h"

@interface HDSegmentedView : UIView

@end

@implementation HDSegmentedView

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGPathRef roundRect = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(rect, -1, -1)
                                                     cornerRadius:self.layer.cornerRadius].CGPath;
    CGContextAddPath(context, roundRect);
    CGContextClip(context);
    //
    //    CGContextSetShadowWithColor(UIGraphicsGetCurrentContext(), CGSizeMake(0, 1), 3,
    //                                UIColor.blackColor.CGColor);
    //    CGContextSetStrokeColorWithColor(context, self.backgroundColor.CGColor);
    //    CGContextStrokePath(context);
}

@end

@interface HDSegmentedControl ()
{
    NSUInteger _selectedSegmentIndex;
}

@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) HDSegmentedView *selectedView;

@end

@implementation HDSegmentedControl

#pragma mark
#pragma mark Init

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self commonInit];
    }
    return self;
}

//- (instancetype)initWithCoder:(NSCoder *)coder
//{
//    self = [super initWithCoder:coder];
//    if (self)
//    {
//        [self commonInit];
//    }
//    return self;
//}

- (id)initWithItems:(NSArray *)items
{
    self = [self init];
    if (self)
    {
        [items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [self insertSegmentWithTitle:obj atIndex:idx animated:NO];
        }];
    }
    return self;
}
//
//- (void)awakeFromNib
//{
//    [self commonInit];
//    _selectedSegmentIndex = super.selectedSegmentIndex;
//}

- (void)commonInit
{
    _selectedSegmentIndex = 0;
    _normalColor = [UIColor whiteColor];
    _items = [NSMutableArray array];
    _borderWidth = 1;

    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _selectedView = [[HDSegmentedView alloc] init];
    _selectedView.backgroundColor = self.tintColor;
    [self addSubview:_selectedView];
}

#pragma mark
#pragma mark Getter

- (UIColor *)borderColor
{
    if (_borderColor == nil)
    {
        _borderColor = self.tintColor;
    }
    return _borderColor;
}

- (UIColor *)normalColor
{
    if (_normalColor == nil)
    {
        _normalColor = [UIColor whiteColor];
    }
    return _normalColor;
}

- (UIColor *)highlightedColor
{
    if (_highlightedColor == nil)
    {
        _highlightedColor = self.tintColor;
    }
    return _highlightedColor;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    CGRect frame = self.frame;
    if (frame.size.height == 0)
    {
        frame.size.height = 30;
    }
    if (frame.size.width == 0)
    {
        frame.size.width = CGRectGetWidth(newSuperview.bounds);
    }
    self.frame = frame;
}

#pragma mark
#pragma mark Render

- (void)layoutSubviews
{
    // setup layer
    self.layer.backgroundColor = self.backgroundColor.CGColor;
    self.layer.borderColor = self.borderColor.CGColor;
    self.layer.borderWidth = self.borderWidth;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = CGRectGetHeight(self.bounds) / 2;
    [self layoutSegments];
}

- (void)layoutSegments
{
    // setup item
    CGFloat itemWidth = (CGRectGetWidth(self.bounds)) / _items.count;
    __block CGFloat posX = 0;
    [_items enumerateObjectsUsingBlock:^(UIView *item, NSUInteger idx, BOOL *stop) {
        item.alpha = 1;
        item.frame = CGRectMake(posX, 0, itemWidth, CGRectGetHeight(self.bounds));

        posX += CGRectGetWidth(item.bounds);
    }];

    UIView *selectedItem = _items[_selectedSegmentIndex];
    CGRect selectedFrame = selectedItem.frame;
    _selectedView.layer.cornerRadius = CGRectGetHeight(selectedFrame) / 2;
    BOOL animated = !_selectedView.hidden && !CGRectEqualToRect(_selectedView.frame, CGRectZero);
    [UIView setAnimationsEnabled:animated];
    [UIView animateWithDuration:animated ? 0.3 : 0
        animations:^{ _selectedView.frame = selectedFrame; }
        completion:^(BOOL finished) {
            for (UILabel *itemLabel in _items)
            {
                if (itemLabel == selectedItem)
                {
                    itemLabel.textColor = self.normalColor;
                }
                else
                {
                    itemLabel.textColor = self.highlightedColor;
                }
            }
        }];
    [UIView setAnimationsEnabled:YES];
}

#pragma mark
#pragma mark Items

- (void)insertSegmentWithImage:(UIImage *)image atIndex:(NSUInteger)segment animated:(BOOL)animated
{
    NSAssert(NO,
             @"insertSegmentWithImage:atIndex:animated: is not supported on HDSegmentedControl");
}

- (UIImage *)imageForSegmentAtIndex:(NSUInteger)segment
{
    NSAssert(NO, @"imageForSegmentAtIndex: is not supported on HDSegmentedControl");
    return nil;
}

- (void)setImage:(UIImage *)image forSegmentAtIndex:(NSUInteger)segment
{
    NSAssert(NO, @"setImage:forSegmentAtIndex: is not supported on HDSegmentedControl");
}

- (void)setTitle:(NSString *)title forSegmentAtIndex:(NSUInteger)segment
{
    NSUInteger index = MAX(MIN(segment, self.numberOfSegments - 1), 0);
    UILabel *segmentView = _items[index];
    segmentView.text = title;
    [self setNeedsLayout];
}

- (NSString *)titleForSegmentAtIndex:(NSUInteger)segment
{
    NSUInteger index = MAX(MIN(segment, self.numberOfSegments - 1), 0);
    UILabel *segmentView = _items[index];
    return segmentView.text;
}

- (void)insertSegmentWithTitle:(NSString *)title atIndex:(NSUInteger)segment animated:(BOOL)animated
{
    UILabel *segmentView = [[UILabel alloc] init];
    segmentView.alpha = 0;
    segmentView.text = title;
    segmentView.textAlignment = NSTextAlignmentCenter;
    segmentView.textColor = _normalColor;
    segmentView.font = [UIFont systemFontOfSize:14];
    segmentView.backgroundColor = [UIColor clearColor];
    segmentView.userInteractionEnabled = YES;
    [segmentView addGestureRecognizer:[[UITapGestureRecognizer alloc]
                                          initWithTarget:self
                                                  action:@selector(segmentSelected:)]];
    NSUInteger index = MAX(MIN(segment, self.numberOfSegments), 0);
    if (index < _items.count)
    {
        segmentView.center = ((UIView *)_items[index]).center;
        [self insertSubview:segmentView belowSubview:_items[index]];
        [_items insertObject:segmentView atIndex:index];
    }
    else
    {
        segmentView.center = self.center;
        [self addSubview:segmentView];
        [_items addObject:segmentView];
    }
    if (_selectedSegmentIndex > index)
    {
        _selectedSegmentIndex++;
    }
    if (animated)
    {
        [UIView animateWithDuration:0.4 animations:^{ [self layoutSubviews]; }];
    }
    else
    {
        [self setNeedsLayout];
    }
}

- (void)removeSegmentAtIndex:(NSUInteger)segment animated:(BOOL)animated
{
    if (_items.count == 0)
        return;
    NSUInteger index = MAX(MIN(segment, self.numberOfSegments - 1), 0);
    UIView *segmentView = _items[index];

    if (self.selectedSegmentIndex >= index)
    {
        self.selectedSegmentIndex--;
    }

    if (animated)
    {
        [_items removeObject:segmentView];
        [UIView animateWithDuration:.4
            animations:^{
                segmentView.alpha = 0;
                [self layoutSubviews];
            }
            completion:^(BOOL finished) { [segmentView removeFromSuperview]; }];
    }
    else
    {
        [segmentView removeFromSuperview];
        [_items removeObject:segmentView];
        [self setNeedsLayout];
    }
}

- (void)removeAllSegments
{
    [_items makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_items removeAllObjects];
    [self setNeedsLayout];
}

- (NSUInteger)numberOfSegments
{
    return _items.count;
}

#pragma mark
#pragma mark Action

- (void)setSelectedSegmentIndex:(NSInteger)selectedSegmentIndex
{
    if (_selectedSegmentIndex != selectedSegmentIndex)
    {
        NSParameterAssert(selectedSegmentIndex < _items.count);
        _selectedSegmentIndex = selectedSegmentIndex;
        [self setNeedsLayout];
    }
}

- (NSInteger)selectedSegmentIndex
{
    return _selectedSegmentIndex;
}

- (void)segmentSelected:(UITapGestureRecognizer *)gesture
{
    NSUInteger index = [_items indexOfObject:gesture.view];
    if (index != NSNotFound)
    {
        if (_selectedSegmentIndex != index)
        {
            _selectedSegmentIndex = index;
            [self setNeedsLayout];
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        }
    }
}

@end
