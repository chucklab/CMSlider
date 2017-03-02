//
//  LineSliderDemoViewController.m
//  CMSliderDemo
//
//  Created by Chuck MA on 02/28/2017.
//  Copyright © 2017 Chuck's Lab. All rights reserved.
//

#import "LineSliderDemoViewController.h"
#import "CMLineSlider.h"
#import "Utils.h"
#import "CMToolTipButton.h"
#import "UILabel+CMAdd.h"
#import <Masonry.h>

@interface LineSliderDemoViewController ()
@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) CMLineSlider *lineSlider;
@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UIImageView *rightImageView;
@property (nonatomic, strong) CMToolTipButton *tipLabel;
@property (nonatomic, strong) UILabel *bottomLabel;
@property (nonatomic, strong) UIButton *nextButton;

@property (nonatomic, strong) NSArray *options;
@property (nonatomic, copy) NSAttributedString *selectedOption;
@end

@implementation LineSliderDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorFromRGB(0x3BA0DC);
    
    // Data
    self.options = @[
                     [[NSMutableAttributedString alloc] initWithString:@"Thin"],
                     [[NSMutableAttributedString alloc] initWithString:@"Well proportioned"],
                     [[NSMutableAttributedString alloc] initWithString:@"Strong build"],
                     [[NSMutableAttributedString alloc] initWithString:@"Too fat"],
                     ];
    
    // UI Setups
    [self setupTopLabel];
    [self setupLeftAndRightImageView];
    [self setupLineSlider];
    [self setupTipLabel];
    [self setupBottomLabel];
    [self setupNextButton];
}

#pragma mark - UI Setups
- (void)setupTopLabel {
    self.topLabel = [[UILabel alloc] init];
    [self.view addSubview:self.topLabel];
    [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.topLabel.superview).offset(60);
        make.left.equalTo(self.topLabel.superview).offset(60);
        make.right.equalTo(self.topLabel.superview).offset(-60);
    }];
    self.topLabel.backgroundColor = [UIColor clearColor];
    self.topLabel.textColor = [UIColor whiteColor];
    self.topLabel.font = [UIFont systemFontOfSize:24 weight:UIFontWeightSemibold];
    self.topLabel.text = @"What do you think your figure belongs to?";
    self.topLabel.numberOfLines = 0;
}

- (void)setupLeftAndRightImageView {
    self.leftImageView = [[UIImageView alloc] init];
    [self.view addSubview:self.leftImageView];
    [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(self.leftImageView.superview);
        make.height.equalTo(@(60));
        make.width.equalTo(@(30));
        make.left.equalTo(self.leftImageView.superview);
    }];
    self.leftImageView.image = [UIImage imageNamed:@"img_thin"];
    self.leftImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.rightImageView = [[UIImageView alloc] init];
    [self.view addSubview:self.rightImageView];
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(self.rightImageView.superview);
        make.height.equalTo(@(60));
        make.width.equalTo(@(30));
        make.right.equalTo(self.rightImageView.superview);
    }];
    self.rightImageView.image = [UIImage imageNamed:@"img_fat"];
    self.rightImageView.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)setupLineSlider {
    self.lineSlider = [[CMLineSlider alloc] init];
    [self.view addSubview:self.lineSlider];
    [self.lineSlider mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.leftImageView.mas_right);
        make.right.equalTo(self.rightImageView.mas_left);
        make.centerY.equalTo(self.lineSlider.superview);
        make.height.equalTo(@(60));
    }];
    
    [self.lineSlider addTarget:self action:@selector(lineSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)setupTipLabel {
    self.tipLabel = [[CMToolTipButton alloc] init];
    [self.view addSubview:self.tipLabel];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(self.tipLabel.superview);
        make.top.equalTo(self.lineSlider.mas_bottom).offset(5.0);
    }];

    self.tipLabel.tipColor = [UIColor blackColor];
    self.tipLabel.tipTextColor = [UIColor whiteColor];
    self.tipLabel.textTitle = @"Drag to select";
}

- (void)setupBottomLabel {
    self.bottomLabel = [[UILabel alloc] init];
    [self.view addSubview:self.bottomLabel];
    [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.tipLabel.mas_bottom).offset(10);
        make.centerX.equalTo(self.bottomLabel.superview);
        make.width.mas_lessThanOrEqualTo(self.bottomLabel.superview).offset(-120);
    }];
    self.bottomLabel.backgroundColor = [UIColor clearColor];
    self.bottomLabel.textColor = [UIColor whiteColor];
    self.bottomLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightLight];
    self.bottomLabel.text = @"";
    self.bottomLabel.textAlignment = NSTextAlignmentCenter;
    self.bottomLabel.numberOfLines = 0;
    self.bottomLabel.hidden = YES;
}

- (void)setupNextButton {
    self.nextButton = [[UIButton alloc] init];
    [self.view addSubview:self.nextButton];
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(self.nextButton.superview).offset(-25);
        make.left.equalTo(self.nextButton.superview).offset(25);
        make.right.equalTo(self.nextButton.superview).offset(-25);
        make.height.equalTo(@(57));
    }];
    self.nextButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.nextButton setTitle:@"NEXT" forState:UIControlStateNormal];
    [self.nextButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.nextButton setBackgroundColor:[UIColor whiteColor]];
    [self.nextButton addTarget:self action:@selector(nextButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    self.nextButton.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setters & Getters
- (void)setSelectedOption:(NSAttributedString *)selectedOption {
    self.bottomLabel.hidden = NO;
    [self.bottomLabel fadeOutAndInFromText:_selectedOption toText:selectedOption];
    _selectedOption = selectedOption;
}

#pragma mark - Actions
- (void)lineSliderValueChanged:(CMSlider *)slider {
    int index = slider.selectedItemIndex;
    NSLog(@"Line slider value changed: -> %@", @(index));
    
    self.tipLabel.hidden = YES;
    self.selectedOption = self.options[index];
    self.nextButton.hidden = NO;
}

- (void)nextButtonTapped {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
