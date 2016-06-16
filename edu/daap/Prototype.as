/*


	Less syntax, less mistakes, less frustration.
	
	This helper class decorates the MovieClip prototype to make doing simple things easy. 
	ex.
	
		clip.click = clip.rotate(90);					// rotate the clip to 90 degrees on click
		clip.click = [clip.rotate(90),clip.fade(.5)];	// rotate the clip to 90 degrees and fade to .5 on click
		clip.click = function(){ trace('ok'); }			// totally ok

	It makes use of the excellent Greensock.com tween engine.	
	It makes use of the experimental Manipulus library. 


*/

package edu.daap
{	
	import edu.daap.*;

	import flash.display.*;
	import flash.events.*;
	import flash.text.*;	

	import net.manipulus.Set;
	import net.manipulus.Reference;
	import net.manipulus.RandomNumberReference;

	// deprecating . . .	
	import com.greensock.TweenMax;
	import com.greensock.easing.*;

	import fl.transitions.Tween;
	import fl.transitions.easing.*;

	dynamic public class Prototype extends MovieClip
	{

		// psedo constants

		public var X = 'x';
		public var Y = 'y';
		public var Width = "width";
		public var Height = "height";
		public var Alpha = "alpha";
		public var Rotation = "rotation";
		public var Scale = "scale";
		public var ScaleX = "scaleX";
		public var ScaleY = "scaleY";

		// . . . 

		public var click;
		public var rollOver;
		public var rollOut; 
		public var toggle;
		public var handleToggle;		
		
		public var animation;	
		public var animate;
		
		public var slide;	
		public var lift;  	
		public var spin;   	
		public var fade;   	
		public var grow;   	
		public var blur; 

		public var goto;
		public var go;

		public var enterFrame ;
		public var clickCount = 0;			

		public function Prototype()
		{

			stage.addEventListener(MouseEvent.MOUSE_DOWN,handleMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_OVER,handleRollOver);
			stage.addEventListener(MouseEvent.MOUSE_OUT,handleRollOut);
			addEventListener(Event.ADDED_TO_STAGE,handleAddedToStage);
						
			stage.addEventListener(Event.ENTER_FRAME,handleEnterFrame);

			click = function(){};
			rollOver = function(){};
			rollOut = function(){};
			toggle = [];

			//
			//	Snarky extension of the MovieClip class.
			//
				MovieClip.prototype.mouseChildren = false;
				// Create and return event handler function				
				
				animation = MovieClip.prototype.animation = function(props='x',val= "10",time=1,delay=0,easing=null,fixedReference:Boolean=true):Function
				{
					/*
					if(props=='scale') 
					{
						return this['animation'](['scaleX','scaleY'],val,time,delay,easing);						
					}*/
					
					var handler = function(e=null)
					{		
						
						// check to see if what this animation should be targeted at.
						var targetObject = (arguments.callee['target'] == null)?e.target:arguments.callee['target'];

						// TweenMax seems to treat References like a strings... and I don't have time to hack it
						// so... before we feed TweenMax, we need a target object with immutable values
						var immutableAnimationTarget = {};
						for(var prop:String in arguments.callee['animationTarget']){								
							if(prop == 'scale'){								
								immutableAnimationTarget['scaleX'] = immutableAnimationTarget['scaleY'] = arguments.callee['animationTarget'][prop].valueOf(); 
								continue;
							}else if (prop=="blurFilter"){
								var immutableFilterValue = arguments.callee['animationTarget'][prop].blurX.valueOf();
								var immutableFilter = {blurX:immutableFilterValue, blurY:immutableFilterValue};
								immutableAnimationTarget.blurFilter = immutableFilter;
								continue;						
							}				
							immutableAnimationTarget[prop] = arguments.callee['animationTarget'][prop].valueOf(); 							

						}

						var immutableTime = arguments.callee['time'] + 0;
						TweenMax.to(arguments.callee['target'],immutableTime,immutableAnimationTarget);
						
						/*
						In the event greensock tween engine is unavailable...

						if(arguments.callee['tween'] != null) arguments.callee['tween'].stop();						
						arguments.callee['tween'].tween = new Tween(arguments.callee['target'], 
												prop, 
												Quad.easeInOut, 
												arguments.callee['target'][prop], 
												immutableTarget, 
												immutableTime,  
												true);*/

					}
					handler.target  = (fixedReference)?this:null;
					handler.time	= time;
					handler.animationTarget = {};
				
					if(props is Array)
					{
						for(var i : uint = 0; i < props.length; i++)
						{
							handler.animationTarget[props[i]] = val;
						}
					}
					else if (props is String)
					{
						handler.animationTarget[props] = val;
					}
					else if(props is Object)
					{
						handler.animationTarget = props;
					}
				
					handler.animationTarget.delay	= delay;
					//handler.animationTarget.easing = (easing==null)?Linear.easeNone : easing;
	
					return handler
				}
			
				// create event handler with an animation.
				slide = MovieClip.prototype.slide = function(value="50",time=1,delay=0):Function
				{
					return this['animation']('x',value,time,delay)
				}	
				lift = MovieClip.prototype.lift = function(value="50",time=1,delay=0):Function
				{
					return this['animation']('y',value,time,delay)
				}
				spin = MovieClip.prototype.spin = function(value="30",time=1,delay=0):Function
				{
					return this['animation']('rotation',value,time,delay)
				}
				fade = MovieClip.prototype.fade = function(value="-.2",time=1,delay=0):Function
				{
					return this['animation']('alpha',value,time,delay)
				}
				grow = MovieClip.prototype.grow = function(value="+.2",time=1,delay=0):Function
				{										
					return this['animation']('scale',value,time,delay);
				}
				blur = MovieClip.prototype.blur = function(value="+2",time=1,delay=0):Function
				{
					return this['animation']("blurFilter",{blurX:value,blurY:value,delay:delay});
				}											
				
				handleToggle = MovieClip.prototype.handleToggle = function()
				{
					if(this.toggle == undefined) return;

					if(this.clickCount==undefined) this.clickCount = this.toggle.length-1;
					
					this.clickCount = (this.clickCount+1)%this.toggle.length;


					if(this.toggle[this.clickCount] is Function)
					{
						this.toggle[this.clickCount]();
					}
					else if (this.toggle[this.clickCount] is Array)
					{
						for(var i : uint = 0; i < this.toggle[this.clickCount].length; i++)
						{
							this.toggle[this.clickCount][i]();	
						}				
					}					
				}
				
				// animate NOW!				
				animate = MovieClip.prototype.animate = function(props='x',val= "10",time=1,delay=0,easing=null)
				{
					var animationTarget ={};
					if(props is Array)
					{
						for(var i : uint = 0; i < props.length; i++)
						{
							animationTarget[props[i]] = val;
						}
					}
					else if (props is String)
					{
						animationTarget[props] = val;
					}
					else if(props is Object)
					{
						animationTarget = props;
					}
				
					animationTarget.delay	= delay;
					//handler.animationTarget.easing = (easing==null)?Linear.easeNone : easing;
					
					TweenMax.to(this,time,animationTarget)
				}

				// gotoAndPlay handler
				goto = MovieClip.prototype.goto = function(val){
					var handler = function(e=null){
						arguments.callee['target'].gotoAndPlay(arguments.callee['value'])
					}
					handler.target = this;
					handler.value = val;
					return handler;
				}

				// gotoAndPlay handler
				go = MovieClip.prototype.go = function(val){
					var handler = function(e=null){
						arguments.callee['target'].play();
					}
					handler.target = this;
					return handler;
				}
				
				MovieClip.prototype.bringToFront=function(){
					this.parent.addChild(this);
				}

				MovieClip.prototype.sendToBack=function(){
					this.parent.addChildAt(this,0);
				}
				
			//
			//
			//

			each().mouseChildren = false;

		}
		
		/*
			
			Because we're not actively adding event listeners to create our responses, we'll need to handle events manually...		
		
		*/
		
		public function handleMouseDown(e:MouseEvent)
		{
			var target = e.target;
						
			
			handleCustomEvent(e,'toggle');
			handleCustomEvent(e,'click');
		}
				
		public function handleRollOut(e:MouseEvent):void
		{
			handleCustomEvent(e,'rollOut');
		}
		
		public function handleRollOver(e:MouseEvent):void
		{
			handleCustomEvent(e,'rollOver');
		}
		
		private function handleCustomEvent(e,handle)
		{
			var target = e.target;

			if(target == stage)
			{ 
				target = this;
			}
			else
			{			
				//trace("Main::handleCustomEvent()",target,handle,target is MovieClip, !(target is MovieClip));
				while( !(target is MovieClip) || target is TextField || target[handle] == undefined)
				{
					target = target.parent;				
					//trace("		Main::handleCustomEvent()",target,target.name);					
				}				
			}

			if(handle == 'click')
			{
				/*
				if(target == stage) trace('(stage clicked)');
				else if(target == this) trace('(stage clicked)');
				else trace('('+target['name']+' clicked)');
				*/
			}

			if(handle=="toggle")
			{
				if(target.toggle.length == 0) return;
				
				target.handleToggle.apply(target);
				return;
			}



			if(target[handle] is Function)
			{				
				target[handle].apply(target,[e]);		// BAD IDEA?
			}
			else if (target[handle] is Array)
			{				
				// why not just loop through array here? BECAUSE IT CAN BE MULTIDIMENSIONAL. (Thanks to 'each')
				dispatchCustomEventToHandlerArray(e,handle,target[handle]);
				/*for(var i : uint = 0; i < target[handle].length; i++){					
					target[handle][i].apply(target);	
				}*/				
			}
		}

		// What a mouthful! . . . 
		private function dispatchCustomEventToHandlerArray(event,customEventType,handlers){
			for(var i : uint = 0; i < handlers.length; i++){				
				if(handlers[i] is Array){ 
					dispatchCustomEventToHandlerArray(event,customEventType,handlers[i]);
					continue;
				}
				//trace(handlers[i])
				handlers[i].apply(event.target,[event]);	
			}
		}

		public function handleEnterFrame(e=null)
		{
			if(enterFrame != undefined)
			{
				enterFrame();
			}
		}

		public function each(aClass:Class=null,property:String=null,input=null):Set{
			
			aClass = (aClass==null)?MovieClip:aClass;
			var displayObject:DisplayObject;
			var entities = new Set();
			
			for(var i = 0; i < numChildren; i++){
				displayObject = getChildAt(i);
				if(displayObject is aClass){					
					entities.push(displayObject);
				}		
			}

			return entities;
			
		}

		// pre-deprecated? 
		/*
		public function each():Item{
			// just kidding! this doesn't accept anything, it just feels better to say each(something)
			return Item;			
		}
		*/
		// deprecated (if left should accept optional third input)
		/*private function random(low,high):Number{
			return Math.random()*(high-low)+low;
		}*/

		// deprecated
		/*
		private function randomSteps(stepSize,low,high):Number{
			return (Math.floor(Math.random()*(high-low))+low)*stepSize;
		}*/		

		public function make(thingClass:Class,quantity:int=1){
			var entities = new Set();
			for(var i = 0; i< quantity; i++ ){
				var newThing = new thingClass();
				addChild(newThing);				
				newThing.mouseChildren = false;
				entities.push(newThing);
				//newThing.mouseEnabled = false;
			}
			return entities;
		}	

		public function random(low_:Number=0,high_:Number=1,multiple:Number=0){
			return new RandomNumberReference(low_,high_,multiple);
		} 

		// bahaha
		public function get everything(){
			return each();
		}		

		public function handleAddedToStage(e){
			//trace(e.target.name);
			//e.target.mouseChildren = false;
		}

	}
}


/*

	sound?
	video?
	etc?

*/