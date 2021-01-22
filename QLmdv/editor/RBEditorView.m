
#import "RBEditorView.h"
#import "RBTextRulerView.h"
#import "RBTextSettings.h"

@implementation RBEditorView

@synthesize textView = _textView, textProcessor = _textProcessor, error = _error, lineEnding = _lineEnding, encoding = _encoding, wrapsLines = _wrapsLines;

- (NSString *)getText {
	return [_textView string];
}

- (void)setReadOnly:(BOOL)flag {
    _textView.editable = !flag;
}

#pragma mark - Load/save content

- (void)save {
    NSString* text = [self getText];

    NSError* error = NULL;
    [text writeToFile:self.path atomically:NO encoding:NSUTF8StringEncoding error:&error];

    if (error != nil) {
        NSLog(@"%@", error);
    }
}

- (void)load:(NSString *)path name:(NSString *)name extension:(NSString *)extension {
    NSError* error = NULL;
    NSString* content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
	
    self.path = path;
	self.filename = name;
	self.extension = extension;
	self.textProcessor = [RBTextProcessor processorForExtension:self.extension];
    
	if (content != nil) {
        [_textView setString:content];
		[self textStorageDidProcessEditing:nil];
    }
	else {
		NSLog(@"%@", error);
	}
    
    [self.window makeFirstResponder:self];
}

- (void)setSource:(NSString *)text name:(NSString *)name extension:(NSString *)extension {
    self.path = @"";
    self.filename = name;
    self.extension = extension;
    self.textProcessor = [RBTextProcessor processorForExtension:self.extension];
    [_textView setString:text];

    [_rulerView setNeedsDisplay:YES];

    [self.window makeFirstResponder:self];
}

#pragma mark - Mark line

- (void)selectLineWithNumber:(int)number color:(NSColor *)color background:(NSColor *)background {
    NSLayoutManager *layoutManager = _textView.layoutManager;
    int numberOfLines = 0;
    NSRange lineRange = NSMakeRange(0, 0);
    int indexOfGlyph = 0;
    int numberOfGlyphs = (int)layoutManager.numberOfGlyphs;

    [self.textView.layoutManager removeTemporaryAttribute:NSBackgroundColorAttributeName forCharacterRange:NSMakeRange(0, [self.textView.string length])];

    do {
        [layoutManager lineFragmentRectForGlyphAtIndex:indexOfGlyph effectiveRange:&lineRange];
        
        if (numberOfLines == number-1) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self.textView.layoutManager addTemporaryAttribute:NSForegroundColorAttributeName value:color forCharacterRange:lineRange];
                [self.textView.layoutManager addTemporaryAttribute:NSBackgroundColorAttributeName value:background forCharacterRange:lineRange];
            }];

            return;
        }
        
        indexOfGlyph = (int)NSMaxRange(lineRange);
        numberOfLines += 1;

    } while (indexOfGlyph < numberOfGlyphs);
}

#pragma mark - Init

- (id)initWithFrame:(NSRect)frameRect {
    if (self = [super initWithFrame:frameRect]) {
		self.error = nil;
		_errorTextView = nil;

		self.encoding = [RBTextSettings shared].defaultEncoding;
		self.wrapsLines = NO;
		self.lineEnding = @"\n";
		self.textProcessor = [RBTextProcessor defaultProcessor];
		
		_textView = [[RBEditingTextView alloc] initWithFrame:self.bounds];
		[_textView setMaxSize:NSMakeSize(FLT_MAX, FLT_MAX)];
		[_textView setAllowsUndo:YES];
		[_textView setRichText:NO];
		[_textView setEditable:YES];
		[_textView setUsesFindBar:NO];
		[_textView setUsesFindPanel:YES];
		[_textView setUsesFontPanel:NO];
		[_textView setTextContainerInset:(NSSize){4.0, 4.0}];
		[_textView setDelegate:self];
		[_textView setAutomaticDashSubstitutionEnabled:NO];
		[_textView setAutomaticLinkDetectionEnabled:NO];
		[_textView setAutomaticDataDetectionEnabled:NO];
		[_textView setAutomaticTextReplacementEnabled:NO];
		[_textView setAutomaticQuoteSubstitutionEnabled:NO];
		[_textView setAutomaticSpellingCorrectionEnabled:NO];
		[[_textView textStorage] setDelegate:self];

		_scrollView = [[NSScrollView alloc] initWithFrame:self.bounds];
		[_scrollView setAutoresizingMask:(NSViewWidthSizable | NSViewHeightSizable)];
		[_scrollView setHasHorizontalScroller:YES];
		[_scrollView setHasVerticalScroller:YES];
		[_scrollView setDocumentView:_textView];

		_rulerView = [[RBTextRulerView alloc] initWithScrollView:_scrollView orientation:NSVerticalRuler];
		
		[_scrollView setVerticalRulerView:_rulerView];
		
		[_textView setAutoresizingMask:(NSViewWidthSizable | NSViewHeightSizable)];

		[self addSubview:_scrollView];

		[self updateView];
	}
    return self;
}

