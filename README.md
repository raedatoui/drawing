##coding challenge


The main source for the challenge app is located in the app directory

The unit tests are located in test /specs/controllers directory


###In case you haven't noticed, this app does a few extra things

* user input validation: ensure parameters are integers, color is hex, and commands are correct
* can't execute an L, R or B comand until a C is executed first
* check if coordinates don't exceed canvas dimensions
* added actual coloring to the filling cells and some animation to see the algorithm in action
* allow clearing the board by execute a new C command and creating a new canvas
* the app can take an array of commands and auto execute the program. use the button to see that in action
* tests are located in the test directory. Launch test/index.html in your browser. The unit tests are based on
Jasmine. The test suite is only concerned with the renderer and verifies the state of the canvas. the same commands are used in the specs. Please checkout the source on github to make sense of the unit tests and and how the behavior is verified

###Tech

* app is written in coffeescript using Spine.js
* project is scaffolded using spine.app and hem server
