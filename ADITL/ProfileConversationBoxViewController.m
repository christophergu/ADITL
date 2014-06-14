//
//  ProfileConversationBoxViewController.m
//  ADITL
//
//  Created by Christopher Gu on 5/28/14.
//  Copyright (c) 2014 Christopher Gu. All rights reserved.
//

#import "ProfileConversationBoxViewController.h"
#import "ProfileConversationTableViewCell.h"
#import "ConversationViewController.h"

@interface ProfileConversationBoxViewController ()<UITableViewDataSource, UITableViewDelegate>
@property int viewConversationIndexPathRow;
@property (strong, nonatomic) PFUser *currentUser;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) NSMutableArray *addedMessageCheckerArray;

@end

@implementation ProfileConversationBoxViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"view will appear");
    self.currentUser = [PFUser currentUser];
    self.addedMessageCheckerArray = [NSMutableArray new];
    
    PFQuery *conversationQuery = [PFQuery queryWithClassName:@"ConversationThread"];
    [conversationQuery whereKey:@"chattersArray" containsAllObjectsInArray:@[self.currentUser[@"email"]]];
    [conversationQuery includeKey:@"chattersUsersArray"];
    [conversationQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.conversationArray = objects;
        
        // checks if there are new messages from the last time this user viewed
        for (PFObject *conversation in self.conversationArray)
        {
            PFQuery *query = [PFQuery queryWithClassName:@"Message"];
            [query whereKey:@"belongsToConversationWithDate" equalTo:conversation[@"createdDate"]];
            [query countObjectsInBackgroundWithBlock:^(int count, NSError *error) {
                if (!error) {
                    // goes through each messageCounterHelper and finds the object that corresponds to the current
                    // user's message records, if it is the current user testing to see if there are new messages
                    // wil commence
                    for (NSDictionary *counterHelper in conversation[@"messageCounterHelper"])
                    {
                        NSArray *messageCounterHelperKeyArray = [counterHelper allKeys];
                        
                        if ([self.currentUser.objectId isEqualToString: messageCounterHelperKeyArray.firstObject])
                        {
                            int previousMessageCount = [counterHelper[self.currentUser.objectId] intValue];
                            
                            // populates an array that the table cells correspond with that tell the cell whether or not
                            // there is a new message for the current user
                            if (previousMessageCount < count)
                            {
                                NSLog(@"different count previousMessageCount %d  count %d",previousMessageCount, count);
                                [self.addedMessageCheckerArray addObject:@1];
                            }
                            else
                            {
                                NSLog(@"same count");
                                [self.addedMessageCheckerArray addObject:@0];
                            }
                        }
                        else
                        {
                            NSLog(@"empty conversation");
                            [self.addedMessageCheckerArray addObject:@1];
                        }
                    }
                    [self.myTableView reloadData];
                }
                else
                {
                    //                    NSLog(@"error counting");
                }
            }];
        }
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.conversationArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProfileConversationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ConversationCellReuseID"];
    
    if (self.conversationArray)
    {
        for (PFUser *user in self.conversationArray[indexPath.row][@"chattersUsersArray"])
        {
            if (![user.objectId isEqualToString:self.currentUser.objectId])
            {
                cell.myNameTextLabel.text = user.username;
                
                if (user[@"avatar"])
                {
                    [user[@"avatar"] getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                        if (!error) {
                            UIImage *photo = [UIImage imageWithData:data];
                            cell.myImageView.image = photo;
                        }
                    }];
                }
                else
                {
                    cell.myImageView.image = [UIImage imageNamed:@"default_user"];
                }
                
                // if the current user has written any messages then a messageCounterHelper object will have been made
                // if a messageCounterHelper object exists, an addedMessageCheckerArray will have been populated
                // the cell is checking if it's corresponding index in the addedMessageCheckerArray says it should
                // display a NEW message notice or not
                
                // to fix the bug preventing two different chat threads, somthing checking if something was written yet checker
                // needs to be fixed because it there are no messages for the new thread and once it gets here this
                // addedMessageCheckerArray is empty
                if (self.addedMessageCheckerArray.count)
                {
                    NSLog(@"addedmessagecheckerarray %@",self.addedMessageCheckerArray);
                    BOOL b = [[self.addedMessageCheckerArray objectAtIndex:indexPath.row] boolValue];
                    if (b)
                    {
                        NSLog(@"show");
                        cell.myNewMessageLabel.alpha = 1.0;
                    }
                    else
                    {
                        NSLog(@"don't show");
                        cell.myNewMessageLabel.alpha = 0.0;
                    }
                }
                else
                {
                    NSLog(@"didn't write a message yet, show");
                    cell.myNewMessageLabel.alpha = 1.0;
                }
            }
        }
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.viewConversationIndexPathRow = (int)indexPath.row;
    [self performSegueWithIdentifier:@"ProfileViewConversationSegue" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ProfileViewConversationSegue"])
    {
        ConversationViewController *cvc = segue.destinationViewController;
        cvc.conversation = self.conversationArray[self.viewConversationIndexPathRow];
        cvc.conversationExists = 1;
    }
}

@end
