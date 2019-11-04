//
//  APTSidebarNavigationController.h
//  APTSidebarNavigationController
//
//  Created by Li Theen Kok on 10/10/14.
//  Copyright (c) 2014 Apptivity Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APTSidebarContentSegue.h"
#import "APTSidebarNavigationControllerPushSegue.h"
#import "UIViewController+APTSidebarNavigation.h"

/**
 * Post a notification with this constant if you want to toggle sidebar into/out of view.
 */
//extern NSString * const APTNavigationToggleSidebarNotification;
extern NSString * const APTSidebarWillToggleNotification;

typedef NS_ENUM(NSInteger, APTSidebarType) {
    APTSidebarTypeOverContent = 0,
    APTSidebarTypeUnderContent,
};

typedef NS_ENUM(NSInteger, APTSidebarState) {
    APTSidebarStateLeftSidebarOpen = 0,
    APTSidebarStateRightSidebarOpen,
    APTSidebarStateSidebarClosed
};

/**
 * LTSidebarContainerViewController provides a sidebar navigation.
 *
 * The sidebar is revealed or hidden on top of the current content. When the sidebar
 * is revealed, interaction with the current content is disabled and "darken."
 */
@interface APTSidebarNavigationController : UIViewController<UIGestureRecognizerDelegate>

@property (nonatomic) BOOL sidebarEnabled;
/** Determines whether the sidebar is over or under the content.
 *
 * Defaults to APTSidebarTypeOverContent.
 * Use -setSidebarType: animated: to change this property.
 */
@property (nonatomic, readonly) APTSidebarType sidebarType;
@property (nonatomic, readonly) APTSidebarState sidebarState;
@property (nonatomic) BOOL shadowsHidden;
@property (nonatomic, readonly) BOOL sidebarHidden;
@property (weak, nonatomic) UIViewController *leftSidebarViewController;
@property (weak, nonatomic) UIViewController *rightSidebarViewController;
@property (weak, nonatomic) UIViewController *contentViewController;
@property (weak, nonatomic) IBOutlet UIView *leftSidebarView;
@property (weak, nonatomic) IBOutlet UIView *rightSidebarView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic, readonly) UIColor *contentBlockingColor;

- (void)setSidebarType:(APTSidebarType)sidebarType animated:(BOOL)animated;
- (void)setContentViewController:(UIViewController *)contentViewController animated:(BOOL)animated;
- (IBAction)toggleLeftSidebar:(id)sender;
- (IBAction)toggleRightSidebar:(id)sender;
- (void)showLeftSidebar;
- (void)showRightSidebar;
- (void)hideLeftSidebar;
- (void)hideRightSidebar;

@end
