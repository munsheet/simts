% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/update.R
\name{update.lts}
\alias{update.lts}
\alias{update.gts}
\alias{update.imu}
\title{Update Object Attribute}
\usage{
\method{update}{lts}(object, type, new, keep.start = T, ...)

\method{update}{gts}(object, type, new, keep.start = T, ...)

\method{update}{imu}(object, type, new, ...)
}
\arguments{
\item{object}{A \code{lts}, \code{gts} or \code{imu} object}

\item{type}{A \code{string} that contains the attribute to be updated}

\item{new}{The updated value for the attribute}

\item{keep.start}{A \code{boolean} value that indicates whether 'start' or 'end' should remain the same when 'freq' is updated}

\item{...}{Further arguments passed to or from other methods.}
}
\value{
An object with the updated attribute.
}
\description{
Update the attributes of \code{lts}, \code{gts} and \code{imu} object
}
\details{
This function is able to update some attributes for \code{gts}, \code{lts} and \code{imu} objects. 
For \code{lts} object, the attributes that can be updated are 'start', 'end', 'freq', 'unit_time', 'name_ts' and 'process'.
For \code{gts} object, the attributes that can be updated are 'start', 'end', 'freq', 'unit_time' and 'name_ts'.
For \code{imu} object, the attributes that can be updated are 'axis', 'freq', 'unit_time' and 'name_ts'.

If one between 'start' and 'end' is updated, the other one will also be updated, since \code{end-start == (N-1)/freq} must be TRUE, where \code{N}
is the number of observations in the object. 

If 'freq' is updated, by default 'start' will remain the same, and 'end' will be updated at the same time,
unless you set 'keep.start = F'.

If 'unit_time' is updated, the old unit_time will be replaced by the new one, and other attributes will remain the same.
It is different from the unit_time conversion feature.
}
\examples{
gts1 = gts(rnorm(50), freq = 1, unit_time = 'sec', name_ts = 'test1')
gts2 = update(gts1, 'unit_time', 'min')
attr(gts2, 'unit_time')

gts3 = update(gts1, 'name_ts', 'test2')
attr(gts3, 'name_ts')
}
