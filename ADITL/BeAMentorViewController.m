//
//  BeAMentorViewController.m
//  ADITL
//
//  Created by Christopher Gu on 5/14/14.
//  Copyright (c) 2014 Christopher Gu. All rights reserved.
//

#import "BeAMentorViewController.h"
#import "LogInViewController.h"
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>

@interface BeAMentorViewController ()
@property (strong, nonatomic) IBOutlet UITextField *expertiseTextField;
@property (strong, nonatomic) IBOutlet UITextView *whatICanShareTextView;
@property (strong, nonatomic) IBOutlet UITextField *priceTextField;
@property (strong, nonatomic) IBOutlet UITextField *locationTextField;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;
@property (strong, nonatomic) IBOutlet UILabel *missingField1Label;
@property (strong, nonatomic) IBOutlet UILabel *missingField2Label;

@end

@implementation BeAMentorViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.whatICanShareTextView.text = @"What I Can Share (optional)";
    self.whatICanShareTextView.textColor = [UIColor colorWithWhite: 0.8 alpha:1]; //optional
    [self.whatICanShareTextView.layer setBorderColor:[[UIColor colorWithWhite: 0.8 alpha:1] CGColor]];
    [self.whatICanShareTextView.layer setBorderWidth:0.5];
    self.whatICanShareTextView.layer.cornerRadius = 5;
    self.whatICanShareTextView.clipsToBounds = YES;
    
    self.missingField1Label.hidden = YES;
    self.missingField2Label.hidden = YES;
    
    self.expertiseTextField.text = @"";
    self.whatICanShareTextView.text = @"What I Can Share (optional)";
    self.priceTextField.text = @"";
    self.locationTextField.text = @"";
}

#pragma mark - what i can share text view delegate methods (for placehoder text to exist)

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([self.whatICanShareTextView.text isEqualToString:@"What I Can Share (optional)"]) {
        self.whatICanShareTextView.text = @"";
        self.whatICanShareTextView.textColor = [UIColor blackColor]; //optional
    }
    [self.whatICanShareTextView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([self.whatICanShareTextView.text isEqualToString:@""]) {
        self.whatICanShareTextView.text = @"What I Can Share (optional)";
        self.whatICanShareTextView.textColor = [UIColor colorWithWhite: 0.8 alpha:1]; //optional
    }
    [self.whatICanShareTextView resignFirstResponder];
}

#pragma mark - dismissing the keyboard

- (IBAction)onExpertiseEditingDidEnd:(id)sender
{
    [self.expertiseTextField endEditing:YES];
}

- (IBAction)onExpertiseDidEndOnExit:(id)sender
{
    [self.expertiseTextField endEditing:YES];
}

- (IBAction)priceEditingDidEnd:(id)sender
{
    [self.priceTextField endEditing:YES];
}

- (IBAction)priceDidEndOnExit:(id)sender
{
    [self.priceTextField endEditing:YES];
}

- (IBAction)locationEditingDidEnd:(id)sender
{
    [self.locationTextField endEditing:YES];
}

- (IBAction)locationDidEndOnExit:(id)sender
{
    [self.locationTextField endEditing:YES];
}

- (IBAction)onDismissKeyboardButtonPressed:(id)sender
{
    [self.expertiseTextField endEditing:YES];
    [self.whatICanShareTextView endEditing:YES];
    [self.priceTextField endEditing:YES];
    [self.locationTextField endEditing:YES];
//    [self.emailTextField endEditing:YES];
}

#pragma mark - done button pressed

