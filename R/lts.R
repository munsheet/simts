# Copyright (C) 2017 James Balamuta, Stephane Guerrier, Roberto Molinari, Justin Lee
#
# This file is part of simts R Methods Package
#
# The `simts` R package is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# The `simts` R package is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.


#' @title Generate Latent Time Series Object Based on Data
#' @description Create a \code{lts} object based on a supplied matrix or data frame.
#' @param data A multiple-column \code{matrix} or \code{data.frame}. It must contain at least 2 columns. The last column must equal to the sum of all previous columns.
#' @param start A \code{numeric} that provides the time of the first observation.
#' @param end A \code{numeric} that provides the time of the last observation.
#' @param freq A \code{numeric} that provides the rate of samples. Default value is 1.
#' @param unit_ts   A \code{string} that contains the unit expression of the time series. Default value is \code{NULL}.
#' @param unit_time A \code{string} that contains the unit expression of the time. Default value is \code{NULL}.
#' @param name_ts   A \code{string} that provides an identifier for the time series data. Default value is \code{NULL}.
#' @param name_time A \code{string} that provides an identifier for the time. Default value is \code{NULL}.
#' @param process A \code{vector} that contains model names of decomposed and combined processes.
#' @return A \code{lts} object
#' @author Wenchao Yang and Justin Lee
#' @export
#' @examples
#' model1 = AR1(phi = .99, sigma2 = 1) 
#' model2 = WN(sigma2 = 1)
#' col1 = gen_gts(1000, model1)
#' col2 = gen_gts(1000, model2)
#' testMat = cbind(col1, col2, col1+col2)
#' testLts = lts(testMat, unit_time = 'sec', process = c('AR1', 'WN', 'AR1+WN'))
#' plot(testLts)
lts = function(data, start = 0, end = NULL, freq = 1, unit_ts = NULL, unit_time = NULL, name_ts = NULL, name_time = NULL, process = NULL){
  # 1. requirment for 'data'
  if(!is(data,'matrix') && !is(data,'data.frame')){
    stop("'data' must be a matrix or data frame.")
  }
  
  # Force data.frame to matrix  
  if (is.data.frame(data)){ 
    data = data.matrix(data)
  }

  #check ncol
  ncolumn = ncol(data)
  if(ncolumn<2){
    stop("'data' must have at least two columns.")
  }
  
  #check ndata
  ndata = nrow(data)
  if(ndata == 0 ){stop("'data' contains 0 observation.")}
  
  #check: the last column must equal to the sum of all previous columns
  tolerance = 1E-2
  sumAllPreviousColumns = apply(data[,1:(ncolumn-1),drop = F], MARGIN = 1, sum)
  checkVec = sumAllPreviousColumns - data[,ncolumn]
  if(any(checkVec>tolerance)){
    stop(paste0('The last column of data must equal to the sum of all previous columns. The tolerance is ', tolerance,'.' ))
  }
  
  # 2. check process
  if(!is.null(process)){
    if(length(process) != ncolumn ){
      stop(paste0('data has ', ncolumn, ' processes (including the combined one). You must specify the name of each process in parameter "process".') )
    }
  }else{
    process = c(paste(rep('Process', times = ncolumn-1), 1:(ncolumn-1), sep = ''), 'Sum')
  }
  
  # 3. requirement for 'freq'
  if(!is(freq,"numeric") || length(freq) != 1){ stop("'freq' must be one numeric number.") }
  if(freq <= 0) { stop("'freq' must be larger than 0.") }
  
  # 4. requirements for 'start' and 'end'
  if( is.numeric(start)==F && is.numeric(end)==F){
    stop("'start' or 'end' must be specified.")}
  
  if(is.null(start)==F && is.null(end)==F && (end-start)!= ((ndata-1)/freq) ){
    stop("end-start == (ndata-1)/freq must be TRUE.")
  }
  
  if ( is.null(end) ){
    end = start + (ndata - 1)/freq} # freq conversion (unit conversion is handled in graphical function)
  else if ( is.null(start) ){
    start = end - (ndata - 1)/freq}
  
  # 5. requirement for 'unit_time'
  if(!is.null(unit_time)){
    if(!unit_time %in% c('ns', 'ms', 'sec', 'second', 'min', 'minute', 'hour', 'day', 'mon', 'month', 'year')){
      stop('The supported units are "ns", "ms", "sec", "min", "hour", "day", "month", "year". ')
    }
  }
  
  # 6. add column name to data
  colnames(data) = process
  
  out = structure(.Data = data, 
                  start = start, 
                  end = end, # start and end will not be null now
                  freq = freq,
                  unit_ts = unit_ts, 
                  unit_time = unit_time,
                  name_ts = name_ts,
                  name_time = name_time,
                  process = process,
                  class = c("lts","matrix"))
  
  out
}


