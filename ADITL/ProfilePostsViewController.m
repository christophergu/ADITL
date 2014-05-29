//
//  ProfilePostsViewController.m
//  ADITL
//
//  Created by Christopher Gu on 5/28/14.
//  Copyright (c) 2014 Christopher Gu. All rights reserved.
//

#import "ProfilePostsViewController.h"

@interface ProfilePostsViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation ProfilePostsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.postArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostReusableCellID"];
    cell.textLabel.text = self.postArray[indexPath.row][@"expertise"];
    return cell;
}

@end
