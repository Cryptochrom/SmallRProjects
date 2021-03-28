<h1> Clockwork script </h1>

This is a short script defining several functions to track how long you are working.
go() saves the starting time
  I was working with global variables, as I actually dont know how to track this in a more sophisticated way.

pause() will basically save a second timestamp and calculate how you worked.

If you want to resume your work, you can just execute go() and a second measurement will be started.

status() will quickly print your measurements.

reset() will reset all your data.

export() will export your measurements as csv file.
