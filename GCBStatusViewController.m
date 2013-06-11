//
//  GCBStatusViewController.m
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

#import "GCBStatusViewController.h"
#import "GCBStatusManager.h"
#import "GCBStatusItem.h"

#import <QuartzCore/QuartzCore.h>


@interface GCBStatusViewController () {
	CGPoint _contentInset;
}

@property (readwrite, nonatomic, strong) GCBStatusItem *statusItem;
@property (strong) UILabel *titleLabel;
@property (strong) UIImageView *imageView;
@property (strong) UIView *customAccessoryView;

@end

@implementation GCBStatusViewController

- (id)initWithStatusManager:(GCBStatusManager *)statusManager {
	NSParameterAssert(statusManager);
	self = [self init];
	if (self) {
		_statusManager = statusManager;
#if !__has_feature(objc_arc)
		[_statusManager retain];
#endif
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusManagerDidChangeCurrentStatusItem:) name:GCBStatusManagerDidChangeCurrentStatusItemNotification object:_statusManager];
		_contentInset = CGPointMake(15, 15);
	}
	return self;
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
#if !__has_feature(objc_arc)
	[_statusManager release];
	[_statusItem release];
	[_titleLabel release];
	[_imageView release];
	[super dealloc];
#endif
}

- (void)loadView {
	UIView *view = [[UIView alloc] init];
	view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.53];
	view.opaque = NO;
	view.layer.cornerRadius = 9;
	view.autoresizesSubviews = NO;
	self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	self.titleLabel.backgroundColor = [UIColor clearColor];
	self.titleLabel.font = [UIFont boldSystemFontOfSize:[UIFont labelFontSize]];
	self.titleLabel.textColor = [UIColor whiteColor];
	self.titleLabel.shadowColor = [UIColor blackColor];
	self.titleLabel.shadowOffset = CGSizeMake(0, 1);
	[view addSubview:self.titleLabel];
	[view addSubview:self.imageView];
	self.view = view;
	[self updateViewWithStatusItem:self.statusItem];
}

#pragma mark Rotation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return YES;
}

#pragma mark - Status Items
- (void)statusManagerDidChangeCurrentStatusItem:(NSNotification *)notification {
	GCBStatusItem *newStatusItem = notification.userInfo[GCBStatusManagerUserInfoNewStatusItemKey];
	if (newStatusItem == (id)[NSNull null]) {
		self.statusItem = nil;
	} else {
		self.statusItem = newStatusItem;
	}
}

- (void)setStatusItem:(GCBStatusItem *)statusItem {
	if (statusItem == _statusItem) {
		return;
	}
	_statusItem = statusItem;
#if !__has_feature(objc_arc)
	[_statusItem retain];
#endif
	[self updateViewWithStatusItem:_statusItem];
}

- (void)updateViewWithStatusItem:(GCBStatusItem *)statusItem {
	if (![self isViewLoaded]) {
		return;
	}
	[self.customAccessoryView removeFromSuperview];
	self.customAccessoryView = nil;
	
	BOOL showsImage = statusItem.image && !statusItem.accessoryView;
	BOOL showsCustomAccessoryView = statusItem.accessoryView && !statusItem.image;
	if (showsCustomAccessoryView) {
		self.customAccessoryView = statusItem.accessoryView;
		[self.customAccessoryView sizeToFit];
		[self.view addSubview:self.customAccessoryView];
	}
	CGRect maxFrame = self.view.superview.bounds;
	CGSize maxContentSize = CGRectInset(maxFrame, _contentInset.x, _contentInset.y).size;
	CGSize accessorySize;
	if (showsImage) {
		accessorySize = statusItem.image ? self.imageView.frame.size : CGSizeZero;
	} else if (showsCustomAccessoryView) {
		accessorySize = statusItem.accessoryView.frame.size;
	} else {
		accessorySize = CGSizeZero;
	}
	self.titleLabel.text = statusItem.title;
	self.titleLabel.hidden = (statusItem.title.length == 0);
	self.imageView.image = statusItem.image;
	[self.imageView sizeToFit];
	self.imageView.hidden = !showsImage;
	CGSize maxTitleSize = CGSizeMake(maxContentSize.width, statusItem.image ? maxContentSize.height - accessorySize.height : maxContentSize.height);
	CGSize titleSize = [self.titleLabel sizeThatFits:maxTitleSize];
	CGSize actualContentSize = CGSizeMake(titleSize.width + accessorySize.width, titleSize.height + accessorySize.height);
	CGSize frameSize = CGSizeMake(actualContentSize.width + 2 * _contentInset.x, actualContentSize.height + 2 * _contentInset.y);
	self.view.frame = CGRectIntegral(CGRectMake((CGRectGetWidth(self.view.superview.bounds) - frameSize.width) / 2, (CGRectGetHeight(self.view.superview.bounds) - frameSize.height) / 2, frameSize.width, frameSize.height));
	if (showsImage) {
		self.imageView.frame = CGRectIntegral(CGRectOffset(CGRectMake((actualContentSize.width - accessorySize.width) / 2, 0, accessorySize.width, accessorySize.height), _contentInset.x, _contentInset.y));
	} else if (showsCustomAccessoryView) {
		self.customAccessoryView = statusItem.accessoryView;
		self.customAccessoryView.frame = CGRectIntegral(CGRectOffset(CGRectMake((actualContentSize.width - accessorySize.width) / 2, 0, accessorySize.width, accessorySize.height), _contentInset.x, _contentInset.y));
	}
	self.titleLabel.frame = CGRectIntegral(CGRectOffset(CGRectMake((actualContentSize.width - titleSize.width) / 2, accessorySize.height, titleSize.width, titleSize.height), _contentInset.x, _contentInset.y));
	self.view.hidden = !statusItem;
}

@end
