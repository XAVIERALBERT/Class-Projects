#include <limits.h>
#include <stdint.h>
#include <time.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <errno.h>
#include "parking.h"

#ifndef MYLARGEST
TODO(USING THE SOLUTION largest.c NOT MY CODE)
#else

/*
 * largest
 *     find the vehicle with the largest number of
 *     tickets and largest fine in database
 *     and print it
 */
void
largest(void)
{
    struct vehicle *count = NULL; // vehicle with largest number of tickets
    struct vehicle *fine = NULL;  // vehicle with largest total fine

	unsigned int Lfine = 0;

	unsigned int Ltickets = 0;

	unsigned int tabCount = 0;

	struct vehicle *curVeh;

	if (htable == NULL || tabsz == 0) {

		return;

	}

    while (tabCount < tabsz) {
		
		curVeh = *(htable  + tabCount);

		while (curVeh != NULL) {

			if (curVeh->tot_fine >= Lfine) {

				Lfine = curVeh->tot_fine;

				fine = curVeh;

			}

			if (curVeh->cnt_ticket >= Ltickets) {

				Ltickets = curVeh->cnt_ticket;

				count = curVeh;

		    }		

			curVeh = curVeh->next;

		}

		tabCount++;

	}

    if ((count == NULL) || (fine == NULL)) {
        printf("Empty database\n");
        return;
    }
    printf("Most tickets Plate: %s, State: %s tickets: %u, total fine: $%u\n",
            count->plate, count->state, count->cnt_ticket, count->tot_fine);
    printf("Largest fine Plate: %s, State: %s tickets: %u, total fine: $%u\n",
            fine->plate, fine->state, fine->cnt_ticket, fine->tot_fine);
    return;
}
#endif
