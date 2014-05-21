//
//  FindAMentorViewController.m
//  ADITL
//
//  Created by Christopher Gu on 5/17/14.
//  Copyright (c) 2014 Christopher Gu. All rights reserved.
//

#import "FindAMentorViewController.h"
#import "FindAMentorCollectionViewCell.h"

@interface FindAMentorViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) NSArray *categoriesArray;

@end

@implementation FindAMentorViewController

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.categoriesArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FindAMentorCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CategoryCellReuseID" forIndexPath:indexPath];
    cell.categoryLabel.text = self.categoriesArray[indexPath.row];
    return cell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.categoriesArray = @[@"Art",@"Cooking"];
}

@end
