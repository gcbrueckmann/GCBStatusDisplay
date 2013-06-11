//
//  GCBStatusManager.m
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

#import "GCBStatusManager.h"
#import "GCBStatusItem.h"

@interface GCBStatusManager () {
	NSMutableDictionary *_statusItems;
	NSMutableArray *_statusQueue;
}

@property (readwrite, nonatomic, strong) GCBStatusItem *currentStatusItem;

@end

@implementation GCBStatusManager

+ (instancetype)defaultManager {
	static GCBStatusManager *defaultManager;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		defaultManager = [[self alloc] init];
	});
	return defaultManager;
}

- (id)init {
	self = [super init];
	if (self) {
		_statusItems = [[NSMutableDictionary alloc] init];
		_statusQueue = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)dealloc {
#if !__has_feature(objc_arc)
	[_statusItems release];
	[_statusQueue release];
	[super dealloc];
#endif
}

- (id)pushStatusItem:(GCBStatusItem *)statusItem {
	NSParameterAssert(statusItem);
	id itemIdentifier;
	Class UUIDClass = NSClassFromString(@"NSUUID");
	if (UUIDClass) {
		itemIdentifier = [UUIDClass UUID];
	} else {
		itemIdentifier = [[NSProcessInfo processInfo] globallyUniqueString];
	}
	_statusItems[itemIdentifier] = statusItem;
	[_statusQueue addObject:itemIdentifier];
	[self updateCurrentStatusItem];
	return itemIdentifier;
}

- (id)pushStatusItemWithTitle:(NSString *)title image:(UIImage *)image displayDuration:(NSTimeInterval)displayDuration {
	GCBStatusItem *statusItem = [[GCBStatusItem alloc] init];
	statusItem.title = title;
	statusItem.image = image;
	statusItem.displayDuration = displayDuration;
	return [self pushStatusItem:statusItem];
}
- (id)pushActivityStatusItemWithTitle:(NSString *)title displayDuration:(NSTimeInterval)displayDuration {
	GCBStatusItem *statusItem = [[GCBStatusItem alloc] init];
	statusItem.title = title;
	UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
#if !__has_feature(objc_arc)
	[activityIndicatorView autorelease];
#endif
	[activityIndicatorView startAnimating];
	statusItem.accessoryView = activityIndicatorView;
	statusItem.displayDuration = displayDuration;
	return [self pushStatusItem:statusItem];
}

- (void)popStatusItem {
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(popStatusItem) object:nil];
	id itemIdentifier = [_statusQueue objectAtIndex:0];
	NSAssert(itemIdentifier, @"No status item with identifier %@ enqueued with the receiver.", itemIdentifier);
#if !__has_feature(objc_arc)
	itemIdentifier = [[itemIdentifier retain] autorelease];
#endif
	[_statusQueue removeObjectAtIndex:0];
	[_statusItems removeObjectForKey:itemIdentifier];
	[self updateCurrentStatusItem];
}

- (void)updateCurrentStatusItem {
	id currentItemIdentifier = (_statusQueue.count == 0 ? nil : [_statusQueue objectAtIndex:0]);
	self.currentStatusItem = _statusItems[currentItemIdentifier];
	if (self.currentStatusItem.displayDuration != GCBStatusItemDisplayIndefinitely) {
		[self performSelector:@selector(popStatusItem) withObject:nil afterDelay:self.currentStatusItem.displayDuration inModes:@[NSDefaultRunLoopMode]];
	}
}

- (void)setCurrentStatusItem:(GCBStatusItem *)currentStatusItem {
	if (currentStatusItem == _currentStatusItem) {
		return;
	}
	NSDictionary *notificationUserInfo = @{GCBStatusManagerUserInfoOldStatusItemKey: _currentStatusItem ? _currentStatusItem : [NSNull null], GCBStatusManagerUserInfoNewStatusItemKey: currentStatusItem ? currentStatusItem : [NSNull null]};
	[[NSNotificationCenter defaultCenter] postNotificationName:GCBStatusManagerWillChangeCurrentStatusItemNotification object:self userInfo:notificationUserInfo];
	_currentStatusItem = currentStatusItem;
	[[NSNotificationCenter defaultCenter] postNotificationName:GCBStatusManagerDidChangeCurrentStatusItemNotification object:self userInfo:notificationUserInfo];
}

@end

#pragma mark - Notifications
NSString *const GCBStatusManagerWillChangeCurrentStatusItemNotification = @"GCBStatusManagerWillChangeCurrentStatusItem";
NSString *const GCBStatusManagerDidChangeCurrentStatusItemNotification = @"GCBStatusManagerDidChangeCurrentStatusItem";
NSString *const GCBStatusManagerUserInfoOldStatusItemKey = @"GCBStatusManagerUserInfoOldStatusItem";
NSString *const GCBStatusManagerUserInfoNewStatusItemKey = @"GCBStatusManagerUserInfoNewStatusItem";
