# ergMargins (unofficial fork)

This is an **unofficial fork** of [ergMargins](https://cran.r-project.org/package=ergMargins) 1.6.2 by Scott Duxbury, the version on CRAN. The original package is © Scott Duxbury and licensed under GPL (>= 2); this fork keeps that license. For the original, see [CRAN](https://cran.r-project.org/package=ergMargins) and [sduxbury/ergMargins](https://github.com/sduxbury/ergMargins).

## What changed

One change, in `ergm.AME()`, `ergm.MEM()`, `ergm.MSE()`, and `edge.prob2()`: the dyad list is built with the model's sample-space constraints.

```r
# 1.6.2
dyad.mat <- ergmMPLE(model$formula, output = "dyadlist", basis = model$network)
# this fork
dyad.mat <- ergmMPLE(model$formula, output = "dyadlist", basis = model$network,
                     constraints = model$constraints)
```

In 1.6.2, a model fitted with `constraints = ~ blockdiag("classid")`, for example several classrooms pooled into one network, has its marginal effects averaged over **all** dyads, including pairs in different classrooms that the model rules out. With this fork, they are averaged over the dyads the model allows.

Models without constraints, or with constraints that do not remove dyads such as `bd(maxout = 5)`, give the same results as 1.6.2.

`edge.prob2()` now lists only the dyads a single-network `ergm` allows, so a `blockdiag()` model no longer returns pairs from different blocks. The probabilities of the listed dyads are unchanged. For `btergm`, `mtergm`, and `mlergm` objects it behaves as in 1.6.2, because their constraints refer to a stacked network.

| Model | `ergm.AME()` 1.6.2 | This fork |
|---|---|---|
| 8 classrooms pooled, `blockdiag("classid") + bd(maxout = 5)` | 0.0550 | 0.0954 |
| 8 classrooms pooled, `blockdiag("classid")`, dyad-independent | 0.3686 | 0.3739 |
| One classroom, `bd(maxout = 5)` | 0.1370 | 0.1370 |
| One network, no constraints | 0.1711 | 0.1711 |

## Install

```r
install.packages("pak")
pak::pak("benrosche/ergMargins@constraints")
```

This replaces the CRAN version of `ergMargins` in your library. To go back, run `install.packages("ergMargins")`.
