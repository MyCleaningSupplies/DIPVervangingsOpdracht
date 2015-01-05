package  
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author Abdelkarim Ouzzine
	 */
	public class firstGame extends MovieClip 
	{
		public var mcPlayer:MovieClip;
		private var leftKeyIsDown:Boolean;
		private var rightKeyIsDown:Boolean;
		private var aMissileArray:Array;
		private var aEnemyArray:Array;
		public var scoreTxt:TextField;
		public var ammoTxt:TextField;
		private var nScore:Number;
		private var nAmmo:Number;
		private var tEnemyTimer:Timer;
		public var menuEnd:mcEndGameScreen;
		
		public function firstGame() 
		{
			playGameAgain(null);
		}
		
		private function playGameAgain(e:Event):void 
		{
			//initialize variables
			aMissileArray = new Array();
			aEnemyArray = new Array();
			nScore = 0;
			nAmmo = 20;
			
			mcPlayer.visible = true;
			
			menuEnd.addEventListener("PLAY_AGAIN", playGameAgain);
			menuEnd.hideScreen();
			
			updateScoreText();
			updateAmmoText();
			
			//setup listener to listen for keypress
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUp);
			//setup gameloop listener
			stage.addEventListener(Event.ENTER_FRAME, gameLoop) 
			
			//create timer
			tEnemyTimer = new Timer(1000)
			//listen for timer ticks
			tEnemyTimer.addEventListener(TimerEvent.TIMER, addEnemy)
			//start timer
			tEnemyTimer.start();
		}
		
		private function updateScoreText():void 
		{
			scoreTxt.text = "Current score: " + nScore;
		}
		
		private function updateAmmoText():void
		{
			ammoTxt.text = "Ammo capacity: " + nAmmo;
		}
		
		private function addEnemy(e:TimerEvent):void 
		{
			//create new enemy
			var newEnemy:mcEnemy = new mcEnemy();
			//add enemy to stage
			stage.addChild(newEnemy);
			//add newEnemy to a array
			aEnemyArray.push(newEnemy);
			trace(aEnemyArray.length);
		}
		
		private function gameLoop(e:Event):void 
		{
			playerControl();
			clampPlayerToStage();
			checkMissileOffScreen();
			checkEnemyOffScreen();
			checkMissileHit();
			checkEndGameCondition();
		}
		
		private function checkEndGameCondition():void 
		{
			//check if player is out of ammo and no more on screen
			if (nAmmo == 0 && aMissileArray.length == 0)
			{
				//stop player movement
				stage.removeEventListener(KeyboardEvent.KEY_UP, keyUp);
				stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDown);
				//hide player
				mcPlayer.visible = false;
				//stop spawning enemies
				tEnemyTimer.stop();
				//clear out enemies on screen
				for each(var enemy:mcEnemy in aEnemyArray)
				{
					//destroy enemy
					enemy.destroyEnemy();
					//remove it from enemy array
					aEnemyArray.splice(0, 1);
				}
				//end gameloop
				if (aEnemyArray.length == 0)
				{
					stage.removeEventListener(Event.ENTER_FRAME, gameLoop);	
				}
				//show endgame screen
				menuEnd.showScreen();
			}	
		}
		
		private function checkMissileHit():void 
		{
			//loop through current missiles on stage
			for (var i:int = 0; i < aMissileArray.length; i++)
			{
				//get current missile in i loop
				var currentMissile:mcMissile = aMissileArray[i];
				
				//loop through enemies on stage
				for (var j:int = 0; j < aEnemyArray.length; j ++)
				{
					//get current enemy in j loop
					var currentEnemy:mcEnemy = aEnemyArray[j];
					
					//test if missile collides with enemy
					if (currentMissile.hitTestObject(currentEnemy))
					{
						//create explosion
						
						//create new explosion instance
						var newExplosion:mcExplosion = new mcExplosion()
						//add explosion to stage
						stage.addChild(newExplosion)
						//position explosion to enemy
						newExplosion.x = currentEnemy.x;
						newExplosion.y = currentEnemy.y;
						
						//remove missile stage
						 currentMissile.destroyMissile()
						//remove missile from array
						aMissileArray.splice(i, 1);
						
						//remove enemy from stage
						currentEnemy.destroyEnemy()
						//remove enemy from array
						aEnemyArray.splice(j, 1);
						
						//add 1 to score
						nScore++;
						updateScoreText();
					}
					
				}
				
			}
		}
		
		private function checkEnemyOffScreen():void 
		{
			//loop through enemies
			for (var i:int = 0; i < aEnemyArray.length; i++)
			{
				//get enemy in the loop
				var currentEnemy:mcEnemy = aEnemyArray[i];
				
				//if enemy moves right off left side
				if (currentEnemy.sDirection == "L" && currentEnemy.x < -(currentEnemy.width / 2))
				{
					//remove enemy from array
					aEnemyArray.splice(i, 1);
					//remove enemy from stage
					currentEnemy.destroyEnemy();
					
				}else
				if (currentEnemy.sDirection == "R" && currentEnemy.x > (stage.stageWidth + currentEnemy.width / 2))
				{
					//remove enemy from array
					aEnemyArray.splice(i, 1);
					//remove enemy from stage
					currentEnemy.destroyEnemy();
				}
			}
		}
		
		private function checkMissileOffScreen():void 
		{
			//loop through all missiles in missile array
			for (var i:int = 0; i < aMissileArray.length; i++)
			{
				//get the current missile in the loop
				var currentMissile:mcMissile = aMissileArray[i];
				//test if current missile is past the top if stage
				if (currentMissile.y < 0)
				{
					//remove missile from array
					aMissileArray.splice(i, 1);
					//destroy missile
					currentMissile.destroyMissile();
					
				}
			}
		}
		
		private function clampPlayerToStage():void 
		{
			//if our player is to left of stage
			if (mcPlayer.x < (mcPlayer.width / 2))
			{
				//setup player to left of stage
				mcPlayer.x = mcPlayer.width / 2;
			} else if (mcPlayer.x > (stage.stageWidth - (mcPlayer.width / 2)))
			//if player is to right of stage
			{
				//set player to right of stage
				mcPlayer.x = stage.stageWidth - (mcPlayer.width / 2);
			}
		}
	
		
		private function playerControl():void 
		{
			// if our left key is down
			if (leftKeyIsDown == true)
			{
				
				//move player to left
				mcPlayer.x -= 8;
			}
			//if right key is down
			if (rightKeyIsDown == true)
			{
				
				//move player to right
				mcPlayer.x += 8;
			}
		}
		
		private function keyUp(e:KeyboardEvent):void 
		{
			
			
			//if left key is released
			if (e.keyCode == 37)
			{
				//left key is released
				leftKeyIsDown = false;
			}
			//if right key is released
			if (e.keyCode == 39)
			{
				//right key is released
				rightKeyIsDown = false;
			}
			//if spacebar is released
			if (e.keyCode == 32)
			{
				
				
				//test if player has ammo left
				if (nAmmo > 0)
				{
					nAmmo--;
					updateAmmoText();
					//fire missile
					fireMissile();	
				}
				
			}
		}
		
		
		private function fireMissile():void 
		{
			//create new missile object
			var newMissile:mcMissile = new mcMissile();
			//add missile to stage
			stage.addChild(newMissile);
			// position missile on top of player
			newMissile.x = mcPlayer.x;
			newMissile.y = mcPlayer.y;
			//add newmissile to the missile array
			aMissileArray.push(newMissile);
		}
		
		private function keyDown(e:KeyboardEvent):void 
		{
			//if left key is pressed
			if (e.keyCode == 37)
			{
				//left key is pressed
				leftKeyIsDown = true;
			}
			//if right key is pressed
			if (e.keyCode == 39)
			{
				//right key is pressed
				rightKeyIsDown = true;
			}
		}
		
	}

}