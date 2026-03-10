#include <cstdio>
#include <cstring>
#include <cstdlib>
#include <ctime>

int main(int argc, char *argv[])
{
    // parse arguments
    int num = 256;
    if (argc > 1)
        num = atoi(argv[1]);

    srand(time(NULL));

    // set available function
    int func[256], fnum = 3;
    memset(func, 0, sizeof(func));
    func[0] = '=';
    func[1] = '+';
    func[2] = '<';

    for (int i = 0; i < 256; i++)
    {
        printf("=    %d    %d    0\n", i, rand() % 32);
        if (num)
            num--;
    }

    // generate code
    while (num--)
    {
        int opc, op[3];
        opc = rand() % fnum;
        op[0] = rand() % 32;
        op[1] = rand() % 32;
        op[2] = rand() % 32;
        printf("%c    %d    %d    %d\n", func[opc], op[0], op[1], op[2]);
    }

    return 0;
}