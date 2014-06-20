//
//  SearchViewController.m
//  ADITL
//
//  Created by Christopher Gu on 5/17/14.
//  Copyright (c) 2014 Christopher Gu. All rights reserved.
//

#import "SearchViewController.h"
#import "EnthusiastProfileViewController.h"
#import "ProfileViewController.h"
#import "SearchCollectionViewCell.h"
#import "SearchTableViewCell.h"
#import <Parse/Parse.h>

#define allTrim( object ) [object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]

@interface SearchViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSArray *categoriesArray;
@property (strong, nonatomic) NSArray *categoriesKeysArray;
@property (strong, nonatomic) NSArray *searchResultsArray;
@property (strong, nonatomic) NSMutableArray *userArray;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UITextField *locationTextField;
@property (strong, nonatomic) IBOutlet UIView *subcategoryView;
@property (strong, nonatomic) IBOutlet UITableView *subcategoryTableView;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) PFUser *currentUser;
@property (strong, nonatomic) PFUser *chosenUser;
@property (strong, nonatomic) CLLocation *userLocation;

@end

@implementation SearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSDictionary *categoryArt = @{@"Art": [UIImage imageNamed:@"art"]};
    NSDictionary *categoryCooking = @{@"Cooking": [UIImage imageNamed:@"cooking"]};
    self.categoriesArray = @[categoryArt, categoryCooking];
    self.categoriesKeysArray = @[@"Art", @"Cooking"];
    
    self.currentUser = [PFUser currentUser];
    
    self.userLocation = [[CLLocation alloc] initWithLatitude:[self.currentUser[@"latitude"] doubleValue] longitude:[self.currentUser[@"longitude"] doubleValue]];
}

#pragma mark - collection view delegate methods

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
    self.userArray = [NSMutableArray new];
    
    int radius = [self.locationTextField.text intValue];
    
    if (!(allTrim(self.locationTextField.text).length == 0))
    {
        [self searchCategoryHelperWithRadius:radius andIndexPath:indexPath];
    }
    else
    {
        [self searchCategoryHelperWithRadius:50 andIndexPath:indexPath];
    }
}

- (void) searchCategoryHelperWithRadius:(int)radius andIndexPath:(NSIndexPath *)indexPath
{
    if (self.fromEnthusiast)
    {
        PFQuery *searchResultsQuery = [PFQuery queryWithClassName:@"EnthusiastInterest"];
        [searchResultsQuery includeKey:@"enthusiastPointer"];
        [searchResultsQuery whereKey:@"category" equalTo:self.categoriesKeysArray[indexPath.row]];
        
        [searchResultsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            self.searchResultsArray = objects;
            
            for (PFObject *enthusiastInterest in self.searchResultsArray)
            {
                CLLocation *potentialUserLocation = [[CLLocation alloc] initWithLatitude:[enthusiastInterest[@"enthusiastPointer"][@"latitude"] doubleValue] longitude:[enthusiastInterest[@"enthusiastPointer"][@"longitude"] doubleValue]];
                
                float distance = [self.userLocation distanceFromLocation:potentialUserLocation]*0.000621371;
                
                if (distance <= radius) {
                    [self.userArray addObject:enthusiastInterest[@"enthusiastPointer"]];
                }
            }
            
            [self.myTableView reloadData];
        }];
    }
    else
    {
        PFQuery *searchResultsQuery = [PFQuery queryWithClassName:@"LeaderInterest"];
        [searchResultsQuery includeKey:@"leaderPointer"];
        [searchResultsQuery whereKey:@"category" equalTo:self.categoriesKeysArray[indexPath.row]];
        
        [searchResultsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            self.searchResultsArray = objects;
            
            for (PFObject *leaderInterest in self.searchResultsArray)
            {
                CLLocation *potentialUserLocation = [[CLLocation alloc] initWithLatitude:[leaderInterest[@"leaderPointer"][@"latitude"] doubleValue] longitude:[leaderInterest[@"leaderPointer"][@"longitude"] doubleValue]];
                
                float distance = [self.userLocation distanceFromLocation:potentialUserLocation]*0.000621371;
                
                if (distance <= 50)
                {
                    [self.userArray addObject:leaderInterest[@"leaderPointer"]];
                }
            }
            
            [self.myTableView reloadData];
        }];
    }
}

#pragma mark - table view delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchResultsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShareCellReuseID"];
    cell.userSubcategoryLabel.text = [self.searchResultsArray objectAtIndex:indexPath.row][@"subcategory"];
    if (!(self.userArray.count == 0) && ![self.userArray isEqual:NULL])
    {
        NSString *userName = self.userArray[indexPath.row][@"username"];
        cell.userNameLabel.text = [NSString stringWithFormat:@"by %@",userName];
        if (self.userArray[indexPath.row][@"avatar"]) {
            [self.userArray[indexPath.row][@"avatar"] getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                if (!error) {
                    UIImage *photo = [UIImage imageWithData:data];
                    cell.userImageView.image = photo;
                }
            }];
        }
        else
        {
            cell.userImageView.image = [UIImage imageNamed:@"default_user"];
        }
    }
    cell.userPriceLabel.text = [self.searchResultsArray objectAtIndex:indexPath.row][@"price"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.chosenUser = self.userArray[indexPath.row];
    if (self.fromEnthusiast)
    {
        [self performSegueWithIdentifier:@"SearchToEnthusiastSegue" sender:self];
    }
    else
    {
        [self performSegueWithIdentifier:@"SearchToLeaderSegue" sender:self];
    }
}

#pragma mark - segue methods

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UICollectionViewCell *)cell
{
    if (self.fromEnthusiast)
    {
        EnthusiastProfileViewController *epvc = segue.destinationViewController;
        epvc.fromSearch = 1;
        epvc.enthusiastChosenFromSearch = self.chosenUser;
    }
    else
    {
        ProfileViewController *pvc = segue.destinationViewController;
        pvc.fromSearch = 1;
        pvc.leaderChosenFromSearch = self.chosenUser;
    }
}

@end
