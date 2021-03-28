rm(list=ls(all=T))

stats <- 'Idle'

go <- function(){
  if (stats == 'Running') {print("Sorry, logging is already running.")
    what <<- 'error'
    loopfun()} else {
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
    print(paste('You worked for a total of', round(accumulated/60, 2), ' minutes.'))
  } else if ((save_start == start_counter) | (save_stop == stop_counter)) {
    print(paste('You did not restart. Earlier your worked a total of ', round(accumulated/60, 2), ' minutes.'))
    loopfun()
  } else {
    accumulated <<- accumulated + worked
    save_start <<- start_counter
    save_stop <<- stop_counter
    print(paste('You worked for a total of', round(accumulated/60, 2), ' minutes.'))
  }
  Time_log[nrow(Time_log)+1,] <<- c(as.character(starttime), as.character(stoptime),
                                   round(as.numeric(worked), 2), round(as.numeric(worked/60), 2),
                                   round(as.numeric(accumulated/60), 2), round(as.numeric(accumulated/3600), 2))
  print('Data log complete!')
}

status <- function(){
  print(stats)
}

reset <- function(){
  if (exists('accumulated')){
    rm(accumulated, envir = globalenv())
    Time_log <<- data.frame(Start = as.character(), End = as.character(),
                            Time_worked_sec = double(), Time_worked_min = double(),
                            Time_total_min = double(), Time_total_h = double(), stringsAsFactors = FALSE) 
  } else {print('There is nothing to reset!')}
}

export <- function(){
  write.csv(Time_log, file = paste(format(Sys.time(),"%Y-%m-%d-%H-%M-%S"),user,'_Clockwork.csv'))
}

loopfun <- function(){
  repeat {
    if (what == "quit"){
      print("Goodbye!")
      quit()
    } else if (what == "go") {
      print("Let's start!")
      go()
      print("...")
      what <- readline(prompt="What do you want to do? (go/ status/ pause/ reset/ export or quit): ")
    } else if (what == "status") {
      status()
      print("...")
      what <- readline(prompt="What do you want to do? (go/ status/ pause/ reset/ export or quit): ")
    } else if (what == "pause") {
      print("Let's take a break!")
      what <- "pause"
      pause()
      print("...")
      what <- readline(prompt="What do you want to do? (go/ status/ pause/ reset/ export or quit): ")
    } else if (what == "reset") {
      sure <- readline(prompt="Resetting everything, are you sure? (y/n): ")
      if (sure == "y") {
        reset()
        print("...")
        what <- readline(prompt="What do you want to do? (go/ status/ pause/ reset/ export or quit): ")}
      else {
        print("Not resetting ...")
        what <- readline(prompt="What do you want to do? (go/ status/ pause/ reset/ export or quit): ")
      }
    } else if (what == "export") {
      export()
      print("Exporting data ...")
      what <- readline(prompt="What do you want to do? (go/ status/ pause/ reset/ export or quit): ")
    } else if (what =='error') {
      print("It seems there was a malfunction. Let's try this again.")
      what <- readline(prompt="What do you want to do? (go/ status/ pause/ reset/ export or quit): ")
    } else { 
      print("Sorry, i did not get that. Please try again!")
      what <- readline(prompt="What do you want to do? (go/ status/ pause/ reset/ export or quit): ")}
  }
}

print("Welcome to the clockwork script. With this simple script you can log the times when you are working and then export the data into a file")

user <- readline(prompt="Please enter your initials: ")
what <- readline(prompt="What do you want to do? (go/ status/ pause/ reset/ export or quit): ")

loopfun()

