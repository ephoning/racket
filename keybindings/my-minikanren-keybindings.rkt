#lang s-exp framework/keybinding-lang

(keybinding "c:x;c:x;=" (λ (editor evt) (send editor insert "≡")))
