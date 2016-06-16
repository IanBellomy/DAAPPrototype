// TriggeredAnimation.make
// returns event handlers that contain animation code...

// OR

// stand in for iterator?

/*

	each(Arc).rollOver = Item.block.spin();
									^ returns a handler that accepts the target of the event
		

	if property doesn't exist..
		assume it exists on the target of the event
			create a new Item (with refernce to property)  Item("block")
				
				...

				targetObject = e.target find child with path ( calle.pathToTarget )	


*/

package edu.daap
{

	import com.greensock.TweenMax;

	class Item{

			function Item(){}

			public static function animation(props='x',val= "10",time=1,delay=0,easing=null,fixedReference:Boolean=false):Function{
				
				trace(props);

				var handler = function(e=null){		
					
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

					TweenMax.to(targetObject,immutableTime,immutableAnimationTarget);
				}
				handler.target  = null;//(fixedReference)?this:null;
				handler.time	= time;
				handler.animationTarget = {};

				if(props is Array){
					for(var i : uint = 0; i < props.length; i++){
						handler.animationTarget[props[i]] = val;
					}
				}
				else if (props is String){
					handler.animationTarget[props] = val;
				}
				else if(props is Object){
					handler.animationTarget = props;
				}

				handler.animationTarget.delay	= delay;
				//handler.animationTarget.easing = (easing==null)?Linear.easeNone : easing;

				return handler
			}			

			public static function slide(value="50",time=1,delay=0):Function{
				return Item.animation('x',value,time,delay)
			}	
			public static function lift(value="50",time=1,delay=0):Function{
				return Item.animation('y',value,time,delay)
			}
			public static function spin(value="30",time=1,delay=0):Function{
				return Item.animation('rotation',value,time,delay)
			}
			public static function fade(value="-.2",time=1,delay=0):Function{
				return Item.animation('alpha',value,time,delay)
			}
			public static function grow(value="+.2",time=1,delay=0):Function{										
				return Item.animation('scale',value,time,delay);
			}
			public static function blur(value="+2",time=1,delay=0):Function{				
				return Item.animation("blurFilter",{blurX:value,blurY:value,delay:delay});
			}	

	}
}