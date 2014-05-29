//
//  ConversationViewController.h
//  ADITL
//
//  Created by Christopher Gu on 5/28/14.
//  Copyright (c) 2014 Christopher Gu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ConversationViewController : UIViewController
@property (strong, nonatomic) PFObject *conversation;
@property BOOL conversationExists;
@property int viewConversationIndexPathRow;

@end
