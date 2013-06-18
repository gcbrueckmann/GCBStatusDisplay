# GCBStatusDisplay

Version 1.0.1 – 2013-06-18

by Georg C. Brückmann  
<http://gcbrueckmann.de>


## Introduction

A status manager maintains a queue of status items. Other facitlities
can push and pop status items to indicate a status change. Status items
can also be set to be popped off after a given period.

A status view controller manages the display of status items maintained
by a status manager. The default status view controller provides a HUD
notification style similar to what can be seen on iOS when changing the
volume using the volume buttons on the device.

## Example

	- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
		…
		GCBStatusViewController *statusViewController = [[GCBStatusViewController alloc] initWithStatusManager:[GCBStatusManager defaultManager]];
		[myRootViewController.view addSubview:statusViewController.view];
		[myRootViewController addChildViewController:statusViewController];
		[[GCBStatusManager defaultManager] pushActivityStatusItemWithTitle:@"hello, world" displayDuration:5];
		return YES;
	}

## License

Copyright (c) 2013 Georg C. Brückmann (http://gcbrueckmann.de/)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
