//
//  BeAMentorViewController.m
//  ADITL
//
//  Created by Christopher Gu on 5/14/14.
//  Copyright (c) 2014 Christopher Gu. All rights reserved.
//

#import "BeAMentorViewController.h"
#import <Parse/Parse.h>

@interface BeAMentorViewController ()
@property (strong, nonatomic) IBOutlet UITextField *expertiseTextField;
@property (strong, nonatomic) IBOutlet UITextView *whatICanShareTextView;
@property (strong, nonatomic) IBOutlet UITextField *priceTextField;
@property (strong, nonatomic) IBOutlet UITextField *locationTextField;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;

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

- (IBAction)emailEditingDidEnd:(id)sender
{
    [self.emailTextField endEditing:YES];
}

- (IBAction)emailDidEndOnExit:(id)sender
{
    [self.emailTextField endEditing:YES];

}

- (IBAction)onDismissKeyboardButtonPressed:(id)sender
{
    [self.expertiseTextField endEditing:YES];
    [self.whatICanShareTextView endEditing:YES];
    [self.priceTextField endEditing:YES];
    [self.locationTextField endEditing:YES];
    [self.emailTextField endEditing:YES];
}

#pragma mark - done button pressed

- (IBAction)onDoneButtonPressed:(id)sender
{
    [self.expertiseTextField endEditing:YES];
    [self.whatICanShareTextView endEditing:YES];
    [self.priceTextField endEditing:YES];
    [self.locationTextField endEditing:YES];
    [self.emailTextField endEditing:YES];
    
    // ask if the poster wants their info saved into a mentor profile
    PFUser *userNow = [PFUser currentUser];
    if (!userNow)
    {
        UIAlertView *mentorPostSuccessfulAlert = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"People will now be able to search your post.\n\nWe've noticed you are not using a Mentor Profile. Would you like to create one now?" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [mentorPostSuccessfulAlert show];
    }
    
    
//    PFObject *post = [PFObject objectWithClassName:@"MentorPost"];
//    post[@"expertise"] = self.expertiseTextField.text;
//    post[@"whatICanShare"] = self.whatICanShareTextView.text;
//    post[@"price"] = @([self.priceTextField.text integerValue]);
//    post[@"locationCity"] = self.locationTextField.text;
////    post[@"locationState"] = @NO;
//    post[@"email"] = self.emailTextField.text;
//    [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        UIAlertView *mentorPostSuccessfulAlert = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"People will now be able to search your post.\n\nThank you for sharing your expertise!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        [mentorPostSuccessfulAlert show];
//    }];
}


@end
