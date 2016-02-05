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
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [label setBackgroundColor: [UIColor greenColor]];
    label.text = @"Hola";
    
    UIView *view1 = [[UIView alloc] init];
    view1.backgroundColor = [UIColor blueColor];
    [view1.heightAnchor constraintEqualToConstant:100].active = true;
    [view1.widthAnchor constraintEqualToConstant:120].active = true;
    
    TZStackView * stackView = [[TZStackView alloc] initWithArrangedSubviews:@[label]]; //@[label]];
    
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.distribution = UIStackViewDistributionEqualSpacing;
    stackView.alignment = UIStackViewAlignmentCenter;
    stackView.spacing = 30;
    [stackView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor];
    [stackView.topAnchor constraintEqualToAnchor:self.view.topAnchor];
    stackView.translatesAutoresizingMaskIntoConstraints = false;
    
    [self.view addSubview:stackView];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
