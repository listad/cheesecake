package engine 
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	
	public class GameEngine extends Sprite
	{
		
		
		private var _physics:Physics;
		//private var _renderSolver = new RenderSolver();
		//rendererSolver
		//netsyncSolver
		//
		
		//DEBUG:
		private var _gameObjects:Vector.<GameObject> = new Vector.<GameObject>();
		public var _staticGraphics:Graphics;
		private var _dynamicGraphics:Graphics;
		public var _staticContainer:Sprite;
		public var _dynamicContainer:Sprite;
		
		public function GameEngine() 
		{
			
			
			trace("gameEngine initializing...");
			
			//DEBUG GRAPHICS:
			_staticContainer = new Sprite();
			super.addChild(_staticContainer);
			//_staticContainer.cacheAsBitmap = true;
			this._staticGraphics = _staticContainer.graphics;
			//_staticContainer.filters = [new GlowFilter(0x330000, 1.0, 3.0, 3.0, 3.0, 1, true, true)];
			
			_dynamicContainer = new Sprite();
			super.addChild(_dynamicContainer);
			this._dynamicGraphics = _dynamicContainer.graphics;
			//_dynamicContainer.filters = [new GlowFilter(0xDD0000, 1.0, 3.0, 3.0, 2.0, 1, true, true)];
			
			
			
			this._physics = new Physics(this._staticGraphics, this._dynamicGraphics);
			
			super.addEventListener(Event.ENTER_FRAME, step);
		}
		
		public function addGameObject(gameObject:GameObject):void {
			if (!gameObject.rigidBody) _staticContainer.addChild(gameObject);//debug
			else _dynamicContainer.addChild(gameObject);//debug
			
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
			this._physics.step(0.075);
			
			
			
			
			
			//2.	-> execute custom code inside all game objects
			//		-> if(?) invalidate collider
			
			//3.	-> resolveCollisions -> validate all invalidated colliders
			
			//?.	-> audioSource dispose
			
			//?.	-> netSync flush (?)
			
			//4.	-> render all renderable game objects
			
			//this._renderSolver.redraw();
			
			//<-
			
			//debug:
			//for (var i:int = 0; i < this._gameObjects.length; i++) {
				////var gameObject:GameObject = this._gameObjects[i];
				//gameObject.state.position.drawGlobal(this._dynamicGraphics, 5.0, 1.0, 0x440000, 0.5, 0x000000, 0.0);
				//gameObject.state.forward.scale(20).drawVector(this._dynamicGraphics, gameObject.state.x, gameObject.state.y, 1.0, 0x660000, 0.5);
				//gameObject.state.right.scale(20).drawVector(this._dynamicGraphics, gameObject.state.x, gameObject.state.y, 1.0, 0x000066, 0.5);
			//}
		}
		
		public function get physics():Physics { return this._physics; }
		
		
		
	}

}