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
#import "AppointmentRequestViewController.h"
#import <MapKit/MapKit.h>
#import <AddressBook/AddressBook.h>
#import <QuartzCore/QuartzCore.h>


#define allTrim( object ) [object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet] ]

@interface ProfileViewController () <UIScrollViewDelegate,UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate, MKMapViewDelegate>
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *uiViewForScrollView;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;
@property (strong, nonatomic) IBOutlet UIButton *dismissKeyboardButton;

@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
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
@property (strong, nonatomic) IBOutlet UIButton *myAvatarPhotoButton;
@property (strong, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (strong, nonatomic) IBOutlet UILabel *appointmentCounterLabel;
@property (strong, nonatomic) IBOutlet UIButton *websiteButton;
@property (strong, nonatomic) IBOutlet UILabel *conversationStartLabel;
@property (strong, nonatomic) IBOutlet UILabel *appointmentRequestLabel;
@property (strong, nonatomic) IBOutlet UIButton *findLocationButton;
@property (strong, nonatomic) IBOutlet UILabel *findLocationLabel;


@end

@implementation ProfileViewController

-(void)viewWillAppear:(BOOL)animated
{
    self.segmentedControl.selectedSegmentIndex=0;
    [self fetchInterestsToShare];
    
    if (self.fromSearch || self.fromSearchEnthusiast)
    {
        [self.leaderChosenFromSearch[@"avatar"] getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
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
    
    // checks which view controller directed you here
    if (self.fromSearchEnthusiast)
    {
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"back"
                                                                       style:UIBarButtonItemStyleBordered
                                                                      target:self
                                                                      action:@selector(handleBack:)];
        self.navigationItem.leftBarButtonItem = backButton;
        
        [self.logoutBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor clearColor]} forState:UIControlStateNormal];
        self.logoutBarButtonItem.enabled = NO;
    }
    
    if (self.fromSearch || self.fromSearchEnthusiast)
    {
        if (!(allTrim(self.websiteButton.titleLabel.text).length == 0))
        {
            self.websiteButton.alpha = 1.0;
            [self.websiteButton setTitle:self.leaderChosenFromSearch[@"website"] forState:UIControlStateNormal];
        }
        
        self.findLocationLabel.alpha = 0.0;
        self.findLocationButton.alpha = 0.0;
        self.interestAddButton.alpha = 0.0;
        self.interestEditDelButton.alpha = 0.0;
        self.conversationCounterLabel.alpha = 0.0;
        self.appointmentCounterLabel.alpha = 0.0;
        self.conversationStartLabel.alpha = 1.0;
        self.appointmentRequestLabel.alpha = 1.0;
        
        self.nameTextField.borderStyle = UITextBorderStyleNone;
        self.nameTextField.enabled = NO;
        self.locationTextField.borderStyle = UITextBorderStyleNone;
        self.locationTextField.enabled = NO;
        self.websiteTextField.alpha = 0.0;
        self.emailTextField.alpha = 0.0;
        self.passwordTextField.alpha = 0.0;
        self.aboutMeTextView.editable = NO;
        
        [self.logoutBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor clearColor]} forState:UIControlStateNormal];
        self.logoutBarButtonItem.enabled = NO;
        
        self.nameTextField.text = self.leaderChosenFromSearch[@"username"];
        self.emailTextField.text = self.leaderChosenFromSearch[@"email"];
    }
    else
    {
        // this is if it's your own profile
        
        // check if you already have a location before assigning findlocationlabel's alpha
        if (self.currentUser[@"city"] && self.currentUser[@"state"]) {
            self.findLocationLabel.alpha = 0.0;
            self.locationTextField.text = [NSString stringWithFormat:@"%@, %@",self.currentUser[@"city"],self.currentUser[@"state"]];
        }
        else
        {
            self.findLocationLabel.alpha = 1.0;

        }
        
        self.websiteButton.alpha = 0.0;
        self.conversationCounterLabel.alpha = 1.0;
        self.appointmentCounterLabel.alpha = 1.0;
        self.conversationStartLabel.alpha = 0.0;
        self.appointmentRequestLabel.alpha = 0.0;
        
        self.findLocationLabel.layer.cornerRadius = 5.0f;
        self.findLocationButton.alpha = 1.0;
        self.findLocationButton.layer.cornerRadius = 5.0f;
        
        self.interestAddButton.layer.cornerRadius = 5.0f;
        self.interestEditDelButton.layer.cornerRadius = 5.0f;
        
        self.aboutMeTextView.textColor = [UIColor colorWithWhite: 0.8 alpha:1]; //optional
        [self.aboutMeTextView.layer setBorderColor:[[UIColor colorWithWhite: 0.8 alpha:1] CGColor]];
        [self.aboutMeTextView.layer setBorderWidth:0.5];
        self.aboutMeTextView.layer.cornerRadius = 5;
        self.aboutMeTextView.clipsToBounds = YES;
        
        self.nameTextField.text = self.currentUser[@"username"];
        self.passwordTextField.text = self.currentUser[@"password"]; // change placeholder to "Change password?"
        self.emailTextField.text = self.currentUser[@"email"];
    }
    
    
    NSArray *currentUserArray = @[self.currentUser.objectId];
    
    PFQuery *conversationQuery = [PFQuery queryWithClassName:@"ConversationThread"];
    [conversationQuery whereKey:@"chattersArray" containsAllObjectsInArray:currentUserArray];
    
    [conversationQuery  countObjectsInBackgroundWithBlock:^(int count, NSError *error) {
        self.conversationCounterLabel.text = [NSString stringWithFormat:@"x%d",count];
    }];
    
    PFQuery *appointmentQuery = [PFQuery queryWithClassName:@"Appointment"];
    [appointmentQuery whereKey:@"senderAndReceiverArray" containsAllObjectsInArray:currentUserArray];
    
    [appointmentQuery  countObjectsInBackgroundWithBlock:^(int count, NSError *error) {
        self.appointmentCounterLabel.text = [NSString stringWithFormat:@"x%d",count];
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.scrollView.contentSize = CGSizeMake(320, 1100);
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

#pragma mark - location methods
// this delegate is called when the app successfully finds your current location
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    // this creates a MKReverseGeocoder to find a placemark using the found coordinates
    MKReverseGeocoder *geoCoder = [[MKReverseGeocoder alloc] initWithCoordinate:newLocation.coordinate];
    geoCoder.delegate = self;
    [geoCoder start];
}


// this delegate method is called if an error occurs in locating your current location
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"locationManager:%@ didFailWithError:%@", manager, error);
}

