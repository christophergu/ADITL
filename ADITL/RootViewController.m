//
//  RootViewController.m
//  ADITL
//
//  Created by Christopher Gu on 5/16/14.
//  Copyright (c) 2014 Christopher Gu. All rights reserved.
//

#import "RootViewController.h"
#import "RootCollectionViewCell.h"
#import "SearchViewController.h"
#import "ProfileViewController.h"
#import <Parse/Parse.h>

@interface RootViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) NSArray *userArray;
@property (strong, nonatomic) IBOutlet UICollectionView *myCollectionView;
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;
@property int *selectedIndexPathRow;

@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    PFQuery *userQuery = [PFUser query];
    [userQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.userArray = objects;
        [self.myCollectionView reloadData];
    }];
    
    self.loginButton.layer.cornerRadius = 5.0f;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.userArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    RootCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RootCellReuseID" forIndexPath:indexPath];
    
    if (self.userArray[indexPath.row][@"avatar"])
    {
        [self.userArray[indexPath.row][@"avatar"] getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error) {
                UIImage *photo = [UIImage imageWithData:data];
                cell.imageView.image = photo;
            }
        }];
    }
    else
    {
        cell.imageView.image = [UIImage imageNamed:@"default_user"];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndexPath = indexPath;
    [self performSegueWithIdentifier:@"RootCollectionToProfileSegue" sender:self];
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SearchEnthusiastsSegue"])
    {
        SearchViewController *svc = segue.destinationViewController;
        svc.fromEnthusiast = 1;
    }
    else if ([segue.identifier isEqualToString:@"RootCollectionToProfileSegue"])
    {
        ProfileViewController *pvc = segue.destinationViewController;
        pvc.leaderChosenFromSearch = self.userArray[self.selectedIndexPath.row];
        pvc.fromSearch = 1;
    }
}

@end
