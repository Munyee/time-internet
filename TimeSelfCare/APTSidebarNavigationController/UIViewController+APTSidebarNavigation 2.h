//
//  UIViewController+APTSidebarNavigation.h
//  APTSidebarNavigationController
//
//  Created by Li Theen Kok on 10/10/14.
//  Copyright (c) 2014 Apptivity Lab. All rights reserved.
//

#import <UIKit/UIKit.h>

@class APTSidebarNavigationController;

@interface UIViewController (APTSidebarNavigation)
@property (nonatomic, weak, readonly) APTSidebarNavigationController *sidebarNavigationController;
@end
