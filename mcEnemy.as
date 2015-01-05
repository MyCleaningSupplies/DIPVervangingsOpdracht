package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Abdelkarim Ouzzine
	 */
	public class mcEnemy extends MovieClip
	{
		
		public var sDirection:String;
		private var nSpeed:Number;
		
		public function mcEnemy()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAdd);
		
		}
		
		private function onAdd(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdd);
			init();
		}
		
		private function init():void 
		{
			var nEnemies:Number = 3;
			//pick random number between 1 and number of enemies
			var nRandom:Number = randomNumber(1, nEnemies);
			//setup playhead of this enemy clip to random number
			this.gotoAndStop(nRandom);
			//setup start position
			setupStartPos();
		}
		
		private function setupStartPos():void 
		{
			//pick ranom speed for enemy
			nSpeed = randomNumber(5, 10);
			//pick a random number for left or right start position
			var nLeftOrRight:Number = randomNumber(1, 2);
			// if nLeftOrRight == 1, make enemy start on left side
			if (nLeftOrRight == 1)
			{
				//start enemy on left side
				this.x = - (this.width / 2);
				sDirection = "R";
			}else
			{
				//start enemy on right side
				this.x = stage.stageWidth + (this.width / 2);
				sDirection = "L";
			}
			//set random altitude for enemy
			
			//setup 2 variables for minimum and maximum altitude
			var nMinAlt:Number = stage.stageHeight / 2;
			var nMaxAlt:Number = (this.height / 2);
			
			//setup enemy altitude to random point between min and max altitude
			this.y = randomNumber(nMinAlt, nMaxAlt);
			
			//move enemy
			startMoving();
		}
		
		private function startMoving():void 
		{
			addEventListener(Event.ENTER_FRAME, enemyLoop);
		}
		
		private function enemyLoop(e:Event):void 
		{
			//test what direction enemy moves
			
			//if enemy moves right
			if (sDirection == "R")
			{
				
				//move right
				this.x += nSpeed;
			}else
			{
				//move left
				this.x -= nSpeed;
			}
		}
		
		public function destroyEnemy():void
		{
			//remove enemy from stage
			parent.removeChild(this)
			//remove eventlisteners in enemy object
			removeEventListener(Event.ENTER_FRAME, enemyLoop);
		}
		
		function randomNumber(low:Number = 0, high:Number = 1):Number
		{
			return Math.floor(Math.random() * (1 + high - low)) + low;
		}
	
	}

}