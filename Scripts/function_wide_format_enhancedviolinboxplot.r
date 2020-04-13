
enhancedviolinboxplot<-function(data,variables,dicotom=NULL, polar=T){

# PARAMETERS

# data {array}: It is a dataset in which there are columns of the data.
# variables:  There are the number of the columns of the continuous variables that we want to represent
# dicotom: It is the number of the columns regarding the categorical variable (dummy or binary) that will allow us to separate them into two categories. By default, dicotom = NULL.
# polar: It is a parameter for whether we can decide to use a polar graph or not. Default polar = TRUE

# We want to know the dimension and variables of the data.
ncol=length(variables)
nfil=dim(data)[1]


# We can start using the data frame "data2" that will contain the stacked variables and a factor that tells us what each one is.
dades2=NULL
for (i in 1:ncol){dades2=c(dades2,data[,variables[i]])}
dades2=as.data.frame(dades2)
colnames(dades2)[1]="value"

dades2$group=as.factor(rep(colnames(data)[variables], each=nfil))

# The dataframe "dades2" is the stacked data where now we will add two columns.
# upper.limit and lower.limit are the detection limits of atypical plot data.
# We use the summary function applied to the stacked data, depending on the group factor

resum=tapply(dades2[,1],dades2[,2], summary)

# We save upper and lower limits of each group.
limit.sup=NULL
for (i in 1:ncol){limit.sup[i]=(resum[[i]][5]+1.5*(resum[[i]][5]-resum[[i]][2]))}

limit.inf=NULL
for (i in 1:ncol){limit.inf[i]=(resum[[i]][2]-1.5*(resum[[i]][5]-resum[[i]][2]))}

# We obtain variables with the upper and lower limits for each individual.
dades2$upper.limit=rep(limit.sup, each=nfil)
dades2$lower.limit=rep(limit.inf, each=nfil)

# We begin the plot representation.
# We define the p element for the data between the upper and lower limits our data except the atypical ones. Then, for this set we represent the violin_plot of the data except the atypical ones. 

p <- ggplot(dades2[dades2$value < dades2$upper.limit & dades2$value > dades2$lower.limit,], aes(x=factor(group), y=value, col=factor(group)))

#Then, we will add the representation of the data above the upper.limit or below the lower.limit (atypical).
# We include two loops.  The first is to know if we have to dichotomize or not. If we need to dichotomize, we will add the geom_split_violin function and a new variable and another one if they are polar or not. If we need to use polar coordinates, we should add + coordinate ().

if(is.null(dicotom))
{
if(polar==F){
p+geom_violin()+ geom_point(data=dades2[dades2$value > dades2$upper.limit | dades2$value < dades2$lower.limit,] ) +labs(x = "variable",  colour="variable")
}else{ 
p+geom_violin()+ geom_point(data=dades2[dades2$value > dades2$upper.limit | dades2$value < dades2$lower.limit,] )+coord_polar() +labs(x = "variable",  colour="variable")
}


}else{

#It is necessary to install the GeomSplitViolin and the geom_split_violin function.
GeomSplitViolin <- ggproto("GeomSplitViolin", GeomViolin, 
                           draw_group = function(self, data, ..., draw_quantiles = NULL) {
  data <- transform(data, xminv = x - violinwidth * (x - xmin), xmaxv = x + violinwidth * (xmax - x))
  grp <- data[1, "group"]
  newdata <- plyr::arrange(transform(data, x = if (grp %% 2 == 1) xminv else xmaxv), if (grp %% 2 == 1) y else -y)
  newdata <- rbind(newdata[1, ], newdata, newdata[nrow(newdata), ], newdata[1, ])
  newdata[c(1, nrow(newdata) - 1, nrow(newdata)), "x"] <- round(newdata[1, "x"])
  if (length(draw_quantiles) > 0 & !scales::zero_range(range(data$y))) {
    stopifnot(all(draw_quantiles >= 0), all(draw_quantiles <=
      1))
    quantiles <- ggplot2:::create_quantile_segment_frame(data, draw_quantiles)
    aesthetics <- data[rep(1, nrow(quantiles)), setdiff(names(data), c("x", "y")), drop = FALSE]
    aesthetics$alpha <- rep(1, nrow(quantiles))
    both <- cbind(quantiles, aesthetics)
    quantile_grob <- GeomPath$draw_panel(both, ...)
    ggplot2:::ggname("geom_split_violin", grid::grobTree(GeomPolygon$draw_panel(newdata, ...), quantile_grob))
  }
  else {
    ggplot2:::ggname("geom_split_violin", GeomPolygon$draw_panel(newdata, ...))
  }
})
geom_split_violin <- function(mapping = NULL, data = NULL, stat = "ydensity", position = "identity", ..., 
                              draw_quantiles = NULL, trim = TRUE, scale = "area", na.rm = FALSE, 
                              show.legend = NA, inherit.aes = TRUE) {
  layer(data = data, mapping = mapping, stat = stat, geom = GeomSplitViolin, 
        position = position, show.legend = show.legend, inherit.aes = inherit.aes, 
        params = list(trim = trim, scale = scale, draw_quantiles = draw_quantiles, na.rm = na.rm, ...))
}

# Here, we finish the declaration of the function geom_split_violin.

# We create a new variable with the colour from the original dataset column.
                           
dades2$color=rep(data[,dicotom], ncol)


p <- ggplot(dades2[dades2$value < dades2$upper.limit & dades2$value > dades2$lower.limit,], aes(x=factor(group), y=value, fill=color, col=factor(group)))

if(polar==F){
p+geom_split_violin()+ geom_point(data=dades2[dades2$value > dades2$upper.limit | dades2$value < dades2$lower.limit,] ) + labs(x = "variable", y= "dicotom", colour="variable")
}else{
p+geom_split_violin()+ geom_point(data=dades2[dades2$value > dades2$upper.limit | dades2$value < dades2$lower.limit,] )+coord_polar() + labs(x = "variable", y= "dicotom", colour="variable")
}
}

}
