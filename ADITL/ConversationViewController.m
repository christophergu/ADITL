//
//  ConversationViewController.m
//  ADITL
//
//  Created by Christopher Gu on 5/28/14.
//  Copyright (c) 2014 Christopher Gu. All rights reserved.
//

#import "ConversationViewController.h"
#import <Parse/Parse.h>

@interface ConversationViewController ()
@property (strong, nonatomic) IBOutlet UITextField *writeTextField;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) PFUser *currentUser;
@property (strong, nonatomic) PFObject *message;

@property CGFloat containerViewHeight;


@end

@implementation ConversationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.currentUser = [PFUser currentUser];
    
    self.writeTextField.layer.borderColor = [[UIColor orangeColor] CGColor];
    self.writeTextField.layer.borderWidth = 1.0f;
    
    self.containerViewHeight = 0.0f;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    if (self.conversationExists)
    {
        [self displayConversationUpUntilNow];
    }
}


- (void)viewDidAppear:(BOOL)animated
{
    self.scrollView.contentSize = CGSizeMake(320, self.containerViewHeight + 216);
    if (self.containerViewHeight >= 258)
    {
        [self.scrollView setContentOffset:CGPointMake(0, self.containerViewHeight - 322)];
    }
    self.scrollView.scrollEnabled = YES;
    self.scrollView.userInteractionEnabled = YES;
}

#pragma mark - keyboard methods

- (void)keyboardWillShow:(NSNotification*)notification
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    [UIView setAnimationCurve:[notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]];
    [UIView setAnimationBeginsFromCurrentState:YES];
    self.writeTextField.frame = CGRectMake(self.writeTextField.frame.origin.x, self.writeTextField.frame.origin.y-216, self.writeTextField.frame.size.width, self.writeTextField.frame.size.height);
    [UIView commitAnimations];
}

- (void)keyboardWillBeHidden:(NSNotification*)notification
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    [UIView setAnimationCurve:[notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]];
    [UIView setAnimationBeginsFromCurrentState:YES];
    self.writeTextField.frame = CGRectMake(self.writeTextField.frame.origin.x, self.writeTextField.frame.origin.y+216, self.writeTextField.frame.size.width, self.writeTextField.frame.size.height);
    [UIView commitAnimations];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - managing the messages methods

- (IBAction)writeTextFieldDidEndOnExit:(id)sender
{
    // adding the typed message
    UITextView *messageTextView = [[UITextView alloc] init];
    messageTextView.text = self.writeTextField.text;
    CGFloat fixedWidth = 320;
    CGSize newSize = [messageTextView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = messageTextView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    messageTextView.frame = newFrame;
    messageTextView.layer.backgroundColor = [[UIColor colorWithRed:255/255.0f green:235/255.0f blue:175/255.0f alpha:1.0f] CGColor];
    messageTextView.layer.cornerRadius = 5.0;
    [self.scrollView addSubview:messageTextView];
    messageTextView.frame = CGRectMake(0, self.containerViewHeight, messageTextView.frame.size.width, messageTextView.frame.size.height);
    [messageTextView sizeToFit];
    
    self.containerViewHeight += messageTextView.frame.size.height;
    
    // adding the writers name to the message
    UILabel *writerLabel = [[UILabel alloc] init];
    writerLabel.text = [NSString stringWithFormat:@"by %@",self.currentUser[@"username"]];
    [writerLabel setFont:[UIFont systemFontOfSize:12]];
    [self.scrollView addSubview:writerLabel];
    writerLabel.frame = CGRectMake(0, self.containerViewHeight, 320, 30);
    [writerLabel sizeToFit];
    
    // adding the timestamp to the message
    NSDate *date = [[NSDate alloc] init];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"HH:mm:ss MM-dd-yyyy"];
    NSString *formattedDateString = [dateFormat stringFromDate:date];
    
    UILabel *timestampLabel = [[UILabel alloc] init];
    timestampLabel.text = [NSString stringWithFormat:@"%@",formattedDateString];
    timestampLabel.textColor = [UIColor lightGrayColor];
    timestampLabel.font = [UIFont italicSystemFontOfSize:10];
    [self.scrollView addSubview:timestampLabel];
    timestampLabel.frame = CGRectMake(0, self.containerViewHeight + 12, 320, 42);
    [timestampLabel sizeToFit];
    
    self.containerViewHeight += (writerLabel.frame.size.height + timestampLabel.frame.size.height);
    
    [self.writeTextField endEditing:YES];
    self.writeTextField.text = nil;
    
    // saving the new message into the cloud and into the conversation object on the cloud
    self.message = [PFObject objectWithClassName:@"Message"];
    self.message[@"senderString"] = self.currentUser[@"username"];
    self.message[@"body"] = messageTextView.text;
    self.message[@"timestamp"] = formattedDateString;
    self.message[@"belongsToConversationWithDate"] = self.conversation[@"createdDate"];

    [self.message saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        PFQuery *query = [PFQuery queryWithClassName:@"Message"];
        [query whereKey:@"belongsToConversationWithDate" equalTo:self.conversation[@"createdDate"]];
        [query countObjectsInBackgroundWithBlock:^(int count, NSError *error) {
            if (!error) {
                NSMutableDictionary *messageCounterHelperDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@(count), self.currentUser.objectId, nil];
                NSMutableArray *markedForDeletionArray = [NSMutableArray new];
                NSMutableArray *tempCounterHelperArray = [NSMutableArray new];
                
                if (![self.conversation[@"messageCounterHelper"] isEqual:[NSNull null]]) {
                    tempCounterHelperArray = [self.conversation[@"messageCounterHelper"] mutableCopy];
                }
                
                // keeping track of count for each user in the conversation
                if ([self.conversation[@"mcHelperIDsArray"] containsObject:self.currentUser.objectId])
                {
                    for (NSMutableDictionary *dict in self.conversation[@"messageCounterHelper"])
                    {
                        if ([dict valueForKey:self.currentUser.objectId]!=nil)
                        {
                            [markedForDeletionArray addObject:dict];
                        }
                    }
                    [tempCounterHelperArray removeObjectsInArray:markedForDeletionArray];
                }
                else
                {
                    [self.conversation addObject:self.currentUser.objectId forKey:@"mcHelperIDsArray"];
                }

                if (tempCounterHelperArray)
                {
                    self.conversation[@"messageCounterHelper"] = tempCounterHelperArray;
                }
                [self.conversation addObject:messageCounterHelperDictionary forKey:@"messageCounterHelper"];
            }
            else
            {
                // The request failed
            }
            [self.conversation saveInBackground];
        }];
    }];
    
    [self.scrollView setContentOffset:CGPointMake(0, self.containerViewHeight)];
    self.scrollView.contentSize = CGSizeMake(320, (self.scrollView.contentSize.height + (messageTextView.frame.size.height + writerLabel.frame.size.height + timestampLabel.frame.size.height)));
    [self.scrollView setNeedsDisplay];
}


