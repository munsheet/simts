# Generated by using Rcpp::compileAttributes() -> do not edit by hand
# Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

#' @title Reverse Armadillo Vector
#' @description Reverses the order of an Armadillo Vector
#' @usage reverse_vec(x)
#' @param x A \code{column vector} of length N
#' @return x A \code{column vector} with its contents reversed.
#' @details Consider a vector x=[1,2,3,4,5], the function would output x=[5,4,3,2,1].
#' @author James Balamuta
#' @keywords internal
reverse_vec <- function(x) {
    .Call('simts_reverse_vec', PACKAGE = 'simts', x)
}

#' @title Absolute Value or Modulus of a Complex Number.
#' @description Computes the value of the Modulus.
#' @param x A \code{cx_vec}. 
#' @return A \code{vec} containing the modulus for each element.
#' @details Consider a complex number defined as: \eqn{z = x + i y} with real \eqn{x} and \eqn{y},
#' The modulus is defined as: \eqn{r = Mod(z) = \sqrt{(x^2 + y^2)}}
#' @keywords internal
Mod_cpp <- function(x) {
    .Call('simts_Mod_cpp', PACKAGE = 'simts', x)
}

#' Generate a Gaussian White Noise Process (WN(\eqn{\sigma ^2}{sigma^2}))
#' 
#' Simulates a Gaussian White Noise Process with variance parameter \eqn{\sigma ^2}{sigma^2}.
#' @param N      An \code{integer} for signal length.
#' @param sigma2 A \code{double} that contains process variance.
#' @return wn A \code{vec} containing the white noise.
#' @backref src/gen_process.cpp
#' @backref src/gen_process.h
#' @template processes_defined/process_wn
#' @section Generation Algorithm:
#' To generate the Gaussian White Noise (WN) process, we first obtain the 
#' standard deviation from the variance by taking a square root. Then, we 
#' sample \eqn{N} times from a \eqn{N(0,\sigma ^2)}{N(0,sigma^2)} distribution.
#' @keywords internal
#' @export
#' @examples
#' gen_wn(10, 1.5)
gen_wn <- function(N, sigma2 = 1) {
    .Call('simts_gen_wn', PACKAGE = 'simts', N, sigma2)
}

#' Generate a Drift Process
#' 
#' Simulates a Drift Process with a given slope, \eqn{\omega}.
#' @param N     An \code{integer} for signal length.
#' @param omega A \code{double} that contains drift slope
#' @return A \code{vec} containing the drift.
#' @template processes_defined/process_dr
#' @section Generation Algorithm:
#' To generate the Drift process, we first fill a \code{vector} with the \eqn{\omega}{omega} parameter.
#' After, we take the cumulative sum along the vector. 
#' @backref src/gen_process.cpp
#' @backref src/gen_process.h
#' @keywords internal
#' @export
#' @examples
#' gen_dr(10, 8.2)
gen_dr <- function(N, omega = 5) {
    .Call('simts_gen_dr', PACKAGE = 'simts', N, omega)
}

#' Generate a Quantisation Noise (QN) or Rounding Error Sequence
#' 
#' Simulates a QN sequence given \eqn{Q^2}.
#' @param N  An \code{integer} for signal length.
#' @param q2 A \code{double} that contains autocorrection.
#' @return A \code{vec} containing the QN process.
#' @keywords internal
#' @template processes_defined/process_qn
#' @section Generation Algorithm:
#' To generate the quantisation noise, we follow this recipe:
#' First, we generate using a random uniform distribution:
#' \deqn{U_k^*\sim U\left[ {0,1} \right]}{U_k^*~U[0,1]}
#' 
#' Then, we multiple the sequence by \eqn{\sqrt{12}}{sqrt(12)} so:
#' \deqn{{U_k} = \sqrt{12} U_k^*}{U_k = sqrt(12)*U_k^*}
#' 
#' Next, we find the derivative of \eqn{{U_k}}{U_k}
#' \deqn{{{\dot U}_k} = \frac{{{U_{k + \Delta t}} - {U_k}}}{{\Delta t}}}{U_k^. = (U_(k + (delta)t) - U_k)}
#'
#' In this case, we modify the derivative such that:
#' \eqn{{{\dot U}_k}\Delta t = {U_{k + \Delta t}} - {U_k}}{U_k^. * (delta)t = U_{k + (delta)*t} - U_k}
#'
#' Thus, we end up with:
#' \deqn{{x_k} = \sqrt Q {{\dot U}_k}\Delta t}{x_k = sqrt(Q)*U_k^.*(delta)t}
#' \deqn{{x_k} = \sqrt Q \left( {{U_{k + 1}} - {U_k}} \right)}{x_k = sqrt(Q)* (U_(k+1) - U_(k))}
#'
#' @backref src/gen_process.cpp
#' @backref src/gen_process.h
#' @export
#' @examples
#' gen_qn(10, 5)
gen_qn <- function(N, q2 = .1) {
    .Call('simts_gen_qn', PACKAGE = 'simts', N, q2)
}

