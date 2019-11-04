//
//  APTSidebarContentSegue.m
//  Kungfu-iOS
//
//  Created by Li Theen Kok on 3/31/14.
//  Copyright (c) 2014 Apptivity Lab. All rights reserved.
//

#import "APTSidebarContentSegue.h"
#import "APTSidebarNavigationController.h"
#import "UIViewController+APTSidebarNavigation.h"

@implementation APTSidebarContentSegue

- (id)initWithIdentifier:(NSString *)identifier source:(UIViewController *)source destination:(UIViewController *)destination {
    self = [super initWithIdentifier:identifier source:source destination:destination];
    if ([source respondsToSelector:@selector(sidebarNavigationController)]) {
        self.sidebarNavigationController = [source sidebarNavigationController];
    }
    return self;
}

- (void)perform {
    if ([self.destinationViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navController = self.destinationViewController;
        [self.sidebarNavigationController setContentViewController:navController animated:YES];
    } else {
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:self.destinationViewController];
        [self.sidebarNavigationController setContentViewController:navController animated:YES];
    }
}

@end
