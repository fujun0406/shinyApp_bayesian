# Project - Bayesian Coin Flips (Using Shiny App)

## Contents
* [Background](#background)
* [Dataset](#dataset)
* [Application](#application)

## Background
Shiny is a package created by [Rstudio](https://rstudio.com/). Users can easily use this package to build interactive web apps straight from R. Motivated by this, I tried to employ this package to create a web application about simulating flipping coin. You can access my web app on [shiny.io](https://fuchun.shinyapps.io/bayesian_coin/).

## Dataset
If we have a coin that we claim it is fair, but we are less certain. In order to prove fairness, we simulate the scenario.
We consider the prior distribution are Beta or Truncated Normal and utilize approximate bayesian computation to get the results.

## Application
Users can select the number of trials, prior distribtion and parameters to visualize the results. After choicing the variables, they can see prior, likelihood and posterior distribution.

<img src="/image/shinyApp_bayesian_app.JPG" width="800"/> 

<em>Figure 1: The shiny app.</em>
