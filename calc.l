%{
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

#include "mystack.h"
int int_value;

typedef enum {
    LexNumber=1001,
    LexPlus,
    LexMinus,
    LexDiv,
    LexMult,
    LexDiapStart,
    LexDiapEnd,
    LexDiapDelim,
    LexDiapMultPre,
    LexDiapMultPost,
    LexNumberInDiap,
    LexComma,
    LexEnd,
    LexUnknown,
} LexType;

my_stack stack;

int end_file;

%}

%s SKIPERROR

digit     [0-9]
number    {digit}+
delimiter \.\.\.

%%

{number}	{
		  int_value=atoi(yytext);
		  fprintf(stderr, "found %d\n", int_value);
		  return LexNumber; }
{delimiter} {
          fprintf(stderr, "...\n");  
          return LexDiapDelim; }
\[           {
          fprintf(stderr, "[\n");  
          return LexDiapStart;}
,           {
          fprintf(stderr, ",\n");  
          return LexComma;}
\]           {
          fprintf(stderr, "]\n");  
          return LexDiapEnd;}
\+		{
		  fprintf(stderr, "plus\n");
		  return LexPlus; }
\-		{
		  fprintf(stderr, "minus\n");
		  return LexMinus; }
\/		{
		  fprintf(stderr, "div\n");
		  return LexDiv; }
\*		{
		  fprintf(stderr, "mult\n");
		  return LexMult; }
^[ \t]*\n	{
		  fprintf(stderr, "empty line\n");
		}
\n		{
		  fprintf(stderr, "CR\n");
		  return LexEnd; }
[ \t]		{ }
.		{ return LexUnknown; }

<SKIPERROR>[^\n]* {}
%%

int process_command(int token)
{
    fprintf(stderr, "token: %d\n", token);

    switch (token) {
    case LexNumber:
        my_stack_push(&stack, int_value);
        if (my_stack_is_full(&stack)) {
            return -1;
        }
        break;
    case LexPlus: {
        if (my_stack_is_empty(&stack)) {
            return -1;
        }
        int a=my_stack_pull(&stack);

        if (my_stack_is_empty(&stack)) {
            return -1;
        }
        int b=my_stack_pull(&stack);

        my_stack_push(&stack, a+b);
        if (my_stack_is_full(&stack)) {
            return -1;
        }
        break;}
    case LexMinus: {
        if (my_stack_is_empty(&stack)) {
            return -1;
        }
        int a=my_stack_pull(&stack);

        if (my_stack_is_empty(&stack)) {
            return -1;
        }
        int b=my_stack_pull(&stack);

        my_stack_push(&stack, b-a);
        if (my_stack_is_full(&stack)) {
            return -1;
        }
        break;}
    case LexDiv: {
        if (my_stack_is_empty(&stack)) {
            return -1;
        }
        int a=my_stack_pull(&stack);

        if (my_stack_is_empty(&stack)) {
            return -1;
        }
        int b=my_stack_pull(&stack);

        my_stack_push(&stack, b/a);
        if (my_stack_is_full(&stack)) {
            return -1;
        }
        break;}
    case LexMult: {
        if (my_stack_is_empty(&stack)) {
            return -1;
        }
        int a=my_stack_pull(&stack);

        if (my_stack_is_empty(&stack)) {
            return -1;
        }
        int b=my_stack_pull(&stack);

        my_stack_push(&stack, b*a);
        if (my_stack_is_full(&stack)) {
            return -1;
        }
        break;}
    case LexEnd:
    case 0:
        return 0;
    case LexUnknown:
        return -1;

    }
    return 1;
}

int calc_line()
{
    int token = yylex();
    if (token == 0) {
        return 1;
    }

    while (1) {
        int cmd_res = process_command(token);
        if (cmd_res == 0) {
            break;
        }
        else if (cmd_res == -1) {
            fprintf(stderr, "Syntax error\n");
            return 0;
        }
        token = yylex();
    }

    if (my_stack_is_empty(&stack)) {
        fprintf(stderr, "Stack is empty but required value\n");
        return 0;
    }

    int result = my_stack_pull(&stack);
    fprintf(yyout, "%d ", result);

    if (!my_stack_is_empty(&stack)) {
        fprintf(stderr, "Stack not empty after calculation\n");
        return 0;
    }

    return 1;
}

void calc()
{
    while (!end_file) {
        fprintf(stderr, "parse line\n");
        if (calc_line() == 0) {
            printf("FAIL\n");
            BEGIN(SKIPERROR);
            yylex();
            BEGIN(INITIAL);
        }
        else {
            printf("OK\n");
        }
        fprintf(stderr, "line parsed\n");
    }
}

int main(void)
{
    my_stack_init(&stack, 100);
    end_file = 0;

    calc();

    my_stack_done(&stack);
    return 0;
}

int yywrap(void)
{
    end_file = 1;
    return 1;
}