#' @title Generate Latent Time Series Object Based on Model
#' @description Create a \code{lts} object based on a supplied time series model.
#' @param n An \code{interger} indicating the amount of observations generated in this function.
#' @param model A \code{ts.model} or \code{simts} object containing one of the allowed models.
#' @param start A \code{numeric} that provides the time of the first observation.
#' @param end A \code{numeric} that provides the time of the last observation.
#' @param freq A \code{numeric} that provides the rate of samples. Default value is 1.
#' @param unit_ts   A \code{string} that contains the unit expression of the time series. Default value is \code{NULL}.
#' @param unit_time A \code{string} that contains the unit expression of the time. Default value is \code{NULL}.
#' @param name_ts   A \code{string} that provides an identifier for the time series data. Default value is \code{NULL}.
#' @param name_time A \code{string} that provides an identifier for the time. Default value is \code{NULL}.
#' @param process A \code{vector} that contains model names of decomposed and combined processes.
#' @return A \code{lts} object with the following attributes:
#' \describe{
#'   \item{start}{The time of the first observation}
#'   \item{end}{The time of the last observation}
#'   \item{freq}{Numeric representation of frequency}
#'   \item{unit}{String representation of the unit}
#'   \item{name}{Name of the dataset}
#'   \item{process}{A \code{vector} that contains model names of decomposed and combined processes}
#' }
#' @author James Balamuta, Wenchao Yang, and Justin Lee
#' @export
#' @details
#' This function accepts either a \code{ts.model} object (e.g. AR1(phi = .3, sigma2 =1) + WN(sigma2 = 1)) or a \code{simts} object.
#' @examples
#' # AR
#' set.seed(1336)
#' model = AR1(phi = .99, sigma2 = 1) + WN(sigma2 = 1)
#' test = gen_lts(1000, model)
#' plot(test)
gen_lts = function(n, model, start = 0, end = NULL, freq = 1, unit_ts = NULL, unit_time = NULL, name_ts = NULL, name_time = NULL, process = NULL){
  
  # 1. Do we have a valid model?
  if(!(is(model, "ts.model") || is(model, "simts"))){
    stop("model must be created from a ts.model or simts object using a supported component (e.g. AR1(), ARMA(p,q), DR(), RW(), QN(), and WN(). ")
  }
  if(is(model,"simts")){
    model = model$model.hat
  }
  
  # 2. freq
  if(!is(freq,"numeric") || length(freq) != 1){ stop("'freq' must be one numeric number.") }
  if(freq <= 0) { stop("'freq' must be larger than 0.") }
  
  # 3. requirements for 'start' and 'end'
  if( is.numeric(start)==F && is.numeric(end)==F){
    stop("'start' or 'end' must be specified.")}
  
  if(is.null(start)==F && is.null(end)==F && (end - start) != ((n - 1)/freq) ){
    stop("end-start == (n - 1)/freq must be TRUE.")
  }
  
  if ( is.null(end) ){
    end = start + (n - 1)/freq # freq conversion (unit conversion is handled in graphical function)
  }else if ( is.null(start) ){
    start = end - (n - 1)/freq}
  
  # 4. 'unit_time'
  if(!is.null(unit_time)){
    if(!unit_time %in% c('ns', 'ms', 'sec', 'second', 'min', 'minute', 'hour', 'day', 'mon', 'month', 'year')){
      stop('The supported units are "ns", "ms", "sec", "min", "hour", "day", "month", "year". ')
    }
  }
  
  # Information Required by simts:
  desc = model$desc
  p = length(desc) # p decomposed processes
  obj = model$obj.desc
  
  # 5. check process
  if(!is.null(process)){
    if(length(process) != (p+1) ){
      stop(paste0('data has ', (p+1), ' processes (including the combined one). You must specify the name of each process in parameter "process".') )
    }
  }
  
  # Identifiability issues
  if(any( count_models(desc)[c("DR","QN","RW","WN")] >1)){
    stop("Two instances of either: DR, QN, RW, or WN has been detected. As a result, the model will have identifiability issues. Please submit a new model.")
  }
  
  if(!model$starting){
    theta = model$theta
    out = gen_lts_cpp(n, theta, desc, obj)
  }else{
    stop("Need to supply initial values within the ts.model object.")
  }
  
  # 6. assign column name
  if(!is.null(process)){
    colnames(out) = process
    
  }else{
    #name of each process
    comp.desc = c(desc, paste0(desc, collapse = '+'))
    comp.desc2 = orderModel(comp.desc)
    comp.desc2[length(comp.desc2)] = 'Sum'
    colnames(out) = comp.desc2
    
    process = comp.desc
  }
  
  out = structure(.Data = out, 
                  start = start, 
                  end = end, # start and end will not be null now
                  freq = freq,
                  unit_ts = unit_ts, 
                  unit_time = unit_time,
                  name_ts = name_ts,
                  name_time = name_time,
                  print = model$print,
                  process = process,
                  class = c("lts","matrix"))
  
  out

}


