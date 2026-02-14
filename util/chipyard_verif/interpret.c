#include <stdio.h>

typedef unsigned char u8;
typedef unsigned short u16;
typedef unsigned int u32;

#define trace

u16 terminate(u32 *d, u8 (*c)[4], u16 op) {
#ifdef TRACE
    printf(" Terminated.");
#endif
    return 0xffff;
}

u16 assign(u32 *d, u8 (*c)[4], u16 op) {
    d[c[op][1]] = (signed char)c[op][2];
#ifdef TRACE
    printf(" [%d] = %d", c[op][1], d[c[op][1]]);
#endif
    return op + 1;
}

u16 jgz(u32 *d, u8 (*c)[4], u16 op) {
    int cond = (int)d[c[op][2]] > 0;
#ifdef TRACE
    printf(cond ? " taken" : " not taken");
#endif
    return cond ? c[op][3] : op + 1;
}

u16 add(u32 *d, u8 (*c)[4], u16 op) {
    d[c[op][1]] = d[c[op][2]] + d[c[op][3]];
#ifdef TRACE
    printf(" [%d] = %d", c[op][1], d[c[op][1]]);
#endif
    return op + 1;
}

u16 sll(u32 *d, u8 (*c)[4], u16 op) {
    d[c[op][1]] = d[c[op][2]] << c[op][3];
#ifdef TRACE
    printf(" [%d] = %d", c[op][1], d[c[op][1]]);
#endif
    return op + 1;
}

int main(int argc, char *argv[]) {
    if (argc < 2) {
        printf("Please provide arguments: ./interpret file\n");
        return 0;
    }

    FILE *fp = fopen(argv[1], "r");
    if (fp == NULL) {
        printf("Failed to open file %s.\n", argv[1]);
        return -1;
    }

    u32 data[256];    // data width is 32, address width is 8
    u8  code[65536][4]; // 4-tuple
    u16 (*ft[256])(u32 *, u8 (*)[4], u16);

    // initialize operator functions
    for (int i = 0; i < 256; i++)
        ft[i] = terminate;
    ft['.'] = terminate;
    ft['='] = assign;
    ft['j'] = jgz;
    ft['+'] = add;
    ft['<'] = sll;

    // read code from file
    for (int i = 0; i < 65536; i++) {
        code[i][0] = '.';
        while ((code[i][0] = fgetc(fp)) != 0xff && (code[i][0] <= 0x20 || code[i][0] > 0x7e))
            ;
        if (code[i][0] == 0xff)
            code[i][0] = '.';
        if (fscanf(fp, "%hhd%hhd%hhd", &code[i][1], &code[i][2], &code[i][3]) != 3)
            break;
    }

    u16 op = 0; // operator pointer
    while (op != 0xffff) {
#ifdef TRACE
        printf("%d: %c %02x %02x %02x |", op, code[op][0], code[op][1], code[op][2], code[op][3]);
#endif
        op = ft[code[op][0]](data, code, op);
#ifdef TRACE
        printf("\n");
#endif
    }

    printf("Result: %d\n", data[0]);

    fclose(fp);
    return 0;
}
