
#import "QltBridge.h"
#import "RBDirectory.hpp"

extern "C" {
    #import "qlayt.h"
}

static NSMutableArray* s_listOfFiles = NULL;

@implementation QltBridge

+ (int)listMdv:(NSString *)mdvFilename {
    resetglobals();
    
    int result = mdv2fil((char *)[mdvFilename UTF8String], 0);
    
    if (s_listOfFiles == NULL) {
        s_listOfFiles = [NSMutableArray new];
    }
    
    [s_listOfFiles removeAllObjects];
    
    for (int i = 0; i < result; ++i) {
        if (strlen(filenames[i]) > 0) {
            [s_listOfFiles addObject:[NSString stringWithUTF8String:filenames[i]]];
        }
    }
    
    return (int)s_listOfFiles.count;
}

+ (int)fileToMdv:(NSString *)mdvFilename listFilename:(NSString *)listFilename {
    resetglobals();
    return fil2mdv((char *)[listFilename UTF8String], (char *)[mdvFilename UTF8String]);
}

+ (int)mdvToFile:(NSString *)mdvFilename {
    resetglobals();
    return mdv2fil((char *)[mdvFilename UTF8String], 1);
}

+ (NSArray *)qltGetFiles {
    return s_listOfFiles;
}

+ (void)setDirectoryFile:(NSString *)filename {
    strcpy(dirfname, [filename UTF8String]);
}

+ (void)setTemporaryPath:(NSString *)path {
    strcpy(temppath, [path UTF8String]);
}

@end
