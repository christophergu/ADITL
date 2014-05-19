//
//  ScrollViewThatDoesNotAnimateWithKeyboard.m
//  ADITL
//
//  Created by Christopher Gu on 5/16/14.
//  Copyright (c) 2014 Christopher Gu. All rights reserved.
//

#import "ScrollViewThatDoesNotAnimateWithKeyboard.h"

@implementation ScrollViewThatDoesNotAnimateWithKeyboard

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)scrollRectToVisible:(CGRect)rect animated:(BOOL)animated
{
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
