//
//  SearchResultsViewController.m
//  ADITL
//
//  Created by Christopher Gu on 5/19/14.
//  Copyright (c) 2014 Christopher Gu. All rights reserved.
//

#import "SearchResultsViewController.h"
#import "SearchResultsDetailViewController.h"
#import <Parse/Parse.h>

@interface SearchResultsViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) NSArray *searchResultsArray;

@end

@implementation SearchResultsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    PFQuery *searchResultsQuery = [PFQuery queryWithClassName:@"MentorPost"];
    [searchResultsQuery whereKey:@"category" equalTo:self.categoryString];
    if (self.locationString.length)
    {
        [searchResultsQuery whereKey:@"locationCity" equalTo:self.locationString];
    }
    [searchResultsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.searchResultsArray = objects;

        [self.myTableView reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchResultsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchResultsCellReuseID"];
    cell.textLabel.text = self.searchResultsArray[indexPath.row][@"expertise"];
    
    return cell;
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UITableViewCell *)cell
{
    if ([segue.identifier isEqualToString:@"SearchResultsDetailSegue"])
    {
        NSIndexPath *indexPath = [self.myTableView indexPathForCell:cell];
        SearchResultsDetailViewController *srdvc = segue.destinationViewController;
        
        srdvc.selectedPost = self.searchResultsArray[indexPath.row];
    }
}

@end
