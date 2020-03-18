//
//  APTSidebarContentSegue.h
//  Kungfu-iOS
//
//  Created by Li Theen Kok on 3/31/14.
//  Copyright (c) 2014 Apptivity Lab. All rights reserved.
//

#import <UIKit/UIKit.h>

@class APTSidebarNavigationController;

@interface APTSidebarContentSegue : UIStoryboardSegue
@property (strong, nonatomic) APTSidebarNavigationController *sidebarNavigationController;
@property (copy, nonatomic) NSString *menuButtonImageName;
@end
