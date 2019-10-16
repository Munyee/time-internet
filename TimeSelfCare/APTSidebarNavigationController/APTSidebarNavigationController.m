//
//  APTSidebarNavigationController.m
//  APTSidebarNavigationController
//
//  Created by Li Theen Kok on 10/10/14.
//  Copyright (c) 2014 Apptivity Lab. All rights reserved.
//

#import "APTSidebarNavigationController.h"

@interface APTSidebarNavigationController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftSidebarLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewWidthConstraint;
@property (strong, nonatomic) UIPanGestureRecognizer *panGestureRecognizer;
@property (weak, nonatomic) UIView *interactionDisablerView;
- (void)handleToggleSidebarNotification:(NSNotification *)notification;
- (void)pan:(UIPanGestureRecognizer *)gestureRecognizer;
- (void)tap:(UITapGestureRecognizer *)gestureRecognizer;
@end

@implementation APTSidebarNavigationController

NSString * const APTSidebarWillToggleNotification = @"com.apptivitylab.APTSidebarWillToggleNotification";

- (void)viewDidLoad {
    [super viewDidLoad];

    self.sidebarEnabled = YES;
    [self setSidebarType:APTSidebarTypeOverContent animated:NO];

    self.contentViewWidthConstraint.constant = [UIScreen mainScreen].applicationFrame.size.width;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    self.interactionDisablerView.frame = self.contentView.frame;

    // Update shadows
    [self updateShadows];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setup {
    NSAssert(self.contentView && self.contentView.superview == self.view, @"contentView IBOutlet must be linked and must be a view which is a subview of self.view");
    NSAssert(self.leftSidebarView && self.leftSidebarView.superview == self.view, @"sidebarView IBOutlet must be linked and must be a view which is a subview of self.view");

    // Determine and set contentViewController
    for (UIViewController *aChildViewController in self.childViewControllers) {
        if (aChildViewController.view.superview == self.contentView) {
            _contentViewController = aChildViewController;
        } else if (aChildViewController.view.superview == self.leftSidebarView) {
            _leftSidebarViewController = aChildViewController;
        }
    }

    if (!self.panGestureRecognizer) {
        self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        self.panGestureRecognizer.delegate = self;
        [self.view addGestureRecognizer:self.panGestureRecognizer];
    }

    if (!_interactionDisablerView) {
        UIView *disablingView = [[UIView alloc] initWithFrame:self.contentView.bounds];
        disablingView.backgroundColor = self.contentBlockingColor;
        disablingView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.view insertSubview:disablingView aboveSubview:self.contentView];
        self.interactionDisablerView = disablingView;

        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self.interactionDisablerView addGestureRecognizer:tapGesture];
    }

    // TODO: Uncomment for rounded corners sidebar
    /*
     if (self.sidebarView.subviews.count > 0) {
     UIView *sideMenuView = self.sidebarView.subviews[0];
     sideMenuView.layer.cornerRadius = 6.f;
     sideMenuView.layer.masksToBounds = YES;
     self.sidebarView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(10.f, 3.f, self.sidebarView.frame.size.width - 10.f, self.sidebarView.frame.size.height) byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(6.f, 6.f)].CGPath;
     }
     */

    if (self.sidebarType == APTSidebarTypeOverContent) {
        self.leftSidebarView.hidden = NO;
        [self.view bringSubviewToFront:self.leftSidebarView];
    } else {
        self.leftSidebarLeftConstraint.constant = 0;
        self.contentViewLeftConstraint.constant = 0;
        self.leftSidebarView.hidden = NO;
        self.rightSidebarView.hidden = NO;

        [self.interactionDisablerView removeFromSuperview];
        self.interactionDisablerView = nil;

        [self.view bringSubviewToFront:self.contentView];
        if (self.leftSidebarView.subviews.count > 0) {
            UIView *leftSidebarContentView = self.leftSidebarView.subviews[0];
            leftSidebarContentView.frame = self.leftSidebarView.bounds;
        }
        if (self.rightSidebarView && self.rightSidebarView.subviews.count > 0) {
            UIView *rightSidebarContentView = self.rightSidebarView.subviews[0];
            rightSidebarContentView.frame = self.rightSidebarView.bounds;
        }
    }

    [self updateShadows];
}

