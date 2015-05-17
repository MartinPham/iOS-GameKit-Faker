//
//  GKHook.mm
//  GKHook
//
//  Created by NobitaZZZ on 6/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

// CaptainHook by Ryan Petrich
// see https://github.com/rpetrich/CaptainHook/

#import <Foundation/Foundation.h>
#import "CaptainHook/CaptainHook.h"
#include <notify.h> // not required; for examples only
#include <GameKit/GKScore.h>

// Objective-C runtime hooking using CaptainHook:
//   1. declare class using CHDeclareClass()
//   2. load class using CHLoadClass() or CHLoadLateClass() in CHConstructor
//   3. hook method using CHOptimizedMethod()
//   4. register hook using CHHook() in CHConstructor
//   5. (optionally) call old method using CHSuper()


@interface GKHook : NSObject

@end

@implementation GKHook

-(id)init
{
	if ((self = [super init]))
	{
	}

    return self;
}

@end


@class GKScore;

CHDeclareClass(GKScore); // declare class

CHOptimizedMethod(1, self, void, GKScore, reportScoreWithCompletionHandler, id, completionHandler) // hook method (with no arguments and no return value)
{
	// write code here ...
	NSLog(@"hooked %@ %lld %@", self, self.value, self.formattedValue);
    self.value = 99999999999999999999;
	CHSuper(1, GKScore, reportScoreWithCompletionHandler, completionHandler); // call old (original) method
}
/*
CHOptimizedMethod(2, self, BOOL, GKScore, arg1, NSString*, value1, arg2, BOOL, value2) // hook method (with 2 arguments and a return value)
{
	// write code here ...

	return CHSuper(2, GKScore, arg1, value1, arg2, value2); // call old (original) method and return its return value
}

static void WillEnterForeground(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
	// not required; for example only
}

static void ExternallyPostedNotification(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
	// not required; for example only
}
*/
CHConstructor // code block that runs immediately upon load
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSLog(@"Load hook");
	/*
	// listen for local notification (not required; for example only)
	CFNotificationCenterRef center = CFNotificationCenterGetLocalCenter();
	CFNotificationCenterAddObserver(center, NULL, WillEnterForeground, CFSTR("UIApplicationWillEnterForegroundNotification"), NULL, CFNotificationSuspensionBehaviorCoalesce);
	
	// listen for system-side notification (not required; for example only)
	// this would be posted using: notify_post("com.nobitazzz.GKHook.eventname");
	CFNotificationCenterRef darwin = CFNotificationCenterGetDarwinNotifyCenter();
	CFNotificationCenterAddObserver(darwin, NULL, ExternallyPostedNotification, CFSTR("com.nobitazzz.GKHook.eventname"), NULL, CFNotificationSuspensionBehaviorCoalesce);
	
	// CHLoadClass(GKScore); // load class (that is "available now")
	// CHLoadLateClass(GKScore);  // load class (that will be "available later")
	
	CHHook(0, GKScore, messageName); // register hook
	CHHook(2, GKScore, arg1, arg2); // register hook
	*/
    
    CHLoadLateClass(GKScore);
    CHHook(1, GKScore, reportScoreWithCompletionHandler);
	[pool drain];
}
