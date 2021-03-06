% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ts.model.R
\name{ARMA}
\alias{ARMA}
\title{Create an Autoregressive Moving Average (ARMA) Process}
\usage{
ARMA(ar = 1, ma = 1, sigma2 = 1)
}
\arguments{
\item{ar}{A \code{vector} or \code{integer} containing either the coefficients for \eqn{\phi}{phi}'s or the process number \eqn{p} for the Autoregressive (AR) term.}

\item{ma}{A \code{vector} or \code{integer} containing either the coefficients for \eqn{\theta}{theta}'s or the process number \eqn{q} for the Moving Average (MA) term.}

\item{sigma2}{A \code{double} value for the standard deviation, \eqn{\sigma}{sigma}, of the ARMA process.}
}
\value{
An S3 object with called ts.model with the following structure:
\describe{
 \item{process.desc}{\eqn{AR*p}{AR x p}, \eqn{MA*q}{MA x q}}
 \item{theta}{\eqn{\sigma}{sigma}}
 \item{plength}{Number of Parameters}
 \item{print}{String containing simplified model}
 \item{obj.desc}{y desc replicated x times}
 \item{obj}{Depth of Parameters e.g. list(c(length(ar),length(ma),1) )}
 \item{starting}{Guess Starting values? TRUE or FALSE (e.g. specified value)}
}
}
\description{
Sets up the necessary backend for the ARMA process.
}
\details{
A variance is required since the model generation statements utilize 
randomization functions expecting a variance instead of a standard deviation like R.
}
\note{
We consider the following model: \deqn{X_t = \sum_{j = 1}^p \phi_j X_{t-j} + \sum_{j = 1}^q \theta_j \varepsilon_{t-j} + \varepsilon_t}, where \eqn{\varepsilon_t} is iid from a zero 
mean normal distribution with variance \eqn{\sigma^2}.
}
\examples{
# Create an ARMA(1,2) process
ARMA(ar=1,2)
# Creates an ARMA(3,2) process with predefined coefficients.
ARMA(ar=c(0.23,.43, .59), ma=c(0.4,.3))

# Creates an ARMA(3,2) process with predefined coefficients and standard deviation
ARMA(ar=c(0.23,.43, .59), ma=c(0.4,.3), sigma2 = 1.5)
}
\author{
James Balamuta
}
