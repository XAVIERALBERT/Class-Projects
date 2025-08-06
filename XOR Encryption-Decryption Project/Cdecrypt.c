// version 1.0 11/12/2022
#include <stdio.h>
#include "cipher.h"

#ifdef MYDECRYPT_C
TODO("using Cdecrypt.c");

int
decrypt(char *iobuf, char *bookbuf, int cnt)
{

	int key = 0;

	while (key < cnt) {

		unsigned int bookbufint = (unsigned int) *(bookbuf + key);

		*(iobuf + key) = (char) ((unsigned int) (*(iobuf + key)) ^ bookbufint);

		int inc = 0;

		unsigned int reverse = 0;

		unsigned int curC = (unsigned) *(iobuf + key);

		unsigned int temp;

		while (inc < 8) {

			temp = curC;

			temp = temp & 1;

			reverse = reverse << 1;

			reverse = temp | reverse;

			curC = curC >> 1;

			inc ++;

		}

		*(iobuf + key) = (char) (reverse);

		key++;

	}

    return cnt;
}

#elif defined MYDECRYPT_S
TODO("using decrypt.S");
#else
TODO("using solution decrypt");
#endif
