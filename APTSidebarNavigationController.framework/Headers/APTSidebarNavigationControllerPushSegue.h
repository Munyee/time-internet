//
//  APTSidebarNavigationControllerPushSegue.h
//  APTSidebarNavigationController
//
//  Created by Li Theen Kok on 9/2/15.
//  Copyright (c) 2015 Apptivity Lab. All rights reserved.
//

#import <UIKit/UIKit.h>

@class APTSidebarNavigationController;

@interface APTSidebarNavigationControllerPushSegue : UIStoryboardSegue
@property (strong, nonatomic) APTSidebarNavigationController *sidebarNavigationController;
@end