#' Generate an Autoregressive Order 1 ( AR(1) ) sequence
#' 
#' Generate an Autoregressive Order 1 sequence given \eqn{\phi} and \eqn{\sigma^2}.
#' @param N      An \code{unsigned integer} for signal length.
#' @param phi    A \code{double} that contains autocorrection.
#' @param sigma2 A \code{double} that contains process variance.
#' @return A \code{vec} containing the AR(1) process.
#' @details
#' The function implements a way to generate the AR(1)'s \eqn{x_t}{x[t]} values \emph{without} calling the general ARMA function.
#' Thus, the function is able to generate values much faster than \code{\link{gen_arma}}.
#' @template processes_defined/process_ar1
#' @section Generation Algorithm:
#' The function first generates a vector of White Noise with length \eqn{N+1} using \code{\link{gen_wn}} and then obtains the
#' autoregressive values under the above process definition.
#' 
#' The \eqn{X_0}{X[0]} (first value of \eqn{X_t}{X[t]}) is discarded.
#' @backref src/gen_process.cpp
#' @backref src/gen_process.h
#' @keywords internal
#' @export
#' @examples
#' gen_ar1(10, 5, 1.2)
gen_ar1 <- function(N, phi = .3, sigma2 = 1) {
    .Call('simts_gen_ar1', PACKAGE = 'simts', N, phi, sigma2)
}

#' Generate a Random Walk without Drift
#' 
#' Generates a random walk without drift.
#' @param N      An \code{integer} for signal length.
#' @param sigma2 A \code{double} that contains process variance.
#' @return grw A \code{vec} containing the random walk without drift.
#' @template processes_defined/process_rw
#' @section Generation Algorithm:
#' To generate we first obtain the standard deviation from the variance by taking a square root. Then, we 
#' sample \eqn{N} times from a \eqn{N(0,\sigma^2)}{N(0,sigma^2)} distribution. Lastly, we take the
#' cumulative sum over the vector. 
#' @backref src/gen_process.cpp
#' @backref src/gen_process.h
#' @keywords internal
#' @export
#' @examples
#' gen_rw(10, 8.2)
gen_rw <- function(N, sigma2 = 1) {
    .Call('simts_gen_rw', PACKAGE = 'simts', N, sigma2)
}

#' Generate an Moving Average Order 1 (MA(1)) Process
#' 
#' Generate an MA(1) Process given \eqn{\theta} and \eqn{\sigma^2}.
#' @param N      An \code{integer} for signal length.
#' @param theta  A \code{double} that contains moving average.
#' @param sigma2 A \code{double} that contains process variance.
#' @return A \code{vec} containing the MA(1) process.
#' @details
#' The function implements a way to generate the \eqn{x_t}{x[t]} values without calling the general ARMA function.
#' @template processes_defined/process_ma1
#' @section Generation Algorithm:
#' The function first generates a vector of white noise using \code{\link{gen_wn}} and then obtains the
#' MA values under the above equation. 
#' 
#' The \eqn{X_0}{X[0]} (first value of \eqn{X_t}{X[t]}) is discarded.
#' @backref src/gen_process.cpp
#' @backref src/gen_process.h
#' @keywords internal
#' @export
#' @examples
#' gen_ma1(10, .2, 1.2)
gen_ma1 <- function(N, theta = .3, sigma2 = 1) {
    .Call('simts_gen_ma1', PACKAGE = 'simts', N, theta, sigma2)
}

