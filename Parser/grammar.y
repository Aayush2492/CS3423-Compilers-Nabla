%{
#include<stdio.h>
#include<stdlib.h>

extern int yylex();
extern FILE* yyin;
void yyerror(char *);
#define DEBUG
#ifdef DEBUG 
#define SHOW printf
#else
#define SHOW
#endif
%}

// TODOs: 
// 1. Some parts here have to added to pdf. Search for "TODO" in this file.
// 2.
%union{
	int ival;
	float fval;
	// some  technique required for the symbol table , to map strings to indices 
	char *string;

}

%token<string> IDENTIFIER CONSTANT STRING_LITERAL SIZEOF GRAD COS SIN EXP LOG BACKWARD 
%token<ival> INT_CONST 
%token<fval> FLOAT_CONST 
%token<string> CHAR_CONST 
%token<string> PRINT
%token<string> INC_OP DEC_OP LEFT_OP RIGHT_OP LE_OP GE_OP EQ_OP NE_OP AT_OP
%token<string> AND_OP OR_OP MUL_ASSIGN DIV_ASSIGN MOD_ASSIGN ADD_ASSIGN AT_ASSIGN
%token<string> SUB_ASSIGN LEFT_ASSIGN RIGHT_ASSIGN AND_ASSIGN
%token<string> XOR_ASSIGN OR_ASSIGN TYPE_NAME
%token<string> CHAR INT TENSOR FLOAT CNS VAR BOOL
%token<string> IF ELIF ELSE LOOP ENDIF 
%start start
%%

start : compound_statement;

// Statements

compound_statement 
	: '{' '}' {printf("compound_statment in empty\n"); }
	| '{' declaration_list statement_list '}'  {printf("comp_stmt -> decl_stmt  + stmt_list\n");}
	| '{' statement_list '}'  {printf("comp_stmt -> stmt_list \n");}
	| '{' declaration_list '}' {printf("comp_stmt -> declaration_list\n");}
	;

statement 
	: expression_statement {SHOW("stmt -> exp_stmt\n");}
	| compound_statement {SHOW("stmt -> comp_stmt\n");}
	| selection_statement {SHOW("stmt -> selection_stmt\n");}// TODO: Add this in pdf, was missing there
	| iteration_statement {SHOW("stmt -> iter_statementist\n");}
	;

selection_statement 
	: 
	/*|*/ if_section else_section endif_section  {SHOW("selection_stmt -> if else endif\n");}
	| if_section elif_section endif_section	{SHOW("selection_stmt -> if elif endif\n");}
	| if_section elif_section else_section endif_section {SHOW("selection_stmt -> if elif else endif\n");}
 	;

declaration_list 
	: declaration_list declaration {SHOW("decl_list -> decl_list decl\n");}
	| declaration {SHOW("decl_list -> decl\n");}
	;

statement_list 
	: statement {SHOW("state_list -> stmt\n");}
	| statement_list statement {SHOW("state_list -> state_list stmt\n");}
	;

expression_statement 
	: ';' {SHOW("exp_stmt -> ;\n");}
	| exp ';' {SHOW("exp_stmt -> exp ;\n");}
	;

iteration_statement 
	: LOOP '(' expression_statement expression_statement exp ')' statement {SHOW("iter_stmt -> %s exp_stmt exp_stmt exp stmt\n", $1);}
	;

if_section 
	: IF '(' exp ')' statement {SHOW("if_sec -> %s exp exp_stmt exp stmt\n", $1);}
	;

endif_section 
	: ENDIF {SHOW("endif_sec -> %s\n", $1);}
	;

else_section 
	: ELSE statement {SHOW("else_sec -> %s stmt\n", $1);}
	;

elif_section 
	: ELIF '(' exp ')' statement {SHOW("elif_sec -> %s exp stmt\n", $1);}
	| elif_section ELIF '(' exp ')' statement {SHOW("elif_sec -> elif_sec %s exp stmt\n", $2);}
	;

// Declarations 
declaration 
	: declaration_type ';' {SHOW("decl -> decl_type\n");}
	| declaration_type init_declarators ';' {SHOW("decl -> decl_type init_decl\n");}
	;

declaration_type
	: grad_specifier type_specifier {SHOW("decl -> decl_type init_decl\n");}
	| type_specifier
	;

grad_specifier
	: CNS {SHOW("grad_spec -> %s\n", $1);}
	| VAR {SHOW("grad_spec -> %s\n", $1);}
	;

type_specifier
	: CHAR {SHOW("type_spec -> %s\n", $1);}
	| INT {SHOW("type_spec -> %s\n", $1);}
	| FLOAT {SHOW("type_spec -> %s\n", $1);}
	| BOOL {SHOW("type_spec -> %s\n", $1);}
	| TENSOR {SHOW("type_spec -> %s\n", $1);}
	;

init_declarators
	: init_declarator {SHOW("init_decls -> init_decl\n");}
	| init_declarators init_declarator {SHOW("init_decls -> init_decls init_decl\n");}
	;

init_declarator 
	: declarator {SHOW("init_decl -> decl\n");}
	| declarator '=' initializer {SHOW("int_decl -> decl = initializer\n");}
	;

declarator
	: IDENTIFIER {SHOW("decl -> %s\n", $1);}
	| '('declarator')' {SHOW("decl -> (decl)\n");}
	| declarator '[' const_exp ']' {SHOW("decl -> decl [const_exp]\n");}
	;