- (void)updateShadows {
    if (self.shadowsHidden) {
        self.contentView.layer.shadowOpacity = 0;
        self.contentView.layer.shadowRadius = 0;
        self.contentView.layer.shadowPath = nil;

        self.leftSidebarView.layer.shadowRadius = 0;
        self.leftSidebarView.layer.shadowOpacity = 0;
        self.leftSidebarView.layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectMake(10.f, 3.f, self.leftSidebarView.frame.size.width - 10.f, self.leftSidebarView.frame.size.height)].CGPath;

        return;
    }

    if (self.sidebarType == APTSidebarTypeOverContent) {
        self.contentView.layer.shadowOpacity = 0;
        self.contentView.layer.shadowRadius = 0;
        self.contentView.layer.shadowPath = nil;

        self.leftSidebarView.layer.shadowRadius = 4;
        self.leftSidebarView.layer.shadowOpacity = 0.65;
        self.leftSidebarView.layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectMake(self.leftSidebarView.frame.size.width, 0, 3.f, self.leftSidebarView.frame.size.height)].CGPath;
    } else {
        self.leftSidebarView.layer.shadowRadius = 0;
        self.leftSidebarView.layer.shadowOpacity = 0;
        self.leftSidebarView.layer.shadowPath = nil;

        self.contentView.layer.shadowOpacity = 0.65;
        self.contentView.layer.shadowRadius = 6;
        self.contentView.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.contentView.bounds].CGPath;
    }
}

#pragma mark - Properties

//- (UIStatusBarStyle)preferredStatusBarStyle {
//    // TODO: Set appropriate status bar style here
//    return UIStatusBarStyleLightContent;
//}

- (BOOL)prefersStatusBarHidden {
    /*
    if (self.sidebarType == APTSidebarTypeUnderContent) {
        if (self.contentViewLeftConstraint.constant != 0) {
            return YES;
        }
    }
     */

    return NO;
}

- (APTSidebarState)sidebarState {
    BOOL leftSidebarIsVisible = self.leftSidebarView.alpha != 0;
    BOOL rightSidebarIsVisible = self.rightSidebarView != nil && self.rightSidebarView.alpha != 0;

    if (self.sidebarType == APTSidebarTypeOverContent) {
        leftSidebarIsVisible = !self.leftSidebarView.hidden;
    }

    if (leftSidebarIsVisible) {
        return APTSidebarStateLeftSidebarOpen;
    } else if (rightSidebarIsVisible) {
        return APTSidebarStateRightSidebarOpen;
    }

    return APTSidebarStateSidebarClosed;
}

- (void)setSidebarType:(APTSidebarType)sidebarType animated:(BOOL)animated {
    _sidebarType = sidebarType;

    [self setup];
    [self setNeedsStatusBarAppearanceUpdate];

    NSTimeInterval animDuration = animated ? 0.125 : 0;
    [UIView animateWithDuration:animDuration delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:animDuration delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.view.alpha = 1;
        } completion:^(BOOL finished) {
            // Do nothing for now
        }];
    }];
}

- (UIColor *)contentBlockingColor {
    return [UIColor colorWithWhite:0 alpha:0.35f];
}

- (void)setContentViewController:(UIViewController *)contentViewController {
    if (contentViewController) {
        [self addChildViewController:contentViewController];
//        contentViewController.view.frame = self.contentView.bounds;
        [contentViewController beginAppearanceTransition:YES animated:YES];
        [self.contentView addSubview:contentViewController.view];
        [contentViewController endAppearanceTransition];
        [contentViewController didMoveToParentViewController:self];

        [self.contentViewController willMoveToParentViewController:nil];
        [self.contentViewController.view removeFromSuperview];
        [self.contentViewController removeFromParentViewController];
        [self.contentViewController didMoveToParentViewController:nil];
    }
    _contentViewController = contentViewController;
}

