//
//  ProfileViewController.m
//  ADITL
//
//  Created by Christopher Gu on 5/16/14.
//  Copyright (c) 2014 Christopher Gu. All rights reserved.
//

#import "ProfileViewController.h"
#import <Parse/Parse.h>

@interface ProfileViewController () <UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *uiViewForScrollView;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;
@property (strong, nonatomic) IBOutlet UIButton *dismissKeyboardButton;

@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *expertiseTextField;
@property (strong, nonatomic) IBOutlet UITextField *locationTextField;
@property (strong, nonatomic) IBOutlet UITextView *aboutMeTextView;
@property (strong, nonatomic) IBOutlet UITextView *whatICanShareTextView;
@property (strong, nonatomic) IBOutlet UITextField *websiteTextField;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation ProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.aboutMeTextView.textColor = [UIColor colorWithWhite: 0.8 alpha:1]; //optional
    [self.aboutMeTextView.layer setBorderColor:[[UIColor colorWithWhite: 0.8 alpha:1] CGColor]];
    [self.aboutMeTextView.layer setBorderWidth:0.5];
    self.aboutMeTextView.layer.cornerRadius = 5;
    self.aboutMeTextView.clipsToBounds = YES;
    
    self.whatICanShareTextView.textColor = [UIColor colorWithWhite: 0.8 alpha:1]; //optional
    [self.whatICanShareTextView.layer setBorderColor:[[UIColor colorWithWhite: 0.8 alpha:1] CGColor]];
    [self.whatICanShareTextView.layer setBorderWidth:0.5];
    self.whatICanShareTextView.layer.cornerRadius = 5;
    self.whatICanShareTextView.clipsToBounds = YES;
    
    self.nameTextField.text = self.usernameString;
    self.passwordTextField.text = self.passwordString;
    self.expertiseTextField.text = self.expertiseString;
    self.whatICanShareTextView.text = self.whatICanShareString;
    self.locationTextField.text = self.locationString;
    self.emailTextField.text = self.emailString;
}

- (void)viewDidAppear:(BOOL)animated
{
//    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(320, 800);
    self.scrollView.scrollEnabled = YES;
    self.scrollView.userInteractionEnabled = YES;
    [self.scrollView addSubview:self.uiViewForScrollView];
}

#pragma mark - what i can share text view delegate methods (for placehoder text to exist)

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([self.aboutMeTextView.text isEqualToString:@"About Me"]) {
        self.aboutMeTextView.text = @"";
        self.aboutMeTextView.textColor = [UIColor blackColor]; //optional
//        [self.aboutMeTextView becomeFirstResponder];
    }
    if ([self.whatICanShareTextView.text isEqualToString:@"What I Can Share"])
    {
        self.whatICanShareTextView.text = @"";
        self.whatICanShareTextView.textColor = [UIColor blackColor]; //optional
//        [self.whatICanShareTextView becomeFirstResponder];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([self.aboutMeTextView.text isEqualToString:@""]) {
        self.aboutMeTextView.text = @"About Me";
        self.aboutMeTextView.textColor = [UIColor colorWithWhite: 0.8 alpha:1]; //optional
        [self.aboutMeTextView resignFirstResponder];
    }
    if ([self.whatICanShareTextView.text isEqualToString:@""]) {
        self.whatICanShareTextView.text = @"What I Can Share";
        self.whatICanShareTextView.textColor = [UIColor colorWithWhite: 0.8 alpha:1]; //optional
        [self.whatICanShareTextView resignFirstResponder];
    }
}

- (IBAction)onSaveButtonPressed:(id)sender
{
    [self createNewUser];
}

- (void)createNewUser
{
    PFUser *user = [PFUser user];
    user.username = self.nameTextField.text;
    user.password = self.passwordTextField.text;
    user.email = self.emailTextField.text;
//    NSDate *joinDate = [NSDate date];
//    user[@"joinDate"] = joinDate;
    
//    UIImage *pickedImage = [UIImage imageNamed:@"defaultUserImage"];
//    NSData* data = UIImageJPEGRepresentation(pickedImage,1.0f);
//    PFFile *imageFile = [PFFile fileWithData:data];
//    user[@"avatar"] = imageFile;
    
    [user signUpInBackgroundWithTarget:self selector:@selector(handleSignUp:error:)];
}

- (void)handleSignUp:(NSNumber *)result error:(NSError *)error
{
//    if (!error)
//    {
//        [PFUser logInWithUsernameInBackground:self.usernameTextField.text password:self.passwordTextField.text block:^(PFUser *user, NSError *error) {
//            if (user) {
//                [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
//            }
//            else
//            {
//                UIAlertView *logInFailAlert = [[UIAlertView alloc] initWithTitle:@"Log In Error" message:@"Username or Password is Incorrect" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//                [logInFailAlert show];            }
//        }];
//    }
//    else
//    {
//        UIAlertView *signUpErrorAlert = [[UIAlertView alloc] initWithTitle:@"Sign In Failed" message:[NSString stringWithFormat:@"%@",[error userInfo][@"error"]] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//        [signUpErrorAlert show];
//    }
}

- (IBAction)onDismissKeyboardButtonPressed:(id)sender
{
    [self.nameTextField endEditing:YES];
    [self.expertiseTextField endEditing:YES];
    [self.locationTextField endEditing:YES];
    [self.aboutMeTextView endEditing:YES];
    [self.whatICanShareTextView endEditing:YES];
    [self.websiteTextField endEditing:YES];
    [self.emailTextField endEditing:YES];
    [self.passwordTextField endEditing:YES];
}

@end
