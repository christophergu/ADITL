//
//  BeAMentorCategoryViewController.m
//  ADITL
//
//  Created by Christopher Gu on 5/21/14.
//  Copyright (c) 2014 Christopher Gu. All rights reserved.
//

#import "BeAMentorCategoryViewController.h"

@interface BeAMentorCategoryViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *categoriesArray;

@end

@implementation BeAMentorCategoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.categoriesArray = @[@"Art",@"Cooking"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.categoriesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CategoryCellReuseID"];
    cell.textLabel.text = self.categoriesArray[indexPath.row];
    return cell;
}

@end
