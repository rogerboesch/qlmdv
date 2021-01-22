
#import "RBEditingTextView.h"

@implementation RBEditingTextView

- (void)didChangeText {
	[self hideFindMatches];
	[super didChangeText];
}

- (void)keyDown:(NSEvent*)event {
	if (!self.delegate || ![self.delegate respondsToSelector:@selector(textView:doKeyDownByEvent:)] || ![(id<RBEditingTextViewDelegate>)self.delegate textView:self doKeyDownByEvent:event]) {
		if (![self window] || ![[self window] respondsToSelector:@selector(textView:doKeyDownByEvent:)] || ![(id<RBEditingTextViewDelegate>)[self window] textView:self doKeyDownByEvent:event]) {
			[super keyDown:event];
		}
	}
}

- (void)hideFindMatches {
	[[self layoutManager] removeTemporaryAttribute:NSBackgroundColorAttributeName forCharacterRange:NSMakeRange(0, [[self string] length])];
}

- (void)showFindMatchesForRanges:(NSArray*)ranges {
	[self hideFindMatches];
	
	for (NSValue* value in ranges) {
		NSRange range = [value rangeValue];
		[[self layoutManager] addTemporaryAttribute:NSBackgroundColorAttributeName value:[NSColor colorWithDeviceRed:0.7 green:0.7 blue:0.0 alpha:0.5] forCharacterRange:range];
	}
}

- (void)performAdvancedFindPanelAction:(id)sender {
}

- (BOOL)validateUserInterfaceItem:(id<NSValidatedUserInterfaceItem>)item {
	if ([item action] == @selector(performAdvancedFindPanelAction:)) {
		return NO;
	}
	else {
		return [super validateUserInterfaceItem:item];
	}
}

- (BOOL)becomeFirstResponder {
	if ([super becomeFirstResponder]) {
		return YES;
	}
	else {
		return NO;
	}
}

- (BOOL)resignFirstResponder {
	if ([super resignFirstResponder]) {
		return YES;
	}
	else {
		return NO;
	}
}

- (void)aBEToggleComment:(id)sender {
	if (self.delegate && [self.delegate respondsToSelector:@selector(textView:doCommandBySelector:)]) {
		[self.delegate textView:self doCommandBySelector:@selector(toggleComment:)];
	}
}

- (void)aBEShiftLeft:(id)sender {
	if (self.delegate && [self.delegate respondsToSelector:@selector(textView:doCommandBySelector:)]) {
		[self.delegate textView:self doCommandBySelector:@selector(shiftLeft:)];
	}
}

- (void)aBEShiftRight:(id)sender {
	if (self.delegate && [self.delegate respondsToSelector:@selector(textView:doCommandBySelector:)]) {
		[self.delegate textView:self doCommandBySelector:@selector(shiftRight:)];
	}
}

- (BOOL)isOpaque {
	return NO;
}

- (void)changeFont:(id)sender {
	[self display];
	[self display];
}

@end

/**
  RBEditingTextView.m
  roboText

  Created by Roger Boesch on 11.03.18.
  Copyright © 2018 Roger Boesch. All rights reserved.
*/
