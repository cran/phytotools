\name{fitPGH}
\alias{fitPGH}

\title{
Fit PE or RLC data to Platt, Gallegos and Harrison 1980
}

\description{
Calculates photosynthetic-irradiance (PE) parameters (alpha, beta, ps) and fit statistics for PE
or RLC data using the model of Platt, Gallegos and Harrison 1980
}

\usage{
fitPGH(x, y, normalize = FALSE, lowerlim = c(0, 0, 0), upperlim = c(100, 1000, 1000), 
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
Boolean. Default is FALSE. Set to TRUE if fitting PSII quantum efficiency. See Details.
}
  \item{lowerlim}{
Lower limits of parameter estimates (alpha,beta,ps).
}
  \item{upperlim}{
Upper limits of parameter estimates (alpha,beta,ps).
}
  \item{fitmethod}{
The method to be used, one of "Marq", "Port", "Newton", "Nelder-Mead", "BFGS", "CG", "L-BFGS-B", "SANN", "Pseudo". Default is "Nelder-Mead" - see details.
}
}

\details{

This function passes the data to the function  modFIT in the package FME that, through minimization via the specified 'fitmethod' algorithm, determines the optimal model parameters.
See the help on modFit algorithms. "Nelder-Mead" is fast and works well for two parameter models, "SANN" is slow and works well for three parameter models.


If normalize is set to FALSE, then data is fit to the equation:

\deqn{y = ps \times (1-e^{\frac{-x \times alpha}{ps}}) \times e^{\frac{-x \times beta}{ps}}}{
      y = ps (1 - exp (-x alpha / ps )) exp (-x beta / ps )}

If normalize is set to TRUE, then data is fit to the same equation but normalized to irradiance:

\deqn{y = \frac{ps}{x} \times (1-e^{\frac{-x \times alpha}{ps}}) \times e^{\frac{-x \times beta}{ps}}}{
      y = ps / x (1 - exp (-x alpha / ps )) exp (-x beta / ps )}
      
Fitting a E normalized PE model is useful for modeling the irradiance-dependency of PSII quantum yield, as discussed in Silsbe and Kromkamp 2012.

}

\value{
\item{alpha}{Parameter estimate, standard error, t-value and p-value}
\item{beta}{Parameter estimate, standard error, t-value and p-value}
\item{ps}{Parameter estimate, standard error, t-value and p-value}
\item{ssr}{Sum of square residuals of fit}
\item{residuals}{Residuals of fit}
\item{model}{PGH}
\item{normalize}{Boolean. TRUE or FALSE as passed to the function}
}

\references{
Platt, T., Gallegos, C.L. and Harrison, W.G. 1980 Photoinhibition and photosynthesis in natural assemblages of marine phytoplankton. \emph{Journal of Marine Research}. \bold{38}, 687--701.

Silsbe, G.M., and Kromkamp, J.C. 2012 Modeling the irradiance dependency of the quantum efficiency of photosynthesis. \emph{Limnology and Oceanography: Methods}. \bold{10}, 642--652. 

}
\author{

Greg M. Silsbe

Sairah Y. Malkin
}

\note{

Parameter units are dependent on the input. 

If normalize=FALSE, then alpha has unit of y/x, beta has units of x, and ps has units of y.

If normalize=TRUE, then alpha has unit of y, beta has units of x, and ps has units of y/x.

}


\seealso{
\code{\link{fitJP}}, \code{\link{fitWebb}}, \code{\link{fitEP}}
}

\examples{

####   Single PE dataset example    ####

PAR <- c(5,10,20,50,100,150,250,400,800,1200) #umol m-2 s-1
Pc  <- c(1.02,1.99,3.85,9.2,15.45,21.3,28.8,34.5,39.9,38.6) #mg C m-3 hr-1

#Call function
myfit <- fitPGH(PAR, Pc)

#Plot input data
plot(PAR, Pc, xlim=c(0,1500), ylim=c(0,40), xlab="PAR", ylab="Pc")

#Add model fit
E <- seq(0,1500,by=1)
with(myfit,{
  P <- ps[1]*(1-exp(-1*alpha[1]*E/ps[1]))*exp(-1*beta[1]*E/ps[1])
  lines(E,P)
})


####   Multiple RLC dataset example    ####

data('rlcs') 

names(rlcs) #id is unique to a given RLC

id <- unique(rlcs$id)  #Hold unique ids
n  <- length(id)       #5 unique RLCs

#Setup arrays and vectors to store data

alpha     <- array(NA,c(n,4))
beta      <- array(NA,c(n,4))
ps        <- array(NA,c(n,4))
ssr       <- rep(NA,n)
residuals <- array(NA,c(n,11))  

#Loop through individual RLCs

for (i in 1:n){
  
  #Get ith data
  PAR  <- rlcs$PAR[rlcs$id==id[i]]
  FqFm <- rlcs$FqFm[rlcs$id==id[i]]
  
  #Call function
  myfit <- fitPGH(PAR,FqFm,normalize=TRUE)
  
  #Store data
  alpha[i,]     <- myfit$alpha
  beta[i,]      <- myfit$beta
  ps[i,]        <- myfit$ps
  ssr[i]        <- myfit$ssr
  residuals[i,] <- myfit$residuals
  
}

}