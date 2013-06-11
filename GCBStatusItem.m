//
//  GCBStatusItem.m
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

#import "GCBStatusItem.h"

const NSTimeInterval GCBStatusItemDisplayIndefinitely = 0;

@implementation GCBStatusItem

- (void)dealloc {
#if !__has_feature(objc_arc)
	[_title release];
	[_image release];
	[_accessoryView release];
	[super dealloc];
#endif
}

- (id)copyWithZone:(NSZone *)zone {
	GCBStatusItem *copy = [[self.class alloc] init];
	copy.title = self.title;
	copy.image = self.image;
	copy.accessoryView = self.accessoryView;
	copy.displayDuration = self.displayDuration;
	return copy;
}

@end
