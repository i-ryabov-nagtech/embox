/**
 * @file
 * @brief
 *
 * @date 29.07.2013
 * @author Andrey Gazukin
 */

#ifndef __ASM_BUG_H__
#define __ASM_BUG_H__

#include <stdio.h>

#define BUG() do { printf("BUG() at %s %d\n", __FILE__, __LINE__); *(int *)0=0; } while (0)

#endif /* __ASM_BUG_H__ */
