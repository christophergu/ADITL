//
//  RootViewController.m
//  ADITL
//
//  Created by Christopher Gu on 5/16/14.
//  Copyright (c) 2014 Christopher Gu. All rights reserved.
//

#import "RootViewController.h"
#import <Parse/Parse.h>

@interface RootViewController ()
@property (strong, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.loginButton.layer.cornerRadius = 5.0f;
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
