package engine {
	
	import engine.physics.Collider;
	import engine.physics.Quadtrees;
	import engine.physics.RigidBody;
	
	//debug:
	import flash.display.Graphics;
	
	public class Physics {
		
		private var _quadtrees:Quadtrees;
		
		private var _iterations:int = 4;
		
		private var _rigidbodies:Vector.<RigidBody> = new Vector.<RigidBody>();
		private var _staticColliders:Vector.<Collider> = new Vector.<Collider>();
		private var _dynamicColliders:Vector.<Collider> = new Vector.<Collider>();
		
		private var _staticGraphics:Graphics;
		private var _dynamicGraphics:Graphics;
		
		public function Physics(staticGraphics:Graphics, dynamicGraphics:Graphics) {
			trace("physicsEngine initializing...");
			
			this._staticGraphics = staticGraphics;
			this._dynamicGraphics = dynamicGraphics;
			
			this._quadtrees = new Quadtrees(staticGraphics);
		}
		
		public function addRigidbody(rigidbody:RigidBody):void {
			this._rigidbodies.push(rigidbody);
		}
		
		public function addCollider(collider:Collider, isStatic:Boolean = false):void {
			//if (isStatic) {//реализовать
				//this._staticColliders.push(collider);
			//} else {
				this._dynamicColliders.push(collider);
				collider.quadcell = this._quadtrees.push(collider);//запихнуть в функцию push
			//}
		}
		
		public function step(dt:Number):void {
			var ddt:Number = dt / this._iterations;
			var iterationNum:int = 0;
			do {
				var rigidbodiesNum:int = this._rigidbodies.length;
				for (var i:int = 0; i < rigidbodiesNum; i++) {
					var rigidbody:RigidBody = this._rigidbodies[i];
					if (!rigidbody.sleeps) {
						rigidbody.physicsUpdate(ddt);
						// -> invalidate collider
					}
				}
				this.resolveCollisions();
				
			} while (++iterationNum < _iterations);
			
			//debug:
			for (i = 0; i < this._dynamicColliders.length; i++) {
				this._dynamicColliders[i].bounds.draw(this._dynamicGraphics, 1, 0xff0000, 0.1, 0, 0.0);
			}
		}
		
		public function resolveCollisions():void {
			// -> unhide all colliders
			var dynamicsNum:int = this._dynamicColliders.length;
			for (var i:int = 0; i < dynamicsNum; i++) {
				var colliderA:Collider = this._dynamicColliders[i];
				// <- validate collider
				// <- hide collider
				// QUADTREES get VISIBLE colliders near collider
				var neighbors:Vector.<Collider> = this._quadtrees.getColliders(colliderA);//^
				var neighborsNum:int = neighbors.length;
				for (var j:int = 0; j < neighborsNum; j++) {
						var colliderB:Collider = neighbors[j];
						this.coarseCollision(colliderA, colliderB);
				}
			}
		}
		
		public function coarseCollision(colliderA:Collider, colliderB:Collider):void {
			//bounds VS bounds
				//1. polygon VS polygon
				//2. circle VS polygon || polygon VS circle
				//3. circle VS circle
		}
	}
}