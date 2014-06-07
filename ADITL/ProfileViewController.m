//
//  ProfileViewController.m
//  ADITL
//
//  Created by Christopher Gu on 5/16/14.
//  Copyright (c) 2014 Christopher Gu. All rights reserved.
//

#import "ProfileViewController.h"
#import "ProfileConversationBoxViewController.h"
#import "EnthusiastProfileViewController.h"
#import <Parse/Parse.h>

@interface ProfileViewController () <UIScrollViewDelegate,UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *uiViewForScrollView;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;
@property (strong, nonatomic) IBOutlet UIButton *dismissKeyboardButton;

@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *expertiseTextField;
@property (strong, nonatomic) IBOutlet UITextField *locationTextField;
@property (strong, nonatomic) IBOutlet UITextView *aboutMeTextView;
@property (strong, nonatomic) IBOutlet UITextField *websiteTextField;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *logoutBarButtonItem;
@property (strong, nonatomic) IBOutlet UILabel *conversationCounterLabel;
@property (strong, nonatomic) NSArray *conversationArray;
@property (strong, nonatomic) NSMutableDictionary *interestDictionary;
@property (strong, nonatomic) NSMutableArray *interestGroupsArray;
@property (strong, nonatomic) IBOutlet UIButton *interestAddButton;
@property (strong, nonatomic) IBOutlet UIButton *interestEditDelButton;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (strong, nonatomic) PFUser *currentUser;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;


@end

@implementation ProfileViewController

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.interestGroupsArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *key = [self.interestGroupsArray objectAtIndex:section];
    
    NSArray *category = [self.interestDictionary objectForKey:key];
    
    return category.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = [self.interestGroupsArray objectAtIndex:indexPath.section];
    
    NSArray *category = [self.interestDictionary objectForKey:key];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShareCellReuseID"];
    cell.textLabel.text = [category objectAtIndex:indexPath.row][@"subcategory"];
    cell.detailTextLabel.text = [category objectAtIndex:indexPath.row][@"price"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *groupName = [self.interestGroupsArray objectAtIndex:section];
    return groupName;
}

- (void)fetchInterestsToShare
{
    self.interestGroupsArray = [NSMutableArray new];
    
    PFQuery *postQuery = [PFQuery queryWithClassName:@"LeaderInterest"];
    [postQuery whereKey:@"leaderEmail" equalTo:self.currentUser.email];
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         //        self.postArray = objects;
         
         self.interestDictionary = [NSMutableDictionary new];
         
         for (PFObject *post in objects)
         {
             if (![self.interestGroupsArray containsObject:post[@"category"]]) {
                 [self.interestGroupsArray addObject:post[@"category"]];
             }
         }
         [self.interestGroupsArray sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
         
         for (NSString *groupName in self.interestGroupsArray)
         {
             NSMutableArray *postArray = [NSMutableArray new];
             
             for (PFObject *post in objects)
             {
                 if ([post[@"category"] isEqualToString:groupName])
                 {
                     [postArray addObject:post];
                 }
             }
             [self.interestDictionary setObject:postArray forKey:groupName];
         }
         
         NSLog(@"%@",self.interestDictionary);
         [self.myTableView reloadData];
     }];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.segmentedControl.selectedSegmentIndex=0;
    [self fetchInterestsToShare];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.currentUser = [PFUser currentUser];
    
    self.interestAddButton.layer.cornerRadius = 5.0f;
    
    self.interestEditDelButton.layer.cornerRadius = 5.0f;
    
    self.aboutMeTextView.textColor = [UIColor colorWithWhite: 0.8 alpha:1]; //optional
    [self.aboutMeTextView.layer setBorderColor:[[UIColor colorWithWhite: 0.8 alpha:1] CGColor]];
    [self.aboutMeTextView.layer setBorderWidth:0.5];
    self.aboutMeTextView.layer.cornerRadius = 5;
    self.aboutMeTextView.clipsToBounds = YES;
    
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser && !self.mentorThatPostedUser) {
        self.nameTextField.text = currentUser[@"username"];
        self.passwordTextField.text = currentUser[@"password"]; // change placeholder to "Change password?"
        self.emailTextField.text = currentUser[@"email"];
    }
    else if (self.mentorThatPostedUser)
    {
        [self.logoutBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor clearColor]} forState:UIControlStateNormal];
        self.logoutBarButtonItem.enabled = NO;
        
        [self.mentorThatPostedUser fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            self.nameTextField.text = self.mentorThatPostedUser[@"username"];
            self.emailTextField.text = self.mentorThatPostedUser[@"email"];
        }];
    }
    
    NSArray *currentUserArray = @[currentUser[@"email"]];
    
    PFQuery *conversationQuery = [PFQuery queryWithClassName:@"ConversationThread"];
    [conversationQuery whereKey:@"chattersArray" containsAllObjectsInArray:currentUserArray];
    [conversationQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.conversationCounterLabel.text = [NSString stringWithFormat:@"x%lu",(unsigned long)[objects count]];
        self.conversationArray = objects;
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
//    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(320, 800);
    self.scrollView.scrollEnabled = YES;
    self.scrollView.userInteractionEnabled = YES;
    [self.scrollView addSubview:self.uiViewForScrollView];
}

