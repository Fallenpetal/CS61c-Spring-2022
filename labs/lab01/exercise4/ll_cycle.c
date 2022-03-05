#include <stddef.h>
#include "ll_cycle.h"

int ll_has_cycle(node *head) {
  /* there is 0,1,2 nodes' case */
    if(head == NULL || head->next == NULL || head->next->next == NULL) {
      return 0;
    }
    node *fast_ptr = head;
    node *low_ptr = head;
    /* there is more than 2 nodes's case */
    while(fast_ptr->next != NULL) {
      if(fast_ptr -> next != NULL) {
        fast_ptr = fast_ptr -> next;
        if(fast_ptr -> next != NULL) {
          fast_ptr = fast_ptr ->next;
        } else {
          break;
        }
      } else {
        break;
      }
      low_ptr = low_ptr -> next;
      if(fast_ptr == low_ptr) {
        return 1;
      }
    }
    return 0;

}
