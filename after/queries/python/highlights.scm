;; extends 

(("global" @keyword) (#set! conceal "G"))
(("and" @keyword.operator) (#set! conceal "&"))
(("break" @keyword) (#set! conceal "B"))
(("else" @conditional) (#set! conceal "e"))
(("for" @repeat) (#set! conceal "F"))
((yield ("from") @keyword) (#set! conceal "F"))
(("def" @keyword.function) (#set! conceal "f"))
(("class" @keyword) (#set! conceal "c"))
((call function: (identifier) @function.builtin (#eq? @function.builtin "print")) (#set! conceal "p"))
(("lambda" @include) (#set! conceal "λ"))
((import_from_statement ("from") @include) (#set! conceal "f"))
(("with" @keyword) (#set! conceal "w"))
(("continue" @keyword) (#set! conceal "C"))
(("pass" @keyword) (#set! conceal "P"))
(("elif" @conditional) (#set! conceal "e"))
(("not" @keyword.operator) (#set! conceal "!"))
(("or" @keyword.operator) (#set! conceal "|"))
(("assert" @keyword) (#set! conceal "?"))
(("while" @repeat) (#set! conceal "W"))
(("if" @conditional) (#set! conceal "?"))
(("del" @keyword) (#set! conceal "D"))
(("import" @include) (#set! conceal "i"))
(("return" @keyword) (#set! conceal "R"))
(("yield" @keyword) (#set! conceal "Y"))