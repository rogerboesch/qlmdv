
#import <Cocoa/Cocoa.h>

@class TextDocument;

@interface RBTextProcessor : NSObject {
	NSArray* _keywords;
	NSString* _singleLineCommentPrefix;
	NSUInteger _lastHash;
	NSMutableArray* _resumePoints;
	NSUInteger _highlightStopPosition;
	NSUInteger _highlightResumeIndex;
	NSUInteger _highlightNextHighlight;
	NSUInteger _highlightGoThrough;
}

+ (RBTextProcessor*)defaultProcessor;
+ (RBTextProcessor*)processorForExtension:(NSString*)extension;

- (BOOL)isSimilarTo:(RBTextProcessor*)processor;

- (NSUInteger)quoteLength:(NSString*)string range:(NSRange)range;
- (NSUInteger)whiteSpaceLength:(NSString*)string;

- (void)addPrefix:(NSString*)prefix toSelectedLinesInTextView:(NSTextView*)textView;
- (BOOL)removePrefix:(NSString*)prefix fromSelectedLinesInTextView:(NSTextView*)textView;

- (BOOL)document:(TextDocument*)document textView:(NSTextView*)textView doCommandBySelector:(SEL)selector;
- (BOOL)document:(TextDocument *)document textView:(NSTextView *)textView doKeyDownByEvent:(NSEvent *)event;
- (void)document:(TextDocument*)document textView:(NSTextView*)textView didChangeSelection:(NSRange)oldSelection;

// overload this for syntax highlighting
- (void)syntaxHighlightTextStorage:(NSTextStorage*)textStorage startingAt:(NSUInteger)position;

// call these from syntaxHighlightTextStorage:
- (void)colorText:(NSColor*)color atRange:(NSRange)range textStorage:(NSTextStorage*)textStorage;
- (BOOL)addResumePoint:(NSUInteger)position; // stop highlighting when this returns false
- (void)uppercaseTextAtRange:(NSRange)range textStorage:(NSTextStorage*)textStorage;

// call these when text changes change
- (void)resetTextStorage:(NSTextStorage*)textStorage;
- (void)replacedCharactersInRange:(NSRange)range newRangeLength:(NSUInteger)newRangeLength textStorage:(NSTextStorage*)textStorage;

@property (nonatomic, retain) NSArray* keywords;
@property (nonatomic, copy) NSString* singleLineCommentPrefix;
@property (nonatomic, retain) NSMutableArray* resumePoints;

@end

/**
  RBTextProcessor.h
  roboText

  Created by Roger Boesch on 11.03.18.
  Copyright © 2018 Roger Boesch. All rights reserved.
*/
