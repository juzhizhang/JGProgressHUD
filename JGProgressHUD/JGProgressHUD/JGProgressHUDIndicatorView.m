//
//  JGProgressHUDIndicatorView.m
//  JGProgressHUD
//
//  Created by Jonas Gessner on 20.7.14.
//  Copyright (c) 2014 Jonas Gessner. All rights reserved.
//  

#import "JGProgressHUDIndicatorView.h"

@implementation JGProgressHUDIndicatorView

#pragma mark - Initializers

- (instancetype)initWithFrame:(CGRect)frame {
    return [self init];
}

- (instancetype)init {
    return [self initWithContentView:nil];
}

- (instancetype)initWithContentView:(UIView *)contentView {
    self = [super initWithFrame:(contentView ? contentView.frame : CGRectMake(0.0f, 0.0f, 50.0f, 50.0f))];
    if (self) {
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
        
        if (contentView) {
            _contentView = contentView;
            
            [self addSubview:self.contentView];
        }
    }
    return self;
}

#pragma mark - Getters & Setters

- (void)setProgress:(float)progress {
    _progress = progress;
    
    if (![NSThread isMainThread]) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self setNeedsDisplay];
        });
    }
    else {
        [self setNeedsDisplay];
    }
}

@end
