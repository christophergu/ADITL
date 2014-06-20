//
//  AppointmentViewController.m
//  ADITL
//
//  Created by Christopher Gu on 6/18/14.
//  Copyright (c) 2014 Christopher Gu. All rights reserved.
//

#import "AppointmentViewController.h"
#import <Parse/Parse.h>

@interface AppointmentViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSMutableArray *appointmentArray;
@property (strong, nonatomic) NSMutableArray *appointmentConfirmedArray;
@property (strong, nonatomic) PFUser *currentUser;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) NSDateFormatter *dateFormat;
@property (strong, nonatomic) IBOutlet UISegmentedControl *mySegmentedControl;

@end

@implementation AppointmentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dateFormat = [[NSDateFormatter alloc] init];
    [self.dateFormat setDateFormat:@"MM/dd/YYYY"];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.currentUser = [PFUser currentUser];
    NSArray *currentUserObjectIdArray = @[self.currentUser.objectId];
    self.appointmentArray = [NSMutableArray new];
    self.appointmentConfirmedArray = [NSMutableArray new];
    
    PFQuery *appointmentQuery = [PFQuery queryWithClassName:@"Appointment"];
    [appointmentQuery whereKey:@"senderAndReceiverArray" containsAllObjectsInArray:currentUserObjectIdArray];
    [appointmentQuery includeKey:@"sender"];
    [appointmentQuery includeKey:@"receiver"];
    [appointmentQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for (PFObject *appointment in objects)
        {
            if ([[appointment[@"receiverConfirmCheck"] allObjects].firstObject intValue] && [[appointment[@"senderConfirmCheck"] allObjects].firstObject intValue])
            {
                [self.appointmentConfirmedArray addObject:appointment];
            }
            else
            {
                [self.appointmentArray addObject:appointment];
            }
        }
        
        NSLog(@"%@", self.appointmentArray);
        NSLog(@"%@", self.appointmentConfirmedArray);

        [self.myTableView reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows;
    
    if(self.mySegmentedControl.selectedSegmentIndex==0)
    {
        numberOfRows = (NSInteger)self.appointmentArray.count;
    }
    else if(self.mySegmentedControl.selectedSegmentIndex==1)
    {
        numberOfRows = (NSInteger)self.appointmentConfirmedArray.count;
    }
    
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AppointmentCellReuseID"];
    PFUser *tempUser = self.appointmentArray[indexPath.row][@"sender"];
    
    NSString *dateString = [self.dateFormat stringFromDate: self.appointmentArray[indexPath.row][@"meetingTime"]];
    
    if(self.mySegmentedControl.selectedSegmentIndex==0)
    {
        if ([tempUser.objectId isEqualToString:self.currentUser.objectId])
        {
            cell.textLabel.text = dateString;
            cell.detailTextLabel.text = self.appointmentArray[indexPath.row][@"receiver"][@"username"];
        }
        else
        {
            cell.textLabel.text = dateString;
            cell.detailTextLabel.text = self.appointmentArray[indexPath.row][@"sender"][@"username"];
        }
    }
    else if(self.mySegmentedControl.selectedSegmentIndex==1)
    {
        if ([tempUser.objectId isEqualToString:self.currentUser.objectId])
        {
            cell.textLabel.text = dateString;
            cell.detailTextLabel.text = self.appointmentArray[indexPath.row][@"receiver"][@"username"];
        }
        else
        {
            cell.textLabel.text = dateString;
            cell.detailTextLabel.text = self.appointmentArray[indexPath.row][@"sender"][@"username"];
        }
    }

    return cell;
}
- (IBAction)onSegmentedControlIndexChanged:(id)sender {
    [self.myTableView reloadData];
}

@end
