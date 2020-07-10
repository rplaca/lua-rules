### Lua Rules : A forward chaining rete rules engine

Lua Rules is like a mini version of [CLIPS](http://www.clipsrules.net/). It supports the most basic functionality but does not implement features that already have an equivalent in Lua. The aim is not to provide a copy of CLIPS, rather something that feels and behaves like it's inference engine.

#### Facts
Any table in Lua can be added to working memory as a fact with the `assert` function and can be removed with `retract`. Initial facts can be defined with the `deffacts` function. Lua Rules does not make a distinction between *ordered* and *non-ordered* facts, tables naturally represent them both anyway. 

#### Rules
A rule is created by the `defrule` function which takes two parameters, an *antecedent* (aka Left Hand Side or LHS) and a *consequent* (Right Hand Side or RHS).

#### Engine
The rules engine itself is initialized with `reset` and started with the `run` function. Other top-level commands that are supported are `load` for loading rules and facts from a file, `clear` to delete all facts from working memory and `agenda` plus `watch` for debugging.

#### NOTE!
This is my first attempt at a non-trivial Lua program. I've implemented a number of rules engines and I'm comfortable around a number of other programming languages (including CLIPS) but if you see me running in the wrong direction, please point me towards the light.