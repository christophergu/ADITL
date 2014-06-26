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
@property (strong, nonatomic) IBOutlet UITextView *myMoreTextView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *uiViewForScrollView;
@property (strong, nonatomic) IBOutlet UIButton *moreDoneButton;
@property (strong, nonatomic) IBOutlet UIView *categoryMoreView;

@end

@implementation AddToShareViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.currentUser = [PFUser currentUser];
    
    self.doneButton.layer.cornerRadius = 5.0f;

    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    
    NSDictionary *categoryArt = @{@"Art": [UIImage imageNamed:@"art"]};
    NSDictionary *categoryCooking = @{@"Cooking": [UIImage imageNamed:@"cooking"]};
    self.categoriesArray = @[categoryArt, categoryCooking];
    
    self.myMoreTextView.textColor = [UIColor colorWithWhite: 0.8 alpha:1]; //optional
    self.myMoreTextView.text = @"A more indepth description of what you can offer can go here.";
    [self.myMoreTextView.layer setBorderColor:[[UIColor colorWithWhite: 0.8 alpha:1] CGColor]];
    [self.myMoreTextView.layer setBorderWidth:0.5];
    self.myMoreTextView.layer.cornerRadius = 5;
    self.moreDoneButton.layer.cornerRadius = 5.0f;
    self.myMoreTextView.clipsToBounds = YES;
    self.categoryMoreView.alpha = 0.0;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [tap setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:tap];
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

- (void)viewDidAppear:(BOOL)animated
{
    self.scrollView.contentSize = CGSizeMake(320, 640);
    self.scrollView.scrollEnabled = YES;
    self.scrollView.userInteractionEnabled = YES;
    [self.scrollView addSubview:self.uiViewForScrollView];
}

-(void)dismissKeyboard {
    [self.myMoreTextView resignFirstResponder];
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

#pragma mark - what i can share text view delegate methods (for placehoder text to exist)

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([self.myMoreTextView.text isEqualToString:@"A more indepth description of what you can offer can go here."]) {
        self.myMoreTextView.text = @"";
        self.myMoreTextView.textColor = [UIColor blackColor]; //optional
        [self.myMoreTextView becomeFirstResponder];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([self.myMoreTextView.text isEqualToString:@""]) {
        self.myMoreTextView.text = @"A more indepth description of what you can offer can go here.";
        self.myMoreTextView.textColor = [UIColor colorWithWhite: 0.8 alpha:1]; //optional
        [self.myMoreTextView resignFirstResponder];
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

- (IBAction)onMoreButtonPressed:(id)sender
{
    [UIView animateWithDuration:0.5f animations:^{
        self.categoryMoreView.alpha = 1.0;
    }];
}
- (IBAction)onMoreDoneButtonPressed:(id)sender {
    [UIView animateWithDuration:0.5f animations:^{
        self.categoryMoreView.alpha = 0.0;
    }];
    if (![self.myMoreTextView.text isEqualToString:@"All fields must be completed to add."] && !(allTrim(self.myMoreTextView.text).length == 0))
    {
        if (self.fromEnthusiast)
        {
            self.enthusiastInterest[@"more"] = self.myMoreTextView.text;
        }
        else
        {
            self.leaderInterest[@"more"] = self.myMoreTextView.text;
        }
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"CategoryExtraDetailsSegue"])
    {
        NSLog(@"hi");
    }
}

@end
