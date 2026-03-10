#include <cstdio>
#include <cstring>
#include <cstdlib>

#define COM_STR "[commit]"
#define UPD_STR "[update]"
#define PRD_STR "[predict]"
#define STR_EQL(str, ref) (strncmp(str, ref, strlen(ref)) == 0)
#define LOCATE(delim) while (*p != '\0' && *p != delim) ++p
#define BH(index) (bh[((index) + bhptr) % 64])
#define PH(index) (ph[((index) + phptr) % phmax])

int main()
{
    const int bhlen = 16;
    const int phlen = 2, phmax = 8, phsz = 16;
    const int nsets = 128;
    const int nways = 2;
    const int tagsz = 16;
    const int bankw = 4;
    int com = 0, upd = 0, prd = 0, wrt = 0, col = 0;
    unsigned long btb[bankw][nsets][nways], tag[bankw][nsets][nways], bh[64];
    unsigned long ph[phmax];
    int bhptr = 0, phptr = 0;
    memset(btb, 0, sizeof(btb));
    memset(tag, 0, sizeof(tag));
    memset(bh, 0, sizeof(bh));
    memset(ph, 0, sizeof(ph));
    while (true)
    {
        char line[1024];
        if (!fgets(line, sizeof(line), stdin))
            break;
        char *p = line;
        if (STR_EQL(p, COM_STR))
        {
            // extract committing info
            ++com;
            unsigned long pc, misp, target, type;
            static unsigned long lastpc;
            LOCATE(':');
            if (p - 2 > line && STR_EQL(p - 2, "pc"))
                pc = strtoul(++p, &p, 16);
            LOCATE(':');
            if (p - 4 > line && STR_EQL(p - 4, "misp"))
                misp = strtoul(++p, &p, 16);
            LOCATE(':');
            if (p - 6 > line && STR_EQL(p - 6, "target"))
                target = strtoul(++p, &p, 16);
            LOCATE(':');
            if (p - 4 > line && STR_EQL(p - 4, "type"))
                if (STR_EQL(++++p, "branch"))
                    type = 1;
                else if (STR_EQL(p, "jalr"))
                    type = 2;
                else
                    type = 0;
            if (type == 1)
                bh[(bhptr++) % 64] = target;
            else if (type == 2)
                ph[(phptr++) % phmax] = target;
            // adjacent branch history is not deterministic
            // anyway we do not modify the branch history design
            // so that its verification is not fundamental
            if (type == 1 && (pc & ~7ul) == ((lastpc + 2) & ~7ul))
                memset(bh, 0, sizeof(bh));
            if (type == 1)
                lastpc = pc;
        }
        else if (STR_EQL(p, UPD_STR))
        {
            // extract updating info
            ++upd;
            unsigned long pc, target, misp, utag, uway;
            LOCATE(':');
            if (p - 2 > line && STR_EQL(p - 2, "pc"))
                pc = strtoul(++p, &p, 16);
            LOCATE(':');
            if (p - 6 > line && STR_EQL(p - 6, "target"))
                target = strtoul(++p, &p, 16);
            LOCATE(':');
            if (p - 4 > line && STR_EQL(p - 4, "misp"))
                misp = strtoul(++p, &p, 16);
            LOCATE(':');
            if (p - 3 > line && STR_EQL(p - 3, "tag"))
                utag = strtoul(++p, &p, 16);
            LOCATE(':');
            if (p - 3 > line && STR_EQL(p - 3, "way"))
                uway = strtoul(++p, &p, 16);

            // update table
            if (misp)
            {
                ++wrt;
                if (tag[(pc & 7) >> 1][utag & (nsets - 1)][uway] &&
                    tag[(pc & 7) >> 1][utag & (nsets - 1)][uway] != utag)
                    ++col;
                btb[(pc & 7) >> 1][utag & (nsets - 1)][uway] = target;
                tag[(pc & 7) >> 1][utag & (nsets - 1)][uway] = utag;
            }
        }
        else if (STR_EQL(p, PRD_STR))
        {
            // extract predicting info
            ++prd;
            unsigned long pc, ghist, phist[phmax], pred, ghist_unspec;
            LOCATE(':');
            if (p - 2 > line && STR_EQL(p - 5, "f2_pc"))
                pc = strtoul(++p, &p, 16);
            LOCATE(':');
            if (p - 6 > line && STR_EQL(p - 8, "f2_ghist"))
                ghist = strtoul(++p, &p, 16);
            LOCATE(':');
            if (p - 6 > line && STR_EQL(p - 8, "f2_phist"))
                for (int i = 0; i < phmax; i++)
                    phist[i] = strtoul(++p, &p, 16);
            LOCATE(':');
            if (p - 5 > line && STR_EQL(p - 7, "pred_pc"))
                pred = strtoul(++p, &p, 16);
            for (int i = 0; i < 64; i++)
                ghist_unspec = (ghist_unspec << 1) | BH(i);

#ifdef LOG_PRED
            // output for debugging
            printf("[predict] pc: %lx  pred: %lx  ghist: %lx  ghist_unspec: %lx",
                pc, pred, ghist, ghist_unspec);
            printf("  phist: ");
            for (int i = 0; i < phmax; i++)
                printf("%lx ", phist[i]);
            printf("  phist_unspec: ");
            for (int i = 0; i < phmax; i++)
                printf("%lx ", PH(i) & (1ul << phsz) - 1);
            printf("\n");
#endif

            // check branch history
            unsigned long nz_spec = 0, nz_unspec = 0, x = ghist, y = ghist_unspec;
            while (x)
                ++nz_spec, x >>= 1;
            while (y)
                ++nz_unspec, y >>= 1;
            const int bcklen = 32;
            // check when effective lengths are long enough
            x = ghist;
            if (nz_spec >= bcklen && nz_unspec >= bcklen)
            {
                int match = 0;
                while (nz_spec > 0)
                {
                    unsigned long nz = nz_spec < nz_unspec ? nz_spec : nz_unspec;
                    unsigned long mask = nz == 64 ? -1ul : (1ul << nz) - 1;
                    if ((x & mask) == (ghist_unspec & mask))
                    {
                        match = 1;
                        break;
                    }
                    x >>= 1;
                    --nz_spec;
                }
                if (!match)
                {
                    printf("[BH checking] pc: %lx  ghist: %lx  ghist_unspec: %lx", pc, ghist, ghist_unspec);
                    exit(1);
                }
            }

            // check path history
            nz_spec = nz_unspec = 0;
            for (int i = 0; i < phmax; i++)
            {
                if (PH(i))
                    ++nz_unspec;
                if (phist[i])
                    ++nz_spec;
            }
            const int pcklen = phmax;
            if (nz_spec >= pcklen && nz_unspec >= pcklen)
            {
                int match = 0;
                unsigned long nz = nz_spec < nz_unspec ? nz_spec : nz_unspec;
                for (int s = 0; s < nz; s++)
                {
                    int same = 1;
                    for (int i = s; i < nz; i++)
                    {
                        if ((phist[phmax - 1 - i] & (1ul << phsz) - 1) !=
                            (PH(phmax - 1 - i + s) & (1ul << phsz) - 1))
                        {
                            same = 0;
                            break;
                        }
                    }
                    if (same)
                    {
                        match = 1;
                        break;
                    }
                }
                if (!match)
                {
                    printf("[PH checking] pc: %lx  phist: ", pc);
                    for (int i = 0; i < phmax; i++)
                        printf("%lx ", phist[i]);
                    printf("  phist_unspec: ");
                    for (int i = 0; i < phmax; i++)
                        printf("%lx ", PH(i) & (1ul << phsz) - 1);
                    printf("\n");
                    exit(1);
                }
            }

            // check prediction result
            unsigned long ptag = ((pc >> 3) ^ ghist) & (1 << tagsz) - 1;
            int found = 0;
            for (int i = 0; i < phlen; i++)
                ptag ^= phist[phmax - 1 - i];
            for (int i = 0; i < nways; i++)
                if (tag[(pc & 7) >> 1][ptag & (nsets - 1)][i] == ptag)
                {
                    found = 1;
                    if (btb[(pc & 7) >> 1][ptag & (nsets - 1)][i] != pred)
                    {
                        printf("[Pred checking] pc: %lx  wrong_pred: %lx  correct_pred: %lx\n",
                            pc, pred, btb[(pc & 7) >> 1][ptag & (nsets - 1)][i]);
                        exit(1);
                    }
                }
            if (!found)
            {
                printf("[Pred checking] pc: %lx  wrong_pred: %lx  correct_pred: N/A\n", pc, pred);
                exit(1);
            }
        }
    }
    printf("Total commit entries: %d\n", com);
    printf("Total update entries: %d\n", upd);
    printf("Total predict entries: %d\n", prd);
    printf("Total writen entries: %d\n", wrt);
    printf("Total collision entries: %d\n", col);
    return 0;
}
