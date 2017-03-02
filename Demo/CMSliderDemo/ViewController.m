//
//  ViewController.m
//  CMSliderDemo
//
//  Created by Chuck MA on 03/01/2017.
//  Copyright © 2017 Chuck's Lab. All rights reserved.
//
#import "ViewController.h"
#import <Masonry.h>
#import "CMLineSlider.h"
#import "CMTriangleSlider.h"
#import "CMCircleSlider.h"
#import "Utils.h"
#import "LineSliderDemoViewController.h"
#import "CMToolTipButton.h"
#import "UILabel+CMAdd.h"

@interface ViewController ()
@property (nonatomic, strong) CMLineSlider *lineSlider;
@property (nonatomic, strong) CMTriangleSlider *triangleSlider;
@property (nonatomic, strong) CMCircleSlider *circleSlider;

@property (nonatomic, strong) CMToolTipButton *tipLabelOne;
@property (nonatomic, strong) CMToolTipButton *tipLabelTwo;
@property (nonatomic, strong) CMToolTipButton *tipLabelThree;

@property (nonatomic, strong) UILabel *resultLabelOne;
@property (nonatomic, strong) UILabel *resultLabelTwo;
@property (nonatomic, strong) UILabel *resultLabelThree;

@property (nonatomic, strong) UIButton *startButton;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorFromRGB(0x3BA0DC);
    
    // UI setups
    [self setupLineSlider];
    [self setupTriangleSlider];
    [self setupCircleSlider];
    [self setupTipLabels];
    [self setupResultLabels];
    [self setupStartButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI setups

- (void)setupLineSlider {
    self.lineSlider = [[CMLineSlider alloc] init];
    [self.view addSubview:self.lineSlider];
    [self.lineSlider mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.lineSlider.superview).offset(20);
        make.right.equalTo(self.lineSlider.superview).offset(-20);
        make.top.equalTo(self.lineSlider.superview).offset(30);
        make.height.mas_equalTo(60);
    }];
    
    [self.lineSlider addTarget:self action:@selector(lineSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)setupTriangleSlider {
    self.triangleSlider = [[CMTriangleSlider alloc] init];
    [self.view addSubview:self.triangleSlider];
    [self.triangleSlider mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.triangleSlider.superview).offset(20);
        make.right.equalTo(self.triangleSlider.superview).offset(-20);
        make.top.equalTo(self.lineSlider.mas_bottom).offset(20);
        make.height.mas_equalTo(180);
    }];
    
    self.triangleSlider.innerTriangleColor = UIColorFromRGB(0x3BA0DC);
    
    [self.triangleSlider addTarget:self action:@selector(triangleSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)setupCircleSlider {
    self.circleSlider = [[CMCircleSlider alloc] init];
    [self.view addSubview:self.circleSlider];
    [self.circleSlider mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.circleSlider.superview).offset(20);
        make.right.equalTo(self.circleSlider.superview).offset(-20);
        make.top.equalTo(self.triangleSlider.mas_bottom).offset(30);
        make.height.mas_equalTo(200);
    }];
    
    self.circleSlider.innerCircleColor = UIColorFromRGB(0x3BA0DC);
    
    [self.circleSlider addTarget:self action:@selector(circleSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)setupTipLabels {
    // Tip one
    self.tipLabelOne = [[CMToolTipButton alloc] init];
    [self.view addSubview:self.tipLabelOne];
    [self.tipLabelOne mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(self.tipLabelOne.superview);
        make.top.equalTo(self.lineSlider.mas_bottom).offset(-5.0);
    }];
    self.tipLabelOne.tipColor = [UIColor blackColor];
    self.tipLabelOne.tipTextColor = [UIColor whiteColor];
    self.tipLabelOne.textTitle = @"Drag to select";
    
    // Tip two
    self.tipLabelTwo = [[CMToolTipButton alloc] init];
    [self.view addSubview:self.tipLabelTwo];
    [self.tipLabelTwo mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(self.tipLabelTwo.superview);
        make.top.equalTo(self.triangleSlider.mas_bottom).offset(-5.0);
    }];
    self.tipLabelTwo.tipColor = [UIColor blackColor];
    self.tipLabelTwo.tipTextColor = [UIColor whiteColor];
    self.tipLabelTwo.textTitle = @"Drag to select";
    
    // Tip three
    self.tipLabelThree = [[CMToolTipButton alloc] init];
    [self.view addSubview:self.tipLabelThree];
    [self.tipLabelThree mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(self.tipLabelThree.superview);
        make.top.equalTo(self.circleSlider.mas_bottom).offset(-5.0);
    }];
    self.tipLabelThree.tipColor = [UIColor blackColor];
    self.tipLabelThree.tipTextColor = [UIColor whiteColor];
    self.tipLabelThree.textTitle = @"Drag to select";
}

