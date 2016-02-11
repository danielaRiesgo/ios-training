//
//  TZStackProductTableViewCell.m
//  Training
//
//  Created by Daniela Riesgo on 2/11/16.
//  Copyright © 2016 Daniela Riesgo. All rights reserved.
//

#import "TZStackProductTableViewCell.h"

@implementation TZStackProductTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    self.detailLabel.numberOfLines = 0;
    [self.detailLabel.leadingAnchor constraintEqualToAnchor:self.superview.leadingAnchor constant:10].active = YES;
    [self.detailLabel.centerYAnchor constraintEqualToAnchor:self.superview.centerYAnchor].active = YES;
    self.detailLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.quantityLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    self.quantityLabel.textAlignment = NSTextAlignmentRight;
    [self.detailLabel.leadingAnchor constraintEqualToAnchor:self.quantityLabel.trailingAnchor constant:40].active = YES;
    [self.quantityLabel.centerYAnchor constraintEqualToAnchor:self.superview.centerYAnchor].active = YES;
    [self.quantityLabel.widthAnchor constraintEqualToConstant:35].active = YES;
    self.quantityLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    self.priceLabel.textAlignment = NSTextAlignmentRight;
    [self.superview.trailingAnchor constraintEqualToAnchor:self.priceLabel.trailingAnchor constant:10].active = YES;
    [self.priceLabel.centerYAnchor constraintEqualToAnchor:self.superview.centerYAnchor].active = YES;
    [self.priceLabel.widthAnchor constraintEqualToConstant:65].active = YES;
    self.priceLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
