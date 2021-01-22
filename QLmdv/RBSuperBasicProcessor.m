
#import "RBSuperBasicProcessor.h"
#import "RBTextSettings.h"

@interface RBSuperBasicProcessor()

@end

@implementation RBSuperBasicProcessor

- (id)init {
    self = [super init];

    self.keywords = [NSArray arrayWithObjects:
                     @"ABS",@"ACOS",@"ACOT",@"ADATE",@"AND",@"ARC",@"ARC_R",@"ASIN",@"AT",@"ATAN",@"AUTO",@"BAUD",@"BEEP",@"BEEPING",
                     @"BLOCK",@"BORDER",@"CALL",@"CHR$",@"CIRCLE",@"CIRCLE_R",@"CLEAR",@"CLOSE",@"CLS",@"CODE",@"CON",@"CONTINUE",@"COPY",
                     @"COPY_N",@"COS",@"COT",@"CSIZE",@"CURSOR",@"DATA",@"DATE",@"DATE$",@"DAY$",@"DEFine",@"DEG",@"DELETE",@"DIM",
                     @"DIMN",@"DIR",@"DIV",@"DLINE",@"EDIT",@"ELLIPSE",@"ELLIPSE_R",@"ELSE",@"END",@"DEFine",@"FOR",@"FuNction",@"IF",@"REPeat",@"SELect",
                     @"WHEN",@"EOF",@"ERRor",@"EXEC",@"EXEC_W",@"EXIT",@"EXP",@"FILL",@"FILL$",@"FLASH",@"FOR",@"FORMAT",
                     @"FuNction",@"GO SUB",@"GO TO",@"IF",@"INK",@"INPUT",@"INSTR",@"INT",@"KEYROW",@"LEN",@"LBYTES",@"LET",@"LINE",@"LINE_R",@"LIST",@"LN", @"LOAD",
                     @"LOG10",@"LRUN",@"MERGE",@"MDV",@"MISTake",@"MOD",@"MODE",@"MOVE",@"MRUN",@"NET",@"NETI",@"NETO",@"NEW",@"NEXT",@"NOT",@"ON",@"OPEN",
                     @"LOCal", @"OPEN_IN",@"OPEN_NEW",@"OR",@"OVER",@"PAN",@"PAPER",@"PAUSE",@"PEEK",@"PEEK_L",@"PEEK_W",@"PENDOWN",@"PENUP",@"PI",@"POINT",@"POINT_R",@"POKE",@"POKE_L",@"POKE_W",@"PRINT",
                     @"PROCedure",@"RAD",@"RANDOMISE",@"READ",@"RECOL",@"REMAINDER",@"REMark",@"RENUM",@"REPeat",@"RESPR",@"RESTORE",@"RETRY",@"RETurn",
                     @"RND",@"RUN",@"SAVE",@"SBYTES",@"SCALE",@"SCR",@"SCROLL",@"SDATE",@"SELect",@"SER",@"SEXEC",@"SIN",@"SQRT",@"STEP",@"STOP",@"STRIP",@"TAN",@"THEN",@"TO",
                     @"TRA",@"TURN",@"TURNTO",@"UNDER",@"VER$",@"WHEN",@"WIDTH",@"WINDOW",@"XOR",
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
