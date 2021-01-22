
#import "QltBridge.h"
#import "qlayt.h"

static NSMutableArray* s_listOfFiles = NULL;

@implementation QltBridge

+ (void)resetGlobals {
    // Reset globals (Remove after with global vars)
    dbg = 0;
    randmdv = -1;
    ifname[LINESIZE-1] = '\0';
    lstline[LINESIZE-1] = '\0';
    lstline2[LINESIZE-1] = '\0';
    qdosname[QDOSSIZE-1] = '\0';
    dosname[DOSSIZE-1] = '\0';
}

+ (int)listMdv:(NSString *)mdvFilename {
    [self resetGlobals];
    
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
    [self resetGlobals];
    return fil2mdv((char *)[listFilename UTF8String], (char *)[mdvFilename UTF8String]);
}

+ (int)mdvToFile:(NSString *)mdvFilename {
    [self resetGlobals];
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
