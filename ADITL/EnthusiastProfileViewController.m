//
//  EnthusiastProfileViewController.m
//  ADITL
//
//  Created by Christopher Gu on 6/6/14.
//  Copyright (c) 2014 Christopher Gu. All rights reserved.
//

#import "EnthusiastProfileViewController.h"
#import "ProfileViewController.h"
#import "ProfileConversationBoxViewController.h"
#import "AddToShareViewController.h"

@interface EnthusiastProfileViewController () <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
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
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (strong, nonatomic) PFUser *currentUser;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (strong, nonatomic) IBOutlet UIButton *myAvatarPhotoButton;

@end

@implementation EnthusiastProfileViewController

-(void)viewWillAppear:(BOOL)animated
{
    [self fetchInterestsToShare];
    
    if (self.fromSearch || self.fromSearchLeader)
    {
        [self.enthusiastChosenFromSearch[@"avatar"] getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error) {
                UIImage *photo = [UIImage imageWithData:data];
                self.avatarImageView.image = photo;
            }
        }];
    }
    else if (self.currentUser[@"avatar"])
    {
        [self.currentUser[@"avatar"] getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error) {
                UIImage *photo = [UIImage imageWithData:data];
                self.avatarImageView.image = photo;
            }
        }];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.currentUser = [PFUser currentUser];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"back"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(handleBack:)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    self.segmentedControl.selectedSegmentIndex=1;
    
    self.interestAddButton.layer.cornerRadius = 5.0f;
    
    self.aboutMeTextView.textColor = [UIColor colorWithWhite: 0.8 alpha:1]; //optional
    [self.aboutMeTextView.layer setBorderColor:[[UIColor colorWithWhite: 0.8 alpha:1] CGColor]];
    [self.aboutMeTextView.layer setBorderWidth:0.5];
    self.aboutMeTextView.layer.cornerRadius = 5;
    self.aboutMeTextView.clipsToBounds = YES;
    
    PFUser *currentUser = [PFUser currentUser];
    
    if (self.fromSearch || self.fromSearchLeader)
    {
        [self.logoutBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor clearColor]} forState:UIControlStateNormal];
        self.logoutBarButtonItem.enabled = NO;
        
        self.nameTextField.text = self.enthusiastChosenFromSearch[@"username"];
        self.emailTextField.text = self.enthusiastChosenFromSearch[@"email"];
    }
    else
    {
        self.nameTextField.text = currentUser[@"username"];
        self.passwordTextField.text = currentUser[@"password"]; // change placeholder to "Change password?"
        self.emailTextField.text = currentUser[@"email"];
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

#pragma mark - table view delegate methods

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

#pragma mark - helper methods

- (void)fetchInterestsToShare
{
    self.interestGroupsArray = [NSMutableArray new];
    
    PFQuery *postQuery = [PFQuery queryWithClassName:@"EnthusiastInterest"];
    [postQuery whereKey:@"enthusiastEmail" equalTo:self.currentUser.email];
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
         [self.myTableView reloadData];
     }];
}

#pragma mark - button methods

- (void) handleBack:(id)sender
{
    // pop to root view controller
    [self.navigationController popToRootViewControllerAnimated:YES];
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

- (IBAction)segmentedControlIndexChanged:(id)sender {
    if (self.fromSearch)
    {
        if(self.segmentedControl.selectedSegmentIndex==0)
        {
            [UIView beginAnimations:@"animation" context:nil];
            [self performSegueWithIdentifier:@"FromSearchEnthusiastSegue" sender:self];
            [UIView setAnimationDuration:0.8];
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
            [UIView commitAnimations];
        }
    }
    else
    {
        if(self.segmentedControl.selectedSegmentIndex==0)
        {
            [UIView beginAnimations:@"animation" context:nil];
            [UIView setAnimationDuration:0.8];
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
            [UIView commitAnimations];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
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

#pragma mark - image picker methods

- (IBAction)onImageViewButtonPressed:(id)sender
{
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
    
	if((UIButton *) sender == self.myAvatarPhotoButton)
    {
		picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
	} else
    {
		picker.sourceType = UIImagePickerControllerSourceTypeCamera;
	}
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [[picker presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    
    // saving a uiimage to pffile
    UIImage *pickedImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    NSData* data = UIImagePNGRepresentation(pickedImage);// UIImageJPEGRepresentation(pickedImage,1.0f);
    PFFile *imageFile = [PFFile fileWithData:data];
    PFUser *user = [PFUser currentUser];
    
    user[@"avatar"] = imageFile;
    
    // getting a uiimage from pffile
    [user[@"avatar"] getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            UIImage *photo = [UIImage imageWithData:data];
            self.avatarImageView.image = photo;
        }
    }];
    
    [user saveInBackground];
}

#pragma mark - segue methods

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ConversationBoxSegue"])
    {
        ProfileConversationBoxViewController *pcbvc = segue.destinationViewController;
        pcbvc.conversationArray = self.conversationArray;
    }
    else if ([segue.identifier isEqualToString:@"AddInterestFromEnthusiastSegue"])
    {
        AddToShareViewController *atsvc = segue.destinationViewController;
        atsvc.fromEnthusiast = 1;
    }
    else if ([segue.identifier isEqualToString:@"FromSearchEnthusiastSegue"])
    {
        ProfileViewController *pvc = segue.destinationViewController;
        pvc.fromSearchEnthusiast = 1;
    }
}

@end
