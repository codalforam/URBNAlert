//
//  URBNAlertView.m
//  URBNAlertTest
//
//  Created by Ryan Garchinsky on 3/3/15.
//  Copyright (c) 2015 URBN. All rights reserved.
//

#import "URBNAlertView.h"
#import "URBNAlertController.h"
#import "URBNAlertConfig.h"

@interface URBNAlertView()

@property (nonatomic, strong) URBNAlertConfig *alertConfig;
@property (nonatomic, strong) URBNAlertController *alertController;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, copy) NSArray *buttons;

@end

@implementation URBNAlertView

- (instancetype)initWithAlertConfig:(URBNAlertConfig *)config alertController:(URBNAlertController *)controller {
    self = [super init];
    if (self) {
        self.alertConfig = config;
        self.alertController = controller;
        
        self.backgroundColor = self.alertController.alertStyler.backgroundColor ?: [UIColor whiteColor];
        self.layer.cornerRadius = self.alertController.alertStyler.alertCornerRadius.floatValue;
        
        UIView *buttonContainer = [UIView new];
        NSDictionary *views;
        
        if (self.alertConfig.customView) {
            [self addSubview:self.alertConfig.customView];
            views = @{@"customView" : self.alertConfig.customView, @"buttonContainer" : buttonContainer};
        }
        else {
            [self addSubview:self.titleLabel];
            [self addSubview:self.messageLabel];
            
            if (self.alertConfig.hasInput) {
                [self addSubview:self.textField];
                views = NSDictionaryOfVariableBindings(_titleLabel, _messageLabel, buttonContainer, _textField);
            }
            else {
                views = NSDictionaryOfVariableBindings(_titleLabel, _messageLabel, buttonContainer);
            }
        }
        
        // Add some buttons
        NSMutableArray *btns = [NSMutableArray new];
        buttonContainer.translatesAutoresizingMaskIntoConstraints = NO;
        
        __weak typeof(self) weakSelf = self;
        [self.alertConfig.buttonTitles enumerateObjectsUsingBlock:^(NSString *buttonTitle, NSUInteger idx, BOOL *stop) {
            UIButton *btn = [weakSelf createAlertViewButtonWithTitle:buttonTitle atIndex:idx];
            [buttonContainer addSubview:btn];
            [btns addObject:btn];
        }];

        [self addSubview:buttonContainer];
        
        NSDictionary *metrics = @{@"sectionMargin" : @24, @"btnH" : @44, @"lblMargin" : @16, @"btnMargin" : @8};
        
        self.buttons = [btns copy];
        if (self.buttons.count == 1) {
            [buttonContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[btnOne]|" options:0 metrics:metrics views:@{@"btnOne" : self.buttons.firstObject}]];
            [buttonContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[btnOne(btnH)]|" options:0 metrics:metrics views:@{@"btnOne" : self.buttons.firstObject}]];
        }
        else if (self.buttons.count == 2) {
            [buttonContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[btnOne]-[btnTwo(==btnOne)]|" options:0 metrics:nil views:@{@"btnOne" : self.buttons.firstObject, @"btnTwo" : self.buttons[1]}]];
            [buttonContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[btnOne(btnH)]|" options:0 metrics:metrics views:@{@"btnOne" : self.buttons.firstObject}]];
            [buttonContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[btnTwo(btnH)]|" options:0 metrics:metrics views:@{@"btnTwo" : self.buttons[1]}]];
        }
        // TODO: Handle 3+ buttons
        
        if (self.titleLabel && self.messageLabel) {
            for (UILabel *lbl in @[self.titleLabel, self.messageLabel]) {
                lbl.translatesAutoresizingMaskIntoConstraints = NO;
                [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-lblMargin-[lbl]-lblMargin-|" options:0 metrics:metrics views:NSDictionaryOfVariableBindings(lbl)]];
            }
        }
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-btnMargin-[buttonContainer]-btnMargin-|" options:0 metrics:metrics views:views]];
        
        if (self.alertConfig.customView) {
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[customView]-sectionMargin-[buttonContainer]-btnMargin-|" options:0 metrics:metrics views:views]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[customView]-|" options:0 metrics:metrics views:views]];
        }
        else {
            if (self.alertConfig.hasInput) {
                [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-lblMargin-[_textField]-lblMargin-|" options:0 metrics:metrics views:views]];
                
                [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_titleLabel]-sectionMargin-[_messageLabel]-sectionMargin-[_textField]-sectionMargin-[buttonContainer]-btnMargin-|" options:0 metrics:metrics views:views]];
            }
            else {
                [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_titleLabel]-sectionMargin-[_messageLabel]-sectionMargin-[buttonContainer]-btnMargin-|" options:0 metrics:metrics views:views]];
            }
        }
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.messageLabel.preferredMaxLayoutWidth = self.messageLabel.frame.size.width;
    self.titleLabel.preferredMaxLayoutWidth = self.titleLabel.frame.size.width;
}

#pragma mark - Getters
- (UITextField *)textField {
    if (!_textField) {
        self.textField = [UITextField new];
        self.textField.borderStyle = UITextBorderStyleRoundedRect;
        self.textField.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _textField;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.numberOfLines = 2;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        _titleLabel.font = self.alertController.alertStyler.titleFont;
        _titleLabel.textColor = self.alertController.alertStyler.titleColor;
        _titleLabel.text = self.alertConfig.title;
    }
    
    return _titleLabel;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [UILabel new];
        _messageLabel.numberOfLines = 0;
        _messageLabel.font = self.alertController.alertStyler.messageFont;
        _messageLabel.textColor = self.alertController.alertStyler.messageColor;
        _messageLabel.text = self.alertConfig.message;
    }
    
    return _messageLabel;
}

#pragma mark - Methods
- (UIButton *)createAlertViewButtonWithTitle:(NSString *)title atIndex:(NSInteger)index {
    UIColor *bgColor = self.alertController.alertStyler.buttonBackgroundColor;///self.alertController.buttonBackgroundColor ?: [UIColor lightGrayColor];
    UIColor *bgDenialColor = self.alertController.alertStyler.buttonDenialBackgroundColor;//self.alertController.buttonDenialBackgroundColor ?: [UIColor blueColor];
    UIColor *titleColor = self.alertController.alertStyler.buttonTitleColor;//self.alertController.buttonTitleColor ?: [UIColor whiteColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.translatesAutoresizingMaskIntoConstraints = NO;
    btn.backgroundColor = (index == 0 && self.alertConfig.buttonTitles.count > 1) ? bgDenialColor : bgColor;
    btn.titleLabel.font = self.alertController.alertStyler.buttonFont;//self.alertController.buttonFont ?: [UIFont boldSystemFontOfSize:14];
    btn.layer.cornerRadius = self.alertController.alertStyler.buttonCornerRadius.floatValue;
    btn.tag = index;
    
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(buttonTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

#pragma mark - Actions
- (void)buttonTouch:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (self.buttonTouchedBlock) {
        self.buttonTouchedBlock(btn.tag);
    }
}

@end
