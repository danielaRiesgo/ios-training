//
//  TZStackProductsTableViewController.m
//  Training
//
//  Created by Daniela Riesgo on 2/11/16.
//  Copyright © 2016 Daniela Riesgo. All rights reserved.
//


#import "TZStackProductsTableViewController.h"
#import "TZStackProductTableViewCell.h"
#import "Product.h"

@interface TZStackProductsTableViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView * tableView;
@property (strong, nonatomic) NSArray * products;

@end

@implementation TZStackProductsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Product * p1 = [[Product alloc] initWithDetail:@"Detalle del primer item de producto con nombre largo, para ver si se hace multilinea" quantity:@5 price:@24];
    Product * p2 = [[Product alloc] initWithDetail:@"Detalle 2" quantity:@7 price:@2];
    Product * p3 = [[Product alloc] initWithDetail:@"Item De testeo - Por favor no ofertar" quantity:@1 price:@125];
    self.products = @[p1, p2, p3];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview: self.tableView];
    [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    [self.tableView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 40;
    
    
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.products.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"ProductTableViewCell";
    TZStackProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    Product* p = [self.products objectAtIndex:indexPath.row];
    cell.detailLabel.text = p.detail;
    cell.quantityLabel.text = [NSString stringWithFormat:@"%@", p.quantity];
    cell.priceLabel.text = [NSString stringWithFormat:@"$%@", p.price];
    return cell;
}

- (NSUInteger)tableViewHeight {
    return self.tableView.contentSize.height;
}

@end
