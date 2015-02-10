\name{reflectance}
\alias{reflectance}
\title{
Computes surface reflectance
}
\description{
The fraction of surface reflectance at the air-water interface is calculated as a function of solar zenith angle following Kirk (2011).

}
\usage{
reflectance(date, latitude, longitude, timezone)
}
\arguments{
  \item{date}{
The date and time over which to calculate reflectance. Date and time must be in the ISO format with the timezone set to UTC, see examples.
}
  \item{latitude}{
Latitude in decimal degrees. Northern hemisphere is positive.
}
  \item{longitude}{
Longitude in decimal degrees. Eastern hemisphere is positive.
}
  \item{timezone}{
Time zone, west is negative. See Details.
}
}
\details{
Timezone refers to hours relative to UTC. There is currently no provision for daylight savings time. 

}
\value{
A two column matrix specifying the decimal day of year and the fraction of surface reflectance.
}
\references{
Kirk, J.T.O., 2011. Light and photosynthesis in aquatic environments. Cambridge Press.

}
\author{
Greg M. Silsbe
Sairah Y. Malkin
}

\seealso{

\code{\link{incident}}

}
\examples{

#Calculate surface reflectance in 10 minute increments 
#for Godthabsfjord fjord, Greenland on March 1

#Setup date sequence
date <- seq(ISOdatetime(2013,3,1,0,0,0,tz="UTC"), 
            ISOdatetime(2013,3,2,0,0,0,tz="UTC"),
            by = "10 min")

#Call the function
ref <- reflectance(date,64.20,-51.76,-3)

#Plot data
plot(ref[,1],ref[,2],type="l",xlab="Day of Year",ylab="Surface Reflectance")

}
