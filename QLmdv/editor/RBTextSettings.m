
#import "RBTextSettings.h"
#import "NSColor+RB.h"

@implementation RBTextSettings

- (id)init {
	self = [super init];
	
	// Editor
	self.tabKeyInsertsSpaces = YES;
	self.tabSize = 4;
	self.tabString = @"\t";
	self.defaultEncoding = NSUTF8StringEncoding;
	self.tabKeyInsertsSpaces = YES;
	self.defaultLineEnding = @"\n";
	self.wrapLinesByDefault = YES;
	self.showLineNumbers = YES;
	self.autoIndentNewLines = YES;
	self.autoIndentCloseBraces = YES;

	// Appearance
	self.font = [NSFont fontWithName:@"Menlo" size: 13];

	self.lineNumberFont = [NSFont systemFontOfSize:12.0];
	self.backgroundColor = [NSColor colorFromHexValue:@"1F1F24"];
	self.defaultColor = [NSColor whiteColor];
    self.keywordColor = [NSColor colorFromHexValue:@"FC5FA3"];
    self.keyword2Color = [NSColor colorFromHexValue:@"89C0B4"];
    self.keyword3Color = [NSColor colorFromHexValue:@"89C0B4" alpha:0.6];
	self.commentColor = [NSColor colorFromHexValue:@"6C7986"];
	self.constantColor = [NSColor colorFromHexValue:@"D0BF69"];
	self.directiveColor = [NSColor colorFromHexValue:@"FD8F3F"];
	self.quoteColor = [NSColor colorFromHexValue:@"FC6A5D"];
	self.functionColor = [NSColor cyanColor];
	self.identifierColor = [NSColor colorFromHexValue:@"FFFFFF"];
	self.selectionColor = [NSColor colorFromHexValue:@"AAAAAA"];
	self.cursorColor = [NSColor whiteColor];
	self.lineNumberColor = [NSColor whiteColor];
	
	return self;
}

+ (RBTextSettings *)shared {
    static RBTextSettings *shared = nil;
    static dispatch_once_t onceToken;

	dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    
	return shared;
}
@end

/**
  RBTextSettings.m
  roboText

  Created by Roger Boesch on 11.03.18.
  Copyright © 2018 Roger Boesch. All rights reserved.
*/

