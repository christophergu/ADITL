//
//  SearchResultsDetailViewController.m
//  ADITL
//
//  Created by Christopher Gu on 5/19/14.
//  Copyright (c) 2014 Christopher Gu. All rights reserved.
//

#import "SearchResultsDetailViewController.h"
#import "ConversationViewController.h"
#import "LogInViewController.h"
#import "ProfileViewController.h"

@interface SearchResultsDetailViewController ()
@property (strong, nonatomic) IBOutlet UILabel *expertiseLabel;
@property (strong, nonatomic) IBOutlet UITextView *whatICanShareTextView;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet UILabel *emailLabel;
@property (strong, nonatomic) PFUser *currentUser;
@property (strong, nonatomic) PFObject *conversation;
@property (strong, nonatomic) PFObject *mentorOfSelectedPost;


@end

@implementation SearchResultsDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    PFQuery *postQuery = [PFQuery queryWithClassName:@"MentorPost"];
    [postQuery includeKey:@"mentor"];
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.expertiseLabel.text = self.selectedPost[@"expertise"];
        self.whatICanShareTextView.text = self.selectedPost[@"whatICanShare"];
        self.priceLabel.text = [NSString stringWithFormat:@"%@", self.selectedPost[@"price"]];
        self.locationLabel.text = self.selectedPost[@"locationCity"];
        self.emailLabel.text = self.selectedPost[@"email"];
        self.mentorOfSelectedPost = self.selectedPost[@"mentor"];
    }];
}

- (IBAction)onContactButtonPressed:(id)sender
{
    self.currentUser = [PFUser currentUser];
    
    if (self.currentUser)
    {
        if (self.conversation)
        {
            [self performSegueWithIdentifier:@"ConversationExistsVCSegue" sender:self];
        }
        else
        {
            [self.mentorOfSelectedPost fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                self.conversation = [PFObject objectWithClassName:@"ConversationThread"];
                self.conversation[@"senderString"] = self.currentUser[@"email"];
                [self.conversation addObject:self.mentorOfSelectedPost[@"email"] forKey:@"chattersArray"];
                [self.conversation addObject:self.currentUser[@"email"] forKey:@"chattersArray"];
                self.conversation[@"createdDate"] = [NSDate date];
                //            [self.conversation saveInBackground];
                
                [self performSegueWithIdentifier:@"ConversationVCSegue" sender:self];
            }];
        }
    }
    else
    {
        UIAlertView *notLoggedInAlert = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"You need to be logged in to contact a mentor.\n\nWould you like to log in now?" delegate:self cancelButtonTitle:@"Yes!" otherButtonTitles: nil];
        [notLoggedInAlert show];
    }
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0)
    {
        if (!self.currentUser)
        {
            [self performSegueWithIdentifier:@"SRDetailToLoginSegue" sender:self];
        }
    }
}

- (IBAction)unwindToSRDetail:(UIStoryboardSegue *)unwindSegue
{

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SearchResultDetailsToProfileSegue"])
    {
        ProfileViewController *pvc = segue.destinationViewController;
        pvc.mentorThatPostedUser = self.selectedPost[@"mentor"];
    }
    else if ([segue.identifier isEqualToString:@"ConversationExistsVCSegue"])
    {
        ConversationViewController *cvc = segue.destinationViewController;
        cvc.conversation = self.conversation;
        cvc.conversationExists = 1;
    }
    else if ([segue.identifier isEqualToString:@"ConversationVCSegue"])
    {
        ConversationViewController *cvc = segue.destinationViewController;
        cvc.conversation = self.conversation;
        cvc.conversationExists = 0;
    }
    else if ([segue.identifier isEqualToString:@"SRDetailToLoginSegue"])
    {
        LogInViewController *cvc = segue.destinationViewController;
        cvc.becauseLoginRequired = 1.0;
        cvc.conversation = self.conversation;
    }
}

@end
