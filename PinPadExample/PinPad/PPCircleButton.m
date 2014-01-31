//
//  VTCircleButton.m
//  PinPad
//
//  Created by Aleks Kosylo on 1/16/14.
//  Copyright (c) 2014 Aleks Kosylo. All rights reserved.
//

#import "PPCircleButton.h"

@implementation PPCircleButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [super drawRect:rect];
    [self.layer setCornerRadius:CGRectGetHeight(rect)/2.0];
    self.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5].CGColor;
    self.layer.borderWidth = 2.0f;
}

- (void)setHighlighted:(BOOL)highlighted {
    
    if(highlighted) {
        self.layer.borderColor = [self titleColorForState:UIControlStateHighlighted].CGColor;
    }
    else {
        self.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5].CGColor;
    }
    
}
@end
