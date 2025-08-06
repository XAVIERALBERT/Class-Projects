// version 1.0 11/12/2022
#include <stdio.h>
#include "cipher.h"

#ifdef MYENCRYPT_C
TODO("using Cencrypt.c");

int
encrypt(char *iobuf, char *bookbuf, int cnt)
{	

	int key = 0;

	while (key < cnt) {

		int inc = 0;
		
		unsigned int reverse = 0;

		unsigned int curC = (unsigned int) *(iobuf + key);

		unsigned int temp;

		while (inc < 8) {

			temp = curC;

			temp = temp & 1;

			reverse = reverse << 1;

			reverse = temp | reverse;

			curC = curC >> 1;

			inc++;

		}

		unsigned int bookbufint = (unsigned int) *(bookbuf + key);

		*(iobuf + key) = (char) (reverse ^ bookbufint);

		key++;

	}

    return cnt;

}

#elif defined MYENCRYPT_S
TODO("using encrypt.S");
#else
TODO("using solution encrypt");
#endif
