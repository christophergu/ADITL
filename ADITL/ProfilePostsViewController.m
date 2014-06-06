//
//  ProfilePostsViewController.m
//  ADITL
//
//  Created by Christopher Gu on 5/28/14.
//  Copyright (c) 2014 Christopher Gu. All rights reserved.
//

#import "ProfilePostsViewController.h"
#import "SearchResultsDetailViewController.h"
#import <Parse/Parse.h>

@interface ProfilePostsViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) PFObject *selectedPost;

@end

@implementation ProfilePostsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.postGroupsArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *key = [self.postGroupsArray objectAtIndex:section];
    
    NSArray *category = [self.postDictionary objectForKey:key];
    
    return category.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = [self.postGroupsArray objectAtIndex:indexPath.section];
    
    NSArray *category = [self.postDictionary objectForKey:key];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostReusableCellID"];
    cell.textLabel.text = [category objectAtIndex:indexPath.row][@"expertise"];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *groupName = [self.postGroupsArray objectAtIndex:section];
    return groupName;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = [self.postGroupsArray objectAtIndex:indexPath.section];
    NSArray *category = [self.postDictionary objectForKey:key];

    self.selectedPost = category[indexPath.row];
    
    [self performSegueWithIdentifier:@"PostToPostSegue" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    SearchResultsDetailViewController *srdvc = segue.destinationViewController;
    srdvc.selectedPost = self.selectedPost;
}

@end
