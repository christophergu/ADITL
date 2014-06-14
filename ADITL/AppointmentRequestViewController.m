//
//  AppointmentRequestViewController.m
//  ADITL
//
//  Created by Christopher Gu on 6/13/14.
//  Copyright (c) 2014 Christopher Gu. All rights reserved.
//

#import "AppointmentRequestViewController.h"

@interface AppointmentRequestViewController ()
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *uiViewForScrollView;


@end

@implementation AppointmentRequestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)onCancelButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
