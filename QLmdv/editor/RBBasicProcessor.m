
#import "RBBasicProcessor.h"
#import "RBTextSettings.h"

@interface RBBasicProcessor()
@end

@implementation RBBasicProcessor

- (id)init {
    self = [super init];

    self.keywords = [NSArray arrayWithObjects:
                    @"SPECTRUM", @"PLAY", @"RND", @"INKEY$", @"PI", @"POINT", @"SCREEN$", @"ATTR", @"AT", @"TAB", @"VAL$", @"CODE", @"VAL",
                     @"LEN", @"SIN", @"COS", @"TAN", @"ASN", @"ACS", @"ATN", @"LN", @"EXP", @"INT", @"SQR", @"SGN", @"ABS", @"PEEK", @"IN",
                     @"USR", @"STR$", @"CHR$", @"NOT", @"BIN", @"OR", @"AND", @"LINE", @"THEN", @"TO", @"STEP", @"DEF", @"FN", @"CAT",
                     @"FORMAT", @"MOVE", @"ERASE", @"OPEN", @"CLOSE", @"MERGE", @"VERIFY", @"BEEP", @"CIRCLE", @"INK", @"PAPER", @"FLASH",
                     @"BRIGHT", @"INVERSE", @"OVER", @"OUT", @"LPRINT", @"LLIST", @"STOP", @"READ", @"DATA", @"RESTORE", @"NEW", @"BORDER",
                     @"CONTINUE", @"DIM", @"REM", @"FOR", @"GOTO", @"GOSUB", @"INPUT", @"LOAD", @"LIST", @"LET", @"PAUSE", @"NEXT", @"POKE",
                     @"PRINT", @"PLOT", @"RUN", @"SAVE", @"RANDOMIZE", @"IF", @"CLS", @"DRAW", @"CLEAR", @"RETURN", @"COPY",
                     nil];

    return self;
}

- (void)replacedCharactersInRange:(NSRange)range newRangeLength:(NSUInteger)newRangeLength textStorage:(NSTextStorage*)textStorage {
    [self uppercaseTextAtRange:range textStorage:textStorage];
    [super replacedCharactersInRange:range newRangeLength:newRangeLength textStorage:textStorage];
}

- (void)syntaxHighlightTextStorage:(NSTextStorage*)textStorage startingAt:(NSUInteger)position {
    NSString* string = [textStorage string];
    NSUInteger length = [string length] - position;

    // for quotes and multi-line comments that return to directives when they end
    bool returnToDirective = false;

    NSUInteger i;
    
    while (length > 0 && length < 0x80000000) {
        if (!returnToDirective && ![self addResumePoint:position]) {
            return;
        }
        
        unichar c1 = [string characterAtIndex:position];
        unichar c2 = (length > 1 ? [string characterAtIndex:position + 1] : 'x');
        unichar c3 = (length > 2 ? [string characterAtIndex:position + 2] : 'x');

        if (c1 == 'R' && c2 == 'E' && c3 == 'M') {
            // single line comment
            for (i = 1; i < length; ++i) {
                if ([string characterAtIndex:position + i] == '\n' && [string characterAtIndex:position + i - 1] != '\\') {
                    break;
                }
            }

            [self colorText:[RBTextSettings shared].commentColor atRange:NSMakeRange(position, i) textStorage:textStorage];

            position += i;
            length -= i;
        }
        else if (c1 == '"' || c1 == '\'') {
            // quote
            NSUInteger quoteLength = [self quoteLength:string range:NSMakeRange(position, length)];

            [self colorText:(c1 == '"' ? [RBTextSettings shared].quoteColor : [RBTextSettings shared].constantColor) atRange:NSMakeRange(position, quoteLength) textStorage:textStorage];

            position += quoteLength;
            length -= quoteLength;
        }
        else if (returnToDirective || c1 == '#') {
            // preprocessor directive
            returnToDirective = false;
            
            for (i = 0; i < length; ++i) {
                unichar ic1 = [string characterAtIndex:position + i];
                
                if (ic1 == '"' || ic1 == '\'') {
                    // quote
                    returnToDirective = true;
                    break;
                }

                if (ic1 == '\n' && [string characterAtIndex:position + i - 1] != '\\') {
                    // end of the directive
                    break;
                }
            }
            
            [self colorText:[RBTextSettings shared].directiveColor atRange:NSMakeRange(position, i) textStorage:textStorage];

            position += i;
            length -= i;
        }
        else if ((c1 >= '0' && c1 <= '9') || (c1 == '.' && (c2 >= '0' && c2 <= '9'))) {
            // number
            for (i = 1; i < length; ++i) {
                unichar c = [string characterAtIndex:position + i];

                if (!((c >= '0' && c <= '9') || (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || c == '.')) {
                    break;
                }
            }
            
            [self colorText:[RBTextSettings shared].constantColor atRange:NSMakeRange(position, i) textStorage:textStorage];

            position += i;
            length -= i;
        }
        else if ((c1 >= 'a' && c1 <= 'z') || (c1 >= 'A' && c1 <= 'Z') || c1 == '_') {
            // identifier
            for (i = 1; i < length; ++i) {
                unichar c = [string characterAtIndex:position + i];

                if (!((c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || (c >= '0' && c <= '9') || c == '_')) {
                    break;
                }
            }
            
            NSString* identifier = [string substringWithRange:NSMakeRange(position, i)];

            if ([self.keywords containsObject:identifier]) {
                [self colorText:[RBTextSettings shared].keywordColor atRange:NSMakeRange(position, i) textStorage:textStorage];
            }

            position += i;
            length -= i;
        }
        else {
            ++position;
            --length;
        }
    }
}

@end
