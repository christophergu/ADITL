//
//  AppointmentRequestViewController.m
//  ADITL
//
//  Created by Christopher Gu on 6/13/14.
//  Copyright (c) 2014 Christopher Gu. All rights reserved.
//

#import "AppointmentRequestViewController.h"

#define allTrim( object ) [object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet] ]

@interface AppointmentRequestViewController ()
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *uiViewForScrollView;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) IBOutlet UITextField *meetingTimeTextField;
@property (strong, nonatomic) IBOutlet UIView *uiViewWithDatePicker;
@property BOOL timeBoolForButton;
@property (strong, nonatomic) IBOutlet UITextField *meetingLocationTextField;
@property (strong, nonatomic) PFUser *currentUser;


@end

@implementation AppointmentRequestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.currentUser = [PFUser currentUser];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.scrollView.contentSize = CGSizeMake(320, 1100);
    self.scrollView.scrollEnabled = YES;
    self.scrollView.userInteractionEnabled = YES;
    [self.scrollView addSubview:self.uiViewForScrollView];
}

- (IBAction)onConfirmButtonPressed:(id)sender
{

    
    if (!(allTrim(self.meetingTimeTextField.text).length == 0) && !(allTrim(self.meetingLocationTextField.text).length == 0) )
    {
        PFObject *appointment = [PFObject objectWithClassName:@"Appointment"];
        appointment[@"meetingTime"] = self.date;
        appointment[@"meetingLocation"] = self.meetingLocationTextField.text;
        appointment[@"sender"] = self.currentUser.objectId;
        appointment[@"receiver"] = self.chosenUser.objectId;
        appointment[@"senderConfirmCheck"] = [@{self.currentUser.objectId: @1} mutableCopy];
        appointment[@"receiverConfirmCheck"] = [@{self.chosenUser.objectId: @0} mutableCopy];
        
        [appointment saveInBackground];
        
        UILocalNotification *note = [[UILocalNotification alloc] init];
        note.alertBody = @"You have a meeting";
        note.fireDate = self.date;
        
        [[UIApplication sharedApplication] scheduleLocalNotification:note];
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
    else
    {
        UIAlertView *incompleteAlert = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                                  message:@"You much provide both a meeting time and a meeting location."
                                                                 delegate:self
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles: nil];
        [incompleteAlert show];
    }
}

- (IBAction)onCancelButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)onTimeButtonPressed:(id)sender
{
    self.datePicker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:60];
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         NSLog(@"ya");
                         self.uiViewWithDatePicker.frame = CGRectMake(0, 377, 320, 191);

     }
                     completion:^(BOOL finished){
     }];
}

- (IBAction)onDatePickerDoneButtonPressed:(id)sender {
    self.date = self.datePicker.date;
    NSLog(@"the date %@", self.date);

    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EEEE MMMM d, YYYY hh:mm aaa"];
    NSString *dateString = [dateFormat stringFromDate:self.date];
    NSLog(@"the formatted date %@", dateString);
    self.meetingTimeTextField.text = dateString;
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         NSLog(@"na");
                         self.uiViewWithDatePicker.frame = CGRectMake(0, 568, 320, 191);
                     }
                     completion:^(BOOL finished){
                     }];
}

- (IBAction)meetingLocationTextFieldDidEndOnExit:(id)sender {
    [self.meetingTimeTextField endEditing:YES];
}

@end
