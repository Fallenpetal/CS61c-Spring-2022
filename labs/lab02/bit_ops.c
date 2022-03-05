#include <stdio.h>
#include "bit_ops.h"

/* Returns the Nth bit of X. Assumes 0 <= N <= 31. */
unsigned get_bit(unsigned x, unsigned n) {
    unsigned y = 0x1<<n;
    return (x&y)>>n; 
}

/* Set the nth bit of the value of x to v. Assumes 0 <= N <= 31, and V is 0 or 1 */
void set_bit(unsigned *x, unsigned n, unsigned v) {
    unsigned y = 1<<n;
    y = ~y;
    *x = (*x&y)|(v<<n);           
    /* if n > the bit number of *x,such as 0b100,we insert 4th 1 should be 0b1100,so need to consider do or oprator with v<<n */

}

/* Flips the Nth bit in X. Assumes 0 <= N <= 31.*/
void flip_bit(unsigned *x, unsigned n) {
    unsigned v = get_bit(*x, n);
    if(v == 0) {
      set_bit(x, n, 1);
    } else {
      set_bit(x, n, 0);
    }
}

