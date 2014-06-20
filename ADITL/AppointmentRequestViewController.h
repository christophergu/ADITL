//
//  AppointmentRequestViewController.h
//  ADITL
//
//  Created by Christopher Gu on 6/13/14.
//  Copyright (c) 2014 Christopher Gu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface AppointmentRequestViewController : UIViewController
@property (strong, nonatomic) PFUser *chosenUser;
@property (strong, nonatomic) PFObject *selectedAppointment;
@property int checkingAppointmentRequest;

@end
