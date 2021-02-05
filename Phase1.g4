grammar Phase1;
sophia : (class_object)* EOF;

class_object
  : (parent | child) LBRACE class_scope  RBRACE
  ;
parent
  : CLASS (name = NAME)  {System.out.println("ClassDec:" + $name.text);}
  ;
child
  : CLASS (kid = NAME) EXTENDS (dad = NAME) {System.out.println("ClassDec:" + $kid.text + "," + $dad.text);}
  ;
constructor
  : DEF NAME {System.out.println("ConstructorDec:" + $NAME.text);} LPAR func_dec_inp RPAR scope
  ;
class_scope
  : (var_dec SEMICOLON)* (constructor)? (func_dec)*
  ;

assignment
  : ((expression ASSIGN expression) | (expression ASSIGN (list_val)) | (expression ASSIGN (NEW function_call)) | (expression ASSIGN assignment))
  {System.out.println("Operator:=");}
  ;

func_dec_inp
  : (argument(COMMA argument)*) | ()
  ;
func_dec
  : DEF (types | VOID) NAME {System.out.println("MethodDec:" + $NAME.text);} LPAR func_dec_inp RPAR  scope
  ;
scope
  : LBRACE (var_dec SEMICOLON)* (statement)*   RBRACE
  ;
argument
  : NAME COLON types
  ;
var_dec
  : NAME COLON types {System.out.println("VarDec:" + $NAME.text);}
  ;
no_var_scope
  :( LBRACE (statement)* RBRACE)
  | (function_call SEMICOLON)
  | (assignment SEMICOLON)
  | (condition)
  | (loop)
  | (print SEMICOLON)
  | (BREAK SEMICOLON {System.out.println("Control:break");})
  | (CONTINURE SEMICOLON  {System.out.println("Control:continue");})
  | (RETURN {System.out.println("Return");} (variable | val) SEMICOLON)
  ;
statement
  : function_call SEMICOLON
  | assignment SEMICOLON
  | condition
  | loop
  | BREAK SEMICOLON {System.out.println("Control:break");}
  | CONTINURE SEMICOLON  {System.out.println("Control:continue");}
  | RETURN {System.out.println("Return");} (variable | val) SEMICOLON
  | no_var_scope
  | print SEMICOLON
  ;
condition
  : IF {System.out.println("Conditional:if");} LPAR expression RPAR no_var_scope (ELSE {System.out.println("Conditional:elseif");} no_var_scope)?
  ;
loop
  : (('for' {System.out.println("Loop:for");} LPAR (assignment)? SEMICOLON (assignment | expression)? SEMICOLON (assignment)? RPAR) | (FOREACH {System.out.println("Loop:foreach");} LPAR NAME IN expression RPAR) )
    no_var_scope
  ;

print
  : PRINT {System.out.println("Built-in:print");} (LPAR) (function_input) (RPAR)
  ;
function_call
  : variable {System.out.println("MethodCall");} LPAR function_input RPAR
  ;
input
  : (variable | val | expression)
  ;
function_input
  : (input (COMMA input)*)?
  ;

variable
  : (NAME) variable
  | (DOT) variable
  | (LPAR function_input RPAR) variable
  | (((NAME)| (LPAR function_input RPAR)) LSQRBRACE expression RSQRBRACE) variable
  | NAME
  | ((DOT)? (LPAR function_input RPAR) )
  | (((NAME)| (LPAR function_input RPAR)) LSQRBRACE expression RSQRBRACE)
  | (THIS DOT (variable| function_call))
  ;

priority1
  : expression_val
  | LPAR expression RPAR
  | variable
  ;
priority2
  : priority1 p2_r
  ;
p2_r
  : (UNARY {System.out.println("Operator:" + $UNARY.text);} p2_r)
  | ()
  ;

