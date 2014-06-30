FlickWhiz
==================

by Scott Kildall
May 20 2014

**File Paths**
If you don't have this already, create these empty directories at the root level:

data/error
data/input
data/output
data/processed

**Memory**
First, you'll need to bump up your preferences in Processing to be 2048MB of memory. Refer to the image: **memory_prefs.jpg**

**Source Directories**
Input files: these all go into the "data/input/" Acceptable formats are: .gif, .jpg, .tga, .png

**Running it**
Run it in the Processing environment, version 2.0 or later. It should work as a compiled application but the error-messaging will be better in the development environment.

The on-screen instructions should be pretty straightforward. When you launch the program, it searches for the input files.

Hitting space bar will run through each file, in alphabetic order and:
(1) Load it into memory. If it isn't an image file, it will go to the next file and register this as an error

(2) Resize it to 1280X720 (max dimension, e.g. image could be 640x300 or 500x480, etc)

(3) Draw it on a black background

(4) Display it on the screen

(5) Save it as an numbererd JPG file in the outputs directory

**Changing the number of frames**
The global declaration:
	int maxNumFiles = 18000

will dictate the maximum number of frames that we will send out. At 30 fps, 18000 images is 10 minutes.

**Destination Directories**
These get tagged with a simple timestamp, e.g. 412031921, so you can re-run the script with multiple input directories

Results will be something like (example is using the 412031921 timestamp)

- Sequenced outputs: created in to "data/output/412031921"
- Successfully processed originals: moved to "data/processed/412031921"
- Error originals: moved to "data/error/412031921"

Error files are non-image files, inlcuding hidden desktop files.

**Compiling the movie**
Use Adobe Premiere to import files and select the first one. Chose Import as Sequence. The target output for tranmission is 640x480, Quicktime, H264, 30fps.

