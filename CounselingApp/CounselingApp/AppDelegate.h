//
//  AppDelegate.h
//  CounselingApp
//
//  Created by shawn yap on 9/23/16.
//  Copyright © 2016 ACU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class SWRevealViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (NSString*)openPath;
- (void)showHomeScreen;
- (void)saveContext;
- (void)call;


@end

