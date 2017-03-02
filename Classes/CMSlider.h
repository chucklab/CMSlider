//
//  CMSlider.h
//  CMSlider
//
//  Created by Chuck MA on 02/24/2017.
//  Copyright © 2017 Chuck's Lab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMSlider : UIControl

// Line
@property (nonatomic, assign) double lineWidth;
@property (nonatomic, strong) UIColor *lineColor;

// Critical points
@property (nonatomic, assign) int criticalPoints;

// Toggle
@property (nonatomic, assign) double togglePosition;
@property (nonatomic, assign) double toggleWidth;
@property (nonatomic, assign) double toggleHeight;
@property (nonatomic, assign) double toggleRadius;
@property (nonatomic, strong) UIColor *toggleColor;

// Strips
@property (nonatomic, assign) double stripDistance;
@property (nonatomic, strong) UIColor *stripColor;

// Background layer
@property (nonatomic, strong) UIColor *layerBackgroundColor;

// Indexes
@property (nonatomic, assign) int selectedItemIndex;

@end