- (void)displayConversationUpUntilNow
{
    __block NSArray *messageArray;
    
    PFQuery *messageQuery = [PFQuery queryWithClassName:@"Message"];
    [messageQuery whereKey:@"belongsToConversationWithDate" equalTo:self.conversation[@"createdDate"]];
    [messageQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        messageArray = objects;
        
        for (PFObject *message in messageArray)
        {
            // adding the typed message
            UITextView *messageTextView = [[UITextView alloc] init];
            messageTextView.text = message[@"body"];
            CGFloat fixedWidth = 320;
            CGSize newSize = [messageTextView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
            CGRect newFrame = messageTextView.frame;
            newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
            messageTextView.frame = newFrame;
            if ([message[@"senderString"] isEqualToString:self.currentUser[@"username"]])
            {
                messageTextView.layer.backgroundColor = [[UIColor colorWithRed:255/255.0f green:235/255.0f blue:175/255.0f alpha:1.0f] CGColor];
            }
            else
            {
                messageTextView.layer.backgroundColor = [[UIColor colorWithRed:196/255.0f green:240/255.0f blue:255/255.0f alpha:1.0f] CGColor];
            }
            messageTextView.layer.cornerRadius = 5.0;
            [self.scrollView addSubview:messageTextView];
            messageTextView.frame = CGRectMake(0, self.containerViewHeight, messageTextView.frame.size.width, messageTextView.frame.size.height);
            [messageTextView sizeToFit];
            
            self.containerViewHeight += messageTextView.frame.size.height;
            
            // adding the writers name to the message
            UILabel *writerLabel = [[UILabel alloc] init];
            writerLabel.text = [NSString stringWithFormat:@"by %@",message[@"senderString"]];
            [writerLabel setFont:[UIFont systemFontOfSize:12]];
            [self.scrollView addSubview:writerLabel];
            writerLabel.frame = CGRectMake(0, self.containerViewHeight, 320, 30);
            [writerLabel sizeToFit];
            
            // adding the timestamp to the message
            UILabel *timestampLabel = [[UILabel alloc] init];
            timestampLabel.text = message[@"timestamp"];
            timestampLabel.textColor = [UIColor lightGrayColor];
            timestampLabel.font = [UIFont italicSystemFontOfSize:10];
            [self.scrollView addSubview:timestampLabel];
            timestampLabel.frame = CGRectMake(0, self.containerViewHeight + 12, 320, 42);
            [timestampLabel sizeToFit];
            
            self.containerViewHeight += (writerLabel.frame.size.height + timestampLabel.frame.size.height);
        }
    }];
}


- (IBAction)onRefreshButtonPressed:(id)sender
{
    [[self.scrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.containerViewHeight = 0;
    [self displayConversationUpUntilNow];
}

- (IBAction)onTrashButtonPressed:(id)sender
{
    UIAlertView *askingForDeleteConfirmation = [[UIAlertView alloc] initWithTitle:@"Confirm Removal"
                                                                          message:@"Are you sure you want to remove yourself from this conversation?"
                                                                         delegate:self
                                                                cancelButtonTitle:@"NO"
                                                                otherButtonTitles:@"YES", nil];
    [askingForDeleteConfirmation show];
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    // the user clicked one of the OK/Cancel buttons
    if (buttonIndex == 1)
    {
        [self confirmDeletion];
    }
}

- (void)confirmDeletion
{
    // removes self from this conversation
    [self.conversation removeObject:self.currentUser[@"email"] forKey:@"chattersArray"];
    
    // if there are no more recipients in this conversation then the conversation deletes itself
    [self.conversation saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if ([self.conversation[@"chattersArray"] count] == 0)
        {
            PFQuery *messageQuery = [PFQuery queryWithClassName:@"Message"];
            [messageQuery whereKey:@"belongsToConversationWithDate" equalTo:self.conversation[@"createdDate"]];
            [messageQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                for (PFObject *message in objects)
                {
                    [message deleteInBackground];
                }
            }];
            [self.conversation deleteInBackground];
        }
    }];
}

@end
