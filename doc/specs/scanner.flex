package compiler.lexical;

import compiler.syntax.sym;
import compiler.lexical.Token;
import es.uned.lsi.compiler.lexical.ScannerIF;
import es.uned.lsi.compiler.lexical.LexicalError;
import es.uned.lsi.compiler.lexical.LexicalErrorManager;

// incluir aqui, si es necesario otras importaciones

%%
 
%public
%class Scanner
%char
%line
%column
%cup
%unicode


%implements ScannerIF
%scanerror LexicalError

// incluir aqui, si es necesario otras directivas

%{

  	LexicalErrorManager lexicalErrorManager = new LexicalErrorManager ();
  	private int commentCount = 0;
  
  	/**
  	 *	Crea un token para el identificador id 
  	 * 
  	 *@param id numero identificiador del simbolo
  	 */
	private Token createToken(int id){  		
  		Token token = new Token (id);
  		token.setLine(yyline + 1);
  		token.setColumn(yycolumn + 1);
  		token.setLexema(yytext());
  		return token;
  	}
  	
  	/**
  	 * Genera un error con el mensaje msg
  	 * 
  	 *@param msg mensaje del error
  	 */
  	private LexicalError generateError(String msg){
  		LexicalError error = new LexicalError(msg);
  		error.setLine(yyline + 1);
  		error.setColumn(yycolumn + 1);
  		error.setLexema(yytext());
  		return error;
  	}
  	
%}  
  
// REGEX

ESPACIO_BLANCO=[ \t\r\n\f]
//FIN = "fin"{ESPACIO_BLANCO} // NO SE UTILIIZA
LETRA = [a-zA-Z]
DIGITO = [0-9]
NUMERO = 0|[1-9]{DIGITO}*
ID = {LETRA}({LETRA}|{DIGITO})*
STRING = \"({LETRA}|{DIGITO}|{ESPACIO_BLANCO})*\"

%state COMMENT

%%

<YYINITIAL> 
{

	"/*" { commentCount++; yybegin(COMMENT); }
     
    "+"  {return createToken(sym.PLUS);}
	 
     "*" {return createToken(sym.PROD); }
	 
	 "<" {return createToken(sym.LESS); }
	 
	 "==" {return createToken(sym.EQ); }
	 
	 "&&" {return createToken(sym.AND); }
	 
	 "!" {return createToken(sym.NOT); }
	 
	 "++" {return createToken(sym.AUTOINC); }
	 
	 "=" {return createToken(sym.ASIG); }
	 
	 "+=" {return createToken(sym.ASIGSUM); }
	 
	 "caso" {return createToken(sym.CASE); }
	 
	 "#constante" {return createToken(sym.CONST); }
	 
	 "corte" {return createToken(sym.BREAK); }
	 
	 "entero" {return createToken(sym.INT); }
	 
	 "escribe" {return createToken(sym.PRINT); }
	 
	 "escribeEnt" {return createToken(sym.PRINTINT); }
	 
	 "alternativas" {return createToken(sym.SWITCH); }
	 
	 "mientras" {return createToken(sym.WHILE); }
	 
	 "pordefecto" {return createToken(sym.DEFAULT); }
	 
	 "principal" {return createToken(sym.MAIN); }
	 
	 "devuelve" {return createToken(sym.RETURN); }
	 
	 "si" {return createToken(sym.IF); }
	 
	 "sino" {return createToken(sym.ELSE); }
	 
	 "tipo" {return createToken(sym.TYPE); }
	 
	 "vacio" {return createToken(sym.VOID); }
	 
	 ";" {return createToken(sym.SEMICOL); }
	 
	 ":" {return createToken(sym.TWOPOINTS); }
	 
	 "(" {return createToken(sym.PARENOP); }
	 
	 ")" {return createToken(sym.PARENCL); }
	 
	 "[" {return createToken(sym.CORCHOP); }
	 
	 "]" {return createToken(sym.CORCHCL); }
	 
	 "{" {return createToken(sym.LLAVEOP);}
	 
	 "}" {return createToken(sym.LLAVECL);}
	 
	 "," {return createToken(sym.COMMA); }
		 
	 {STRING} {
	 	// Elimina las comillas del lexema
	 	Token token = new Token (sym.STRING);
	 	token.setLine(yyline + 1);
	 	token.setColumn(yycolumn + 1);
	 	token.setLexema(yytext().substring(1,yytext().length()-1));
	 	return token;
	 }
	 
	 {ID} {return createToken(sym.ID); }
	 
	 {NUMERO} {return createToken(sym.NUM);}
	 
   	{ESPACIO_BLANCO} {}

	// {FIN} {}
    
    // error en caso de coincidir con ningún patrón
	[^] {lexicalErrorManager.lexicalError (generateError("La expresión no coincide con ningún patrón"));}
    
}


<COMMENT>{

    	"/*" { commentCount++;}
    	
		"*/"	 {
    	 	commentCount--;
    	 	if (commentCount == 0)  yybegin(YYINITIAL);
    		else if (commentCount < 0) lexicalErrorManager.lexicalError(generateError("Comentarios mal balanceados: un */ no cierra nada"));
    	}
    	
    	<<EOF>> {
    		if (commentCount != 0) lexicalErrorManager.lexicalError(generateError("Comentarios mal balanceados: seguramente un /* no está cerrado"));
    	}
    	
    	[^] {/* No hacer nada */}
    	   	
 }

                         


