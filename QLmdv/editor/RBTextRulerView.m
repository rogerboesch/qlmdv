
#import "RBTextRulerView.h"
#import "RBTextSettings.h"

@implementation RBTextRulerView

- (id)initWithScrollView:(NSScrollView *)scrollView orientation:(NSRulerOrientation)orientation {
    if ((self = [super initWithScrollView:scrollView orientation:orientation])) {
        // Initialization code here.
    	NSView* view = [[self scrollView] documentView];
		
		if (![view isKindOfClass:[NSTextView class]]) {
			return nil;
		}
		
		_textView = (NSTextView*)view;
		_lineNumber = 0;

		[self setRuleThickness:32.0];
	}
    
    return self;
}

- (NSString*)lineNumberStringForRange:(NSRange)range {
	NSString* string = [_textView string];

	if (_lineNumber && range.location < _position) {
		// if we went backwards, reset the cache
		_lineNumber = 0;
	}
	
	NSUInteger line = _lineNumber ? _lineNumber : 1;
	NSUInteger col = _lineNumber ? _column : 0;

	for (NSUInteger i = _lineNumber ? _position : 0; i < [string length]; ++i) {
		unichar c = [string characterAtIndex:i];

		if (i == range.location) {
			// cache this position / line number / column
			_position = i;
			_lineNumber = line;
			_column = col;

			if (col == 0) {
				return [NSString stringWithFormat:@"%u", (int)line];
			}
			else {
				return @".";
			}
		}
		
		if (c == '\n' || c == '\v') {
			++line;
			col = 0;
		}
		else {
			++col;
		}
	}

	return nil;
}

- (NSString*)extraLineNumberString {
	NSString* string = [_textView string];

	NSUInteger line = _lineNumber ? _lineNumber : 1;
	
	for (NSUInteger i = _lineNumber ? _position : 0; i < [string length]; ++i) {
		unichar c = [string characterAtIndex:i];
	
		if (c == '\n') {
			++line;
		}
	}
	
	return [NSString stringWithFormat:@"%u", (int)line];
}

- (void)drawHashMarksAndLabelsInRect:(NSRect)rect {
	NSFont* font = [RBTextSettings shared].lineNumberFont;
	NSDictionary* lineTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
										[RBTextSettings shared].lineNumberFont, NSFontAttributeName,
										[RBTextSettings shared].lineNumberColor, NSForegroundColorAttributeName,
										nil];
		
	NSLayoutManager* lm = [_textView layoutManager];
	NSTextContainer* tc = [_textView textContainer];
	NSRect visibleRect = [_textView convertRect:NSMakeRect(self.frame.size.width, rect.origin.y - 10.0, _textView.frame.size.width, rect.size.height + 20.0) fromView:self];	
	NSRange visibleRange = [lm glyphRangeForBoundingRect:visibleRect inTextContainer:tc];
	
	_lineNumber = 0;
	
	NSUInteger i = visibleRange.location;

	while (i < visibleRange.location + visibleRange.length) {
		NSRange range;
		NSRect lineRect = [_textView convertRect:[lm lineFragmentRectForGlyphAtIndex:i effectiveRange:&range] toView:self];
		NSString* lineText = [self lineNumberStringForRange:[lm characterRangeForGlyphRange:range actualGlyphRange:NULL]];
		NSRect bounding = [lineText boundingRectWithSize:(NSSize){1000.0, 1000.0} options:0 attributes:lineTextAttributes];

		[lineText drawAtPoint:NSMakePoint([self ruleThickness] - bounding.size.width - 4.0, lineRect.origin.y + 5.0 - bounding.size.height - [font descender] + [font ascender]) withAttributes:lineTextAttributes];
		i = range.location + range.length;
	}
	
	NSRect extraRect = [lm extraLineFragmentRect];

	if (extraRect.size.height > 0.0) {
		NSString* lineText = [self extraLineNumberString];
		NSRect lineRect = [_textView convertRect:extraRect toView:self];
		NSRect bounding = [lineText boundingRectWithSize:(NSSize){1000.0, 1000.0} options:0 attributes:lineTextAttributes];

		[lineText drawAtPoint:NSMakePoint([self ruleThickness] - bounding.size.width - 4.0, lineRect.origin.y + 5.0 - bounding.size.height - [font descender] + [font ascender]) withAttributes:lineTextAttributes];
	}
}

@end

/**
  RBTextRulerView.m
  roboText

  Created by Roger Boesch on 11.03.18.
  Copyright © 2018 Roger Boesch. All rights reserved.
*/
