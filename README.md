<!-- README.md is generated from README.Rmd. Please edit that file -->

# enhacedviolinboxplot

[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)

This function allows you to obtain violinboxplots and enhanced radar plot to represent the data pattern in parallel coordinates and also in polar coordinates, taking into account the statistical summaries as well as their distribution, without neglecting the interesting atypical data in the form of radar plots.

## Initialitzation

### Dependencies: ggplot2

Load Package: 

```{r}
if (!require('ggplot2')) install.packages('ggplot2'); library('ggplot2')
```

## Example

The example data set is soccer data of the top 13 European clubs in the 2016/17 season of most importat leagues (Premier League, La Liga, , Ligue 1, Bundesliga, and Serie A. The variables used in this example are “competition” and “18-yard shot” that it was obtained from the publicly accessible website www.whoscored.com owned by Opta Sports.  

```{r}
load("soccer.RData")
source("function_enhacedviolinboxplot.R")
```

```{r}
enhacedviolinboxplot(soccer, c(1,2,3,4,5), polar=F)+ xlab('Competition')+ ylab('18-yard-shot')
enhacedviolinboxplot(soccer, c(1,2,3,4,5), polar=T)+ xlab('Competition')+ ylab('18-yard-shot')
enhacedviolinboxplot(soccer, c(1,2,3,4,5), polar=F, dicotom=6)+ xlab('Competition')
enhacedviolinboxplot(soccer, c(1,2,3,4,5), polar=T, dicotom=6)+ xlab('Competition')
```




