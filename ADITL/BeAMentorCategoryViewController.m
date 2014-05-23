//
//  BeAMentorCategoryViewController.m
//  ADITL
//
//  Created by Christopher Gu on 5/21/14.
//  Copyright (c) 2014 Christopher Gu. All rights reserved.
//

#import "BeAMentorCategoryViewController.h"
#import "BeAMentorViewController.h"
#import "BeAMentorCategoryTableViewCell.h"

@interface BeAMentorCategoryViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *categoriesArray;


@end

@implementation BeAMentorCategoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSDictionary *categoryArt = @{@"Art": [UIImage imageNamed:@"art"]};
    NSDictionary *categoryCooking = @{@"Cooking": [UIImage imageNamed:@"cooking"]};
    self.categoriesArray = @[categoryArt, categoryCooking];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.categoriesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BeAMentorCategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CategoryCellReuseID"];
    
    cell.categoryTextLabel.text = [self.categoriesArray[indexPath.row] allKeys][0];
    cell.categoryImageView.image = self.categoriesArray[indexPath.row][cell.categoryTextLabel.text];
    cell.categoryImageView.contentMode = UIViewContentModeScaleAspectFill;
    cell.categoryImageView.clipsToBounds = YES;
    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UITableViewCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    BeAMentorViewController *bamvc = segue.destinationViewController;
    NSString *categoryString = [self.categoriesArray[indexPath.row] allKeys][0];
    bamvc.categoryString = categoryString;
}

@end
