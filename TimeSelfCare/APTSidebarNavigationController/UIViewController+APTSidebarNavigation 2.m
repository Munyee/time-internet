//
//  UIViewController+APTSidebarNavigation.m
//  APTSidebarNavigationController
//
//  Created by Li Theen Kok on 10/10/14.
//  Copyright (c) 2014 Apptivity Lab. All rights reserved.
//

#import "UIViewController+APTSidebarNavigation.h"
#import "APTSidebarNavigationController.h"

@implementation UIViewController (APTSidebarNavigation)

- (APTSidebarNavigationController *)sidebarNavigationController {
    if ([self.parentViewController isKindOfClass:APTSidebarNavigationController.class]) {
        return (APTSidebarNavigationController *)self.parentViewController;
    } else {
        UIViewController *parentVC = self.parentViewController;
        while (![parentVC isKindOfClass:APTSidebarNavigationController.class]) {
            if (!parentVC.parentViewController) {
                parentVC = nil;
                break;
            }

            parentVC = parentVC.parentViewController;
        }

        return (APTSidebarNavigationController *)parentVC;
    }
}

@end
