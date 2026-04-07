#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
    if (argc < 3) {
        fprintf(stderr, "Usage: %s <iter> <nops>\n", argv[0]);
        return 1;
    }

    // randomized calculation
    srand(1);
    int r[1024];
    for (int i = 0; i < sizeof(r) / sizeof(r[0]); i++)
        r[i] = rand() % 4;
    int n = atoi(argv[1]), m = atoi(argv[2]), ans = 0;
    for (int i = 0; i < n; i++) {
        int x = r[i % (sizeof(r) / sizeof(r[0]))];
        for (int j = 0; j < m; j++)
            asm volatile("nop");
        if (x % 2 == 0)
            ans += x;
        else
            ans -= x;
    }

    printf("%d\n", ans);
    return 0;
}
