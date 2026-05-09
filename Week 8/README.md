# Week 8: Algorithmic music and sampling
## Directory contents

* [code examples](./examples)

## Week 8 Task

Using at least 4 samples, create a drum pattern. Make the pattern change in time. You could do that by:
    - adding an element of randomness to at least one of the samples,
    - alternate the pattern depending on time, e.g. count bars based on frameCount, seconds or milliseconds

How to start (optional prompts):

- Pick some samples from the resources below (or find or record your own), and modify the example from class using them.
- Pick a drum pattern or a beat from a song from the examples below (or your own example), and try to replicate it. If you're a beginner, replicating one of these would be a good start: Essential drum patterns (for hip hop).
- Design your own beat using clapping, visuals, or however you like, and try to replicate it.


(Optional). Can you add an audio-reactive visualisation? For this, you may want to increase the frameRate to achieve a smooth animation. For example, if you want the music to play at 120 bpm, which is 2 times per second, set the frameRate to 60 and play the base sound every 30th frame (frameCount % 30 == 0).
(Advanced). Can you combine sound synthesised with an oscillator (task from last week) with looped samples in a single piece of music?

** Have a look at the additional resources on Moodle **
(articles, free sample sources, technical documentation)

## RESEARCH AND PROCESS
For the first task I had to create a drum sequence. To start off I researched a bit of music theory concerning beat sequences so I can get a good idea. This is so I can know how to create  something auditively consumable and coherent.

[Music Theory for Beatmaking](https://www.loopcloud.com/cloud/blog/5290-Music-Theory-for-Beatmaking)

Thanks to this article but also my previous knowledge in music ( I took piano for one year when I was 5 so I am basically Mozart ), I understood that music is like math : Beats need to repeat consistently, and the beats within each rythm need to be consistent as well. This is when I created my first  modulo loop example.
After that 
I felt inspired in garage band to extract the beat from the song I used into replicating it. I used the pluck glass effect and transofrmed it to sound like drum symbals and extracted the beat from the song into one singluar beat or something. From there I assembled them both using code and together, they sound like a trashy messy uncoordinated band.