#' Generate an ARMA(1,1) sequence
#' 
#' Generate an ARMA(1,1) sequence given \eqn{\phi}, \eqn{\theta}, and \eqn{\sigma^2}.
#' @param N      An \code{integer} for signal length.
#' @param phi    A \code{double} that contains autoregressive.
#' @param theta  A \code{double} that contains moving average.
#' @param sigma2 A \code{double} that contains process variance.
#' @return A \code{vec} containing the MA(1) process.
#' @details
#' The function implements a way to generate the \eqn{x_t}{x[t]} values without calling the general ARMA function.
#' @template processes_defined/process_arma11
#' @section Generation Algorithm:
#' The function first generates a vector of white noise using \code{gen_wn} and then obtains the
#' ARMA values under the above equation.
#' 
#' The \eqn{X_0}{X[0]} (first value of \eqn{X_t}{X[t]}) is discarded.
#' @backref src/gen_process.cpp
#' @backref src/gen_process.h
#' @keywords internal
#' @export
#' @examples
#' gen_ma1(10, .2, 1.2)
gen_arma11 <- function(N, phi = .1, theta = .3, sigma2 = 1) {
    .Call('simts_gen_arma11', PACKAGE = 'simts', N, phi, theta, sigma2)
}

#' Generate Autoregressive Order \eqn{p} - Moving Average Order \eqn{q} (ARMA(\eqn{p},\eqn{q})) Model
#' 
#' Generate an ARMA(\eqn{p},\eqn{q}) process with supplied vector of Autoregressive Coefficients (\eqn{\phi}), Moving Average Coefficients (\eqn{\theta}), and \eqn{\sigma^2}.
#' @param N       An \code{integer} for signal length.
#' @param ar      A \code{vec} that contains the AR coefficients.
#' @param ma      A \code{vec} that contains the MA coefficients.
#' @param sigma2  A \code{double} that contains process variance.
#' @param n_start An \code{unsigned int} that indicates the amount of observations to be used for the burn in period. 
#' @return A \code{vec} that contains the generated observations.
#' @details
#' For \code{\link[=gen_ar1]{AR(1)}}, \code{\link[=gen_ma1]{MA(1)}}, and \code{\link[=gen_arma11]{ARMA(1,1)}} please use their functions if speed is important
#' as this function is designed to generate generic ARMA processes.
#' @template processes_defined/process_arma
#' @section Generation Algorithm: 
#' The innovations are generated from a normal distribution.
#' The \eqn{\sigma^2} parameter is indeed a variance parameter. 
#' This differs from R's use of the standard deviation, \eqn{\sigma}.
#' @backref src/gen_process.cpp
#' @backref src/gen_process.h
#' @keywords internal
#' @export
#' @examples
#' gen_arma(10, c(.3,.5), c(.1), 1, 0)
gen_arma <- function(N, ar, ma, sigma2 = 1.5, n_start = 0L) {
    .Call('simts_gen_arma', PACKAGE = 'simts', N, ar, ma, sigma2, n_start)
}

#' Generate Seasonal Autoregressive Order P - Moving Average Order Q (SARMA(p,q)x(P,Q)) Model
#' 
#' Generate an ARMA(P,Q) process with supplied vector of Autoregressive Coefficients (\eqn{\phi}), Moving Average Coefficients (\eqn{\theta}), and \eqn{\sigma^2}.
#' @param N       An \code{integer} for signal length.
#' @param ar      A \code{vec} that contains the AR coefficients.
#' @param ma      A \code{vec} that contains the MA coefficients.
#' @param sar     A \code{vec} that contains the SAR coefficients.
#' @param sma     A \code{vec} that contains the SMA coefficients.
#' @param sigma2  A \code{double} that contains process variance.
#' @param s       An \code{integer} that contains a seasonal id. 
#' @param n_start An \code{unsigned int} that indicates the amount of observations to be used for the burn in period. 
#' @return A \code{vec} that contains the generated observations.
#' @details 
#' The innovations are generated from a normal distribution.
#' The \eqn{\sigma^2} parameter is indeed a variance parameter. 
#' This differs from R's use of the standard deviation, \eqn{\sigma}.
#' @backref src/gen_process.cpp
#' @backref src/gen_process.h
#' @keywords internal
#' @export
#' @examples
#' gen_sarma(10, c(.3,.5), c(.1), c(.2), c(.4), 1, 12, 0)
gen_sarma <- function(N, ar, ma, sar, sma, sigma2 = 1.5, s = 12L, n_start = 0L) {
    .Call('simts_gen_sarma', PACKAGE = 'simts', N, ar, ma, sar, sma, sigma2, s, n_start)
}

