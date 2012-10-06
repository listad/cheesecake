package engine {
	
	import engine.geometry.Projection;
	import engine.geometry.Vector2D;
	import engine.physics.Collider;
	import engine.physics.CollisionMatrix;
	import engine.physics.Quadtrees;
	import engine.physics.RigidBody;
	
	//debug:
	import flash.display.Graphics;
	import engine.physics.State;
	import engine.physics.ColliderType;
	
	public class Physics {
		
		private var _quadtrees:Quadtrees;
		private var _collision:Collision;
		
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
			this._collision = new Collision(staticGraphics, dynamicGraphics);
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
						if (rigidbody.collider) {
							rigidbody.collider.invalidate();// -> invalidate collider
							rigidbody.collider.quadcell = rigidbody.collider.quadcell.repush(rigidbody.collider);//обернуть в нормальную ф-цию
							//debug:
							//rigidbody.collider.quadcell.draw(this._dynamicGraphics, 2.0, 0x005500, 0.05, 0x005500, 0.01);
						}
					}
				}
				this.resolveCollisions();
				
			} while (++iterationNum < _iterations);
			
			//debug:
			//for (i = 0; i < this._dynamicColliders.length; i++) {
				//this._dynamicColliders[i].bounds.draw(this._dynamicGraphics, 1, 0xff0000, 0.1, 0, 0.0);
			//}
			//debug^
		}
		
		public function resolveCollisions():void {
			//trace("resolveCollisions");
			// -> unhide all colliders
			var dynamicsNum:int = this._dynamicColliders.length;
			for (var i:int = 0; i < dynamicsNum; i++) {
				var colliderA:Collider = this._dynamicColliders[i];
				if(!colliderA.rigidBody) continue;//debug;
				colliderA.validate();
				// <- validate collider
				// <- hide collider
				colliderA.quadtreeVisible = false;
				// QUADTREES get VISIBLE colliders near collider
				var neighbors:Vector.<Collider> = this._quadtrees.getColliders(colliderA);//^
				var neighborsNum:int = neighbors.length;
				for (var j:int = 0; j < neighborsNum; j++) {
						var colliderB:Collider = neighbors[j];
						if(colliderB.quadtreeVisible)this.coarseCollision(colliderA, colliderB);
				}
			}
			
			for (i = 0; i < dynamicsNum; i++) {//fixme
				colliderA = this._dynamicColliders[i];
				colliderA.quadtreeVisible = true;
			}
		}
		
		public function coarseCollision(colliderA:Collider, colliderB:Collider):void {//COARSE
			//debug:
			//this._dynamicGraphics.lineStyle(1.0, 0x00FF00, 1.0);
			//this._dynamicGraphics.moveTo(colliderA.state.x, colliderA.state.y);
			//this._dynamicGraphics.lineTo(colliderB.state.x, colliderB.state.y);
			//debug^
			if (colliderA.bounds.collide(colliderB.bounds)) {
				//debug:
				//this._dynamicGraphics.lineStyle(1.0, 0xFF0000, 1.0);
				//this._dynamicGraphics.moveTo(colliderA.state.x, colliderA.state.y);
				//this._dynamicGraphics.lineTo(colliderB.state.x, colliderB.state.y);
				//debug^
				this._collision.collision(colliderA, colliderB);
				/*switch(colliderA.type | colliderB.type) {
					case CollisionMatrix.POLYGON_VS_POLYGON:
						this._collision.pvpCollision(colliderA, colliderB);
						break;
					case CollisionMatrix.POLYGON_VS_CIRCLE:
						if(colliderA.type == ColliderType.CIRCLE) {
							this._collision.pvcCollision(colliderB, colliderA);
						} else {
							this._collision.pvcCollision(colliderA, colliderB);
						}
						break;
					case CollisionMatrix.CIRCLE_VS_CIRCLE:
						this._collision.cvcCollision(colliderA, colliderB);
						break;
					default:
						break;
				}*/
				
			}
			//bounds VS bounds
				//1. polygon VS polygon
				//2. circle VS polygon || polygon VS circle
				//3. circle VS circle
		}
		
		public function get quadtrees():Quadtrees { return this._quadtrees; }
		
		//debug:
		public function get rigidbodies():Vector.<RigidBody> { return this._rigidbodies; }
	}
}