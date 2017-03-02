//
//  CMClosestPoint.h
//  CMSlider
//
//  Created by Chuck MA on 02/27/2017.
//  Copyright © 2017 Chuck's Lab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMClosestPoint : NSObject

@property (nonatomic, assign) CGPoint closestPoint;
@property (nonatomic, assign) double distance;

+ (CMClosestPoint *)closestPointAtLineSegmentWithPointOne:(CGPoint)pt1 pointTwo:(CGPoint)pt2 fromPoint:(CGPoint)pt;

@end
