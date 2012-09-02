package engine 
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class GameEngine extends Sprite
	{
		
		
		private var _physics:Physics;
		//private var _renderSolver = new RenderSolver();
		//rendererSolver
		//netsyncSolver
		//
		
		//DEBUG:
		private var _gameObjects:Vector.<GameObject> = new Vector.<GameObject>();
		private var _staticGraphics:Graphics;
		private var _dynamicGraphics:Graphics;
		
		public function GameEngine() 
		{
			trace("gameEngine initializing...");
			
			//DEBUG GRAPHICS:
			var temp:Sprite = new Sprite();
			super.addChild(temp);
			this._staticGraphics = temp.graphics;
			temp = new Sprite();
			super.addChild(temp);
			this._dynamicGraphics = temp.graphics;
			
			
			
			this._physics = new Physics(this._staticGraphics, this._dynamicGraphics);
			
			super.addEventListener(Event.ENTER_FRAME, step);
		}
		
		public function addGameObject(gameObject:GameObject):void {
			super.addChild(gameObject);//debug
			
			this._gameObjects.push(gameObject);//debug
			
			if (gameObject.collider) this._physics.addCollider(gameObject.collider);
			//if (gameOgject.renderable) this._renderSolver.addRenderable(gameOgject.renderable);
			if (gameObject.rigidBody) this._physics.addRigidbody(gameObject.rigidBody);
		}
		
		public function step(e:Event):void {
			this._dynamicGraphics.clear();
			
			//->
			
			//this._physicsSolver.step();
			//?.	-> netSync -> read (?)
			
			
			//1.	-> physics iterations
			//			-> rigidbody.update() -> if(?) invalidate collider
			//			-> resolveCollisions -> validate all invalidated colliders
			this._physics.step(0.05);
			
			
			
			
			
			//2.	-> execute custom code inside all game objects
			//		-> if(?) invalidate collider
			
			//3.	-> resolveCollisions -> validate all invalidated colliders
			
			//?.	-> audioSource dispose
			
			//?.	-> netSync flush (?)
			
			//4.	-> render all renderable game objects
			
			//this._renderSolver.redraw();
			
			//<-
			
			//debug:
			for (var i:int = 0; i < this._gameObjects.length; i++) {
				var gameObject:GameObject = this._gameObjects[i];
				gameObject.state.position.drawGlobal(this._dynamicGraphics, 5.0, 1.0, 0x440000, 0.5, 0x000000, 0.0);
				gameObject.state.forward.scale(20).drawVector(this._dynamicGraphics, gameObject.state.x, gameObject.state.y, 1.0, 0x660000, 0.5);
				gameObject.state.right.scale(20).drawVector(this._dynamicGraphics, gameObject.state.x, gameObject.state.y, 1.0, 0x000066, 0.5);
			}
		}
		
		
		
	}

}