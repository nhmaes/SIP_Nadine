# Sound Image Processing - BSc Creative Computing Year 1
# Week 2
# Task Part 1 :
## Instructions
Open the histogram sketch. It's a script which converts a photo into black and white, and shows a histogram of brightness.
Working in pairs - as a Driver and Navigator - try to adapt the code so that it shows the image in its original colour, and then show three histograms: one for each of the R, G, B channels.
Try it with a different image of your choice.
Advanced: Make a copy of the sketch, swap colour channels, and display histograms for those.

### My reflection :
This task was a bit tricky because I had to identitify the math in the inititial histogram code that makes the image grey.
It makes the red green and blue channels all the same.
Once I fixed it, by loading the image pixels in its initial form and removing the code that makes the rgb channels all equal, i used for loops to initialise strokes of each channel based each pixel within that channel's value (from 0 to 256 so on a scale of 255) and then scaling it to the window.