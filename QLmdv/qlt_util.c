
#include <stdio.h>
#include "qlayt.h"

// Qlt globals (to remove later)
char ifname[LINESIZE];
char lstline[LINESIZE];
char qdosname[QDOSSIZE];
char dosname[DOSSIZE];
char lstline2[LINESIZE];
U8   head[64];
U8   sector[SECTLENQXL];
int  dbg;
int  randmdv;
FILE *qxldf;
char lstfname[256] = "";
char addfname[256] = "";
char outfname[256] = "qlay.mdv";
char dirfname[256] = "qlay.dir";
char temppath[256] = "/";

// Callbacks
void usage(void) {}

// Helper functions
void putlong(U8 *p, U32 v) {
    p[0] = v>>24;
    p[1] = v>>16;
    p[2] = v>>8;
    p[3] = v;
}

void putword(U8 *p, U16 v) {
    p[0] = v>>8;
    p[1] = v;
}

U32 getlong(U8 *p) {
    return (p[0]<<24)+(p[1]<<16)+(p[2]<<8)+p[3];
}

U16 getword(U8 *p) {
    return (p[0]<<8)+p[1];
}

int getxtcc(FILE *f, U32 *d) {
    U8 tmp[8];

    fseek(f,-8L,2);
    fread(tmp,sizeof(U8),8,f);

    if (strncmp(tmp, "XTcc",4) == 0) {
        *d=getlong(&tmp[4]);
    }
    else {
        fprintf(stderr,"Error: could not find XTcc datasize\n");
        return -1;
    }

    return 0;
}
