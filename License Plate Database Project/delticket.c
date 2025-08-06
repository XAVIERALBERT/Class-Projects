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

#ifndef MYDELTICKET
TODO(USING THE SOLUTION delticket.c NOT MY CODE)
#else

/*
 * delticket
 *      remove ticket (summons) from the database
 *      look up the summons for a vehicle and pay it (remove the ticket) 
 *
 *      Find the vehicle by the state and plate. if not found return -1
 *
 *      convert the summ string to a long long int using
 *      using strtosumid. This long long int is how the summons number
 *      is stored in the database in struct ticket.
 *      After being converted you can use it find a summons id match
 *      in the linked list of tickets attached to the strcut vehicle.      
 *
 *      After you have the vehicle, find the summons on the ticket chain
 *      that matches the converted summons string (summid in the example)
 *      example:
 *        unsigned long long summid
 *        if (strtosumid(summ, &summid) != 0)
 *           return -1;
 *        now search the ticket chain to find that summons
 *        struct ticket *tptr;
 *        if (tptr->summons == summid)
 *          found it
 *           
 *      If found, delete it from the ticket chain. If the vehicle
 *      no longer has any tickets, then remove the vehicle from the hash chain
 *      Otherwise you must update the tot_fine and cnt_tickets fields in
 *      the struct vehicle so the are accurate after removing the summons
 *      Make sure to delete all space that malloc()'d 
 *
 * Inputs:
 *  plate   plate id string to be found
 *  state   state id string to be found
 *  summ    summon id string to be found
 *
 * returns 0 if ok -1 if not found or error
 */

int
delticket(char *plate, char *state, char *summ)
{
    unsigned long long summid;

    /*
     * convert the summons string to a number
     */
    if (strtosumid(summ, &summid) != 0)
        return -1;

    /*
     * first find the vehicle
     */

	unsigned int key = hash(plate) % tabsz;

	struct vehicle *curVeh = *(htable + key);

	struct vehicle *prevV = *(htable + key);

	int vehCnt = 1;

	if (curVeh == NULL) {

		return -1;
	
	}

   /*
    * did we find the vehicle?
    */

	/*free anything for tickets?*/

	while (curVeh != NULL) {

		/*found vehicle*/

		if (strcmp(plate, curVeh->plate) == 0
			&& strcmp(state, curVeh->state) == 0) {

			struct ticket *curT = curVeh->head;

			struct ticket *prevT = curVeh->head;

			int Tcnt = 1;

			/*goes thru tickets*/

			while (curT != NULL) {

				/*finds ticket*/
		
				if (curT->summons == summid) {

					/*its the last ticket*/

					if (curT->next == NULL) {

						unsigned int code = curT->code;

						unsigned int curFine = fineTab[code].fine;

						curVeh->cnt_ticket = curVeh->cnt_ticket - 1;

						curVeh->tot_fine = curVeh->tot_fine - curFine;

						if (Tcnt != 1) {

							prevT->next = NULL;

						}

						else if (Tcnt == 1) {

							curVeh->head = NULL;

						}

						free(curT);

						curT = NULL;

						/*removes vehicle from chain if ticket = 0*/

						if (curVeh->cnt_ticket == 0) {

							/*case: beginning vehicle? and middle vehicle*/

							if (curVeh->next != NULL) {

								struct vehicle *nextV = curVeh->next;

								curVeh->next = NULL;

								free(curVeh->state);

								free(curVeh->plate);

								free(curVeh);

								curVeh = NULL;

								if (vehCnt != 1) {

									prevV->next = nextV;

								}

								else if (vehCnt == 1) {

									*(htable + key) = nextV;

								}

								return 0;

							}

							/*case: last vehicle*/

							if (curVeh->next == NULL) {

								free(curVeh->state);

								free(curVeh->plate);

								free(curVeh);
								
								curVeh = NULL;

								if (vehCnt != 1) {

									prevV->next = NULL;

								}

								else if (vehCnt == 1) {

									*(htable + key) = NULL;

								}

								return 0;
							
							}


						}

						return 0;

					}

					/*not the last ticket (PROBLEM)*/

					if (curT->next != NULL) {

						struct ticket *nextT = curT->next;

						unsigned int code = curT->code;

						unsigned int curFine = fineTab[code].fine;

						curT->next = NULL;

						curVeh->cnt_ticket = curVeh->cnt_ticket - 1;

						curVeh->tot_fine = curVeh->tot_fine - curFine;

						free(prevT->next);

						if (Tcnt != 1) {

							prevT->next = nextT;

						}

						else if (Tcnt == 1) {

							curVeh->head = nextT;

						}

						curT = NULL;
						
						return 0;						

					}

				}

				prevT = curT;

				curT = curT->next;

				Tcnt++;

			}

			if (curT == NULL) {

				/*free prevT?*/

				prevT = NULL;

				return -1;

			}

		}

		prevV = curVeh;

		curVeh = curVeh->next;	

		vehCnt++;	

	}

	if (curVeh == NULL) {

		/*free prevV?*/

		prevV = NULL; 

		return -1;
	
	}

    /*
     * find the ticket
     */
   
    /*
     * if ticket not found we are done
     */

    /*
     * update the summary fields and remove the ticket
     */
    
    /*
     * was this the last ticket for the vehicle?
     * if so, remove the vehicle from the hash chain
     */

    return 0;
}
#endif
