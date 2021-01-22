
#import "RBKeyTextView.h"

@implementation RBKeyTextView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    
	if (self) {
		_keyDownEvent = nil;
    }
    
    return self;
}

- (void)keyDown:(NSEvent*)event {
	[_keyDownEvent release];
	_keyDownEvent = [event retain];

	[super keyDown:event];
}

- (void)doCommandBySelector:(SEL)selector {
	if (_keyDownEvent && selector == @selector(noop:)) {
		if ([self nextResponder]) {
			[[self nextResponder] keyDown:[_keyDownEvent autorelease]];
		}
		else {
			[_keyDownEvent release];
		}
		_keyDownEvent = nil;
	}
	else {
		[super doCommandBySelector:selector];
	}
}

- (void)dealloc {
	[_keyDownEvent release];
	
	[super dealloc];
}

@end

/**
  RBKeyTextView.m
  roboText

  Created by Roger Boesch on 11.03.18.
  Copyright © 2018 Roger Boesch. All rights reserved.
*/
