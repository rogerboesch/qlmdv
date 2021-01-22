
#import <Cocoa/Cocoa.h>

@interface RBTextRulerView : NSRulerView {
	NSTextView* _textView;
	NSUInteger _lineNumber;
	NSUInteger _position;
	NSUInteger _column;
}

@end

/**
  RBTextRulerView.h
  roboText

  Created by Roger Boesch on 11.03.18.
  Copyright © 2018 Roger Boesch. All rights reserved.
*/
