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
@property (strong, nonatomic) PFObject *enthusiastInterest;

@property (strong, nonatomic) IBOutlet UILabel *categoryHeaderLabel;
@property (strong, nonatomic) IBOutlet UILabel *subcategoryHeaderLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceHeaderLabel;

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
    self.doneButton.alpha = 0.0;
    
    if (self.fromEnthusiast)
    {
        self.categoryHeaderLabel.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:198.0/255.0 blue:72.0/255.0 alpha:1];
        self.subcategoryHeaderLabel.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:198.0/255.0 blue:72.0/255.0 alpha:1];
        self.priceHeaderLabel.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:198.0/255.0 blue:72.0/255.0 alpha:1];
        
        self.doneButton.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:198.0/255.0 blue:72.0/255.0 alpha:1];
    }
    else
    {
        self.categoryHeaderLabel.backgroundColor = [UIColor colorWithRed:68.0/255.0 green:121.0/255.0 blue:255.0/255.0 alpha:1];
        self.subcategoryHeaderLabel.backgroundColor = [UIColor colorWithRed:68.0/255.0 green:121.0/255.0 blue:255.0/255.0 alpha:1];
        self.priceHeaderLabel.backgroundColor = [UIColor colorWithRed:68.0/255.0 green:121.0/255.0 blue:255.0/255.0 alpha:1];
        
        self.doneButton.backgroundColor = [UIColor colorWithRed:68.0/255.0 green:121.0/255.0 blue:255.0/255.0 alpha:1];
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
    if (self.fromEnthusiast)
    {
        cell.categoryLabel.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:198.0/255.0 blue:72.0/255.0 alpha:1];
    }
    else
    {
        cell.categoryLabel.backgroundColor = [UIColor colorWithRed:68.0/255.0 green:121.0/255.0 blue:255.0/255.0 alpha:1];
    }
    cell.categoryImageView.image = self.categoriesArray[indexPath.row][cell.categoryLabel.text];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.fromEnthusiast)
    {
        self.enthusiastInterest = [PFObject objectWithClassName:@"EnthusiastInterest"];
        self.enthusiastInterest[@"category"] = [self.categoriesArray[indexPath.row] allKeys][0];
        self.enthusiastInterest[@"enthusiastEmail"] = self.currentUser.email;
        
        self.categoryLabel.text = self.enthusiastInterest[@"category"];
        if (self.categoryView.alpha == 0.0)
        {
            [UIView animateWithDuration:0.5 animations:^{
                self.categoryView.alpha = 1.0;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.4 animations:^{
                    self.subcategoryView.alpha = 1.0;
                }];
            }];
        }
    }
    else
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
                [UIView animateWithDuration:0.4 animations:^{
                    self.subcategoryView.alpha = 1.0;
                }];
            }];
        }
    }
}

- (IBAction)subcategoryDidEndOnExit:(id)sender
{
    
    if (!(allTrim(self.subcategoryTextField.text).length == 0) ) {
        if (self.fromEnthusiast)
        {
            self.enthusiastInterest[@"subcategory"] = self.subcategoryTextField.text;
            [UIView animateWithDuration:0.4 animations:^{
                self.doneButton.alpha = 1.0;
            }];
        }
        else
        {
            self.leaderInterest[@"subcategory"] = self.subcategoryTextField.text;
            [UIView animateWithDuration:0.4 animations:^{
                self.priceView.alpha = 1.0;
            }];
        }
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
    if (self.fromEnthusiast)
    {
        self.enthusiastInterest[@"price"] = self.priceTextField.text;
    }
    else
    {
        self.leaderInterest[@"price"] = self.priceTextField.text;
        [UIView animateWithDuration:0.4 animations:^{
            self.doneButton.alpha = 1.0;
        }];
    }
}

- (IBAction)onDoneButtonPressed:(id)sender
{
    if (self.fromEnthusiast)
    {
        if (!(self.enthusiastInterest[@"category"]==NULL)&&
            !(self.enthusiastInterest[@"subcategory"]==NULL))
        {
            self.enthusiastInterest[@"enthusiastPointer"] = self.currentUser;
            [self.enthusiastInterest saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                NSLog(@"enthusiast interest complete");
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
    else
    {
        if (!(self.leaderInterest[@"category"]==NULL)&&
            !(self.leaderInterest[@"subcategory"]==NULL)&&
            !(self.leaderInterest[@"price"]==NULL))
        {
            self.leaderInterest[@"leaderPointer"] = self.currentUser;
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
}


@end
