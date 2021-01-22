
#import <Cocoa/Cocoa.h>

@interface RBTextSettings : NSObject

// Editor
@property (nonatomic, readwrite) BOOL tabKeyInsertsSpaces;
@property (nonatomic, readwrite) NSUInteger tabSize;
@property (nonatomic, readwrite) NSStringEncoding defaultEncoding;
@property (nonatomic, copy) NSString* tabString;
@property (nonatomic, copy) NSString* defaultLineEnding;
@property (nonatomic, readwrite) BOOL wrapLinesByDefault;
@property (nonatomic, readwrite) BOOL showLineNumbers;
@property (nonatomic, readwrite) BOOL autoIndentNewLines;
@property (nonatomic, readwrite) BOOL autoIndentCloseBraces;

// Appearance
@property (nonatomic, retain) NSFont* font;
@property (nonatomic, retain) NSFont* lineNumberFont;
@property (nonatomic, retain) NSColor* defaultColor;
@property (nonatomic, retain) NSColor* keywordColor;
@property (nonatomic, retain) NSColor* keyword2Color;
@property (nonatomic, retain) NSColor* keyword3Color;
@property (nonatomic, retain) NSColor* commentColor;
@property (nonatomic, retain) NSColor* constantColor;
@property (nonatomic, retain) NSColor* directiveColor;
@property (nonatomic, retain) NSColor* quoteColor;
@property (nonatomic, retain) NSColor* functionColor;
@property (nonatomic, retain) NSColor* identifierColor;
@property (nonatomic, retain) NSColor* backgroundColor;
@property (nonatomic, retain) NSColor* selectionColor;
@property (nonatomic, retain) NSColor* cursorColor;
@property (nonatomic, retain) NSColor* lineNumberColor;

+ (RBTextSettings *)shared;

@end

/**
  RBTextSettings.h
  roboText

  Created by Roger Boesch on 11.03.18.
  Copyright © 2018 Roger Boesch. All rights reserved.
*/