priority3
  : UNARY priority3 {System.out.println("Operator:" + $UNARY.text);}
  | NOT priority3 {System.out.println("Operator:" + $NOT.text);}
  | SUB priority3 {System.out.println("Operator:" + $SUB.text);}
  | priority2
  ;
priority4
  : priority3 p4_r
  ;
p4_r
  : (MULTIPLY priority3 {System.out.println("Operator:" + $MULTIPLY.text);} p4_r)
  | (DIVIDE priority3 {System.out.println("Operator:" + $DIVIDE.text);} p4_r)
  | (REMAIN priority3 {System.out.println("Operator:" + $REMAIN.text);} p4_r)
  | ()
  ;

priority5
  : priority4 p5_r
  ;
p5_r
  : (ADD priority4 {System.out.println("Operator:" + $ADD.text);} p5_r)
  | (SUB priority4 {System.out.println("Operator:" + $SUB.text);} p5_r)
  | ()
  ;

priority6
  : priority5 p6_r
  ;
p6_r
  : (LESS priority5 {System.out.println("Operator:" + $LESS.text);} p6_r)
  | (GREATER priority5 {System.out.println("Operator:" + $GREATER.text);} p6_r)
  | ()
  ;

priority7
  : priority6 p7_r
  ;
p7_r
  : (compare priority6 p7_r)
  | ()
  ;

priority8
  : priority7 p8_r
  ;
p8_r
  : (AND priority7 {System.out.println("Operator:" + $AND.text);} p8_r)
  | ()
  ;

priority9
  : priority8 p9_r
  ;
p9_r
  : (OR priority8 {System.out.println("Operator:" + $OR.text);} p9_r)
  | ()
  ;

expression
  : priority9
  ;


list
 : LIST LPAR (var | types | ()) (COMMA (var | types | ()))* RPAR
 | LIST LPAR INT '#' types RPAR
 ;
list_val
  : LSQRBRACE (list_val | expression | STRING | ()) (COMMA (list_val | expression | STRING | ()))* RSQRBRACE
  ;
new_assignment
  : NEW variable
  ;

fptr
 : 'func' '<' (types (COMMA types)* | VOID) '->' types '>'
 ;
types
  : 'int'
  | 'string'
  | 'bool'
  | list
  | NAME
  | fptr
  ;

var
  : NAME COLON types
  ;

expression_val
  : INT
  | BOOL
  | list_val
  | new_assignment
  | NAME
  ;
val
  : expression_val
  | STRING
  | NULL
  ;

compare
  : COMPARE {System.out.println("Operator:" + $COMPARE.text);}
  ;

IF: 'if';
ELSE: 'else';
ELSEIF: 'elseif';
FOREACH: 'foreach';
FOR: 'for';
CONTINURE: 'continue';
BREAK: 'break';
IN: 'in';
NULL: 'null';
NEW: 'new';
VOID: 'void';
THIS: 'this';
CLASS: 'class' ;
PRINT: 'print';
DOT: '.';
COLON: ':';
SEMICOLON: ';';
COMMA: ',';
INTEGER: 'int';
BOOLEAN: 'bool';
LIST: 'list';
STR: 'string';
BOOL: 'true' | 'false';
STRING: '"' ~('"')* '"';
INT: '0' | [1-9][0-9]*;
NAME: [A-Za-z_][A-Za-z0-9_]*;
LBRACE: '{';
RBRACE: '}';
LPAR: '(';
RPAR: ')';
LSQRBRACE: '[';
RSQRBRACE: ']';
UNARY: '++' | '--';
NOT: '!';
MULTIPLY: '*';
DIVIDE: '/';
REMAIN: '%';
ADD: '+';
SUB: '-';
LESS: '<';
GREATER: '>';
DEF: 'def ';
COMPARE: '==' | '!=';
EXTENDS: 'extends ';
ASSIGN: '=';
RETURN: 'return ';
AND: '&&';
OR: '||';
WS: [ \t\r\n]+ -> skip;