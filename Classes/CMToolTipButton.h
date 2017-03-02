//
//  CMToolTipButton.h
//  CMSlider
//
//  Created by Chuck MA on 02/28/2017.
//  Copyright © 2017 Chuck's Lab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMToolTipButton : UIButton

@property (nonatomic, assign) double pointHeight;
@property (nonatomic, assign) double pointWidth;
@property (nonatomic, assign) double cornerRadius;

@property (nonatomic, strong) UIColor *tipColor;
@property (nonatomic, strong) UIColor *tipTextColor;

@property (nonatomic, copy) NSString *textTitle;

@property (nonatomic, assign) double fontSize;

@end
