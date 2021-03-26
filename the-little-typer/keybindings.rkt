#lang s-exp framework/keybinding-lang

(keybinding "d:\\" (λ (editor evt) (send editor insert "λ")))
(keybinding "d:." (λ (editor evt) (send editor insert "→")))
