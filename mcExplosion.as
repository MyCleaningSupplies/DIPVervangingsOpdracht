package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Abdelkarim Ouzzine
	 */
	public class mcExplosion extends MovieClip
	{
		
		public function mcExplosion()
		{
			//check if explosion is added to stage
			addEventListener(Event.ADDED_TO_STAGE, onAdd);
		
		}
		
		private function onAdd(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdd);
			init();
		}
		
		private function init():void 
		{
			addEventListener(Event.ENTER_FRAME, explosionLoop);
		}
		
		private function explosionLoop(e:Event):void 
		{
			//if current frame is at final frame
			if (this.currentFrame == this.totalFrames)
			{
				
				//remove explosion  clip
				parent.removeChild(this)
				//remove enterframe event listener
				removeEventListener(Event.ENTER_FRAME, explosionLoop);
			}
		}
	
	}

}