#' Generate Autoregressive Order p, Integrated d, Moving Average Order q (ARIMA(p,d,q)) Model
#' 
#' Generate an ARIMA(p,d,q) process with supplied vector of Autoregressive Coefficients (\eqn{\phi}), Integrated \eqn{d}{d}, Moving Average Coefficients (\eqn{\theta}), and \eqn{\sigma^2}.
#' @param N       An \code{integer} for signal length.
#' @param ar      A \code{vec} that contains the AR coefficients.
#' @param d       An \code{integer} that indicates a difference.
#' @param ma      A \code{vec} that contains the MA coefficients.
#' @param sigma2  A \code{double} that contains process variance.
#' @param n_start An \code{unsigned int} that indicates the amount of observations to be used for the burn in period. 
#' @return A \code{vec} that contains the generated observations.
#' @details 
#' The innovations are generated from a normal distribution.
#' The \eqn{\sigma^2} parameter is indeed a variance parameter. 
#' This differs from R's use of the standard deviation, \eqn{\sigma}.
#' @section Warning:
#' Please note, this function will generate a sum of \eqn{N + d} number of observations,
#' where \eqn{d} denotes the number of differences necessary. 
#' @backref src/gen_process.cpp
#' @backref src/gen_process.h
#' @keywords internal
#' @export
#' @examples
#' # Generate an ARIMA model
#' xt = gen_arima(10, c(.3,.5), 1, c(.1), 1.5, 0)
gen_arima <- function(N, ar, d, ma, sigma2 = 1.5, n_start = 0L) {
    .Call('simts_gen_arima', PACKAGE = 'simts', N, ar, d, ma, sigma2, n_start)
}

#' Generate Seasonal Autoregressive Order P - Moving Average Order Q (SARMA(p,q)x(P,Q)) Model
#' 
#' Generate an ARMA(P,Q) process with supplied vector of Autoregressive Coefficients (\eqn{\phi}), Moving Average Coefficients (\eqn{\theta}), and \eqn{\sigma^2}.
#' @param N       An \code{integer} for signal length.
#' @param ar      A \code{vec} that contains the AR coefficients.
#' @param d       An \code{integer} that indicates a non-seasonal difference.
#' @param ma      A \code{vec} that contains the MA coefficients.
#' @param sar     A \code{vec} that contains the SAR coefficients.
#' @param sd      An \code{integer} that indicates a seasonal difference.
#' @param sma     A \code{vec} that contains the SMA coefficients.
#' @param sigma2  A \code{double} that contains process variance.
#' @param s       An \code{integer} that contains a seasonal id. 
#' @param n_start An \code{unsigned int} that indicates the amount of observations to be used for the burn in period. 
#' @return A \code{vec} that contains the generated observations.
#' @details 
#' The innovations are generated from a normal distribution.
#' The \eqn{\sigma^2} parameter is indeed a variance parameter. 
#' This differs from R's use of the standard deviation, \eqn{\sigma}.
#' @backref src/gen_process.cpp
#' @backref src/gen_process.h
#' @keywords internal
#' @export
#' @examples
#' gen_sarima(10, c(.3,.5), 1, c(.1), c(.2), 0, c(.4), 1, 12, 0)
gen_sarima <- function(N, ar, d, ma, sar, sd, sma, sigma2 = 1.5, s = 12L, n_start = 0L) {
    .Call('simts_gen_sarima', PACKAGE = 'simts', N, ar, d, ma, sar, sd, sma, sigma2, s, n_start)
}

#' Generate Generic Seasonal Autoregressive Order P - Moving Average Order Q (SARMA(p,q)x(P,Q)) Model
#' 
#' Generate an ARMA(P,Q) process with supplied vector of Autoregressive Coefficients (\eqn{\phi}), Moving Average Coefficients (\eqn{\theta}), and \eqn{\sigma^2}.
#' @param N            An \code{integer} for signal length.
#' @param theta_values A \code{vec} containing the parameters for (S)AR and (S)MA.
#' @param objdesc      A \code{vec} that contains the \code{\link{+.ts.model}}'s obj.desc field.
#' @param sigma2       A \code{double} that contains process variance.
#' @param s            An \code{integer} that contains a seasonal id. 
#' @param n_start      An \code{unsigned int} that indicates the amount of observations to be used for the burn in period. 
#' @return A \code{vec} that contains the generated observations.
#' @details 
#' The innovations are generated from a normal distribution.
#' The \eqn{\sigma^2} parameter is indeed a variance parameter. 
#' This differs from R's use of the standard deviation, \eqn{\sigma}.
#' @backref src/gen_process.cpp
#' @backref src/gen_process.h
#' @keywords internal
#' @export
#' @examples
#' gen_sarima(10, c(.3,.5), 1, c(.1), c(.2), 0, c(.4), 1, 12, 0)
gen_generic_sarima <- function(N, theta_values, objdesc, sigma2 = 1.5, n_start = 0L) {
    .Call('simts_gen_generic_sarima', PACKAGE = 'simts', N, theta_values, objdesc, sigma2, n_start)
}

