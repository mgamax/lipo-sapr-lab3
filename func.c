/*
    Diapason functions
*/

#include "func.h"

void lex_diap_mult_post(my_stack* stack)
{
    int mult = my_stack_pull(stack);
    int end = my_stack_pull(stack);
    int step = my_stack_pull(stack);
    int start = my_stack_pull(stack);
    
    if (mult != 0) {
        start *= mult;
        end *= mult;
    }
    
    my_stack_push(stack, end);
    my_stack_push(stack, step);
    my_stack_push(stack, start);
}

void lex_diap_mult_pre(my_stack* stack)
{
    int end = my_stack_pull(stack);
    int step = my_stack_pull(stack);
    int start = my_stack_pull(stack);
    int mult = my_stack_pull(stack);
        
    if (mult != 0) {
        start *= mult;
        end *= mult;
    }
        
    my_stack_push(stack, end);
    my_stack_push(stack, step);
    my_stack_push(stack, start);
}

void lex_number_in_diap(my_stack* stack)
{
    int number = my_stack_pull(stack);
    int stop = my_stack_pull(stack);
    int step = my_stack_pull(stack);
    int start = my_stack_pull(stack);
        
    int find = 0;
        
    if (start == stop && step == 0 && number == start) {
        find = 1;
    } else if (start != stop && step == 0) {
        find = 0;
    }
        
    for (int i = start; i < stop; i += step) {
        if (i == number) {
            find = 1;
            break;
        } else {
            continue;
        }
    }
        
    my_stack_push(stack, stop);
    my_stack_push(stack, step);
    my_stack_push(stack, start);
    my_stack_push(stack, find);
}