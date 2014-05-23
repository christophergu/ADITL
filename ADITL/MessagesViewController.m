//
//  MessagesViewController.m
//  ADITL
//
//  Created by Christopher Gu on 5/22/14.
//  Copyright (c) 2014 Christopher Gu. All rights reserved.
//

#import "MessagesViewController.h"

@interface MessagesViewController () <UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UITextView *messageInputTextView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *messageHolderView;

@end

@implementation MessagesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //    self.scrollView.pagingEnabled = YES;
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, 320, 200)];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    self.scrollView.scrollEnabled = YES;
    self.scrollView.userInteractionEnabled = YES;
    self.scrollView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.scrollView];
    
    self.messageHolderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height/2)]; //LOOK HERE DIVIDED BY 2
    self.messageHolderView.backgroundColor = [UIColor redColor];
    [self.scrollView addSubview:self.messageHolderView];
    

    
    
    NSLayoutConstraint *scrollViewConstraint1 = [NSLayoutConstraint constraintWithItem:self.scrollView
                                                                                    attribute:NSLayoutAttributeTop
                                                                                    relatedBy:NSLayoutRelationEqual
                                                                                       toItem:self.view
                                                                                    attribute:NSLayoutAttributeTop
                                                                                   multiplier:1.0f
                                                                                     constant:0.0f];
    [self.view addConstraint:scrollViewConstraint1];
    
    NSLayoutConstraint *scrollViewConstraint2 = [NSLayoutConstraint constraintWithItem:self.scrollView
                                                                                    attribute:NSLayoutAttributeBottom
                                                                                    relatedBy:NSLayoutRelationEqual
                                                                                       toItem:self.view
                                                                                    attribute:NSLayoutAttributeBottom
                                                                                   multiplier:1.0f
                                                                                     constant:0.0f];
    [self.view addConstraint:scrollViewConstraint2];
    
    NSLayoutConstraint *scrollViewConstraint3 = [NSLayoutConstraint constraintWithItem:self.scrollView
                                                                                    attribute:NSLayoutAttributeTrailing
                                                                                    relatedBy:NSLayoutRelationEqual
                                                                                       toItem:self.scrollView
                                                                                    attribute:NSLayoutAttributeTrailing
                                                                                   multiplier:1.0f
                                                                                     constant:0.0f];
    [self.scrollView addConstraint:scrollViewConstraint3];
    
    NSLayoutConstraint *scrollViewConstraint4 = [NSLayoutConstraint constraintWithItem:self.scrollView
                                                                                    attribute:NSLayoutAttributeLeading
                                                                                    relatedBy:NSLayoutRelationEqual
                                                                                       toItem:self.view
                                                                                    attribute:NSLayoutAttributeLeading
                                                                                   multiplier:1.0f
                                                                                     constant:0.0f];
    [self.view addConstraint:scrollViewConstraint4];
    
    
    
    
    
    NSLayoutConstraint *messageHolderViewConstraint1 = [NSLayoutConstraint constraintWithItem:self.messageHolderView
                                                                                    attribute:NSLayoutAttributeTop
                                                                                    relatedBy:NSLayoutRelationEqual
                                                                                       toItem:self.scrollView
                                                                                    attribute:NSLayoutAttributeTop
                                                                                   multiplier:1.0f
                                                                                     constant:0.0f];
    [self.scrollView addConstraint:messageHolderViewConstraint1];
    
    NSLayoutConstraint *messageHolderViewConstraint2 = [NSLayoutConstraint constraintWithItem:self.messageHolderView
                                                                                    attribute:NSLayoutAttributeBottom
                                                                                    relatedBy:NSLayoutRelationEqual
                                                                                       toItem:self.scrollView
                                                                                    attribute:NSLayoutAttributeBottom
                                                                                   multiplier:1.0f
                                                                                     constant:0.0f];
    [self.scrollView addConstraint:messageHolderViewConstraint2];
    
    NSLayoutConstraint *messageHolderViewConstraint3 = [NSLayoutConstraint constraintWithItem:self.messageHolderView
                                                                                    attribute:NSLayoutAttributeTrailing
                                                                                    relatedBy:NSLayoutRelationEqual
                                                                                       toItem:self.scrollView
                                                                                    attribute:NSLayoutAttributeTrailing
                                                                                   multiplier:1.0f
                                                                                     constant:0.0f];
    [self.scrollView addConstraint:messageHolderViewConstraint3];
    
    NSLayoutConstraint *messageHolderViewConstraint4 = [NSLayoutConstraint constraintWithItem:self.messageHolderView
                                                                                    attribute:NSLayoutAttributeLeading
                                                                                    relatedBy:NSLayoutRelationEqual
                                                                                       toItem:self.scrollView
                                                                                    attribute:NSLayoutAttributeLeading
                                                                                   multiplier:1.0f
                                                                                     constant:0.0f];
    [self.scrollView addConstraint:messageHolderViewConstraint4];
}

- (IBAction)onDoneButtonPressed:(id)sender
{
    [self.messageInputTextView endEditing:YES];
    
    CGFloat height = 0.0f;
    
    UITextView *textViewToAdd = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    textViewToAdd.text = self.messageInputTextView.text;
    textViewToAdd.userInteractionEnabled = NO;
    textViewToAdd.backgroundColor = [UIColor greenColor];
    [self.messageHolderView addSubview:textViewToAdd];
    
    
    
//    self.messageHolderView.frame = CGRectMake(0, height, self.messageInputTextView.frame.size.width, self.messageInputTextView.frame.size.height);
//    self.messageHolderView.contentMode = UIViewContentModeScaleAspectFit;
//    height += self.messageHolderView.frame.size.height;
//
//    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, height);
    [self.scrollView setNeedsDisplay];
    if ([self.messageHolderView.subviews containsObject:self.messageInputTextView]) {
        NSLog(@"it's inside");
    }
    
    self.messageInputTextView.text = nil;
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    
}


@end
