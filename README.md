#DAAPPrototype

An old Actionscript library that makes basic interactions easy. 
Created for DAAPCamp workshops on interactivity in order to get highschoolers without programming knowledge up to making interactive things in a couple hours.

Less syntax, less mistakes, less frustration.
	
The edu.daap.Prototype class modifies the MovieClip prototype to allow things like this: 

	clip.click = clip.rotate(90);					// rotate the clip to 90 degrees on click
	clip.click = [clip.rotate(90),clip.fade(.5)];	// rotate the clip to 90 degrees and fade to .5 on click
	clip.click = function(){ trace('ok'); }			// totally ok

It makes use of the excellent Greensock.com tween engine.	
It makes use of the experimental Manipulus library. 
