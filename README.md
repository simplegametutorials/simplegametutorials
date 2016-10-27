# If you're looking for the actual tutorials, go to [http://simplegametutorials.github.io](http://simplegametutorials.github.io)

## This is the code for generating tutorials and it is currently a mess

Each tutorial has a folder within the main folder.

Run `love <path of main folder> html <name of tutorial folder>` to generate the HTML using **input.txt** in the tutorial folder.

Run `love <path of main folder> images <name of tutorial folder>` to open the thing for making images using **images.lua** in the tutorial folder.

### Making HTML

The output HTML will be at the location `<LOVE save directory>/tutorials/<name of tutorial folder>/index.html`.

The markup for **input.txt** is:

* Lines starting with #, ##, ###, #### become h1, h2, h3, h4
* \*Asterisks for bold\*
* & Amperands for a two column table & This is the second column
* Code is within lines of \` and uses | to surround highlighted code. For example:
```
`
function test() {
    |a = 'This line will be highlighted.'|
end
`
```
* Console output within lines of ~. For example:
```
~
This is console output.
~
```
* The exclamation point (!) creates a place for an image.
* Lines in a list begin with "- ".
* For everything else normal HTML should work, \<i\>like for italics\</i\>.

### Making images

**images.lua** returns a table of functions which draw stuff. Each function in the table corresonds to each exclamation point in **input.txt**. For example the function at table index 2 will be placed at the position of the second exclamation point. The !s and the functions need to be "lined up".

The up and down arrows move through the previews of the functions. The space bar outputs the currently displayed images to a file to be used by the HTML, and the **a** key loops through all of the functions and outputs them to files.

Any blank space around whatever is drawn is cropped away.

Because the drawing functions are called repeatedly, this window can remain open while **input.lua** is edited.

There is a maximum limit to how big the image can be, this can be changed by the MAX_WIDTH and MAX_HEIGHT variables at the top of **main.lua**. You can also change the background color (which doesn't affect the outputted images) by changing the BACKGROUND variable near the top of **main.lua**.
