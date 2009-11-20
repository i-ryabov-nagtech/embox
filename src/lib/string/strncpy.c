/**
 * \file strncpy.c
 * \date 20.11.09
 * \author Sikmir
 */
#include "string.h"

char *strncpy(char *dest, const char *source, size_t count) {
        char *start = dest;
        while (count && (*dest++ = *source++))
        	count--;
        while (count--)
        	*dest++ = '\0';
        return start;
}