- (IBAction)onDoneButtonPressed:(id)sender
{
    [self.expertiseTextField endEditing:YES];
    [self.whatICanShareTextView endEditing:YES];
    [self.priceTextField endEditing:YES];
    [self.locationTextField endEditing:YES];
    
    NSString *trimmedExpertiseString = [self.expertiseTextField.text stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *trimmedPriceString = [self.priceTextField.text stringByTrimmingCharactersInSet:
                                        [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *trimmedLocationString = [self.locationTextField.text stringByTrimmingCharactersInSet:
                                        [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if(![trimmedExpertiseString isEqualToString:@""] &&
       ![trimmedPriceString isEqualToString:@""] &&
       ![trimmedLocationString isEqualToString:@""])
    {
        NSLog(@"textView is ok");
        self.missingField1Label.hidden = YES;
        self.missingField2Label.hidden = YES;
        
        PFUser *userNow = [PFUser currentUser];
        if (!userNow)
        {
            UIAlertView *nonmentorPostSuccessfulAlert = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"People will now be able to search your post.\n\nWe've noticed you are not using a Mentor Profile. Would you like to create one now?" delegate:self cancelButtonTitle:@"Yes!" otherButtonTitles: nil];
            [nonmentorPostSuccessfulAlert show];
        }
        else if (userNow)
        {
            UIAlertView *mentorPostSuccessfulAlert = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"People will now be able to search your post.\n\nThanks for sharing!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [mentorPostSuccessfulAlert show];
        }
    }
    else
    {
        NSLog(@"textView has not ok");
        
        self.missingField1Label.hidden = NO;
        self.missingField2Label.hidden = NO;
        
        if ([trimmedExpertiseString isEqualToString:@""])
        {
            self.expertiseTextField.backgroundColor = [UIColor whiteColor];
            self.expertiseTextField.layer.borderWidth = 0.5f;
            self.expertiseTextField.layer.cornerRadius = 5.0f;
            self.expertiseTextField.layer.masksToBounds = YES;
            self.expertiseTextField.layer.borderColor = [[UIColor redColor] CGColor];
        }
        else
        {
            self.expertiseTextField.layer.borderColor = [[UIColor colorWithWhite: 0.8 alpha:1] CGColor];
        }
        
        if ([trimmedPriceString isEqualToString:@""])
        {
            self.priceTextField.backgroundColor = [UIColor whiteColor];
            self.priceTextField.layer.borderWidth = 0.5f;
            self.priceTextField.layer.cornerRadius = 5.0f;
            self.priceTextField.layer.masksToBounds = YES;
            self.priceTextField.layer.borderColor = [[UIColor redColor] CGColor];
        }
        else
        {
            self.priceTextField.layer.borderColor = [[UIColor colorWithWhite: 0.8 alpha:1] CGColor];
        }
        
        if ([trimmedLocationString isEqualToString:@""])
        {
            self.locationTextField.backgroundColor = [UIColor whiteColor];
            self.locationTextField.layer.borderWidth = 0.5f;
            self.locationTextField.layer.cornerRadius = 5.0f;
            self.locationTextField.layer.masksToBounds = YES;
            self.locationTextField.layer.borderColor = [[UIColor redColor] CGColor];
        }
        else
        {
            self.locationTextField.layer.borderColor = [[UIColor colorWithWhite: 0.8 alpha:1] CGColor];
        }
    }
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    // the user clicked one of the OK/Cancel buttons
    if (buttonIndex == 0)
    {
        PFUser *userNow = [PFUser currentUser];
        
        if (userNow)
        {
            [self savePost];
        }
        else if (!userNow)
        {
            [self performSegueWithIdentifier:@"SignUpSegue" sender:self];
            
            NSMutableArray *navigationArray = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
            [navigationArray removeObjectAtIndex:1];
            self.navigationController.viewControllers = navigationArray;
        }
    }
}

- (void)savePost
{
    PFObject *post = [PFObject objectWithClassName:@"MentorPost"];
    post[@"expertise"] = self.expertiseTextField.text;
    post[@"whatICanShare"] = self.whatICanShareTextView.text;
    post[@"price"] = @([self.priceTextField.text integerValue]);
    post[@"locationCity"] = self.locationTextField.text;
    //    post[@"locationState"] = @NO;
    PFUser *userNow = [PFUser currentUser];
    if (userNow) {
        post[@"mentor"] = userNow;
    }
    [post saveInBackground];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"SignUpSegue"])
    {
        LogInViewController *lvc = segue.destinationViewController;
        
        // pass over unfinished post
        PFObject *post = [PFObject objectWithClassName:@"MentorPost"];
        post[@"expertise"] = self.expertiseTextField.text;
        post[@"whatICanShare"] = self.whatICanShareTextView.text;
        post[@"price"] = @([self.priceTextField.text integerValue]);
        post[@"locationCity"] = self.locationTextField.text;
        lvc.post = post;
    }
}

@end
