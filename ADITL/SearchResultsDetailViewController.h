//
//  SearchResultsDetailViewController.h
//  ADITL
//
//  Created by Christopher Gu on 5/19/14.
//  Copyright (c) 2014 Christopher Gu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface SearchResultsDetailViewController : UIViewController
@property (strong, nonatomic) PFObject *selectedPost;

@end
