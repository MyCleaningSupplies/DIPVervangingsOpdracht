package  
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Abdelkarim Ouzzine
	 */
	public class mcMissile extends Sprite 
	{
		
		public function mcMissile() 
		{
			//setup a listener to see if missile is added to stage
			addEventListener(Event.ADDED_TO_STAGE, onAdd);
		}
		
		private function onAdd(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdd);
			//object is on stage, run custom code
			init();
		}
		
		private function init():void 
		{
			addEventListener(Event.ENTER_FRAME, missleLoop)
		}
		
		private function missleLoop(e:Event):void 
		{
			this.y -= 20;
		}
		
		public function destroyMissile():void
		{
			//remove object from stage
			parent.removeChild(this);
			//remove any event listeners
			removeEventListener(Event.ENTER_FRAME, missleLoop);
		}
		
	}

}