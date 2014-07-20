//
//  JGProgressHUDFadeAnimation.m
//  JGProgressHUD
//
//  Created by Jonas Gessner on 20.7.14.
//  Copyright (c) 2014 Jonas Gessner. All rights reserved.
//  

#import "JGProgressHUDFadeAnimation.h"

@implementation JGProgressHUDFadeAnimation

#pragma mark - Initializers

- (instancetype)init {
    self = [super init];
    if (self) {
        self.duration = 0.3;
        self.animationOptions = UIViewAnimationOptionCurveEaseInOut;
    }
    return self;
}

#pragma mark - Showing

- (void)show {
    [super show];
    
    //Prepare animation
    self.progressHUD.alpha = 0.0f;
    
    //Now unhide HUD
    self.progressHUD.hidden = NO;
    
    //Perform the presentation animation
    [UIView animateWithDuration:self.duration delay:0.0 options:self.animationOptions animations:^{
        self.progressHUD.alpha = 1.0f;
    } completion:^(BOOL finished) {
        [self animationFinished];
    }];
}

#pragma mark - Hiding

- (void)hide {
    [super hide];
    
    //Perform the dismissal animation
    [UIView animateWithDuration:self.duration delay:0.0 options:self.animationOptions animations:^{
        self.progressHUD.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self animationFinished];
    }];
}

@end
