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
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.scrollEnabled = YES;
    scrollView.userInteractionEnabled=YES;
    [self.view addSubview:scrollView];
    scrollView.contentSize = CGSizeMake(414, 1000); //

    [scrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [scrollView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [scrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    [scrollView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:contentView];
    [contentView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [contentView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [contentView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    [contentView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
    [contentView.leadingAnchor constraintEqualToAnchor:scrollView.leadingAnchor].active = YES;
    [contentView.topAnchor constraintEqualToAnchor:scrollView.topAnchor].active = YES;
    [contentView.trailingAnchor constraintEqualToAnchor:scrollView.trailingAnchor].active = YES;
    [contentView.bottomAnchor constraintEqualToAnchor:scrollView.bottomAnchor].active = YES;
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    TZStackView *stackView = [[TZStackView alloc] initWithArrangedSubviews:@[[self createShopView], [self createProductsView], [self createAddressView], [self createPictureView], [self createClientView], [self createNotesView]]];
    
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.distribution = UIStackViewDistributionEqualSpacing;
    stackView.alignment = UIStackViewAlignmentFill;
    stackView.spacing = 8; //30;
    
    [contentView addSubview:stackView];
    [stackView.leadingAnchor constraintEqualToAnchor:contentView.leadingAnchor constant:8].active = YES;
    [stackView.topAnchor constraintEqualToAnchor:contentView.topAnchor constant:8].active = YES;
    [contentView.trailingAnchor constraintEqualToAnchor:stackView.trailingAnchor constant:8].active = YES;
    [contentView.bottomAnchor constraintEqualToAnchor:stackView.bottomAnchor constant:8].active = YES;
    stackView.translatesAutoresizingMaskIntoConstraints = NO;

}

- (UIView *)createShopView {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    [view.heightAnchor constraintEqualToConstant:100].active = YES;
    
    UILabel *labelName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [labelName setBackgroundColor: [UIColor clearColor]];
    labelName.text = @"A name";
    [labelName setFont:[UIFont systemFontOfSize:27]];
    [view addSubview:labelName];
    [labelName.leadingAnchor constraintEqualToAnchor:view.leadingAnchor constant:15].active = YES;
    [labelName.topAnchor constraintEqualToAnchor:view.topAnchor constant:15].active = YES;
    labelName.translatesAutoresizingMaskIntoConstraints = NO;
    
    UILabel *labelVia = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [labelVia setBackgroundColor: [UIColor clearColor]];
    labelVia.text = @"via: MercadoShops";
    [labelVia setFont:[UIFont systemFontOfSize:14]];
    [view addSubview:labelVia];
    [labelVia.leadingAnchor constraintEqualToAnchor:view.leadingAnchor constant:15].active = YES;
    [labelVia.topAnchor constraintEqualToAnchor:labelName.bottomAnchor constant:10].active = YES;
    labelVia.translatesAutoresizingMaskIntoConstraints = NO;
    
    UILabel *timeDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [timeDateLabel setBackgroundColor: [UIColor clearColor]];
    timeDateLabel.text = @"3 nov 3:42PM";
    timeDateLabel.textAlignment = NSTextAlignmentRight;
    timeDateLabel.numberOfLines = 2;
    [timeDateLabel setFont:[UIFont systemFontOfSize:15]];
    [view addSubview:timeDateLabel];
    [timeDateLabel.widthAnchor constraintEqualToConstant:65].active = YES;
    [timeDateLabel.centerYAnchor constraintEqualToAnchor:view.centerYAnchor].active = YES;
    [view.trailingAnchor constraintEqualToAnchor:timeDateLabel.trailingAnchor constant:15].active = YES;
    timeDateLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIImageView *mailingImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sales_mailing"]];
    [view addSubview:mailingImage];
    [mailingImage.widthAnchor constraintEqualToConstant:50].active = YES;
    [mailingImage.heightAnchor constraintEqualToConstant:50].active = YES;
    [mailingImage.centerYAnchor constraintEqualToAnchor:view.centerYAnchor].active = YES;
    [timeDateLabel.leadingAnchor constraintEqualToAnchor:mailingImage.trailingAnchor constant:10].active = YES;
    mailingImage.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIImageView *callingImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sales_calling"]];
    [view addSubview:callingImage];
    [callingImage.widthAnchor constraintEqualToConstant:50].active = YES;
    [callingImage.heightAnchor constraintEqualToConstant:50].active = YES;
    [callingImage.centerYAnchor constraintEqualToAnchor:view.centerYAnchor].active = YES;
    [mailingImage.leadingAnchor constraintEqualToAnchor:callingImage.trailingAnchor constant:10].active = YES;
    callingImage.translatesAutoresizingMaskIntoConstraints = NO;
    
    
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
