//
//  GCBStatusManager.h
//
//  Copyright (c) 2013 Georg C. Brückmann (http://gcbrueckmann.de/)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import <Foundation/Foundation.h>

@class GCBStatusItem;

@interface GCBStatusManager : NSObject

+ (instancetype)defaultManager;

@property (readonly, nonatomic, strong) GCBStatusItem *currentStatusItem;

- (id)pushStatusItem:(GCBStatusItem *)statusItem;
- (id)pushStatusItemWithTitle:(NSString *)title image:(UIImage *)image displayDuration:(NSTimeInterval)displayDuration;
- (id)pushActivityStatusItemWithTitle:(NSString *)title displayDuration:(NSTimeInterval)displayDuration;
- (void)popStatusItem;

@end

#pragma mark - Notification
/// Notification user info contains \c GCBStatusManagerUserInfoOldStatusItemKey and
/// \c GCBStatusManagerUserInfoNewStatusItemKey.
extern NSString *const GCBStatusManagerWillChangeCurrentStatusItemNotification;
/// Notification user info contains \c GCBStatusManagerUserInfoOldStatusItemKey and
/// \c GCBStatusManagerUserInfoNewStatusItemKey.
extern NSString *const GCBStatusManagerDidChangeCurrentStatusItemNotification;

extern NSString *const GCBStatusManagerUserInfoOldStatusItemKey;
extern NSString *const GCBStatusManagerUserInfoNewStatusItemKey;
