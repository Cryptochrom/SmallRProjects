setwd("C:/Users/Cryptochrom/Documents/R_projects/Clockwork")

rm(list=ls(all=T))

go <- function(){
  starttime <<- Sys.time()
  stats <<- 'Running'
  if (exists('start_counter') == FALSE){
    start_counter <<- 1
  } else {start_counter <<- start_counter + 1}
  if (exists('Time_log') == FALSE) {
    Time_log <<- data.frame(Start = as.character(), End = as.character(),
                            Time_worked_sec = double(), Time_worked_min = double(),
                            Time_total_min = double(), Time_total_h = double(), stringsAsFactors = FALSE)
  }
}

pause <- function(){
  stoptime <<- Sys.time()
  stats <<- 'Idle'
  worked <<- as.numeric(difftime(stoptime, starttime, units = 'secs'))
  if (exists('stop_counter') == FALSE){
    stop_counter <<- 1
  } else {stop_counter <<- stop_counter + 1}
  eval()
}

eval <- function(){
    if (exists('accumulated') == FALSE){
    accumulated <<- worked
    save_start <<- start_counter
    save_stop <<- stop_counter
    print(paste('You worked for a total of', round(accumulated/60, 2), ' minutes. IF1'))
  } else if ((save_start == start_counter) | (save_stop == stop_counter)) {
    print(paste('You did not restart. Earlier your worked a total of ', round(accumulated/60, 2), ' minutes.'))
    stop()
  } else {
    accumulated <<- accumulated + worked
    save_start <<- start_counter
    save_stop <<- stop_counter
    print(paste('You worked for a total of', round(accumulated/60, 2), ' minutes. IF2'))
  }
  Time_log[nrow(Time_log)+1,] <<- c(as.character(starttime), as.character(stoptime),
                                   as.numeric(worked), as.numeric(worked/60),
                                   as.numeric(accumulated/60), as.numeric(accumulated/3600))
  print('Data log complete!')
}

status <- function(){
  print(stats)
}

reset <- function(){
  if (exists('accumulated')){
    rm(accumulated, envir = globalenv())
  } else {print('There is nothing to reset!')}
}

export <- function(){
  write.csv(Time_log, file = paste("C:/Users/Cryptochrom/Documents/R_projects/Clockwork/", format(Sys.time(),"%Y-%m-%d-%H-%M-%S"), 'CRY_Clockwork.csv'))
}

################################################################################


go()

status()

pause()



#reset()

export()
