\name{fitEP}
\alias{fitEP}

\title{
Fit PE or RLC data to Eilers and Peeters 1988
}

\description{
Calculates photosynthetic-irradiance (PE) parameters (alpha, eopt, ps) and fit statistics for PE
or RLC data using the model of Eilers and Peeters 1988.
}

\usage{
fitEP(x, y, normalize = FALSE, lowerlim = c(0, 0, 0), upperlim = c(100, 2000, 2000), 
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
Lower limits of parameter estimates (alpha, eopt, ps).
}
  \item{upperlim}{
Upper limits of parameter estimates (alpha, eopt, ps).
}
  \item{fitmethod}{
The method to be used, one of "Marq", "Port", "Newton", "Nelder-Mead", "BFGS", "CG", "L-BFGS-B", 
"SANN", "Pseudo". Default is "Nelder-Mead" - see details.
}
}

\details{

This function passes the data to the function  modFIT in the package FME that, through minimization via the specified 'fitmethod' algorithm, determines the optimal model parameters.
See the help on modFit algorithms. "Nelder-Mead" is fast and works well for two parameter models, "SANN" is slow and works well for three parameter models.

If normalize is set to FALSE, then data is fit to the equation:

\deqn{y = \frac{x}{x^2 \frac{1}{alpha \times epot^2} + \frac{x}{ps} - \frac{2x}{alpha \times eopt} + \frac{1}{alpha}}}{
      y = x / ( x^2/(alpha eopt^2)  +  x/ps - 2x/(alpha eopt) + (1/alpha)) }


If normalize is set to TRUE, then data is fit to the same equation but normalized to irradiance:

\deqn{y = \frac{1}{x^2 \frac{1}{alpha \times epot^2} + \frac{x}{ps} - \frac{2x}{alpha \times eopt} + \frac{1}{alpha}}}{
      y = 1 / ( x^2/(alpha eopt^2)  + x/ps - 2x / (alpha eopt) + 1/alpha)}

Fitting a E normalized PE model is useful for modeling the irradiance-dependency of PSII quantum yield, as discussed in Silsbe and Kromkamp 2012.

}

\value{
\item{alpha}{Parameter estimate, standard error, t-value and p-value}
\item{eopt}{Parameter estimate, standard error, t-value and p-value}
\item{ps}{Parameter estimate, standard error, t-value and p-value}
\item{ssr}{Sum of square residuals of fit}
\item{residuals}{Residuals of fit}
\item{model}{EP}
\item{normalize}{Boolean. TRUE or FALSE as passed to the function}
}

\references{

Eilers, P.H.C. and Peeters, J.C.H. 1988 A model for the relationship between light intensity and the rate of photosynthesis in phytoplankton. \emph{Ecological Modeling}. \bold{42}, 199--215.

Silsbe, G.M., and Kromkamp, J.C. 2012 Modeling the irradiance dependency of the quantum efficiency of photosynthesis. \emph{Limnology and Oceanography: Methods}. \bold{10}, 642--652. 

}

\author{

Greg M. Silsbe

Sairah Y. Malkin
}

\note{

Parameter units are dependent on the input. 

If normalize=FALSE, then alpha has unit of y/x, eopt has units of x, and ps has units of y.

If normalize=TRUE, then alpha has unit of y, eopt has units of x, and ps has units of y/x.

}


\seealso{
\code{\link{fitJP}}, \code{\link{fitPGH}}, \code{\link{fitWebb}}
}

\examples{

####   Single PE dataset example    ####

PAR <- c(5,10,20,50,100,150,250,400,800,1200) #umol m-2 s-1
Pc  <- c(1.02,1.99,3.85,9.2,15.45,21.3,28.8,34.5,39.9,38.6) #mg C m-3 hr-1

myfit <- fitEP(PAR, Pc)

#Plot input data
plot(PAR, Pc, xlim=c(0,1500), ylim=c(0,40), xlab="PAR", ylab="Pc")

#Add model fit
E <- seq(0,1500,by=1)
with(myfit,{
  P <- E/((1/(alpha[1]*eopt[1]^2))*E^2+(1/ps[1]-2/(alpha[1]*eopt[1]))*E+(1/alpha[1]))
  lines(E,P)
})


####   Multiple RLC dataset example    ####

data('rlcs') 

names(rlcs) #id is unique to a given RLC

id <- unique(rlcs$id)  #Hold unique ids
n  <- length(id)       #5 unique RLCs

#Setup arrays and vectors to store data

alpha     <- array(NA,c(n,4))
eopt      <- array(NA,c(n,4))
ps        <- array(NA,c(n,4))
ssr       <- rep(NA,n)
residuals <- array(NA,c(n,11))   

#Loop through individual RLCs

for (i in 1:n){
  
  #Get ith data
  PAR  <- rlcs$PAR[rlcs$id==id[i]]
  FqFm <- rlcs$FqFm[rlcs$id==id[i]]
  
  #Call function
  myfit <- fitEP(PAR,FqFm,normalize=TRUE)
  
  #Store data
  alpha[i,]     <- myfit$alpha
  eopt[i,]      <- myfit$eopt
  ps[i,]        <- myfit$ps
  ssr[i]        <- myfit$ssr
  residuals[i,] <- myfit$residuals
  
}


}