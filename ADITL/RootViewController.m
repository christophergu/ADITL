//
//  RootViewController.m
//  ADITL
//
//  Created by Christopher Gu on 5/16/14.
//  Copyright (c) 2014 Christopher Gu. All rights reserved.
//

#import "RootViewController.h"
#import <Parse/Parse.h>

@interface RootViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation RootViewController

-(void)viewWillAppear:(BOOL)animated
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.loginButton.layer.cornerRadius = 5.0f;
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

- (IBAction)onMentorLogInButtonPressed:(id)sender
{
    PFUser *userNow = [PFUser currentUser];
    if (userNow)
    {
        [self performSegueWithIdentifier:@"RootToProfileSegue" sender:self];
    }
    else
    {
        [self performSegueWithIdentifier:@"RootToLogInSegue" sender:self];
    }
}

- (IBAction)unwindToBeginning:(UIStoryboardSegue *)unwindSegue
{
    [PFUser logOut];
}

@end
