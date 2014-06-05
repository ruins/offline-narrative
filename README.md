Offline Narrative
=================

Background
----------
The [Narrative Clip] is a wearable lifelogging camera that snaps photos regularly through out the day. Unfortunately, while the hardware is pretty good, there are major limitations imposed by the softare, Namely:
* Requires internet connection to upload images to a cloud service for further image processing
* No outward facing API as of June 2014
* No way to browse and edit photos apart from mobile apps with limited functionality. Very difficult to remove and modify old photos.
* Little to no image processing and sensor processing to improve photo quality, select the "good" photos or reject the "bad" photos
* 

What this code does
-------------------
**Offline Narrative** is intended to address these short comings by:
* Performing image and sensor processing **offline**
* **Remove "bad" images**, such as those that are too dark or blurry
* **Find "good" images**, such as those that are not blurry or has interesting things in them
* Performing **new functions** not currently available from the official app. More soon!
* **Visualising sensor data**, such as battery levels and light meter readings

The code
--------
The plan is to start with MATLAB, which allows for rapid prototyping and data visualisation. This will (hopefully) be followed with using OpenCV and C++ (or python) to produce cross-platform code that can be used freely. 

Notes about the Narrative Clip
-----
1. Accelerometer axes
   * x goes 'up' (out of the battery indicator)
   * y goes right (opposite direction to usb port)
   * z goes out from camera
   * Magnitude of the acceleration according to sqrt(x^2+y^2+z^2) is around 1150 for me on average, which is basically just g (9.81 etc)
   * It seems that blurry images can (mostly) be removed by just looking for large accelerations. More testing and coding to come before I am convinced though.

2. The light sensor values are pretty much useless on their own other than filtering out very, very dark photos (from your pocket). The two avg parameters seem to be more useful in rejecting dark images.


3. Filenames seem to be UTC HHMMSS and seems fairly accurate

4. One can operate in "offline" mode by adding a firewall rule to Win 8.1 to stop Narrative from using the web. Seems to work so far in stopping the upload but still allowing the Narrative Clip to cache to a HDD folder. 

TODO
----
* Auto-rotation - Maybe using homography or similar given that we have a reliable (sort of) 3D vector?
* Object detection and recognition. Ditto for places.
* Still can't get GPS values. May be it is hidden in the .snap files? The files seems very "random" and might be encrypted -_-


[Narrative Clip]:http://getnarrative.com/
