# Week 9: Vectors and movement
## Directory contents

* [code examples](./examples)

## Week 9 Task

Feel free to work in pairs (please add a comment about it in your sketch if you do).

**Make a game using all of the below:**
- at least 1 class
- at least 2 forces influencing the object movement
- at least 1 type of interaction.

Feel free to use the prompts below or use your own idea. You can also start with a sketch you developed earlier in the term - make sure to save it as a new sketch, as these are separate tasks to submit!

**Think about:**

- the theme of the game
- what types of objects / game characters you might need
- the goal of the game
- the score (if there is one)
- how does the game end?
- what are the interactions?

**Optional prompts:**

- You're a player running away from a giant space worm.
- You're a zombie and you need to collect brains to survive.
- You're a unicorn jumping from one rainbow to another.
- You collect flowers of different kinds to complete a predefined bouquet.

**Links to resources & technical references on Moodle :)**

# My process and relfection
We learned the fundamentals when it comes to prgramming in Processing. Up untill week 8 it corned mainly interactive visuals, now we are learnign the more intricate maths behind what makes these graphics interactive. I referred myself  to online tutorials to help me. This is when I followed a tutorial from Toptal.

[Read the article I used for reference here](https://www.toptal.com/developers/game/ultimate-guide-to-processing-simple-game)

Following the tutorial I started by understanding how different screen displays work. From that , I created a variable that would change based on the stiuatuation the user would be in . the gameScreen variable acts as an indicator to tell the computer what stiuaton the user is in, if they started the game, if they are playin, if htey lost so they know what to show the user.
After that I had to create the ball and implement gravity. 
The surface variable woldnt work when initialised as a float so i initialised it as an integer instead. The surface is used to define where the ball will land so the computer knows when to make it bounce. This is also when I referred to the code given in the examples folder on Marysias Github where the colorful balls bounce on the screen. 
The result of this is an animation where the ball bounces infinetly.

After that I went onto the next step to control how the ball bounces to make it more realistic. This means the game needs friction fom the air and friction from the ball. Now I am presented with an outcome where the ball bounces like a real ball affected by gravity and air friction : it slows down and bounces less.

I then created a controllable racket for it to bounce on.

When playing the game it is really satisfying and the concept of it reminds me o a simple warm up game I used ot play in tennis where the player bounces the ball repeaatedly on their racket.
The only thing I had to add after is physics to the X parameters of the ball so I can actually control the direction of the ball with my racket.

I skipped a few of the steps to make the game feel more like mine. From there I wanted to make the game go off of the tennis warm up concept as a game. SO i iddnt want any exterior elements interacting with the ball and racket as the whole point of the game is that its a solo exercise. 

Since I am very happy with the prototype so far. I want to finalise it by giving it an actual ending. By wrapping uo my code I need to find a way to end it so like that it the game itselfs becomes an operable but interactie loop. 
In doing so I added classic video game elemtns that make the game feel competitive but make you want to play it more : a health bar. 
So like that when miss your hit the health bar goes down and you lose, showing the game over screen.

I ended uo making the game quirte difficult which underlines the real frustration in tennis.