- (void)resizeSubviewsWithOldSize:(NSSize)oldSize {
	_scrollView.frame = self.bounds;
	_textView.frame = self.bounds;
}

- (void)textStorageDidProcessEditing:(NSNotification *)notification {
	NSTextStorage* textStorage = [notification object];
	NSRange range = [textStorage editedRange];
	NSInteger changeInLength = [textStorage changeInLength];

	[_textProcessor replacedCharactersInRange:range newRangeLength:range.length + changeInLength textStorage:textStorage];

	[self invalidateRestorableState];
}

- (void)convertLineEndings {
	NSString* original = [_textView string];
	
	NSString* noCRLFs = [original stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\n"];

	NSString* noCRs = [noCRLFs stringByReplacingOccurrencesOfString:@"\r" withString:@"\n"];
	
	NSString* result;
	
	if ([self.lineEnding compare:@"\n"] == NSOrderedSame) {
		result = noCRs;
	} else {
		result = [noCRs stringByReplacingOccurrencesOfString:@"\n" withString:self.lineEnding];
	}
	
	if ([result compare:original] == NSOrderedSame) {
		return;
	}
	
	if ([_textView shouldChangeTextInRange:NSMakeRange(0, original.length) replacementString:result]) {
		[_textView replaceCharactersInRange:NSMakeRange(0, original.length) withString:result];
		[_textView didChangeText];
	}
}

// for the undo manager only
- (void)_convertToEncoding:(NSNumber*)encoding {
	[self convertToEncoding:[encoding unsignedIntegerValue]];
}

- (BOOL)convertToEncoding:(NSStringEncoding)encoding {
	NSString* original = [_textView string];

	NSData* data = [original dataUsingEncoding:encoding allowLossyConversion:NO];

	if (!data) {
		return NO;
	}

	NSString* result = [[NSString alloc] initWithData:data encoding:encoding];
	
	if (!result) {
		return NO;
	}
	
	[[self undoManager] registerUndoWithTarget:self selector:@selector(_convertToEncoding:) object:[NSNumber numberWithUnsignedInteger:_encoding]];
	[[self undoManager] setActionName:@"Encoding"];
	
	self.encoding = encoding;
	
	// don't let the text view register an undo for this
	[[self undoManager] disableUndoRegistration];

	if ([_textView shouldChangeTextInRange:NSMakeRange(0, original.length) replacementString:result]) {
		[_textView replaceCharactersInRange:NSMakeRange(0, original.length) withString:result];
		[_textView didChangeText];
	}

	[[self undoManager] enableUndoRegistration];

	[result release];
	
	return YES;
}

- (void)updateView {
	NSMutableParagraphStyle* paragraphStyle = [[_textView defaultParagraphStyle] mutableCopy];
	
	if (paragraphStyle == nil) {
		paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
	}
	
	float charWidth = [[[RBTextSettings shared].font screenFontWithRenderingMode:NSFontDefaultRenderingMode] advancementForGlyph:' '].width;
	[paragraphStyle setDefaultTabInterval:(charWidth * [RBTextSettings shared].tabSize)];
	[paragraphStyle setTabStops:[NSArray array]];
	
	if (self.wrapsLines) {
		[paragraphStyle setLineBreakMode:NSLineBreakByCharWrapping];
		[[_textView textContainer] setContainerSize:NSMakeSize(_scrollView.contentSize.width, FLT_MAX)];
		[[_textView textContainer] setWidthTracksTextView:YES];
		[_textView setFrameSize:[[_textView textContainer] containerSize]];
		[_textView setHorizontallyResizable:NO];
		[_scrollView setHasHorizontalScroller:NO];
	}
	else {
		[[_textView textContainer] setContainerSize:NSMakeSize(FLT_MAX, FLT_MAX)];
		[[_textView textContainer] setWidthTracksTextView:NO];
		[_textView setHorizontallyResizable:YES];
		[_scrollView setHasHorizontalScroller:YES];
	}
	
	[_textView setDefaultParagraphStyle:paragraphStyle];
	
	NSMutableDictionary* typingAttributes = [[_textView typingAttributes] mutableCopy];
	[typingAttributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];	
	[typingAttributes setObject:[RBTextSettings shared].font forKey:NSFontAttributeName];
	[_textView setTypingAttributes:typingAttributes];

	[_textView setFont:[RBTextSettings shared].font];
	[_textView setBackgroundColor:[RBTextSettings shared].backgroundColor];
	[_textView setInsertionPointColor:[RBTextSettings shared].cursorColor];

	[_textView setSelectedTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[RBTextSettings shared].selectionColor, NSBackgroundColorAttributeName, nil]];

	[_scrollView setBackgroundColor:[RBTextSettings shared].backgroundColor];

	[_scrollView setRulersVisible:YES];
	[_rulerView setNeedsDisplay:YES];

	if (self.error) {
		if (!_errorTextView) {
			_errorTextView = [[RBKeyTextView alloc] initWithFrame:NSMakeRect(100.0, 200.0, self.bounds.size.width - 200.0, self.bounds.size.height - 400.0)];
			[_errorTextView setAutoresizingMask:(NSViewWidthSizable | NSViewHeightSizable)];
			[_errorTextView setString:[self.error description]];
			[_errorTextView setEditable:NO];
			[_errorTextView setSelectable:YES];
			[_errorTextView setBackgroundColor:[NSColor clearColor]];
			
			[self addSubview:_errorTextView];
			[_scrollView removeFromSuperview];
		}
		[_textView setEditable:NO];
	}

	[[_textView textStorage] addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [[_textView textStorage] length])];
	
	// if we don't fix the size here, it'll get drawn when the height is FLT_MAX which does weird things
	[_textView sizeToFit];
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError {
	if ([typeName isEqualToString:@"All Documents"]) {
		return [[_textView string] dataUsingEncoding:_encoding];
	}

    if (outError) {
        *outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
    }
    return nil;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError {
	if ([typeName isEqualToString:@"All Documents"]) {
		NSString* string;
		// try the current encoding, then the default, then iso latin 1
		if ((string = [[NSString alloc] initWithData:data encoding:self.encoding])) {
			// success, do nothing
		} else if ((string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding])) {
			self.encoding = NSUTF8StringEncoding;
		} else {
			string = [[NSString alloc] initWithData:data encoding:NSISOLatin1StringEncoding];
			self.encoding = NSISOLatin1StringEncoding;
		}
		[_textView setString:string];
		[string release];
		return YES;
	}

    if (outError) {
        *outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
    }
    return NO;
}