//#pragma mark - what i can share text view delegate methods (for placehoder text to exist)
//
//- (void)textViewDidBeginEditing:(UITextView *)textView
//{
//    if ([self.aboutMeTextView.text isEqualToString:@"About Me"]) {
//        self.aboutMeTextView.text = @"";
//        self.aboutMeTextView.textColor = [UIColor blackColor]; //optional
////        [self.aboutMeTextView becomeFirstResponder];
//    }
//}
//
//- (void)textViewDidEndEditing:(UITextView *)textView
//{
//    if ([self.aboutMeTextView.text isEqualToString:@""]) {
//        self.aboutMeTextView.text = @"About Me";
//        self.aboutMeTextView.textColor = [UIColor colorWithWhite: 0.8 alpha:1]; //optional
//        [self.aboutMeTextView resignFirstResponder];
//    }
//}

//- (IBAction)onSaveButtonPressed:(id)sender
//{
//    [self createNewUser];
//}

- (IBAction)segmentedControlIndexChanged:(id)sender {
    if(self.segmentedControl.selectedSegmentIndex==1)
    {

    }
}
- (IBAction)onEnthusiastSubstituteButtonPressed:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    EnthusiastProfileViewController *epvc =[storyboard instantiateViewControllerWithIdentifier:@"EnthusiastProfileViewControllerID"];
    
    [UIView beginAnimations:@"animation" context:nil];
    [self.navigationController pushViewController:epvc animated:NO];
    [UIView setAnimationDuration:0.8];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
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

//- (void) saveUnfinishedPost
//{
//    if (self.post)
//    {
//        NSLog(@"ya");
//        PFUser *userNow = [PFUser currentUser];
//        if (userNow) {
//            self.post[@"mentor"] = userNow;
//        }
//        [self.post saveInBackground];
//    }
//    else if (!self.post)
//    {
//        NSLog(@"nah");
//    }
//}

- (void)handleSignUp:(NSNumber *)result error:(NSError *)error
{
//    [self saveUnfinishedPost];
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
    [self.websiteTextField endEditing:YES];
    [self.emailTextField endEditing:YES];
    [self.passwordTextField endEditing:YES];
}

- (IBAction)onConversationButtonPressed:(id)sender
{
    [self performSegueWithIdentifier:@"ConversationBoxSegue" sender:self];
}

- (IBAction)onViewPostsButtonPressed:(id)sender
{
    [self performSegueWithIdentifier:@"ViewPostsSegue" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ConversationBoxSegue"])
    {
        ProfileConversationBoxViewController *pcbvc = segue.destinationViewController;
        pcbvc.conversationArray = self.conversationArray;
    }
    else if ([segue.identifier isEqualToString:@"AddInterestSegue"])
    {
//        ProfileConversationBoxViewController *pcbvc = segue.destinationViewController;
//        pcbvc.conversationArray = self.conversationArray;
    }
}

@end
