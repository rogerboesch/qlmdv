
#import <Cocoa/Cocoa.h>

#import "RBEditingTextView.h"
#import "RBTextProcessor.h"

@class RBTextRulerView, RBTextProcessor;

@interface RBEditorView : NSView <NSTextStorageDelegate, RBEditingTextViewDelegate> {
	NSScrollView* _scrollView;
	RBTextRulerView* _rulerView;
	RBEditingTextView* _textView;
	NSError* _error;
	RBKeyTextView* _errorTextView;
	RBTextProcessor* _textProcessor;
	NSString* _lineEnding;
	NSStringEncoding _encoding;
	BOOL _wrapsLines;
}

- (void)updateView;
- (void)convertLineEndings;
- (BOOL)convertToEncoding:(NSStringEncoding)encoding;

@property (nonatomic, retain) RBTextProcessor* textProcessor;

@property (readonly) RBEditingTextView* textView;
@property (nonatomic, retain) NSError* error;

@property (readwrite, copy) NSString* path;
@property (readwrite, copy) NSString* filename;
@property (readwrite, copy) NSString* extension;

@property (readwrite, copy) NSString* lineEnding;
@property (readwrite, readwrite) NSStringEncoding encoding;
@property (readwrite, readwrite) BOOL wrapsLines;

- (NSString *)getText;

- (void)save;
- (void)load:(NSString *)path name:(NSString *)name extension:(NSString *)extension;
- (void)setSource:(NSString *)text name:(NSString *)name extension:(NSString *)extension;
- (void)setReadOnly:(BOOL)flag;

- (void)selectLineWithNumber:(int)number color:(NSColor *)color background:(NSColor *)background;

@end

/**
  RBTextEditor.h
  roboText

  Created by Roger Boesch on 11.03.18.
  Copyright © 2018 Roger Boesch. All rights reserved.
*/
