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

@end

@implementation NotesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

@end
