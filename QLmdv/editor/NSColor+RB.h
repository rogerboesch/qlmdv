#import <Cocoa/Cocoa.h>

@interface NSColor (Hex)

- (NSString *)hexValue;
+ (NSColor *)colorFromHexValue:(NSString *)hex alpha:(CGFloat)alpha;
+ (NSColor *)colorFromHexValue:(NSString *)hex;

@end
