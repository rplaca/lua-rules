### Lua Rules : A forward chaining rete rules engine

Lua Rules is like a mini version of [CLIPS](https://clipsrules.sourceforge.net/)

#### Facts
Any table in Lua can be added to working memory as a fact with the `assert` function and can be removed with `retract`. Initial facts can be defined with the `deffacts` function.

#### Rules
A rule is created by the `defrule` function which takes two parameters, an *antecedent* (aka Left Hand Side or LHS) and a *consequent* (Right Hand Side or RHS).

#### Engine
The rules engine itself is initialized with the `reset` function and started with the `run` function. Other top-level commands that are supported are `load` for loading rules and facts from a file, `clear` to delete all facts and `watch` for debugging. 