#' @title Plot Latent Time Series Data
#' @description Plot Latent Time Series Data generated by lts or gen_lts. 
#' @method plot lts
#' @export
#' @keywords internal
#' @param x               A \code{gts} object
#' @param xlab            A \code{string} that gives a title for the x axis.
#' @param ylab            A \code{string} that gives a title for the y axis.
#' @param main            A \code{string} that gives an overall title for the plot.
#' @param couleur         A \code{string} that gives a color for the line. 
#' @param ...             additional arguments affecting the plot produced.
#' @return A plot containing the graph of the latent time series.
#' @author Stephane Gurrier and Justin Lee
plot.lts = function(x, xlab = NULL, ylab = NULL, main = NULL, couleur = NULL, ...){
  unit_ts = attr(x, 'unit_ts')
  name_ts = attr(x, 'name_ts')
  unit_time = attr(x, 'unit_time')
  name_time = attr(x, 'name_time')
  start =  attr(x, 'start')
  end = attr(x, 'end')
  freq = attr(x, 'freq')
  print = attr(x, 'print')
  dim_x = attr(x, 'dim')
  title_x = attr(x,"dimnames")[[2]]
  dim_x = attr(x, "dim")
  n_x = length(x)

  if (dim_x[1] == 0){stop('Time series is empty!')}
  if (dim_x[2] < 3){stop('There is only one latent time series, use gts instead.')}
  
  if(!is(x,"lts")){stop('object must be a lts object. Use function gen_lts() to create it.')}
  
  # Labels
  if (!is.null(xlab)){
    name_time = xlab
  }
  
  if (!is.null(ylab)){
    name_ts = ylab
  }
  
  if (is.null(name_time)){
    name_time = "Time"
  }
  
  if (is.null(name_ts)){
    name_ts = "Observation"
  }
  
  if (!is.null(unit_time)){
    name_time = paste(name_time, " (", unit_time, ")", sep = "")
  }
  
  if (!is.null(unit_ts)){
    name_ts = paste(name_ts, " (", unit_ts, ")", sep = "")
  }
  
  if (!is.null(print)){
    title_x = c(strsplit(print," [+] ")[[1]], print)
  }

  if (is.null(main)){
    main = title_x
  }else{
    if (length(main) != dim_x[2]){
      warning('"main" is not of the same dimension as lts object, using
              default names instead.')
      main = title_x
    }
  }
  
  # Couleur
  if (is.null(couleur)){
    hues = seq(15, 375, length = dim_x[2] + 1)
    couleur = hcl(h = hues, l = 65, c = 100, alpha = 1)[seq_len(dim_x[2])]
  }else{
    if (length(couleur) == 1 || length(couleur) != dim_x[2]){
      couleur = rep(couleur[1],dim_x[2])
    }
  }
  
  # X Scales
  scales = seq(start, end, length = dim_x[1])
  if (is.null(end)){
    scales = scales/freq
    end = scales[dim_x[1]]
  }
  
  # Main plot
  par(mfrow = c(dim_x[2], 1), mar = c(0.7, 2,0,0), oma = c(4,3.2,1,1))
  #, mar = c(0.7, 2,0,0), oma = c(4,2,1,1)
  for (i in 1:dim_x[2]){
    plot(NA, xlim = c(start, end), ylim = range(x[,i]), xlab = xlab,
         xaxt = 'n', yaxt = 'n', bty = "n", ann = FALSE)
    
    make_frame(start, end, main, xlab, inloop = TRUE, i = i)
    
    if (i == dim_x[2]){
      axis(1, padj = 0.3)
    } 
    
    # Add lines 
    lines(scales, x[,i], type = "l", col = couleur[i], pch = 16)
  }
  
  mtext(name_time, side = 1, outer = TRUE, line = 2)
  mtext(name_ts, side = 2, outer = TRUE, line = 2)
}