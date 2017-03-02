//
//  UILabel+CMAdd.h
//  CMSlider
//
//  Created by Chuck MA on 03/02/2017.
//  Copyright © 2017 Chuck's Lab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (CMAdd)

// Fade out and in with different text
- (void)fadeOutAndInFromText:(NSAttributedString *)fromText toText:(NSAttributedString *)toText;

@end
