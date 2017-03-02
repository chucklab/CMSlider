//
//  CMSlider.m
//  CMSlider
//
//  Created by Chuck MA on 02/24/2017.
//  Copyright © 2017 Chuck's Lab. All rights reserved.
//

#import "CMSlider.h"

#pragma mark - Util macros
#define UIColorFromRGB(rgbValue) \
        [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                        green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
                         blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
                        alpha:1.0]

IB_DESIGNABLE
@implementation CMSlider

#pragma mark - Initials
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self == nil) {
        return nil;
    }
    
    // Line
    self.lineWidth = 2.0;
    self.lineColor = UIColorFromRGB(0x9dc9e8);
    
    // Critical points
    self.criticalPoints = 4;
    
    // Toggle
    self.togglePosition = 0.5;
    self.toggleWidth = 40.0;
    self.toggleHeight = 40.0;
    self.toggleRadius = 20.0;
    self.toggleColor = UIColorFromRGB(0xffffff);
    
    // Strips
    self.stripDistance = 7.0;
    self.stripColor = UIColorFromRGB(0xaaaaaa);
    
    // Background layer
    self.layerBackgroundColor = UIColorFromRGB(0x76b2df);
    
    // Indexes
    self.selectedItemIndex = -1;
    
    // Initial values
    self.backgroundColor = [UIColor clearColor]; /* UIColorFromRGB(0x589fd7) */
    
    return self;
}

- (instancetype)init {
    self = [self initWithFrame:CGRectMake(0, 0, 1, 1)];
    if (self == nil) {
        return nil;
    }
    
    return self;
}

#pragma mark - Setters & Getters
// Line
- (void)setLineWidth:(double)lineWidth {
    _lineWidth = lineWidth;
    [self setNeedsDisplay];
}

- (void)setLineColor:(UIColor *)lineColor {
    _lineColor = lineColor;
    [self setNeedsDisplay];
}

// Critical points
- (void)setCriticalPoints:(int)criticalPoints {
    _criticalPoints = criticalPoints;
    [self setNeedsDisplay];
}

// Toggle
- (void)setTogglePosition:(double)togglePosition {
    if (togglePosition > 1.0 - 0.0000001) {
        togglePosition = 1.0;
    }
    if (togglePosition < 0.0 + 0.0000001) {
        togglePosition = 0.0;
    }
    
    _togglePosition = togglePosition;
    [self setNeedsDisplay];
}

- (void)setToggleWidth:(double)toggleWidth {
    _toggleWidth = toggleWidth;
    [self setNeedsDisplay];
}

- (void)setToggleHeight:(double)toggleHeight {
    _toggleHeight = toggleHeight;
    [self setNeedsDisplay];
}

- (void)setToggleRadius:(double)toggleRadius {
    _toggleRadius = toggleRadius;
    [self setNeedsDisplay];
}

- (void)setToggleColor:(UIColor *)toggleColor {
    _toggleColor = toggleColor;
    [self setNeedsDisplay];
}

// Strips
- (void)setStripDistance:(double)stripDistance {
    _stripDistance = stripDistance;
    [self setNeedsDisplay];
}

- (void)setStripColor:(UIColor *)stripColor {
    _stripColor = stripColor;
    [self setNeedsDisplay];
}

// Background layer
- (void)setLayerBackgroundColor:(UIColor *)layerBackgroundColor {
    _layerBackgroundColor = layerBackgroundColor;
    [self setNeedsDisplay];
}

// Indexes
- (void)setSelectedItemIndex:(int)selectedItemIndex {
    if (selectedItemIndex < 0 || selectedItemIndex >= self.criticalPoints) {
        return;
    }
    
    _selectedItemIndex = selectedItemIndex;
    
    self.togglePosition = selectedItemIndex * (100.0 / (self.criticalPoints - 1)) / 100;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

@end
