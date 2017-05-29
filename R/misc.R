# Copyright (C) 2014 - 2016  James Balamuta, Stephane Guerrier, Roberto Molinari
#
# This file is part of GMWM R Methods Package
#
# The `gmwm` R package is free software: you can redistribute it and/or modify it
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# The `gmwm` R package is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

#' @title Place Legend
#' @description This function decides where the legend should be put (top left or bottom left)
#' @param wv_1 A \code{double} that indicates the first value of \code{wv.empir}
#' @param low_n A \code{doble} that indicates the last value of \code{ci.low}
#' @param high_n A \code{dobule} that indicates the last value of \code{ci.high}
#' @return A numeric vector containing 4 elements. The first two elements indicate legend.justification, the last two elements indicate legend.position (see \code{?theme}).
#' @keywords internal
placeLegend = function(wv_1, low_n, high_n){
  if(log10(wv_1) > ( log10(low_n) + log10(high_n) )/2 ){
    # legend should be placed in bottom left
    legend.justification = c(0,0)
    legend.position = c(0,0)
    #x = wv_1[1]/xlim_length
    #y = high_n/ylim_length
  }
  else{
    # legend should be placed in top left
    legend.justification = c(0,1)
    legend.position = c(0,1)
    #x = wv_1[1]/xlim_length
    #y = low_n/ylim_length
  }
  return( c(legend.justification, legend.position) )
  
}

#' @title Frequent Graph Setting for Paper
#' @description This function sets some parameters such as plot.margin.
#' @return A ggplot2 panel containing the frequent graph setting for paper.
#' @keywords internal
paperSetting = function(){
  
  p = theme(axis.title.y=element_text(margin=margin(0,22.5,0,0)), 
            axis.title.x=element_text(margin=margin(22.5,0,0,0)), 
            plot.title = element_text(margin=margin(0,0,20,0)), 
            plot.margin=unit(c(0.7,0.1,0.7,0.7),"cm"))
  
  return(p)
}

#' @title Emulate ggplot2 default color palette
#' @description Autogenerate a colors according to the ggplot selection mechanism. 
#' @param n An \code{integer} indicating how many colors user wants.
#' @return A \code{vector} containing \code{n} colors
#' @author John Colby
#' @keywords internal
ggColor <- function(n) {
  hues = seq(15, 375, length=n+1)
  rev(hcl(h=hues, l=70, c=100)[1:n])
}


#' @title Order the Model
#' @description Orders the model and changes it to the correct format
#' @param models A vector of \code{string} that specifies the models
#' @details If the \code{models} are c("AR1", "WN", "AR1", "WN", "AR1+WN+AR1+WN"), it will be converted to 
#' c("AR1-1", "WN-1", "AR1-2", "WN-2", "AR1+WN+AR1+WN").
#' 
#' This function is used in \code{gen.lts()}
#' @keywords internal
#' @examples 
#' models = c("AR1", "WN", "AR1", "WN", "AR1+WN+AR1+WN")
#' new.models = orderModel(models)
#' new.models
#' 
#' models = c('AR1', 'QN', 'WN', 'AR1+QN+WN')
#' new.models = orderModel(models)
#' new.models
orderModel = function(models){
  count = table(models)
  if( any(count>1)){
    multi.models = names( count[count>1] )
    
    for(model in multi.models){
      num = count[model]
      models[models == model] = paste( rep(model, num), rep('-', num), 1:num, sep = '' )
    }
    
    return(models)
  }else{
    return(models)
  }
}


#' @title Add Space to Avoid Duplicate Elements
#' @description Add space to every element if there are duplicates in the vector.
#' @param x A \code{character vector}
#' @keywords internal
#' @examples 
#' ##no duplicate
#' x1 = c('GMWM2', 'GMWM1', 'GMWM3')
#' addSpaceIfDuplicate(x1)
#' 
#' ##duplicate
#' x2 = c('GMWM3', 'GMWM4', 'GMWM3', 'GMWM4', 'GMWM5', 'GMWM6','GMWM3')
#' addSpaceIfDuplicate(x2)
addSpaceIfDuplicate = function(x){
  res = x
  count.table = table(x)
  
  if ( any( count.table > 1)  ){
    
    dup.item = count.table[ count.table>1 ]
    
    for(each in names(dup.item) ){
      index = which(x == each)
      
      for(i in 2:length(index)){
        res[ index[i]  ] = paste0(x[ index[i] ], paste0(rep(' ',times = (i-1) ), collapse = ''))
      }
     
    }
    
  }
  return(res)
}


