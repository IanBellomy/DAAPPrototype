#DAAPPrototype

An old Actionscript library that makes basic interactions easy. 
Created for DAAP Summer Camp workshops on interactivity. The goal was to get high-schoolers from zero programming knowledge to making interactive things in a couple of hours.

DAAPPrototype allows things like this: 

````actionscript
clip.click = clip.rotate(90); // rotate the clip to 90 degrees on click
clip.click = [clip.rotate(90),clip.fade(.5)]; // rotate the clip to 90 degrees and fade to .5 on click
clip.click = function(){ trace('ok'); } // totally ok
````

DAAPPrototype makes use of the excellent [Greensock](http://greensock.com) tween engine and the experimental [Manipulus](https://github.com/IanBellomy/Manipulus) library. 

	
##Getting Started

Set the *Class* of the working file to: 

	edu.daap.Prototype
	
Make sure any symbols you'd like to use are set to export for actionscript.

##Put a shape (or shapes) on the screen:

````actionscript
make(Box,5);
make(Triangle,50);
make(Line,500);
````
	
Description:

````actionscript
make(SYMBOL_NAME, QUANTITY);
````

SYMBOL_NAME can be any symbol in the library set to “export for Actionscript”.
The example files have the following options for Symbol Box:

	Triangle
	Circle
	Arc
	Line
	
##Modify shapes on screen:

````actionscript
each(Box).x = 100;
each(Box).rotation = 180;
each(Box).alpha = .5;
````

Description:

````actionscript
each(SYMBOL_NAME).PROPERTY
````

Note: This works even if there is only one thing. Some options for PROPERTY include:

	x,
	y,
	width,
	height,
	rotation,
	alpha,
	scaleX,
	scaleY,
	scale
	
Note: rotation is in degrees.
Note: The values for alpha, scaleX, and scaleY, and scaleY are 0 to 1, where 1 is 100%, .5 is 50%, and so forth.

each(SYMBOL_NAME) returns a collection of items of the kind SYMBOL_NAME. It is effectively a query function.

##Create and use random number
Example:

	each(Line).rotation = random(0,360);

The above code sets the rotation of each Line to a random number between 0 and 360.
Example:

	each(Box).rotation = random(0,360,45);

The above code sets the rotation of each Box to a random number between 0 and 360.
That number is also a multiple of 45°.



Description:

	random(LOW,HIGH);
 
 Or
 
	random(LOW,HIGH, MULTIPLE);
	
Note: If the multiple input is included, the result will be a multiple of that number. If not, the result will be any decimal number between minimum and maximum.
 
##Create a basic response to user input
Example:

	click = grow(.5);
	
When the user clicks, the workspace will shrink to 50%.

	click = spin(45,2);
	
When the user clicks, the workspace will rotate to 45° over the course of two seconds.
The previous ‘grow’ response is overwritten and will not be triggered.

	click = slide(-100,2);
	
When the user clicks, the workspace will move sideways so that it is -100px off screen.
The previous ‘spin’ response is overwritten and will not be triggered.
Description:

	INPUT_TYPE = ANIMATION() Or
	INPUT_TYPE = ANIMATION(VALUE) Or
	INPUT_TYPE = ANIMATION(VALUE, LENGTH) Or
	INPUT_TYPE = ANIMATION(VALUE, LENGTH, DELAY) 

Options for INPUT_TYPE:

	click
	rollOver
	rollOut
             
Options for ANIMATION
             
	spin()
	slide()
	lift()
	grow()
	fade()
	blur()
             
##Create multiple responses to one input
Example:
	
	click = [grow(.5), spin(45,2), slide(-100,2)];
	
When the user clicks, the workspace will shrink to 50%, rotate to 45° over the course of two seconds, and move sideways so that it is -100px off screen.

##Create a response for all shapes
Example:

	click = each(Box).spin(360,2);
	
When the user clicks, all boxes will rotate to 360° over the course of two seconds.

Description:

	INPUT_TYPE = each(SYMBOL_NAME).ANIMATION(VALUE, DURATION, DELAY) 
	
Options for the different parts of this structure are the same as in previous sections.

##Create a response using random values
Example:

	click = each(Box).spin(random(0,360,45));
	
When the user clicks, all boxes will rotate, over time, to a value between 0° and 360°. The
final value will be a multiple of 45.

##Create a one shape response to input on that shape
Example:

	each(Box).click = Item.spin(random(0,360,45));

When the user clicks a Box, that specific Box will rotate, over time, to a value between 0° and 360°. The final value will be a multiple of 45. *Item* is a keyword that refers to the object from where the event came (or will come from). The code can be read like this "for each Box, when clicked, that Item will spin to a random increment of 45°"

