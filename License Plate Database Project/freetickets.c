#include <limits.h>
#include <stdint.h>
#include <time.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <errno.h>
#include "parking.h"
#include "hashdb.h"

#ifndef MYFREETICKETS
TODO(USING THE SOLUTION freetickets.c NOT MY CODE)
#else

/*
 * freetickets
 *      tears down the database freeing all allocated memory
 *      count the number of tickets freed in the database and
 *      print it out before returning
 *
 *      unsigned long cnt = 0UL
 *      printf("Total tickets freed: %lu\n", cnt);
 */
void
freetickets(void)
{
    int empty = 1; // set to zero if the database is not empty
	
	long unsigned int cnt = 0;

    /*
     * walk down each chain
     */

    /*
     * remove all the tickets for all vehicles
     * on this chain
     */

    /*
     * free the vehicle
     */

    /*
     * chain is removed, update the htable entry
     */

	struct vehicle *curVeh;

	struct vehicle *nextVeh;

	struct ticket *nextT;

	int hCount = 0;

	unsigned int tabCount = 0;

	while (tabCount < tabsz) {

		curVeh = *(htable + hCount);

		while (curVeh != NULL) {

			empty = 0;

			nextVeh = curVeh->next;

			while (curVeh->head != NULL) {

				nextT = curVeh->head->next;
			
				free(curVeh->head);

				curVeh->head = nextT;

				cnt++;

			}

			free(curVeh->plate);

			free(curVeh->state);

			free(curVeh);

			curVeh = nextVeh;

		}

		*(htable + hCount) = NULL;

		hCount++;

		tabCount++;
	
	}

    if (empty)
        printf("Empty Database\n");
    printf("Total tickets freed: %lu\n", cnt);
    return;
}
#endif
