//
//  APTSidebarNavigationControllerPushSegue.m
//  APTSidebarNavigationController
//
//  Created by Li Theen Kok on 9/2/15.
//  Copyright (c) 2015 Apptivity Lab. All rights reserved.
//

#import "APTSidebarNavigationControllerPushSegue.h"
#import "APTSidebarNavigationController.h"
#import "UIViewController+APTSidebarNavigation.h"

@implementation APTSidebarNavigationControllerPushSegue

- (id)initWithIdentifier:(NSString *)identifier source:(UIViewController *)source destination:(UIViewController *)destination {
    self = [super initWithIdentifier:identifier source:source destination:destination];
    if ([source respondsToSelector:@selector(sidebarNavigationController)]) {
        self.sidebarNavigationController = [source sidebarNavigationController];
    }
    return self;
}

- (void)perform {
    UINavigationController *navController = nil;

    if (self.sidebarNavigationController) {
        if ([self.sidebarNavigationController.parentViewController isKindOfClass:[UINavigationController class]]) {
            navController = (UINavigationController *)self.sidebarNavigationController.parentViewController;
        }
    }

    if (navController) {
        [navController pushViewController:(UIViewController *) self.destinationViewController animated:YES];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.sidebarNavigationController.sidebarState == APTSidebarStateLeftSidebarOpen) {
                [self.sidebarNavigationController toggleLeftSidebar:nil];
            } else if (self.sidebarNavigationController.sidebarState == APTSidebarStateRightSidebarOpen) {
                [self.sidebarNavigationController toggleRightSidebar:nil];
            }
        });
    }
}

@end
