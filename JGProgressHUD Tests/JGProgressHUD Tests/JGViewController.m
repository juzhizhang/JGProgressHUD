//
//  JGViewController.m
//  JGProgressHUD Tests
//
//  Created by Jonas Gessner on 20.07.14.
//  Copyright (c) 2014 Jonas Gessner. All rights reserved.
//

#import "JGViewController.h"
#import "JGProgressHUD.h"
#import "JGProgressHUDPieIndicatorView.h"
#import "JGProgressHUDRingIndicatorView.h"
#import "JGProgressHUDFadeZoomAnimation.h"

@interface JGViewController () <JGProgressHUDDelegate> {
    BOOL _blockUserInteraction;
}

@end

@implementation JGViewController

#pragma mark - JGProgressHUDDelegate

- (void)progressHUD:(JGProgressHUD *)progressHUD willPresentInView:(UIView *)view {
    NSLog(@"HUD %p will present in view: %p", progressHUD, view);
}

- (void)progressHUD:(JGProgressHUD *)progressHUD didPresentInView:(UIView *)view {
    NSLog(@"HUD %p did present in view: %p", progressHUD, view);
}

- (void)progressHUD:(JGProgressHUD *)progressHUD willDismissFromView:(UIView *)view {
    NSLog(@"HUD %p will dismiss from view: %p", progressHUD, view);
}

- (void)progressHUD:(JGProgressHUD *)progressHUD didDismissFromView:(UIView *)view {
    NSLog(@"HUD %p did dismiss from view: %p", progressHUD, view);
}


#pragma mark -

- (void)simple:(NSUInteger)section {
    JGProgressHUD *HUD = [[JGProgressHUD alloc] initWithStyle:(JGProgressHUDStyle)section];
    HUD.userInteractionEnabled = _blockUserInteraction;
    HUD.delegate = self;
    [HUD showInView:self.navigationController.view];
    
    HUD.position = JGProgressHUDPositionCenter;
    
    [HUD dismissAfterDelay:5];
}

- (void)withText:(NSUInteger)section {
    JGProgressHUD *HUD = [[JGProgressHUD alloc] initWithStyle:(JGProgressHUDStyle)section];
    HUD.textLabel.text = @"Loading...";
    HUD.delegate = self;
    HUD.userInteractionEnabled = _blockUserInteraction;
    [HUD showInView:self.navigationController.view];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        HUD.useProgressIndicatorView = NO;
        
        HUD.textLabel.font = [UIFont systemFontOfSize:30];
        
        HUD.textLabel.text = @"Done";
        
        HUD.position = JGProgressHUDPositionBottomCenter;
    });
    
    HUD.marginInsets = UIEdgeInsetsMake(0, 0, 10, 0);
    
    [HUD dismissAfterDelay:3];
}

- (void)progress:(NSUInteger)section {
    JGProgressHUD *HUD = [[JGProgressHUD alloc] initWithStyle:(JGProgressHUDStyle)section];
    HUD.progressIndicatorView = [[JGProgressHUDPieIndicatorView alloc] initWithHUDStyle:HUD.style];
    HUD.delegate = self;
    HUD.userInteractionEnabled = _blockUserInteraction;
    HUD.textLabel.text = @"Uploading...";
    [HUD showInView:self.navigationController.view];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        float r = 0.01;
        for (int i = 0; i <= 1 / 0.01; i++) {
            HUD.progress = i * r;
            [NSThread sleepForTimeInterval:r];
            if (i*r >= 1.0f) {
                [HUD dismissAfterDelay:0];
            }
        }
    });
}

- (void)zoomAnimationWithRing:(NSUInteger)section {
    JGProgressHUD *HUD = [[JGProgressHUD alloc] initWithStyle:(JGProgressHUDStyle)section];
    HUD.progressIndicatorView = [[JGProgressHUDRingIndicatorView alloc] initWithHUDStyle:HUD.style];
    HUD.userInteractionEnabled = _blockUserInteraction;
    JGProgressHUDFadeZoomAnimation *an = [JGProgressHUDFadeZoomAnimation animation];
    HUD.animation = an;
    HUD.delegate = self;
    HUD.textLabel.text = @"Downloading...";
    [HUD showInView:self.navigationController.view];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        float r = 0.01;
        for (int i = 0; i <= 1 / 0.01; i++) {
            HUD.progress = i * r;
            [NSThread sleepForTimeInterval:r];
            if (i*r >= 1.0f) {
                [HUD dismissAfterDelay:0];
            }
        }
    });
}

-(void)textOnly:(NSUInteger)section {
    JGProgressHUD *HUD = [[JGProgressHUD alloc] initWithStyle:(JGProgressHUDStyle)section];
    HUD.useProgressIndicatorView = NO;
    HUD.userInteractionEnabled = _blockUserInteraction;
    HUD.textLabel.text = @"Hello, World!";
    HUD.delegate = self;
    HUD.position = JGProgressHUDPositionBottomCenter;
    HUD.marginInsets = (UIEdgeInsets) {
        .top = 0,
        .bottom = 20,
        .left = 0,
        .right = 0,
    };
    
    [HUD showInView:self.navigationController.view];
    
    [HUD dismissAfterDelay:2];
}

- (void)switched:(UISwitch *)s {
    _blockUserInteraction = s.on;
    
    for (JGProgressHUD *visible in [JGProgressHUD allProgressHUDsInViewHierarchy:self.navigationController.view]) {
        visible.userInteractionEnabled = _blockUserInteraction;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"";
    }
    else if (section == 1) {
        return @"Extra Light Style";
    }
    else if (section == 2) {
        return @"Light Style";
    }
    else {
        return @"Dark Style";
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    else {
        return 5;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.backgroundColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
    }
    
    if (indexPath.section == 0) {
        cell.textLabel.text = @"Block user interaction";
        UISwitch *s = [[UISwitch alloc] init];
        s.on = _blockUserInteraction;
        [s addTarget:self action:@selector(switched:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = s;
    }
    else {
        cell.accessoryView = nil;
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"Fade, Activity Indicator";
                break;
            case 1:
                cell.textLabel.text = @"Fade, Act. Ind. & Text, Transform";
                break;
            case 2:
                cell.textLabel.text = @"Fade, Pie Progress";
                break;
            case 3:
                cell.textLabel.text = @"Zoom, Ring Progress";
                break;
            case 4:
                cell.textLabel.text = @"Fade, Text Only, Bottom Position";
        }
    }
    
    return cell;
}

#pragma mark - Table view delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
            [self simple:indexPath.section-1];
            break;
        case 1:
            [self withText:indexPath.section-1];
            break;
        case 2:
            [self progress:indexPath.section-1];
            break;
        case 3:
            [self zoomAnimationWithRing:indexPath.section-1];
            break;
        case 4:
            [self textOnly:indexPath.section-1];
            break;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _blockUserInteraction = YES;
    
    self.title = @"JGProgressHUD";
    
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.8f alpha:1.0f];
}


@end
