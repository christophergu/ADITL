//
//  FindAMentorViewController.m
//  ADITL
//
//  Created by Christopher Gu on 5/17/14.
//  Copyright (c) 2014 Christopher Gu. All rights reserved.
//

#import "FindAMentorViewController.h"
#import "FindAMentorCollectionViewCell.h"
#import "SearchResultsViewController.h"

@interface FindAMentorViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) NSArray *categoriesArray;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UITextField *locationTextField;

@end

@implementation FindAMentorViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSDictionary *categoryArt = @{@"Art": [UIImage imageNamed:@"art"]};
    NSDictionary *categoryCooking = @{@"Cooking": [UIImage imageNamed:@"cooking"]};
    self.categoriesArray = @[categoryArt, categoryCooking];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.categoriesArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FindAMentorCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CategoryCellReuseID" forIndexPath:indexPath];
    cell.categoryLabel.text = [self.categoriesArray[indexPath.row] allKeys][0];
    cell.categoryImageView.image = self.categoriesArray[indexPath.row][cell.categoryLabel.text];
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UICollectionViewCell *)cell
{
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    SearchResultsViewController *srvc = segue.destinationViewController;
    NSString *categoryString = [self.categoriesArray[indexPath.row] allKeys][0];
    srvc.locationString = self.locationTextField.text;
    srvc.categoryString = categoryString;
}

@end
