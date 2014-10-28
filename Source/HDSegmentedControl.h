//
//  HDSegmentedControl.h
//  HaidoraSegment
//
//  Created by DaiLingchi on 14-10-17.
//  Copyright (c) 2014年 Haidora. All rights reserved.
//

#import <UIKit/UIKit.h>

//@import QuartzCore.QuartzCore;

@interface HDSegmentedControl : UISegmentedControl

/**
 *  Default is White
 */
@property (nonatomic, strong) UIColor *normalColor;
/**
 *  Default is TintColor
 */
@property (nonatomic, strong) UIColor *highlightedColor;

/**
 *  Default is TintColor
 */
@property (nonatomic, strong) UIColor *borderColor;
/**
 *  Default is 1
 */
@property (nonatomic, assign) CGFloat borderWidth;

@end