#' Generate Time Series based on Model (Internal)
#' 
#' Create a time series process based on a supplied \code{ts.model}.
#' @param N       An \code{interger} containing the amount of observations for the time series.
#' @param theta   A \code{vec} containing the parameters to use to generate the model
#' @param desc    A \code{vector<string>} containing the different model types (AR1, WN, etc..)
#' @param objdesc A \code{field<vec>} contains the different model objects e.g. AR1 = c(1,1)
#' @return A \code{vec} that contains combined time series.
#' @backref src/gen_process.cpp
#' @backref src/gen_process.h
#' @keywords internal
#' @export
#' @examples
#' # AR
#' set.seed(1336)
#' gen_model(1000, c(.9,1), "AR1", list(c(1,1)))
gen_model <- function(N, theta, desc, objdesc) {
    .Call('simts_gen_model', PACKAGE = 'simts', N, theta, desc, objdesc)
}

#' Generate Latent Time Series based on Model (Internal)
#' 
#' Create a latent time series based on a supplied time series model.
#' @param N       An \code{interger} containing the amount of observations for the time series.
#' @param theta   A \code{vec} containing the parameters to use to generate the model.
#' @param desc    A \code{vector<string>} containing the different model types (AR1, WN, etc..).
#' @param objdesc A \code{field<vec>} containing the different model objects e.g. AR1 = c(1,1)
#' @return A \code{mat} containing data for each decomposed and combined time series.
#' @backref src/gen_process.cpp
#' @backref src/gen_process.h
#' @keywords internal
#' @export
#' @examples
#' # AR
#' set.seed(1336)
#' gen_lts_cpp(10, c(.9,1), "AR1", list(c(1,1)))
gen_lts_cpp <- function(N, theta, desc, objdesc) {
    .Call('simts_gen_lts_cpp', PACKAGE = 'simts', N, theta, desc, objdesc)
}

#' @title Root Finding C++
#' @description Used to interface with Armadillo
#' @param z A \code{cx_vec} (complex vector) that has 1 in the beginning (e.g. c(1,3i,-3i))
#' @keywords internal
do_polyroot_arma <- function(z) {
    .Call('simts_do_polyroot_arma', PACKAGE = 'simts', z)
}

#' @title Root Finding C++
#' @description Vroom Vroom
#' @param z A \code{vec<complex<double>} (complex vector) that has 1 in the beginning (e.g. c(1,3i,-3i))
#' @keywords internal
do_polyroot_cpp <- function(z) {
    .Call('simts_do_polyroot_cpp', PACKAGE = 'simts', z)
}

#' @title Read an IMU Binary File into R
#' 
#' @description
#' The function will take a file location in addition to the type of sensor it
#' came from and read the data into R.
#' 
#' @param file_path A \code{string} that contains the full file path.
#' @param imu_type A \code{string} that contains a supported IMU type given below.
#' @details
#' Currently supports the following IMUs:
#' \itemize{
#' \item IMAR
#' \item LN200
#' \item LN200IG
#' \item IXSEA
#' \item NAVCHIP_INT
#' \item NAVCHIP_FLT
#' }
#' 
#' We hope to soon be able to support delimited files.
#' @return A matrix with dimensions N x 7, where the columns represent:
#' \describe{
#' \item{Col 0}{Time}
#' \item{Col 1}{Gyro 1}
#' \item{Col 2}{Gyro 2}
#' \item{Col 3}{Gyro 3}
#' \item{Col 4}{Accel 1}
#' \item{Col 5}{Accel 2}
#' \item{Col 6}{Accel 3}
#' }
#' @references
#' Thanks goes to Philipp Clausen of Labo TOPO, EPFL, Switzerland, topo.epfl.ch, Tel:+41(0)21 693 27 55
#' for providing a matlab function that reads in IMUs.
#' The function below is a heavily modified port of MATLAB code into Armadillo/C++. 
#' 
#' @examples
#' \dontrun{
#' read_imu(file_path = "F:/Desktop/short_test_data.imu", imu_type = "IXSEA")
#' }
#' @keywords internal
read_imu <- function(file_path, imu_type) {
    .Call('simts_read_imu', PACKAGE = 'simts', file_path, imu_type)
}