initializer
	: assignment_exp {SHOW("initializer -> assign_exp\n");}
	| '[' initializer_list ']' {SHOW("initializer -> [initializer_list]\n");}
	| '[' initializer_list ',' ']' {SHOW("initializer -> [initializer_list,]\n");}
	;

initializer_list
	: initializer {SHOW("initializer_list -> initializer\n");}
	| initializer_list ',' initializer {SHOW("initializer_list -> initializer_list, initializer\n");}
	;

// Expressions
exp
	: assignment_exp {SHOW("exp -> assign_exp\n");}
	| exp ',' assignment_exp {SHOW("exp -> exp, assign_exp\n");}
	;

assignment_exp
	: conditional_exp {SHOW("assign_exp -> cond_exp\n");}
	| unary_exp assignment_operator assignment_exp {SHOW("assign_exp -> unary_exp assign_op assign_exp\n");}
	;

assignment_operator
	: '=' {SHOW("assign_op -> =\n");}
	| MUL_ASSIGN {SHOW("assign_op -> %s\n", $1);}
	| DIV_ASSIGN {SHOW("assign_op -> %s\n", $1);}
	| MOD_ASSIGN {SHOW("assign_op -> %s\n", $1);}
	| ADD_ASSIGN {SHOW("assign_op -> %s\n", $1);}
	| SUB_ASSIGN {SHOW("assign_op -> %s\n", $1);}
	| LEFT_ASSIGN	{SHOW("assign_op -> %s\n", $1);}
	| RIGHT_ASSIGN {SHOW("assign_op -> %s\n", $1);}
	| AND_ASSIGN {SHOW("assign_op -> %s\n", $1);}
	| XOR_ASSIGN {SHOW("assign_op -> %s\n", $1);}
	| OR_ASSIGN {SHOW("assign_op -> %s\n", $1);}
	| AT_ASSIGN {SHOW("assign_op -> %s\n", $1);}
	;

conditional_exp
	: logical_or_exp {SHOW("cond_exp -> log_or_exp\n");}
	| logical_or_exp '?' exp ':' conditional_exp {SHOW("cond_exp -> log_or_exp ? exp : cond_exp\n");}
	;
const_exp
	: conditional_exp  {SHOW("const_exp -> cond_exp\n");}
	// TODO: Add this in pdf, was missing there 
	;
logical_or_exp
	: logical_and_exp {SHOW("log_or_exp -> log_and_exp\n");}
	| logical_or_exp OR_OP logical_and_exp {SHOW("log_or_exp -> log_or_exp %s log_and_exp\n", $2);}
	;

logical_and_exp
	: inclusive_or_exp {SHOW("log_and_exp -> incl_or_exp\n");}
	| logical_and_exp AND_OP inclusive_or_exp {SHOW("log_and_exp -> log_and_exp %s incl_or_exp\n", $2);}
	;

inclusive_or_exp
	: exclusive_or_exp {SHOW("incl_or_exp -> excl_or_exp\n");}
	| inclusive_or_exp '|' exclusive_or_exp {SHOW("incl_or_exp -> incl_or_exp | excl_or_exp\n");}
	;

exclusive_or_exp
	: and_exp {SHOW("excl_or_exp -> and_exp\n");}
	| exclusive_or_exp '^' and_exp 	{SHOW("excl_or_exp -> excl_or_exp ^ and_exp\n");}
	;

and_exp
	: equality_exp
	| and_exp '&' equality_exp
	;

equality_exp
	: relational_exp
	| equality_exp EQ_OP relational_exp
	| equality_exp NE_OP relational_exp
	;

relational_exp
	: shift_exp
	| relational_exp '<' shift_exp
	| relational_exp '>' shift_exp
	| relational_exp LE_OP shift_exp
	| relational_exp GE_OP shift_exp
	;

shift_exp
	: additive_exp
	| shift_exp LEFT_OP additive_exp
	| shift_exp RIGHT_OP additive_exp
	;

additive_exp
	: multiplicative_exp
	| additive_exp '+' multiplicative_exp
	| additive_exp '-' multiplicative_exp
	;

multiplicative_exp
	: cast_exp
	| multiplicative_exp '*' cast_exp
	| multiplicative_exp '/' cast_exp
	| multiplicative_exp '%' cast_exp
	;

cast_exp
	: unary_exp
	| '(' type_specifier ')' cast_exp // TODO: Make change in grammar pdf
	;

unary_exp
	: postfix_exp
	| INC_OP unary_exp
	| DEC_OP unary_exp
	| unary_operator cast_exp
	//| '('type_specifier')'cast_exp // TODO: Make change in grammar pdf
	| lib_funcs '(' unary_exp ')'
	;

// TODO: Make change in grammar pdf 
lib_funcs
	: GRAD
	| COS
	| SIN
	| EXP
	| LOG
	| BACKWARD
	| SIZEOF
	| PRINT
	;

unary_operator
	: '&'
	| '*'
	| '+'
	| '-'
	| '~'
	| '!'
	| AT_OP
	;

postfix_exp
	: primary_exp
	| postfix_exp '[' exp ']'
	| postfix_exp INC_OP
	| postfix_exp DEC_OP
	;

primary_exp
	: IDENTIFIER
	| constant
	| '(' exp ')'
	;

// Constants
constant
	: INT_CONST
	| CHAR_CONST
	| FLOAT_CONST
	| CONSTANT
	;

%%

void yyerror(char *s)
{
	fprintf(stderr, "%s\n", s);
}

int main(int argc, char **argv)
{
	// printf("Input argument Number : %d", argc);
	yyin = fopen(argv[1],"r"); 
	yyparse();
	return 0;
}