- (void)setContentViewController:(UIViewController *)contentViewController animated:(BOOL)animated {
    NSTimeInterval animDuration = animated ? 0.2 : 0;

    if (self.sidebarType == APTSidebarTypeOverContent) {
        if (self.sidebarState != APTSidebarStateSidebarClosed) {
            [self hideLeftSidebar];
            [self hideRightSidebar];
        }

        [UIView animateWithDuration:animDuration delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            [self.contentView.subviews[0] setAlpha:0];
        } completion:^(BOOL finished) {
            [self setNeedsStatusBarAppearanceUpdate];

            [self setContentViewController:contentViewController];
            [self.contentView.subviews[0] setAlpha:1];
        }];
    } else {
        [UIView animateWithDuration:animDuration delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            if (self.sidebarState != APTSidebarStateSidebarClosed) {
                [self hideLeftSidebar];
                [self hideRightSidebar];
            }
        } completion:^(BOOL finished) {
            [self setNeedsStatusBarAppearanceUpdate];
            [self setContentViewController:contentViewController];
        }];
    }
}

#pragma mark - Actions

- (IBAction)toggleLeftSidebar:(id)sender {
    if (self.sidebarState == APTSidebarStateLeftSidebarOpen) {
        [self hideLeftSidebar];
    } else {
        [self showLeftSidebar];
    }
}

- (IBAction)toggleRightSidebar:(id)sender {
    if (self.sidebarState == APTSidebarStateRightSidebarOpen) {
        [self hideRightSidebar];
    } else {
        [self showRightSidebar];
    }
}

- (void)showLeftSidebar {
    self.leftSidebarView.hidden = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:APTSidebarWillToggleNotification object:nil];

    if (self.sidebarType == APTSidebarTypeOverContent) {
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.interactionDisablerView.alpha = 1;
            self.leftSidebarLeftConstraint.constant = 0;
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            [self setNeedsStatusBarAppearanceUpdate];
        }];
    } else {
        self.leftSidebarView.alpha = 1;
        self.rightSidebarView.alpha = 1 - self.leftSidebarView.alpha;

        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.contentViewLeftConstraint.constant = self.leftSidebarView.frame.size.width;
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            [self setNeedsStatusBarAppearanceUpdate];
        }];
    }
}

- (void)showRightSidebar {
    if (!self.rightSidebarView || self.rightSidebarView.subviews.count == 0) {
        return;
    }

    self.rightSidebarView.hidden = NO;
    self.rightSidebarView.alpha = 1;
    self.leftSidebarView.alpha = 1 - self.rightSidebarView.alpha;

    [[NSNotificationCenter defaultCenter] postNotificationName:APTSidebarWillToggleNotification object:nil];

    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.contentViewLeftConstraint.constant = -self.rightSidebarView.frame.size.width;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self setNeedsStatusBarAppearanceUpdate];
    }];
}

- (void)hideLeftSidebar {
    [[NSNotificationCenter defaultCenter] postNotificationName:APTSidebarWillToggleNotification object:nil];

    if (self.sidebarType == APTSidebarTypeOverContent) {
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.interactionDisablerView.alpha = 0;
            self.leftSidebarLeftConstraint.constant = -self.leftSidebarView.frame.size.width;
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.leftSidebarView.hidden = YES;
            [self setNeedsStatusBarAppearanceUpdate];
        }];
    } else {
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.contentViewLeftConstraint.constant = 0;
            [self.view layoutIfNeeded];

            self.leftSidebarView.alpha = 0;
        } completion:^(BOOL finished) {
            [self setNeedsStatusBarAppearanceUpdate];
        }];
    }
}

- (void)hideRightSidebar {
    if (!self.rightSidebarView || self.rightSidebarView.subviews.count == 0) {
        return;
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:APTSidebarWillToggleNotification object:nil];
    [UIView animateWithDuration:0.2 delay:0 options:0 animations:^{
        self.contentViewLeftConstraint.constant = 0;
        [self.view layoutIfNeeded];

        self.rightSidebarView.alpha = 0;
    } completion:^(BOOL finished) {
        [self setNeedsStatusBarAppearanceUpdate];
    }];
}

