//
//  LogInViewController.m
//  ADITL
//
//  Created by Christopher Gu on 5/16/14.
//  Copyright (c) 2014 Christopher Gu. All rights reserved.
//

#import "LogInViewController.h"
#import "ProfileViewController.h"
#import "ConversationViewController.h"

@interface LogInViewController ()<PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

@end

@implementation LogInViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    PFUser *userNow = [PFUser currentUser];
    if (userNow)
    {
        [self performSegueWithIdentifier:@"LogInToProfileSegue" sender:self];
    }
    
    self.delegate = self;
    self.signUpController.delegate = self;
    
    if (self.post) {
        [self presentViewController:self.signUpController animated:NO completion:^{
        }];
    }
}

- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user
{
    if (self.becauseLoginRequired)
    {
        
        
        [self performSegueWithIdentifier:@"LoginToConversationVCSegue" sender:self];
        
        NSMutableArray *navigationArray = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
        [navigationArray removeObjectAtIndex:4];
        self.navigationController.viewControllers = navigationArray;
    }
    else
    {
        [self performSegueWithIdentifier:@"LogInToProfileSegue" sender:self];
        
        [self removeLogInSignUpFromStack];
    }
}

- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user
{
    if (self.becauseLoginRequired)
    {
        [self performSegueWithIdentifier:@"LoginToConversationVCSegue" sender:self];
        
        NSMutableArray *navigationArray = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
        [navigationArray removeObjectAtIndex:4];
        self.navigationController.viewControllers = navigationArray;
    }
    else
    {
        [self dismissViewControllerAnimated:NO completion:^{
            [self saveUnfinishedPost];
            [self performSegueWithIdentifier:@"SignUpToProfileSegue" sender:self];
        }];
        
        [self removeLogInSignUpFromStack];
    }
}

- (void)removeLogInSignUpFromStack
{
    NSMutableArray *navigationArray = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
    [navigationArray removeObjectAtIndex:1];
    self.navigationController.viewControllers = navigationArray;
}

- (void) saveUnfinishedPost
{
    if (self.post)
    {
        NSLog(@"ya");
//        [self dismissModalViewControllerAnimated:NO];
        PFUser *userNow = [PFUser currentUser];
        if (userNow) {
            self.post[@"mentor"] = userNow;
        }
        [self.post saveInBackground];
    }
    else if (!self.post)
    {
        NSLog(@"nah");
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ConversationViewController *cvc = segue.destinationViewController;
    
    if ([[segue identifier] isEqualToString:@"LoginToConversationVCSegue"])
    {
        cvc.conversation = self.conversation;
    }
}

@end
