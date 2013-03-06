Parser = require("jison").Parser
			
grammar = {
	lex: {# defines tokens and classes
		rules: [
			["\\s+", "/* skip whitespace */"]
			["\\n", "/* skip linefeed */"]
			["\\r", "/* skip carriage return */"]
			[";", "/* skip semicolon */"]
			["===", "return '===';"]
			["==", "return '==';"]
			["!==", "return '!==';"]
			["!=", "return '!=';"]
			[">=", "return '>=';"]
			[">", "return '>';"]
			["<=", "return '<=';"]
			["<", "return '<';"]
			["&&", "return '&&';"]
			["\\|\\|", "return '||';"]
			["\\(", "return '(';"]
			["\\)", "return ')';"]
			["\\{", "return '{';"]
			["\\}", "return '}';"]
			[",", "return ',';"]
			["\\.", "return '.';"]
			["\\+", "return '+';"]
			["-", "return '-';"]
			["%", "return '%';"]
			["\\/", "return '/';"]
			["\\*", "return '*';"]
			["null", "return 'NULL';"]
			["true|false", "return 'BOOLEAN';"]
			["function", "return 'FUNCTION';"]
			["return", "return 'RETURN';"]
			["[0-9]+(\\.[0-9]+)?", "return 'NUMBER';"]
			["(\"[^\"\\\\\\n\\r]*\")|('[^'\\\\\\n\\r]*')", "return 'STRING';"]
			["[a-zA-Z_$][0-9a-zA-Z_$]*", "return 'VARIABLE';"]
			["$", "return 'EOF';"]
		]
	}
	bnf: {# sets expressions
		process: [
			["expression EOF", "return $1;"]
			["FUNCTION ( ) { RETURN expression } EOF", "return $6;"]
			["FUNCTION ( arguments ) { RETURN expression } EOF", "return [$3, $7];"]
		]
		expression: [
			["logicalOr", "$$ = $1;"]
			["( expression )", "$$ = $2;"]
		]
		logicalOr: [
			["logicalAnd", "$$ = $1;"]
			["logicalOr || logicalAnd", "$$ = ['OR', $1, $3];"]
		]
		logicalAnd: [
			["equality", "$$ = $1;"]
			["logicalAnd && equality", "$$ = ['AND', $1, $3];"]
		]
		equality: [
			["relational", "$$ = $1;"]
			["equality == relational", "$$ = ['EQUAL', $1, $3];"]
			["equality != relational", "$$ = ['NOT EQUAL', $1, $3];"]
			["equality === relational", "$$ = ['STRICT EQUAL', $1, $3];"]
			["equality !== relational", "$$ = ['STRICT NOT EQUAL', $1, $3];"]
		]
		relational: [
			["subtraction", "$$ = $1;"]
			["relational > subtraction", "$$ = ['GREATER THAN', $1, $3];"]
			["relational >= subtraction", "$$ = ['GREATER THAN OR EQUAL', $1, $3];"]
			["relational < subtraction", "$$ = ['LESS THAN', $1, $3];"]
			["relational <= subtraction", "$$ = ['LESS THAN OR EQUAL', $1, $3];"]
		]
		subtraction: [
			["addition", "$$ = $1;"]
			["subtraction - addition", "$$ = ['SUBTRACT', $1, $3];"]
		]
		addition: [
			["modulus", "$$ = $1;"]
			["addition + modulus", "$$ = ['ADD', $1, $3];"]
		]
		modulus: [
			["division", "$$ = $1;"]
			["modulus % division", "$$ = ['MOD', $1, $3];"]		
		]
		division: [
			["multiplication", "$$ = $1;"]
			["division / multiplication", "$$ = ['DIV', $1, $3];"]		
		]
		multiplication: [
			["literal", "$$ = $1;"]
			["multiplication * literal", "$$ = ['MULTIPLY', $1, $3];"]		
		]
		literal: [
			["NULL", "$$ = null;"]
			["BOOLEAN", "$$ = ($1 === true);"]
			["NUMBER", "$$ = Number($1);"]
			["STRING", "$$ = $1.substring(1, $1.length - 1);"]
			["identifier", "$$ = $1;"]
		]
		identifier: [
			["VARIABLE", "$$ = ['IDENTIFIER', $1];"]
			["identifier . VARIABLE", "$1.push($3);"]
		]
		arguments: [
			["VARIABLE", "$$ = ['ARGUMENTS', $1];"]
			["arguments , VARIABLE", "$1.push($3);"]
		]
	}
}

module.exports = new Parser(grammar)


