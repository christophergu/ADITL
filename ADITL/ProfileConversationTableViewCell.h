//
//  ProfileConversationTableViewCell.h
//  ADITL
//
//  Created by Christopher Gu on 6/11/14.
//  Copyright (c) 2014 Christopher Gu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileConversationTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *myNameTextLabel;
@property (strong, nonatomic) IBOutlet UIImageView *myImageView;
@property (strong, nonatomic) IBOutlet UILabel *myNewMessageLabel;

@end
