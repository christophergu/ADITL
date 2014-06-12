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
@property (strong, nonatomic) NSArray *conversationWithUsersArray;
@property (strong, nonatomic) NSMutableArray *addedMessageCheckerArray;

@end

@implementation ProfileConversationBoxViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.currentUser = [PFUser currentUser];
    self.addedMessageCheckerArray = [NSMutableArray new];
    
    PFQuery *conversationQuery = [PFQuery queryWithClassName:@"ConversationThread"];
    [conversationQuery includeKey:@"chattersUsersArray"];
    [conversationQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.conversationWithUsersArray = objects;
        
        for (PFObject *conversation in self.conversationWithUsersArray)
        {
            PFQuery *query = [PFQuery queryWithClassName:@"Message"];
            [query whereKey:@"belongsToConversationWithDate" equalTo:conversation[@"createdDate"]];
            [query countObjectsInBackgroundWithBlock:^(int count, NSError *error) {
                if (!error) {
                    NSLog(@"%@",conversation[@"messageCounterHelper"]);
                    
                    NSArray *messageCounterHelperKeyArray = [conversation[@"messageCounterHelper"] allKeys];
                    
                    if ([self.currentUser.objectId isEqualToString: messageCounterHelperKeyArray.firstObject])
                    {
                        int previousMessageCount = [conversation[@"messageCounterHelper"][self.currentUser.objectId] intValue];
                        
                        NSLog(@"previous message count %d",previousMessageCount);


                        if (previousMessageCount < count)
                        {
                            NSLog(@"different count");
                            [self.addedMessageCheckerArray addObject:@1];
                            [self.myTableView reloadData];
                        }
                        else
                        {
                            NSLog(@"same count");
                            [self.addedMessageCheckerArray addObject:@0];
                            [self.myTableView reloadData];
                        }
                    }
                    else
                    {
                        [self.myTableView reloadData];
                    }
                }
                else
                {
                    NSLog(@"error counting");
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
    
    if (self.conversationWithUsersArray)
    {
        for (PFUser *user in self.conversationWithUsersArray[indexPath.row][@"chattersUsersArray"])
        {
            if (![user[@"email"] isEqualToString:self.currentUser.email])
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
                
                
//                BOOL b = [[self.addedMessageCheckerArray objectAtIndex:indexPath.row] boolValue];
//                if (b)
//                {
//                    NSLog(@"show");
//                    cell.myNewMessageLabel.alpha = 1.0;
//                }
//                else
//                {
//                    NSLog(@"don't show");
//                    cell.myNewMessageLabel.alpha = 0.0;
//                }
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
