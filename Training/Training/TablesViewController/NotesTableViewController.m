//
//  NotesTableViewController.m
//  Training
//
//  Created by Daniela Riesgo on 2/3/16.
//  Copyright © 2016 Daniela Riesgo. All rights reserved.
//

#import "NotesTableViewController.h"
#import "NotesTableViewCell.h"
#import "Note.h"

@interface NotesTableViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray * notes;

@property (weak, nonatomic) IBOutlet UITableView * tableView;

@end

@implementation NotesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Note* n = [[Note alloc] initWithTitle:@"Loren ipsm lorel, commenset	in abem simet" detail:@"Esta nota es corta"];
    self.notes = @[n];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.notes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"NotesTableViewCell";
    NotesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    Note* note = [self.notes objectAtIndex:indexPath.row];
    cell.titleLabel.text = note.title;
    return cell;
}

- (NSUInteger)tableViewHeight {
    return self.tableView.contentSize.height;
}

@end
