//
//  LogInViewController.h
//  ADITL
//
//  Created by Christopher Gu on 5/16/14.
//  Copyright (c) 2014 Christopher Gu. All rights reserved.
//

#import <Parse/Parse.h>

@interface LogInViewController : PFLogInViewController
@property (strong, nonatomic) PFObject *post;
@property BOOL becauseLoginRequired;
@property (strong, nonatomic) NSString *mentorString;
@property (strong, nonatomic) PFObject *conversation;

@end