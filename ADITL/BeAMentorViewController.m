//
//  BeAMentorViewController.m
//  ADITL
//
//  Created by Christopher Gu on 5/14/14.
//  Copyright (c) 2014 Christopher Gu. All rights reserved.
//

#import "BeAMentorViewController.h"

@interface BeAMentorViewController ()
@property (strong, nonatomic) IBOutlet UITextField *expertiseTextField;
@property (strong, nonatomic) IBOutlet UITextView *whatICanShareTextView;
@property (strong, nonatomic) IBOutlet UITextField *priceTextField;
@property (strong, nonatomic) IBOutlet UITextField *locationTextField;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;

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



@end