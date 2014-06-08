//
//  SearchViewController.m
//  ADITL
//
//  Created by Christopher Gu on 5/17/14.
//  Copyright (c) 2014 Christopher Gu. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchCollectionViewCell.h"
#import "SearchResultsViewController.h"
#import <Parse/Parse.h>

@interface SearchViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSArray *categoriesArray;
@property (strong, nonatomic) NSArray *categoriesKeysArray;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UITextField *locationTextField;
@property (strong, nonatomic) IBOutlet UIView *subcategoryView;
@property (strong, nonatomic) IBOutlet UITableView *subcategoryTableView;
@property (strong, nonatomic) NSArray *searchResultsArray;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation SearchViewController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchResultsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShareCellReuseID"];
    cell.textLabel.text = [self.searchResultsArray objectAtIndex:indexPath.row][@"subcategory"];
    cell.detailTextLabel.text = [self.searchResultsArray objectAtIndex:indexPath.row][@"price"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSDictionary *categoryArt = @{@"Art": [UIImage imageNamed:@"art"]};
    NSDictionary *categoryCooking = @{@"Cooking": [UIImage imageNamed:@"cooking"]};
    self.categoriesArray = @[categoryArt, categoryCooking];
    self.categoriesKeysArray = @[@"Art", @"Cooking"];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.categoriesArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SearchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CategoryCellReuseID" forIndexPath:indexPath];
    cell.categoryLabel.text = [self.categoriesArray[indexPath.row] allKeys][0];
    cell.categoryImageView.image = self.categoriesArray[indexPath.row][cell.categoryLabel.text];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.fromEnthusiast)
    {
        PFQuery *searchResultsQuery = [PFQuery queryWithClassName:@"EnthusiastInterest"];
        [searchResultsQuery whereKey:@"category" equalTo:self.categoriesKeysArray[indexPath.row]];
        //        if (self.locationString.length)
        //        {
        //            [searchResultsQuery whereKey:@"locationCity" equalTo:self.locationString];
        //        }
        [searchResultsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            self.searchResultsArray = objects;
            
            [self.myTableView reloadData];
        }];
    }
    else
    {
        PFQuery *searchResultsQuery = [PFQuery queryWithClassName:@"LeaderInterest"];
        [searchResultsQuery whereKey:@"category" equalTo:self.categoriesKeysArray[indexPath.row]];
        //        if (self.locationString.length)
        //        {
        //            [searchResultsQuery whereKey:@"locationCity" equalTo:self.locationString];
        //        }
        [searchResultsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            self.searchResultsArray = objects;
            
            [self.myTableView reloadData];
        }];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UICollectionViewCell *)cell
{
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    SearchResultsViewController *srvc = segue.destinationViewController;
    NSString *categoryString = [self.categoriesArray[indexPath.row] allKeys][0];
    srvc.locationString = self.locationTextField.text;
    srvc.categoryString = categoryString;
    srvc.fromEnthusiast = self.fromEnthusiast;
}

@end
