# Gerrit Tracker

**Gerrit Tracker** is a tool used to track the changes that are raised in the
gerrit. This tool keeps track of all the open mainline changes. It gives the
user the status of each stage of the change. A mainline changes has to go to
developer-verified +1, Lookahead, Klocwork, Windevpool, Code-Review+2 and
preflight. For some projects Klocwork and Windevpool are not applicable (NA).
The status might include Pending, Running, Passed, Failed or NA. At the top
it shows the number changes that are in running state in each stage. It also
shows the change number or ID, Project and Subsystem. At the right corner it
also takes topic as input, gerrit queries all the open mainline changes with
the input topic and shows the result.

## Installation

* Copy the gerrit_tracker to the DocumentRoot directory
* Set up a jenkins job that runs gerrit_tracker/gerrit_tracker.py every
  five minutes.
* gerrit_tracker/gerrit_tracker_poll.py should run continously to process
  the topic as input given. NOTE: create a directory "topic" with 777
  permission recursively.

## Files and Directory needed

## File needed

* gerrit_tracker_api.py
  The base file to get changes status in each stage and generate
  the output html file


* gerrit_tracker.py
  Used to create the general output html file gerrit_tracker.html
  Writes the gerrit query output to gerrit_details.json


* gerrit_tracker_poll.py
  Used to poll for new requests. If new request are found, a tmp*.txt
  file is generated. Based on the request gerrit query is done.
  Output of gerrit query is saved tmp*.json. Then the status is evaluated
  and the output is written to tmp*.html


* cleanup.sh
  Removes all the tmp*.txt, tmp*.json, tmp*.html file from the request
  receives directory "topic"


* response.php
  If a new request is made, creates a tmp*.txt file in request receiving
  directory "topic", with the request content in it.


* subsystem.txt
  A local data file where the projects are mapped to their corresponding
  subsystems


## Directory needed

* topic
  To receive the request. This directory must be 777 permissions.


## Authors

* Hephzibah Pon Cellat Arul Prakash

## Contributors

* Kartika Kalyan
  For initiating and guiding.

## License
