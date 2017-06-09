//
//  Authentication.h
//  CounselingApp
//
//  Created by shawn yap on 11/15/16.
//  Copyright © 2016 ACU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Authentication : NSObject

+(BOOL)checkLogin;
+(BOOL)checkPasswordwithID:(NSString*)user pass:(NSString*)Password;
+(void)updateToken:(NSString*)value;
+(void)signUp; // This is currently used to initialize admin id and pass for Demo
@end