// update these deprecated with CLGeocoder

// this delegate is called when the reverseGeocoder finds a placemark
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark
{
    MKPlacemark * myPlacemark = placemark;
    // with the placemark you can now retrieve the city name
    NSString *city = [myPlacemark.addressDictionary objectForKey:(NSString*) kABPersonAddressCityKey];
    NSString *state = [myPlacemark.addressDictionary objectForKey:(NSString*) kABPersonAddressStateKey];

    [self.locationManager stopUpdatingLocation];
    
    self.currentUser[@"city"] = city;
    self.currentUser[@"state"] = state;
    self.currentUser[@"latitude"] = @(self.locationManager.location.coordinate.latitude);
    self.currentUser[@"longitude"] = @(self.locationManager.location.coordinate.longitude);
    [self.currentUser saveInBackground];
    
    // findLocationLabel animations
    [UIView animateKeyframesWithDuration:2.0f delay:0.0f options:0 animations:^{
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.25 animations:^{
            self.findLocationLabel.text = @"Searching...";
            self.findLocationLabel.alpha = 1.0;
        }];
        [UIView addKeyframeWithRelativeStartTime:0.25 relativeDuration:0.5 animations:^{
            // do nothing
        }];
        [UIView addKeyframeWithRelativeStartTime:0.75 relativeDuration:0.25 animations:^{
            self.locationTextField.text = [NSString stringWithFormat:@"%@, %@",city, state];
            self.findLocationLabel.alpha = 0.0;
        }];
    } completion:^(BOOL finished) {
        
    }];
    

}

// this delegate is called when the reversegeocoder fails to find a placemark
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error
{
    NSLog(@"reverseGeocoder:%@ didFailWithError:%@", geocoder, error);
}

#pragma mark - helpter methods

