//
//  MainViewController.m
//  Training
//
//  Created by Daniela Riesgo on 2/3/16.
//  Copyright © 2016 Daniela Riesgo. All rights reserved.
//

#import "MainViewController.h"
#import "ProductsTableViewController.h"
#import "NotesTableViewController.h"

@interface MainViewController()

@property (weak, nonatomic) IBOutlet UIView * productsTableView;
@property (weak, nonatomic) IBOutlet UIView * notesTableView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint * productsTableViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint * notesTableViewHeight;

@property (strong, nonatomic) ProductsTableViewController * productsTableViewController;
@property (strong, nonatomic) NotesTableViewController * notesTableViewController;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.productsTableViewController = [self createProductsTableViewController];
    [self addChildViewController:self.productsTableViewController];
    [self.productsTableView addSubview:self.productsTableViewController.view];
    self.productsTableViewController.view.frame = self.productsTableView.bounds;
    self.productsTableViewHeight.constant = self.productsTableViewController.tableViewHeight;
    
    self.notesTableViewController = [self createNotesTableViewController];
    [self addChildViewController:self.notesTableViewController];
    [self.notesTableView addSubview:self.notesTableViewController.view];
    self.notesTableViewController.view.frame = self.notesTableView.bounds;
    self.notesTableViewHeight.constant = self.notesTableViewController.tableViewHeight;
}

- (ProductsTableViewController *)createProductsTableViewController {
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"StackViewStoryboard" bundle:[NSBundle mainBundle]];
    return [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass(ProductsTableViewController.class)];
}

- (NotesTableViewController *)createNotesTableViewController {
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"StackViewStoryboard" bundle:[NSBundle mainBundle]];
    return [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass(NotesTableViewController.class)];
}

@end
