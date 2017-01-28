/*
This file is part of Reverse Notation Calc.

    Reverse Notation Calc is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Foobar is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Foobar.  If not, see <http://www.gnu.org/licenses/>.

*/

#ifndef _mystack_h
#define _mystack_h

#include <stddef.h>

typedef struct {
    int *ptr;
    size_t size;
    size_t count;
} my_stack;

void my_stack_init(my_stack* stack, size_t size);
void my_stack_done(my_stack* stack);

void my_stack_push(my_stack* stack, int value);
int my_stack_pull(my_stack* stack);

void my_stack_clean(my_stack* stack);
int my_stack_get_deep(my_stack* stack, int index);

int my_stack_count(my_stack* stack);
int my_stack_top(my_stack* stack);
int my_stack_is_empty(my_stack* stack);
int my_stack_is_full(my_stack* stack);

#endif