#pragma mark Gesture Actions

- (void)tap:(UITapGestureRecognizer *)gestureRecognizer {
    if (!self.leftSidebarView.hidden) {
        [self hideLeftSidebar];
    }
}

- (void)pan:(UIPanGestureRecognizer *)gestureRecognizer {
    CGPoint translation = [gestureRecognizer translationInView:self.view];
    CGPoint velocity = [gestureRecognizer velocityInView:self.view];

    if (!self.sidebarEnabled) {
        return;
    } else if (fabs(translation.y) > 50) {
        if (self.sidebarType == APTSidebarTypeUnderContent) {
            if (self.sidebarState == APTSidebarStateLeftSidebarOpen) {
                if (self.contentViewLeftConstraint.constant > 0.25 * self.leftSidebarView.frame.size.width) {
                    [self showLeftSidebar];
                } else {
                    [self hideLeftSidebar];
                }
            } else if (self.sidebarState == APTSidebarStateRightSidebarOpen && self.rightSidebarView) {
                if (self.contentViewLeftConstraint.constant < -(0.15 * self.rightSidebarView.frame.size.width)) {
                    [self showRightSidebar];
                } else {
                    [self hideRightSidebar];
                }
            }
        } else {
            if (self.sidebarState == APTSidebarStateLeftSidebarOpen) {
                [self hideLeftSidebar];
            } else if (self.sidebarState == APTSidebarStateRightSidebarOpen) {
                [self hideRightSidebar];
            }
        }

        return;
    }

    if (self.sidebarType == APTSidebarTypeUnderContent) {
        if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
            // Left-to-right movement
            if (velocity.x > 0) {
                if (self.sidebarState == APTSidebarStateSidebarClosed) {
                    self.leftSidebarView.alpha = 1;
                    self.rightSidebarView.alpha = 1 - self.leftSidebarView.alpha;

                    [[NSNotificationCenter defaultCenter] postNotificationName:APTSidebarWillToggleNotification object:nil];
                    [self setNeedsStatusBarAppearanceUpdate];
                }
            } else {
                // Right-to-left movement
                if (self.sidebarState == APTSidebarStateSidebarClosed) {
                    self.rightSidebarView.alpha = 1;
                    self.leftSidebarView.alpha = 1 - self.rightSidebarView.alpha;

                    [[NSNotificationCenter defaultCenter] postNotificationName:APTSidebarWillToggleNotification object:nil];
                    [self setNeedsStatusBarAppearanceUpdate];
                }
            }
        } else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
            BOOL needsStatusBarAppearanceUpdate = round(self.contentViewLeftConstraint.constant) == 0;

            if (self.sidebarState == APTSidebarStateLeftSidebarOpen) {
                self.contentViewLeftConstraint.constant = MIN(MAX(0, self.contentViewLeftConstraint.constant + translation.x), self.leftSidebarView.frame.size.width);
            } else if (self.sidebarState == APTSidebarStateRightSidebarOpen) {
                self.contentViewLeftConstraint.constant = MAX(MIN(0, self.contentViewLeftConstraint.constant + translation.x), -self.rightSidebarView.frame.size.width);
            }

            [gestureRecognizer setTranslation:CGPointMake(0, translation.y) inView:self.view];

            if (needsStatusBarAppearanceUpdate) {
                [self setNeedsStatusBarAppearanceUpdate];
            }
        } else {
            if (self.sidebarState == APTSidebarStateLeftSidebarOpen) {
                if (velocity.x < 0 && self.contentViewLeftConstraint.constant < 0.75 * self.leftSidebarView.frame.size.width) {
                    [self hideLeftSidebar];
                } else {
                    if (self.contentViewLeftConstraint.constant > 0.25 * self.leftSidebarView.frame.size.width) {
                        [self showLeftSidebar];
                    } else {
                        [self hideLeftSidebar];
                    }
                }
            } else if (self.sidebarState == APTSidebarStateRightSidebarOpen) {
                if (velocity.x < 0) {
                    if (self.contentViewLeftConstraint.constant < -(0.15 * self.rightSidebarView.frame.size.width)) {
                        [self showRightSidebar];
                    } else {
                        [self hideRightSidebar];
                    }
                } else {
                    if (self.contentViewLeftConstraint.constant > -(0.75 * self.rightSidebarView.frame.size.width) || self.contentViewLeftConstraint.constant >= 0) {
                        [self hideRightSidebar];
                    } else {
                        [self showRightSidebar];
                    }
                }
            } else {
                if (self.contentViewLeftConstraint.constant > 0) {
                    if (self.contentViewLeftConstraint.constant > 0.25 * self.leftSidebarView.frame.size.width) {
                        [self showLeftSidebar];
                    } else {
                        [self hideLeftSidebar];
                    }
                } else {
                    if (self.contentViewLeftConstraint.constant < -(0.15 * self.rightSidebarView.frame.size.width)) {
                        [self hideRightSidebar];
                    } else {
                        [self showRightSidebar];
                    }
                }
            }
        }

        return;
    } else {
        if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
            self.leftSidebarView.hidden = NO;
            [self setNeedsStatusBarAppearanceUpdate];

            [[NSNotificationCenter defaultCenter] postNotificationName:APTSidebarWillToggleNotification object:nil];
        } else if (gestureRecognizer.state == UIGestureRecognizerStateCancelled ||
                   gestureRecognizer.state == UIGestureRecognizerStateFailed) {
            if (translation.x < 0) {
                [self hideLeftSidebar];
            } else if (translation.x > 0.75 * self.leftSidebarView.frame.size.width) {
                [self showLeftSidebar];
            }
        } else if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
            // Pan towards the left
            if (translation.x < 0) {
                if (self.leftSidebarLeftConstraint.constant < -0.25 * self.leftSidebarView.frame.size.width) {
                    [self hideLeftSidebar];
                } else {
                    if (!self.leftSidebarView.hidden) {
                        [self showLeftSidebar];
                    }
                }
            } else {
                // Pan towards the right
                if (self.leftSidebarLeftConstraint.constant > -0.5 * self.leftSidebarView.frame.size.width) {
                    if (!self.leftSidebarView.hidden) {
                        [self showLeftSidebar];
                    }
                } else {
                    [self hideLeftSidebar];
                }
            }
        } else {
            self.leftSidebarLeftConstraint.constant = MIN(0, self.leftSidebarLeftConstraint.constant + translation.x);
            [gestureRecognizer setTranslation:CGPointMake(0, translation.y) inView:self.view];

            self.interactionDisablerView.alpha = self.leftSidebarView.hidden ? 0 : (1 - (fabs(self.leftSidebarLeftConstraint.constant) / self.leftSidebarView.frame.size.width));
        }
    }
}

#pragma mark Notification Actions

- (void)handleToggleSidebarNotification:(NSNotification *)notification {
    if (!self.leftSidebarView.hidden) {
        [self toggleLeftSidebar:nil];
    } else if (!self.rightSidebarView.hidden) {
        [self toggleRightSidebar:nil];
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    BOOL shouldRecognizeSimultaneously = YES;

    UIView *otherGestureTargetRootView = otherGestureRecognizer.view;
    while (otherGestureTargetRootView.superview) {
        if (self.sidebarType == APTSidebarTypeOverContent) {
            if (otherGestureTargetRootView == self.leftSidebarViewController.view ||
                [otherGestureTargetRootView isKindOfClass:[UIScrollView class]]) {
                shouldRecognizeSimultaneously = NO;
                break;
            }
        } else {
            if (otherGestureTargetRootView == self.contentViewController.view) {
                shouldRecognizeSimultaneously = NO;
                break;
            }
        }

        if (otherGestureTargetRootView.superview) {
            otherGestureTargetRootView = otherGestureTargetRootView.superview;
        }
    }

    return shouldRecognizeSimultaneously;
}

@end
