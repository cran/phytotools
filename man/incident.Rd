\name{incident}
\alias{incident}

\title{
Simulate photosynthetic active radiaton (PAR)
}

\description{
Derives and simulates PAR over a defined period for a given location. 
}

\usage{
incident(date, latitude, longitude, elevation, timezone, meanPAR, TL = 3.5, 
reflectance = TRUE)
}

\arguments{
  \item{date}{
The date and time over which to calculate incident PAR. Date and time must be in the ISO format with the timezone set to UTC, see Examples.
}
  \item{latitude}{
Latitude in decimal degrees. Northern hemisphere is positive.
}
  \item{longitude}{
Longitude in decimal degrees. Eastern hemisphere is positive.
}
  \item{elevation}{
Elevation in metres.
}
  \item{timezone}{
Time zone, west is negative. See Details.
}
  \item{meanPAR}{
Optional. Mean daily PAR to scale data to. See Details.
}
  \item{TL}{
Linke turbidity factor that describes atmospheric turbidity. Default value is 3.5, see Details.
}
  \item{reflectance}{
Boolean indicating whether reflectance at the air-water interface should be subtracted from PAR. Default is TRUE, see Details.
}
}

\details{


Timezone refers to hours relative to UTC. There is currently no provision for daylight savings time. An example for Lake Erie below describes a workaround for daylight savings time.

This function calculates the solar position (azimuth and zenith angle) at each time step using the function insol from the package insolation. Next, shortwave radiation is calculated at each time step as the sum of direct and diffuse radiation following Hofierka and Suri (2002). This calculation requires a Linke turbidity factor (TL) that describes cloud-free atmospheric turbidity. Monthly global maps of TL can be found at \url{http://www.soda-is.com/linke/linke_helioserve.html}. Finally, shortwave radiation is multiplied by 2.047 to arrive at PAR (Kirk 2011). 

If a meanPAR argument is passed to this function, cloud-free PAR as calculated above is scaled to this value. Mean daily PAR values for a given month can be retrieved from for the global ocean and many large inland lakes from the MODIS ocean colour website \url{http://oceancolor.gsfc.nasa.gov/cgi/l3}.

If reflectance=TRUE, then irradiance reflected off the air-water interface is subtracted from PAR, as calculated as a function of zenith angle following Kirk (2011).

}

\value{

A two column matrix specifying the decimal day of year and PAR.

}

\references{

Hofierka, J., and Suri, M. 2002 The solar radiation model for Open source GIS: Implementation and applications. \emph{Proceedings of the source GIS-GRASS users conference 2002.} 

Kirk, J.T.O., 2011 Light and photosynthesis in aquatic environments. Cambridge Press.

}

\author{
Greg M. Silsbe
Sairah Y. Malkin
}

\seealso{
\code{\link{reflectance}}
}

\examples{

#Simulate cloud free PAR Lake Diefenbaker on 1 July 2013 using default Linke Turbidity
date <- seq(ISOdatetime(2013,7,1,0,0,0,tz="UTC"),
            ISOdatetime(2013,7,2,0,0,0,tz="UTC"),
            by="10 min")

LD.1 <- incident(date,50,-105,556,-8,reflectance=FALSE)

#Simulate cloud free PAR Lake Diefenbaker on 1 July 2013  Linke Turbidity of 4.5
LD.2 <- incident(date,50,-105,556,-8,TL=4.5,reflectance=FALSE)

#Now simulate PAR for Lake Diefenbaker using a mean PAR value of 578 umol m-2 s-1
LD.3 <- incident(date,50,-105,556,-8,meanPAR=575,reflectance=FALSE)

#Now simulate PAR for Lake Diefenbaker using a mean PAR value of 578 umol m-2 s-1
#and Link Turbidity of 4.5
LD.4 <- incident(date,50,-105,556,-8,meanPAR=575,TL=4.5,reflectance=FALSE)

#Compare simulations
plot(LD.1[,1],LD.1[,2],xlab="Day of year",ylab="PAR",type="l")
lines(LD.2[,1],LD.2[,2],col="red")
lines(LD.3[,1],LD.3[,2],col="blue")
lines(LD.4[,1],LD.4[,2],col="blue",lty=2)

#Simulate annual PAR for Lake Erie, with a workaround for daylight savings time
date1 <- seq(ISOdatetime(2013,1,1,0,0,0,tz="UTC"),
             ISOdatetime(2013,3,9,0,0,0,tz="UTC"),
             by="30 min")

date2 <- seq(ISOdatetime(2013,3,9,0,0,0,tz="UTC"),
             ISOdatetime(2013,11,2,0,0,0,tz="UTC"),
             by="30 min")

date3 <- seq(ISOdatetime(2013,11,2,0,0,0,tz="UTC"),
             ISOdatetime(2014,1,1,0,0,0,tz="UTC"),
             by="30 min")

LE <- rbind(incident(date1,42.15,-81,115,-5,reflectance=FALSE),
            incident(date2,42.15,-81,115,-4,reflectance=FALSE),
            incident(date3,42.15,-81,115,-5,reflectance=FALSE))

#plot data
plot(LE[,1],LE[,2],xlab="Day of year",ylab="PAR",type="l")

}