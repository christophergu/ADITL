//
//  SearchResultsViewController.m
//  ADITL
//
//  Created by Christopher Gu on 5/19/14.
//  Copyright (c) 2014 Christopher Gu. All rights reserved.
//

#import "SearchResultsViewController.h"
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
        
//        srdvc.selectedPost = self.searchResultsArray[indexPath.row];
    }
}

@end
