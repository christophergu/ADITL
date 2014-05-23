//
//  SearchResultsDetailViewController.m
//  ADITL
//
//  Created by Christopher Gu on 5/19/14.
//  Copyright (c) 2014 Christopher Gu. All rights reserved.
//

#import "SearchResultsDetailViewController.h"
#import "ProfileViewController.h"

@interface SearchResultsDetailViewController ()
@property (strong, nonatomic) IBOutlet UILabel *expertiseLabel;
@property (strong, nonatomic) IBOutlet UITextView *whatICanShareTextView;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet UILabel *emailLabel;

@end

@implementation SearchResultsDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.selectedPost fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        self.expertiseLabel.text = self.selectedPost[@"expertise"];
        self.whatICanShareTextView.text = self.selectedPost[@"whatICanShare"];
        self.priceLabel.text = [NSString stringWithFormat:@"%@", self.selectedPost[@"price"]];
        self.locationLabel.text = self.selectedPost[@"locationCity"];
        self.emailLabel.text = self.selectedPost[@"email"];
    }];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SearchResultDetailsToProfileSegue"])
    {
        ProfileViewController *pvc = segue.destinationViewController;
        pvc.mentorThatPostedUser = self.selectedPost[@"mentor"];
    }
}

@end