#' @title Lagged Differences in Armadillo
#' @description Returns the ith difference of a time series of rth lag.
#' @param x A \code{vec} that is the time series
#' @param lag A \code{unsigned int} that indicates the lag
#' @param differences A \code{dif} that indicates how many differences should be taken
#' @return A \code{vector} containing the differenced time series.
#' @author James Balamuta
#' @keywords internal
#' @export
#' @examples
#' x = rnorm(10, 0, 1)
#' diff_cpp(x,1,1)
diff_cpp <- function(x, lag, differences) {
    .Call('simts_diff_cpp', PACKAGE = 'simts', x, lag, differences)
}

#' @title Time Series Convolution Filters
#' @description Applies a convolution filter to a univariate time series.
#' @param x A \code{column vector} of length T
#' @param filter A \code{column vector} of length f
#' @param sides An \code{int} that takes either 1:for using past values only or 2: filter coefficients are centered around lag 0.
#' @param circular A \code{bool} that indicates if the filter should be wrapped around the ends of the time series.
#' @return A \code{column vec} that contains the results of the filtering process.
#' @details This is a port of the cfilter function harnessed by the filter function in stats. 
#' It is about 5-7 times faster than R's base function. The benchmark was done on iMac Late 2013 using vecLib as the BLAS.
#' @author R Core Team and James Balamuta
#' @keywords internal
#' @export
#' @examples
#' x = 1:15
#' # 
#' cfilter(x, rep(1, 3), sides = 2, circular = FALSE)
#' # Using R's function
#' filter(x, rep(1, 3))
#' #
#' cfilter(x, rep(1, 3), sides = 1, circular = FALSE)
#' # Using R's function
#' filter(x, rep(1, 3), sides = 1)
#' #
#' cfilter(x, rep(1, 3), sides = 1, circular = TRUE)
#' # Using R's function
#' filter(x, rep(1, 3), sides = 1, circular = TRUE)
cfilter <- function(x, filter, sides, circular) {
    .Call('simts_cfilter', PACKAGE = 'simts', x, filter, sides, circular)
}

#' @title Time Series Recursive Filters
#' @description Applies a recursive filter to a univariate time series.
#' @usage rfilter(x, filter, init)
#' @param x A \code{column vector} of length T
#' @param filter A \code{column vector} of length f
#' @param init A \code{column vector} of length f that contains the initial values of the time series in reverse.
#' @return x A \code{column vector} with its contents reversed.
#' @details Note: The length of 'init' must be equal to the length of 'filter'.
#' This is a port of the rfilter function harnessed by the filter function in stats. 
#' It is about 6-7 times faster than R's base function. The benchmark was done on iMac Late 2013 using vecLib as the BLAS.
#' @author R Core Team and James Balamuta
#' @keywords internal
#' @export
#' @examples
#' x = 1:15
#' # 
#' rfilter(x, rep(1, 3), rep(1, 3))
#' # Using R's function
#' filter(x, rep(1, 3), method="recursive", init=rep(1, 3))
rfilter <- function(x, filter, init) {
    .Call('simts_rfilter', PACKAGE = 'simts', x, filter, init)
}

#' @title Mean of the First Difference of the Data
#' @description The mean of the first difference of the data
#' @param x A \code{vec} containing the data 
#' @return A \code{double} that contains the mean of the first difference of the data.
#' @keywords internal
#' @export
#' @examples
#' x=rnorm(10)
#' mean_diff(x)
mean_diff <- function(x) {
    .Call('simts_mean_diff', PACKAGE = 'simts', x)
}

#' @rdname diff_inv
intgr_vec <- function(x, xi, lag) {
    .Call('simts_intgr_vec', PACKAGE = 'simts', x, xi, lag)
}

#' @param xi A \code{vec} with length \eqn{lag*d} that provides initial values for the integration.
#' @rdname diff_inv
diff_inv_values <- function(x, lag, d, xi) {
    .Call('simts_diff_inv_values', PACKAGE = 'simts', x, lag, d, xi)
}

#' Discrete Intergral: Inverse Difference
#' 
#' Takes the inverse difference (e.g. goes from diff() result back to previous vector)
#' @param x   A \code{vec} containing the data
#' @param lag An \code{unsigned int} indicating the lag between observations. 
#' @param d   An \code{unsigned int} which gives the number of "differences" to invert.
#' @keywords internal
diff_inv <- function(x, lag, d) {
    .Call('simts_diff_inv', PACKAGE = 'simts', x, lag, d)
}

