//
//  AppointmentTableViewCell.h
//  ADITL
//
//  Created by Christopher Gu on 6/20/14.
//  Copyright (c) 2014 Christopher Gu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppointmentTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *myDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *myNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *myStatusLabel;

@end
