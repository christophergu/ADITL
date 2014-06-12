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
    self.currentUser = [PFUser currentUser];
    self.addedMessageCheckerArray = [NSMutableArray new];
    
    NSArray *currentUserArray = @[self.currentUser[@"email"]];
    
    PFQuery *conversationQuery = [PFQuery queryWithClassName:@"ConversationThread"];
    [conversationQuery whereKey:@"chattersArray" containsAllObjectsInArray:currentUserArray];
    [conversationQuery includeKey:@"chattersUsersArray"];
    [conversationQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.conversationArray = objects;
        NSLog(@"%@",self.conversationArray);
        
        // check if there are new messages from the last time this user viewed
        for (PFObject *conversation in self.conversationArray)
        {
            PFQuery *query = [PFQuery queryWithClassName:@"Message"];
            [query whereKey:@"belongsToConversationWithDate" equalTo:conversation[@"createdDate"]];
            [query countObjectsInBackgroundWithBlock:^(int count, NSError *error) {
                if (!error) {
                    for (NSDictionary *counterHelper in conversation[@"messageCounterHelper"])
                    {
                        NSArray *messageCounterHelperKeyArray = [counterHelper allKeys];

                        if ([self.currentUser.objectId isEqualToString: messageCounterHelperKeyArray.firstObject])
                        {
                            int previousMessageCount = [counterHelper[self.currentUser.objectId] intValue];
                            
                            if (previousMessageCount < count)
                            {
                                NSLog(@"different count");
                                [self.addedMessageCheckerArray addObject:@1];
                            }
                            else
                            {
                                NSLog(@"same count");
                                [self.addedMessageCheckerArray addObject:@0];
                            }
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
                
                if (self.addedMessageCheckerArray.count)
                {
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
                    NSLog(@"show");
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