#' Calculates Length of Seasonal Padding
#' 
#' Computes the total phi and total theta vector length.
#' @param np  An \code{unsigned int} containing the number of non-seasonal phi parameters.
#' @param nq  An \code{unsigned int} containing the number of non-seasonal theta parameters.
#' @param nsp An \code{unsigned int} containing the number of seasonal phi parameters.
#' @param nsq An \code{unsigned int} containing the number of seasonal theta parameters.
#' @seealso \code{\link{sarma_components}}
#' @return A \code{vec} with rows:
#' \describe{
#'  \item{p}{Number of phi parameters}
#'  \item{q}{Number of theta parameters}
#' }
#' @keywords internal
#' 
#' 
sarma_calculate_spadding <- function(np, nq, nsp, nsq, ns) {
    .Call('simts_sarma_calculate_spadding', PACKAGE = 'simts', np, nq, nsp, nsq, ns)
}

#' Efficient way to merge items together
#' @keywords internal
sarma_params_construct <- function(ar, ma, sar, sma) {
    .Call('simts_sarma_params_construct', PACKAGE = 'simts', ar, ma, sar, sma)
}

#' Determine parameter expansion based upon objdesc
#' 
#' Calculates the necessary vec space needed to pad the vectors
#' for seasonal terms. 
#' @param objdesc A \code{vec} with the appropriate sarima object description
#' @return A \code{vec} with the structure:
#' \describe{
#' \item{np}{Number of Non-Seasonal AR Terms}
#' \item{nq}{Number of Non-Seasonal MA Terms}
#' \item{nsp}{Number of Seasonal AR Terms}
#' \item{nsq}{Number of Seasonal MA Terms}
#' \item{ns}{Number of Seasons (e.g. 12 is year)}
#' \item{p}{Total number of phi terms}
#' \item{q}{Total number of theta terms}
#' }
#' @keywords internal
sarma_components <- function(objdesc) {
    .Call('simts_sarma_components', PACKAGE = 'simts', objdesc)
}

#' (Internal) Expand the SARMA Parameters
#' @param params  A \code{vec} containing the theta values of the parameters.
#' @inheritParams sarma_calculate_spadding
#' @param p An \code{unsigned int} that is the total size of the phi vector. 
#' @param q An \code{unsigned int} that is the total size of the theta vector. 
#' @return A \code{field<vec>} that contains the expansion. 
#' @keywords internal
sarma_expand_unguided <- function(params, np, nq, nsp, nsq, ns, p, q) {
    .Call('simts_sarma_expand_unguided', PACKAGE = 'simts', params, np, nq, nsp, nsq, ns, p, q)
}

#' Expand Parameters for an SARMA object
#' 
#' Creates an expanded PHI and THETA vector for use in other objects. 
#' @param params  A \code{vec} containing the theta values of the parameters.
#' @param objdesc A \code{vec} containing the model term information.
#' @return A \code{field<vec>} of size two as follows:
#' \itemize{
#'   \item AR    values
#'   \item THETA values
#' }
#' @details 
#' The \code{objdesc} is assumed to have the structure of:
#' \itemize{
#' \item AR(p)
#' \item MA(q)
#' \item SAR(P)
#' \item SMA(Q)
#' \item Seasons
#' }
#' @keywords internal
sarma_expand <- function(params, objdesc) {
    .Call('simts_sarma_expand', PACKAGE = 'simts', params, objdesc)
}

#' @title Obtain the smallest polynomial root
#' @description Calculates all the roots of a polynomial and returns the root that is the smallest.
#' @param x A \code{cx_vec} that has a 1 appended before the coefficents. (e.g. c(1, x))
#' @return A \code{double} with the minimum root value.
#' @keywords internal
minroot <- function(x) {
    .Call('simts_minroot', PACKAGE = 'simts', x)
}

#' @title Count Models
#' @description Count the amount of models that exist.
#' @param desc A \code{vector<string>} that contains the model's components.
#' @return A \code{map<string, int>} containing how frequent the model component appears.
#' @keywords internal
#' @export
count_models <- function(desc) {
    .Call('simts_count_models', PACKAGE = 'simts', desc)
}

