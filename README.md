#DAAPPrototype

An old Actionscript library that makes basic interactions easy. 
Created for DAAPCamp workshops on interactivity in order to get highschoolers without programming knowledge up to making interactive things in a couple hours.

Less syntax, less mistakes, less frustration.
	
Set the Class of the working file to: edu.daap.Prototype
	
This class modifies the MovieClip prototype to allow things like this: 

	clip.click = clip.rotate(90);					// rotate the clip to 90 degrees on click
	clip.click = [clip.rotate(90),clip.fade(.5)];	// rotate the clip to 90 degrees and fade to .5 on click
	clip.click = function(){ trace('ok'); }			// totally ok


It makes use of the excellent Greensock.com tween engine.	
It makes use of the experimental Manipulus library. 


Examples:

##Put a shape (or shapes) on the screen:

	make(Box,5);
    	make(Triangle,50);
	make(Line,500);
	
Description:

	make(SYMBOL_NAME, QUANTITY);

Symbol can be any symbol in the library set to “export for Actionscript”.
The example files have the following options for Symbol Box

	Triangle
	Circle
	Arc
	Line
	
##Modify shapes on screen:

	each(Box).x = 100;
	each(Box).rotation = 180;
	each(Box).alpha = .5;

Description:

	each(SYMBOL_NAME).property

Note: This works even if there is only one thing. Some options for property include
	x
	y
	width
	height
	rotation
	alpha
	scaleX
	scaleY
	scale
	
Note: rotation is in degrees.
Note: The values for alpha, scaleX, and scaleY, and scaleY are 0 to 1, where 1 is 100%, .5 is 50%, and so forth.

##Create and use random number
Example:

	each(Line).rotation = random(0,360);

The above code sets the rotation of each Line to a random number between 0 and 360.
Example:

	each(Box).rotation = random(0,360,45);

The above code sets the rotation of each Box to a random number between 0 and 360.
That number is also a multiple of 45°.

Description:

	random(low,high);
 Or
	random(low, high, multiple);
	
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

	inputType = animation() Or
	inputType = animation(VALUE) Or
	inputType = animation(VALUE, LENGTH) Or
	inputType = animation(VALUE, LENGTH, DELAY) Options for inputType
             click
             rollOver
             rollOut
             
Options for animation
             
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
inputType = each(Symbol).animation(value, length, delay) Options for the different parts are the same as in previous sections.

##Create a response using random values
Example:

	click = each(Box).spin(random(0,360,45));
	
When the user clicks, all boxes will rotate, over time, to a value between 0o and 360°. The
final value will be a multiple of 45.

##Create a one shape response to input on that shape
Example:

	each(Box).click = Item.spin(random(0,360,45));

When the user clicks a Box, that specific Box will rotate, over time, to a value between 0o and 360°. The final value will be a multiple of 45.

