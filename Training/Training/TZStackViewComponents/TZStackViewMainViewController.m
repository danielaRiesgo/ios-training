//
//  TZStackViewMainViewController.m
//  Training
//
//  Created by Daniela Riesgo on 2/5/16.
//  Copyright © 2016 Daniela Riesgo. All rights reserved.
//

#import "TZStackViewMainViewController.h"
#import <TZStackView/TZStackView.h>

@interface TZStackViewMainViewController ()

@end

@implementation TZStackViewMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)loadView {
    self.view = [[UIView alloc] initWithFrame: [[UIScreen mainScreen] bounds]];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
//    [label setBackgroundColor: [UIColor greenColor]];
//    label.text = @"Hola";
    
//    UIScrollView *scrollView = [[UIScrollView alloc] init];
//    [self.view addSubview:scrollView];
//    [scrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor];
//    [scrollView.topAnchor constraintEqualToAnchor:self.view.topAnchor];
//    [scrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor];
//    [scrollView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor];
//    scrollView.translatesAutoresizingMaskIntoConstraints = NO;

    
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:contentView];
//    [scrollView addSubview:contentView];
    [contentView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [contentView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [contentView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    [contentView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    TZStackView *stackView = [[TZStackView alloc] initWithArrangedSubviews:@[[self createShopView], [self createProductsView], [self createAddressView], [self createPictureView], [self createClientView], [self createNotesView]]];
    
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.distribution = UIStackViewDistributionEqualSpacing;
    stackView.alignment = UIStackViewAlignmentFill;
    stackView.spacing = 8;
    
    [contentView addSubview:stackView];
    
    [NSLayoutConstraint constraintWithItem:stackView
                        attribute:NSLayoutAttributeLeading
                        relatedBy:NSLayoutRelationEqual
                        toItem:contentView
                        attribute:NSLayoutAttributeLeading
                        multiplier:1.0
                        constant:8.0].active = YES;
    [NSLayoutConstraint constraintWithItem:stackView
                        attribute:NSLayoutAttributeTop
                        relatedBy:NSLayoutRelationEqual
                        toItem:contentView
                        attribute:NSLayoutAttributeTop
                        multiplier:1.0
                        constant:8.0].active = YES;
    [NSLayoutConstraint constraintWithItem:contentView
                        attribute:NSLayoutAttributeTrailing
                        relatedBy:NSLayoutRelationEqual
                        toItem:stackView
                        attribute:NSLayoutAttributeTrailing
                        multiplier:1.0
                        constant:8.0].active = YES;
    [NSLayoutConstraint constraintWithItem:contentView
                        attribute:NSLayoutAttributeBottom
                        relatedBy:NSLayoutRelationEqual
                        toItem:stackView
                        attribute:NSLayoutAttributeBottom
                        multiplier:1.0
                        constant:8.0].active = YES;
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    
}

- (UIView *)createShopView {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    [view.heightAnchor constraintEqualToConstant:100].active = YES;
    return view;
}

- (UIView *)createProductsView {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    [view.heightAnchor constraintEqualToConstant:100].active = YES;
    return view;
}

- (UIView *)createAddressView {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    [view.heightAnchor constraintEqualToConstant:100].active = YES;
    return view;
}

- (UIView *)createPictureView {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    [view.heightAnchor constraintEqualToConstant:100].active = YES;
    return view;
}

- (UIView *)createClientView {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    [view.heightAnchor constraintEqualToConstant:100].active = YES;
    return view;
}

- (UIView *)createNotesView {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    [view.heightAnchor constraintEqualToConstant:100].active = YES;
    return view;
}

@end
