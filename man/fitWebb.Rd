\name{fitWebb}
\alias{fitWebb}

\title{
Fit PE data to Webb et al. 1974
}

\description{
Calculates photosynthetic-irradiance (PE) parameters (alpha, ek) and fit statistics for PE
or rapid light curve data using the model of Webb et al. 1974.
}

\usage{
fitWebb(x, y, normalize = FALSE, lowerlim = c(0, 1), upperlim = c(100, 1000), 
fitmethod=c("Nelder-Mead"))
}

\arguments{
  \item{x}{
PAR data. Units of umol m-2 s-1
}
  \item{y}{
Photosynthetic rate or PSII quantum efficiency.
}
  \item{normalize}{
Boolean. Default is FALSE. Set to TRUE if y is PSII quantum efficiency. See Details.
}
  \item{lowerlim}{
Lower limits of parameter estimates (alpha,ek).
}
  \item{upperlim}{
Upper limits of parameter estimates (alpha,ek).
}
  \item{fitmethod}{
The method to be used, one of "Marq", "Port", "Newton", "Nelder-Mead", "BFGS", "CG", "L-BFGS-B", "SANN", "Pseudo". Default is "Nelder-Mead" - see details.
}
}

\details{

This function passes the data to the function  modFIT in the package FME that, through minimization via the specified 'fitmethod' algorithm, determines the optimal model parameters.
See the help on modFit algorithms. "Nelder-Mead" is fast and works well for two parameter models, "SANN" is slow and works well for three parameter models. 

If normalize is set to FALSE, then data is fit to the equation:

\deqn{y = alpha \times ek \times (1-e^{\frac{-x}{ek}})}{y = alpha ek (1 - exp (-x / ek) )}

If normalize is set to TRUE, then data is fit to the same equation but normalized to irradiance:

\deqn{y = \frac{1}{x} \times alpha \times ek \times (1-e^{\frac{-x}{ek}})}{y = 1 / x alpha ek (1-exp (-x / ek) )}

Fitting an irradiance-normalized PE model is useful for modeling the irradiance-dependency of PSII quantum yield, as discussed in Silsbe and Kromkamp 2012. If normalize is set to TRUE, x values eqaul to 0 are set to 1e-6.

}

\value{
\item{alpha}{Parameter estimate, standard error, t-value and p-value}
\item{ek}{Parameter estimate, standard error, t-value and p-value}
\item{ssr}{Sum of square residuals of fit}
\item{residuals}{Residuals of fit}
\item{model}{Webb}
\item{normalize}{Boolean. TRUE or FALSE as passed to the function}
}

\references{
Silsbe, G.M., and Kromkamp, J.C. 2012 Modeling the irradiance dependency of the quantum efficiency of photosynthesis. \emph{Limnology and Oceanography: Methods}. \bold{10}, 642--652. 

Webb, W.L., Newton, M., and Starr, D. 1974 Carbon dioxide exchange of \emph{Alnus rubra}: A mathematical model. \emph{Oecologia}. \bold{17}, 281--291.

}
\author{

Greg M. Silsbe

Sairah Y. Malkin
}

\note{

Parameter units are dependent on the input. 

If normalize=FALSE, then alpha has unit of y/x and ek has units of x.

If normalize=TRUE, then alpha has unit of y and ek has units of x.

}


\seealso{
\code{\link{fitJP}}, \code{\link{fitPGH}}, \code{\link{fitEP}}
}

\examples{

####   Single PE dataset example    ####

PAR <- c(5,10,20,50,100,150,250,400,800,1200) #umol m-2 s-1
Pc  <- c(1.02,1.99,3.85,9.2,15.45,21.3,28.8,34.5,39.9,38.6) #mg C m-3 hr-1

#Call function
myfit <- fitWebb(PAR, Pc)

#Plot input data
plot(PAR, Pc, xlim=c(0,1500), ylim=c(0,40), xlab="PAR", ylab="Pc")

#Add model fit
E <- seq(0,1500,by=1)
with(myfit, {
  P <- alpha[1] * ek[1] * (1 - exp (-E / ek[1]))
  lines(E,P)
})


####   Multiple RLC dataset example    ####

data('rlcs')

names(rlcs) #id is unique to a given RLC

id <- unique(rlcs$id)  #Hold unique ids
n  <- length(id)       #5 unique RLCs

#Setup arrays and vectors to store data
#All RLCs in example have the same 11 PAR steps in the same order

alpha     <- array(NA,c(n,4))
ek        <- array(NA,c(n,4))
ssr       <- rep(NA,n)
residuals <- array(NA,c(n,11))   

#Loop through individual RLCs

for (i in 1:n){
  
  #Get ith data
  PAR  <- rlcs$PAR[rlcs$id==id[i]]
  FqFm <- rlcs$FqFm[rlcs$id==id[i]]
  
  #Call function
  myfit <- fitWebb(PAR,FqFm,normalize=TRUE)
  
  #Store data
  alpha[i,]     <- myfit$alpha
  ek[i,]        <- myfit$ek
  ssr[i]        <- myfit$ssr
  residuals[i,] <- myfit$residuals
}

}