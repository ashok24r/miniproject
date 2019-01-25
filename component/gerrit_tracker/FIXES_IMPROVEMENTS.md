# FIXES

## FIX 1

### Problem Statement

* No comments in the change

### Solution

* Catch the key error, make the comments to "Not Found"
* Change all the stages to "Pending"

## FIX 2

### Problem Statement

* Some comments in the change doesnot has reviewer username, when the
  value is tried to be accessed to get the status of each stage, KeyError
  is thrown and breaks the code

### Solution

* Catch KeyError

# IMPROVEMENTS

## IMPROVEMENT 1

### Problem Statement

* Display Subsystem as a part of output html page

### Solution

* Subsystem is not found in any database as of now.
* Thus maintain a local file where this data is stored.
* In this implementation we used gerrit_tracker/subsystem.txt file.
* WIN Integration are the POC's to get to know about Subsystem.
* In subsystem.txt, for subsystems, projects are mapped.
* Thus get_subsystem_from_project takes project of the corresponding
  project as input.
* If the subsystem for the project is found it is returned.
* Else "Not Found" is returned.

## IMPROVEMENT 2

### Problem Statement

* Get Topic as input and display all the related changes status

### Solution

* Poll for any new requests locally.
* When a request is made, ie., when a input topic is given, Create a
  tmp .txt file in gerrit_tracker/topic directory.
* This .txt file is polled, if a new request file is found, Then query
  the gerrit and display the output
* Poll happens every 5 seconds.
* The fashion the request is processed is linear.
* Why not a direct script execution from the web? Gerrit Tracker does a
  gerrit query to get the changes status. From web when gerrit query is
  done, it is done by a daemon which will not have permissions to do a
  gerrit query.
