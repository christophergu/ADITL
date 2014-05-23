//
//  ProfileViewController.h
//  ADITL
//
//  Created by Christopher Gu on 5/16/14.
//  Copyright (c) 2014 Christopher Gu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ProfileViewController : UIViewController
@property (strong, nonatomic) PFUser *mentorThatPostedUser;

@end