- (void)fetchInterestsToShare
{
    self.interestGroupsArray = [NSMutableArray new];
    
    PFQuery *postQuery = [PFQuery queryWithClassName:@"LeaderInterest"];
    [postQuery whereKey:@"leaderEmail" equalTo:self.currentUser.email];
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
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

- (IBAction)segmentedControlIndexChanged:(id)sender {
    if(self.segmentedControl.selectedSegmentIndex==1)
    {

    }
}

- (IBAction)onWebsiteButtonPressed:(id)sender
{
    
}

- (IBAction)onSaveButtonPressed:(id)sender
{
    self.currentUser.username = self.nameTextField.text;
    self.currentUser.password = self.passwordTextField.text;
    self.currentUser.email = self.emailTextField.text;
    self.currentUser[@"website"] = self.websiteTextField.text;
    
    [self.currentUser saveInBackground];
}

- (IBAction)onEnthusiastSubstituteButtonPressed:(id)sender
{
    if (self.fromSearchEnthusiast)
    {
        [UIView beginAnimations:@"animation" context:nil];
        [UIView setAnimationDuration:0.8];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
        [UIView commitAnimations];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [UIView beginAnimations:@"animation" context:nil];
        [self performSegueWithIdentifier:@"FromLeaderSegue" sender:self];
        [UIView setAnimationDuration:0.8];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
        [UIView commitAnimations];
    }
}

- (IBAction)onFindLocationButtonPressed:(id)sender
{
    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    [self.locationManager startUpdatingLocation];
}

- (IBAction)onDismissKeyboardButtonPressed:(id)sender
{
    [self.nameTextField endEditing:YES];
    [self.locationTextField endEditing:YES];
    [self.aboutMeTextView endEditing:YES];
    [self.websiteTextField endEditing:YES];
    [self.emailTextField endEditing:YES];
    [self.passwordTextField endEditing:YES];
}

- (IBAction)onAppointmentButtonPressed:(id)sender
{
    if (self.leaderChosenFromSearch && [self.currentUser[@"email"] isEqual:self.leaderChosenFromSearch[@"email"]])
    {
        UIAlertView *yourselfAlert = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                                message:@"This is your own profile."
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles: nil];
        [yourselfAlert show];
    }
    else if (self.fromSearch || self.fromSearchEnthusiast)
    {
        [self performSegueWithIdentifier:@"AppointmentRequestSegue" sender:self];
    }
    else
    {
        NSLog(@"this is your own profile and appointments");
        [self performSegueWithIdentifier:@"AppointmentListSegue" sender:self];
    }
}

- (IBAction)onConversationButtonPressed:(id)sender
{
    if (self.leaderChosenFromSearch && [self.currentUser[@"email"] isEqual:self.leaderChosenFromSearch[@"email"]])
    {
        UIAlertView *yourselfAlert = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                                message:@"This is your own profile."
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles: nil];
        [yourselfAlert show];
    }
    else if (self.fromSearch || self.fromSearchEnthusiast)
    {
        NSLog(@"this is for starting a new conversation");
        PFObject *conversation = [PFObject objectWithClassName:@"ConversationThread"];
        conversation[@"senderString"] = self.currentUser[@"username"];
        conversation[@"chattersArray"] = @[self.currentUser.objectId,self.leaderChosenFromSearch.objectId];
        [conversation addObject:self.currentUser forKey:@"chattersUsersArray"];
        [conversation addObject:self.leaderChosenFromSearch forKey:@"chattersUsersArray"];
        conversation[@"createdDate"] = [NSDate date];
        self.conversationArray = @[conversation];
        
        [conversation saveInBackground];
        [self performSegueWithIdentifier:@"ConversationBoxSegue" sender:self];
    }
    else
    {
        NSLog(@"this is your own profile and conversations");
        [self performSegueWithIdentifier:@"ConversationBoxSegue" sender:self];
    }
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
    else if ([segue.identifier isEqualToString:@"FromLeaderSegue"])
    {
        EnthusiastProfileViewController *epvc = segue.destinationViewController;
        epvc.enthusiastChosenFromSearch = self.leaderChosenFromSearch;
        epvc.fromSearchLeader = 1;
    }
    else if ([segue.identifier isEqualToString:@"AppointmentRequestSegue"])
    {
        AppointmentRequestViewController *arvc = segue.destinationViewController;
        arvc.chosenUser = self.leaderChosenFromSearch;
    }
}

@end