- (void)setFileURL:(NSURL*)absoluteURL {
}

- (BOOL)textView:(NSTextView *)textView doCommandBySelector:(SEL)selector {
	if (self.textProcessor) {
		return [self.textProcessor document:nil textView:textView doCommandBySelector:selector];
	}

	return NO;
}

- (BOOL)textView:(NSTextView *)textView doKeyDownByEvent:(NSEvent *)event {
	return [self.textProcessor document:nil textView:textView doKeyDownByEvent:event];
}

- (NSArray*)textView:(NSTextView *)textView completions:(NSArray *)words forPartialWordRange:(NSRange)charRange indexOfSelectedItem:(NSInteger *)index {
	return nil;
}

- (void)textViewDidChangeSelection:(NSNotification *)notification {
	NSRange oldSelection = [(NSValue*)[[notification userInfo] objectForKey:@"NSOldSelectedCharacterRange"] rangeValue];
	
	[self.textProcessor document:nil textView:_textView didChangeSelection:oldSelection];
}

- (void)textDidChange:(NSNotification *)notification {
	[self invalidateRestorableState];
	[_rulerView setNeedsDisplay:YES];
}

- (void)dealloc {	
	self.error = nil;

	[_rulerView release];
	[_scrollView release];
	[_textView release];
	[_errorTextView release];
	
	self.lineEnding = nil;

	[super dealloc];
}

@end

/**
  RBTextEditor.m
  roboText

  Created by Roger Boesch on 11.03.18.
  Copyright © 2018 Roger Boesch. All rights reserved.
*/
