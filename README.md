# ergMargins (unofficial fork)

This is an **unofficial fork** of [ergMargins](https://cran.r-project.org/package=ergMargins) 1.6.2 by Scott Duxbury, the version on CRAN. The original package is © Scott Duxbury and licensed under GPL (>= 2); this fork keeps that license. For the original, see [CRAN](https://cran.r-project.org/package=ergMargins) and [sduxbury/ergMargins](https://github.com/sduxbury/ergMargins).

## What changed

**1. Constraints such as `blockdiag()`.** `ergm.AME()`, `ergm.MEM()`, `ergm.MSE()`, and `edge.prob2()` build their dyad list with the model's sample-space constraints.

```r
# 1.6.2
dyad.mat <- ergmMPLE(model$formula, output = "dyadlist", basis = model$network)
# this fork
dyad.mat <- ergmMPLE(model$formula, output = "dyadlist", basis = model$network,
                     constraints = model$constraints)
```

In 1.6.2, a model fitted with `constraints = ~ blockdiag("classid")`, for example several classrooms pooled into one network, has its marginal effects averaged over **all** dyads, including pairs in different classrooms that the model rules out. With this fork, they are averaged over the dyads the model allows, and `edge.prob2()` lists only those dyads. For `btergm`, `mtergm`, and `mlergm` objects, `edge.prob2()` behaves as in 1.6.2, because their constraints refer to a stacked network.

**2. Multilayer models (`ergm.multi`).** For a term of one layer, such as `L(support)~nodematch.x`, the marginal effect is averaged over that layer's dyads only. In 1.6.2 it was also averaged over the other layers' dyads, where the term does not enter the tie probability. Cross-layer terms, such as `L(support&opposition)~edges`, are still averaged over all layers. `edge.prob2()` now works for multilayer models; in 1.6.2 it stopped with `'length = 2' in coercion to 'logical(1)'`.

**3. Class checks.** Conditions of the form `if (class(x) %in% ...)` are replaced by `inherits()`, so objects with more than one class, such as matrices, no longer cause errors in R >= 4.2.

Models without constraints and with a single layer give the same results as 1.6.2, including the examples in the package documentation.

| Model | 1.6.2 | This fork |
|---|---|---|
| 8 classrooms pooled, `blockdiag("classid") + bd(maxout = 5)`, AME of same gender | 0.0550 | 0.0954 |
| 8 classrooms pooled, `blockdiag("classid")`, dyad-independent, AME of same gender | 0.3686 | 0.3739 |
| One classroom, `bd(maxout = 5)`, AME of same gender | 0.1370 | 0.1370 |
| One network, no constraints, AME of Annex I | 0.1711 | 0.1711 |
| Two layers, AME of `L(support)~nodematch.arab.TRUE` | 0.0652 | 0.0623 |
| Two layers, AME of `L(support&opposition)~edges` | −0.0360 | −0.0360 |
| Two layers, `edge.prob2()` | error | 8,190 dyads |
| `faux.dixon.high` documentation example: AME, MEM, MSE, `edge.prob2()` | — | identical to 1.6.2 |

## Install

```r
install.packages("pak")
pak::pak("benrosche/ergMargins@constraints")
```

This replaces the CRAN version of `ergMargins` in your library. To go back, run `install.packages("ergMargins")`.
