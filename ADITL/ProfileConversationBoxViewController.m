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

@end

@implementation ProfileConversationBoxViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.currentUser = [PFUser currentUser];
    
    PFQuery *conversationQuery = [PFQuery queryWithClassName:@"ConversationThread"];
    [conversationQuery includeKey:@"chattersUsersArray"];
    [conversationQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.conversationWithUsersArray = objects;
        
        [self.myTableView reloadData];
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
                NSLog(@"%@",user);
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