#' @title Transform AR1 to GM
#' @description 
#' Takes AR1 values and transforms them to GM
#' @param theta A \code{vec} that contains AR1 values.
#' @param freq  A \code{double} indicating the frequency of the data.
#' @return A \code{vec} containing GM values.
#' @details
#' The function takes a vector of AR1 values \eqn{\phi}{phi} and \eqn{\sigma ^2}{sigma ^2}
#' and transforms them to GM values \eqn{\beta}{beta} and \eqn{\sigma ^2_{gm}}{sigma ^2[gm]}
#' using the formulas:
#' \eqn{\beta  =  - \frac{{\ln \left( \phi  \right)}}{{\Delta t}}}{beta = -ln(phi)/delta_t}
#' \eqn{\sigma _{gm}^2 = \frac{{{\sigma ^2}}}{{1 - {\phi ^2}}} }{sigma^2[gm] = sigma^2/(1-phi^2)}
#' @keywords internal
#' @author James Balamuta
#' @backref src/ts_model_cpp.cpp
#' @backref src/ts_model_cpp.h
#' @export
#' @examples
#' ar1_to_gm(c(0.3,1,0.6,.3), 2)
ar1_to_gm <- function(theta, freq) {
    .Call('simts_ar1_to_gm', PACKAGE = 'simts', theta, freq)
}

#' @title Transform GM to AR1
#' @description Takes GM values and transforms them to AR1
#' @param theta A \code{vec} that contains AR1 values.
#' @param freq A \code{double} indicating the frequency of the data.
#' @return A \code{vec} containing GM values.
#' @keywords internal
#' @author James Balamuta
#' The function takes a vector of GM values \eqn{\beta}{beta} and \eqn{\sigma ^2_{gm}}{sigma ^2[gm]}
#' and transforms them to AR1 values \eqn{\phi}{phi} and \eqn{\sigma ^2}{sigma ^2}
#' using the formulas:
#' \eqn{\phi  = \exp \left( { - \beta \Delta t} \right)}{phi = exp(-beta * delta[t])}
#' \eqn{{\sigma ^2} = \sigma _{gm}^2\left( {1 - \exp \left( { - 2\beta \Delta t} \right)} \right)}{sigma^2 = sigma^2[gm]*(1-exp(-2*beta*delta[t]))}
#' @backref src/ts_model_cpp.cpp
#' @backref src/ts_model_cpp.h
#' @export
#' @examples
#' gm_to_ar1(c(0.3,1,0.6,.3), 2)
gm_to_ar1 <- function(theta, freq) {
    .Call('simts_gm_to_ar1', PACKAGE = 'simts', theta, freq)
}

#' @title Generate the ts model object description
#' @description Creates the ts.model's obj.desc value
#' @param desc A \code{vector<string>} that contains a list of the strings of each process.
#' @return A \code{field<vec>} that contains the object description of each process.
#' @details
#' This function currently does NOT support ARMA(P,Q) models. 
#' That is, there is no support for ARMA(P,Q), AR(P), or MA(Q).
#' There is support for ARMA11, AR1, MA1, GM, WN, DR, QN, and RW.
#' @keywords internal
#' @export
#' @backref src/ts_model_cpp.cpp
#' @backref src/ts_model_cpp.h
model_objdesc <- function(desc) {
    .Call('simts_model_objdesc', PACKAGE = 'simts', desc)
}

#' @title Generate the ts model object's theta vector
#' @description Creates the ts.model's theta vector
#' @param desc A \code{vector<string>} that contains a list of the strings of each process.
#' @return A \code{vec} with values initialized at 0 that span the space of parameters to be estimated.
#' @details
#' This function currently does NOT support ARMA(P,Q) models. 
#' That is, there is no support for ARMA(P,Q), AR(P), or MA(Q).
#' There is support for ARMA11, AR1, MA1, GM, WN, DR, QN, and RW.
#' @keywords internal
#' @export
#' @backref src/ts_model_cpp.cpp
#' @backref src/ts_model_cpp.h
model_theta <- function(desc) {
    .Call('simts_model_theta', PACKAGE = 'simts', desc)
}

#' @title Generate the ts model object's process desc
#' @description Creates the ts.model's process desc
#' @param desc A \code{vector<string>} that contains a list of the strings of each process.
#' @return A \code{vector<string>} with a list of descriptive values to label the estimate matrix with
#' @details
#' This function currently does NOT support ARMA(P,Q) models. 
#' That is, there is no support for ARMA(P,Q), AR(P), or MA(Q).
#' There is support for ARMA11, AR1, MA1, GM, WN, DR, QN, and RW.
#' @keywords internal
#' @export
#' @backref src/ts_model_cpp.cpp
#' @backref src/ts_model_cpp.h
model_process_desc <- function(desc) {
    .Call('simts_model_process_desc', PACKAGE = 'simts', desc)
}

