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

#ifndef MYVEHLOOKUP
TODO(USING THE SOLUTION vehlookup.c NOT MY CODE)
#else

/*
 * vehiclelookup
 *          look for vehicle in the database
 *          vehicle must match both plate and state strings
 * args
 *  plate   plate id string to be found
 *  state   state id string to be found
 *
 * returns  pointer to vehicle if found NULL otherwise
 */

struct vehicle *
vehiclelookup(char *plate, char *state)
{
	struct vehicle *curVeh;

	char *curPlate;

	char *curState;
	
	unsigned int key = hash(plate) % tabsz;

	curVeh = *(htable + key);

	if (curVeh == NULL) {

		return NULL;

	}	

	while (curVeh != NULL) {

		curPlate = curVeh->plate;

		curState = curVeh->state;
		
		if (strcmp(curPlate, plate) == 0 && strcmp(curState, state) == 0) {

			return curVeh;

		}

		curVeh = curVeh->next;

	}

	return NULL;

}
#endif