- (void)setupResultLabels {
    // Result label one
    self.resultLabelOne = [[UILabel alloc] init];
    [self.view addSubview:self.resultLabelOne];
    [self.resultLabelOne mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.lineSlider.mas_bottom);
        make.left.equalTo(self.resultLabelOne.superview).offset(10);
    }];
    self.resultLabelOne.backgroundColor = [UIColor clearColor];
    self.resultLabelOne.textColor = [UIColor whiteColor];
    self.resultLabelOne.font = [UIFont systemFontOfSize:24 weight:UIFontWeightSemibold];

    // Result label two
    self.resultLabelTwo = [[UILabel alloc] init];
    [self.view addSubview:self.resultLabelTwo];
    [self.resultLabelTwo mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.triangleSlider.mas_bottom);
        make.left.equalTo(self.resultLabelTwo.superview).offset(10);
    }];
    self.resultLabelTwo.backgroundColor = [UIColor clearColor];
    self.resultLabelTwo.textColor = [UIColor whiteColor];
    self.resultLabelTwo.font = [UIFont systemFontOfSize:24 weight:UIFontWeightSemibold];

    // Result label three
    self.resultLabelThree = [[UILabel alloc] init];
    [self.view addSubview:self.resultLabelThree];
    [self.resultLabelThree mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.circleSlider.mas_bottom);
        make.left.equalTo(self.resultLabelThree.superview).offset(10);
    }];
    self.resultLabelThree.backgroundColor = [UIColor clearColor];
    self.resultLabelThree.textColor = [UIColor whiteColor];
    self.resultLabelThree.font = [UIFont systemFontOfSize:24 weight:UIFontWeightSemibold];
}

- (void)setupStartButton {
    self.startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.startButton];
    [self.startButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(self.startButton.superview).offset(-10.0);
        make.right.equalTo(self.startButton.superview).offset(-10.0);
    }];
    self.startButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.startButton setTitle:@"START" forState:UIControlStateNormal];
    [self.startButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.startButton setBackgroundColor:[UIColor whiteColor]];
    [self.startButton addTarget:self action:@selector(startButtonTapped) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Actions
- (void)lineSliderValueChanged:(CMSlider *)slider {
    int index = slider.selectedItemIndex;
    NSLog(@"Line slider value changed: -> %@", @(index));
    
    self.tipLabelOne.hidden = YES;
    [self.resultLabelOne fadeOutAndInFromText:self.resultLabelOne.attributedText
                                       toText:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", @(index)]]];
}

- (void)triangleSliderValueChanged:(CMSlider *)slider {
    int index = slider.selectedItemIndex;
    NSLog(@"Triangle slider value changed: -> %@", @(index));
    
    self.tipLabelTwo.hidden = YES;
    [self.resultLabelTwo fadeOutAndInFromText:self.resultLabelTwo.attributedText
                                       toText:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", @(index)]]];
}

- (void)circleSliderValueChanged:(CMSlider *)slider {
    int index = slider.selectedItemIndex;
    NSLog(@"Circle slider value changed: -> %@", @(index));
    
    self.tipLabelThree.hidden = YES;
    [self.resultLabelThree fadeOutAndInFromText:self.resultLabelThree.attributedText
                                         toText:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", @(index)]]];
}

- (void)startButtonTapped {
    [self presentViewController:[[LineSliderDemoViewController alloc] init] animated:YES completion:nil];
}

@end
