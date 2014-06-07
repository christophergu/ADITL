//
//  AddToShareViewController.m
//  ADITL
//
//  Created by Christopher Gu on 6/6/14.
//  Copyright (c) 2014 Christopher Gu. All rights reserved.
//

#import "AddToShareViewController.h"
#import "AddToShareCollectionViewCell.h"
#import <Parse/Parse.h>

#define allTrim( object ) [object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet] ]

@interface AddToShareViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) NSArray *categoriesArray;
@property (strong, nonatomic) IBOutlet UILabel *categoryLabel;
@property (strong, nonatomic) IBOutlet UIView *categoryView;
@property (strong, nonatomic) IBOutlet UIView *subcategoryView;
@property (strong, nonatomic) IBOutlet UITextField *subcategoryTextField;
@property (strong, nonatomic) IBOutlet UIView *priceView;
@property (strong, nonatomic) IBOutlet UITextField *priceTextField;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;
@property (strong, nonatomic) PFUser *currentUser;
@property (strong, nonatomic) PFObject *leaderInterest;


@end

@implementation AddToShareViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.currentUser = [PFUser currentUser];
    
    self.doneButton.layer.cornerRadius = 5.0f;
    
    NSDictionary *categoryArt = @{@"Art": [UIImage imageNamed:@"art"]};
    NSDictionary *categoryCooking = @{@"Cooking": [UIImage imageNamed:@"cooking"]};
    self.categoriesArray = @[categoryArt, categoryCooking];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.categoryView.alpha = 0.0;
    self.subcategoryView.alpha = 0.0;
    self.priceView.alpha = 0.0;
}

-(void)viewWillDisappear:(BOOL)animated
{
    if ((self.leaderInterest[@"category"]==NULL)||
        (self.leaderInterest[@"subcategory"]==NULL)||
        (self.leaderInterest[@"price"]==NULL))
    {
        [self.leaderInterest deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            NSLog(@"deleted");
        }];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.categoriesArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AddToShareCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AddToShareCellReuseID" forIndexPath:indexPath];
    cell.categoryLabel.text = [self.categoriesArray[indexPath.row] allKeys][0];
    cell.categoryImageView.image = self.categoriesArray[indexPath.row][cell.categoryLabel.text];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.leaderInterest = [PFObject objectWithClassName:@"LeaderInterest"];
    self.leaderInterest[@"category"] = [self.categoriesArray[indexPath.row] allKeys][0];
    self.leaderInterest[@"leaderEmail"] = self.currentUser.email;
    
    self.categoryLabel.text = self.leaderInterest[@"category"];
    if (self.categoryView.alpha == 0.0)
    {
        [UIView animateWithDuration:0.5 animations:^{
            self.categoryView.alpha = 1.0;
        } completion:^(BOOL finished) {
            [self.leaderInterest saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                [UIView animateWithDuration:0.4 animations:^{
                    self.subcategoryView.alpha = 1.0;
                }];
            }];
        }];
    }
}

- (IBAction)subcategoryDidEndOnExit:(id)sender
{
    
    if (!(allTrim(self.subcategoryTextField.text).length == 0) ) {
        self.leaderInterest[@"subcategory"] = self.subcategoryTextField.text;
        
        [self.leaderInterest saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
         {
             [UIView animateWithDuration:0.4 animations:^{
                 self.priceView.alpha = 1.0;
             }];
         }];
    }
    else
    {
        UIAlertView *incompleteAlert = [[UIAlertView alloc]initWithTitle:@"Oops!"
                                                                 message:@"All fields must be completed to add."
                                                                delegate:self
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles: nil];
        [incompleteAlert show];
    }
}

- (IBAction)priceDidEndOnExit:(id)sender
{
    self.leaderInterest[@"price"] = self.priceTextField.text;
}

- (IBAction)onDoneButtonPressed:(id)sender
{
    if (!(self.leaderInterest[@"category"]==NULL)&&
        !(self.leaderInterest[@"subcategory"]==NULL)&&
        !(self.leaderInterest[@"price"]==NULL))
    {
        [self.leaderInterest saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            NSLog(@"leader interest complete");
        }];
    }
    else
    {
        UIAlertView *incompleteAlert = [[UIAlertView alloc]initWithTitle:@"Oops!"
                                                                 message:@"All fields must be completed to add."
                                                                delegate:self
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles: nil];
        [incompleteAlert show];
    }
}


@end
