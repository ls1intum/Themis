Known Issues and Workarounds 
===========================================
.. TODO: Remove once Athena is fully integrated
.. note:: *This section will be removed once feedback suggestions are completely integrated into Artemis.*

The feedback suggestion server ThemisML currently only works with Java projects.
This should be easy to fix by creating an ANTLR grammar for every additional language to support and configuring the codeBERT similarity comparison accordingly.

Creating a New ANTLR4 Grammar for ThemisML
------------------------------------------
You can get grammars for a lot of programming languages in this repository: https://github.com/antlr/grammars-v4
You will find a parser and a lexer, which you will need to convert to Python files for the ThemisML Server to use.

For Java, use the following command:
``antlr4 -Dlanguage=Python3 JavaParser.g4 JavaLexer.g4``

For other languages, the command will be similar, but you will need to find the correct grammar files.