#' @title Get N Colors
#' @description Creates n colors from specific palette
#' @param palette A \code{string} that indicates the name of the palette.
#' @param n An \code{integer} that specifies the number of colors to be generated.
#' @param rm An \code{integer vector} that specifies the index of colors to be removed.
#' @keywords internal
#' @details 
#' Currently, only the palette 'Set1' is implemented in this function.
#' 
#' 'Set1' palette in the package \code{RColorBrewer} originally has 9 colors, but we delete the 
#' yellow color (the 6th one) since it is too much vibrant. 
#' 
#' If \code{n} is larger than the mamixum number of colors in the palette, the function
#' will repeat the palette until \code{n} colors is created.
#' 
#' @examples 
#' getColors('Set1', 10)
getColors = function(palette, n, rm = NULL){
  
  if(palette == 'Set1'){
    color = c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3", "#FF7F00", "#A65628" ,"#F781BF", "#999999")
  }
  
  if(!is.null(rm)){
    color = color[-rm]
  }
  
  modulus = n %/% length(color)
  remainder = n %% length(color)
  result = c( rep(color, times = modulus), color[1:remainder] )
  return(result)
}

#' @title Check the Parameters
#' @description Check the user supplied parameters and assign them to the default if they are wrong.
#' @param params A \code{character vector} that specifies the user supplied parameters.
#' @param require.len An \code{integer vector} that specifies the required length of each parameter.
#' @param default A \code{list} that specifies the default of each parameter.
#' @param null.is.fine A \code{boolean vector} to indicate whether \code{NULL} is fine for parameters.
#' @param env An \code{environment} to use.
#' @keywords internal
#' @details 
#' 
#' The user supplied parameters are usually \code{line.color}, \code{line.type}, \code{point.size}, 
#' \code{point.shape}, \code{CI.color} and \code{legend.label}.
#' 
#' This function will check whether the required length of the parameter is met. If not, it will assign the 
#' default value to that parameter.
#' 
checkParams = function(params, require.len, default, null.is.fine, env = parent.frame()){
  
  for (i in 1:length(params)){
    
    one_param = params[i]
    value = get(one_param, envir = env)
    
    if( length(value)!=require.len[i]){
      
      isNull = is.null(value)
      
      if( (!isNull) || (!null.is.fine[i]) ){
        
        warning(paste('Parameter', one_param, 'requires', require.len[i],'elements,','but', length(value),
                      'is supplied.','Default setting is used.'))
      }
      
      assign(one_param, default[[i]], envir = env)
    }
  }
  
}


#' @title Add Units to Sensor
#' @description Add corresponding units for gyroscope and accelerometer sensors.
#' @param units \code{NULL} or a two-element vector indicating the units of gyroscope and accelerometer sensors.
#' @param sensor A \code{character vector} including all sensors in imu objects.
#' @keywords internal
#' @details 
#' This function is used in \code{plot.wvar.imu} and \code{plot.auto.imu}.
addUnits = function(units, sensor){
  #add units to sensors
  if(!is.null(units)){
    
    sensor[sensor == "Gyroscope"] = as.character(as.expression( bquote('Gyroscope ' * .(units[[1]])) ))
    sensor[sensor == "Accelerometer"] = as.character(as.expression( bquote("Accelerometer " * .(units[[2]])) ))
  }
  return(sensor)
}

#' @title Autofill A Vector
#' @description Autofill a vector to a target length with the specified element
#' @return A new \code{vector}
#' @param v A \code{vector}
#' @param len An \code{integer} indicating the target length
#' @param fillwith The specified element used to fill the empty cells
#' @keywords internal
#' @details 
#' If the length of \code{v} is less than \code{len}, the function will introduce 
#' \code{fillwith} for empty cells.
#' 
#' Nothing will be done if the length of \code{v} is equal to or larger than \code{len}.
#' 
autofill = function(v, len, fillwith = NA){
  v.len = length(v)
  
  if(v.len < len){
    v = c(v, rep(fillwith, len-v.len))
  }
  return(v)
}