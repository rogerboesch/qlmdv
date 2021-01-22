
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QltBridge : NSObject

// Qlt tools
+ (int)listMdv:(NSString *)mdvFilename;
+ (int)fileToMdv:(NSString *)mdvFilename listFilename:(NSString *)listFilename;
+ (int)mdvToFile:(NSString *)mdvFilename;

// Integration helpers
+ (NSArray *)qltGetFiles;
+ (void)setDirectoryFile:(NSString *)filename;
+ (void)setTemporaryPath:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
