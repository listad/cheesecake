package engine.physics {
	import engine.util.Time;
	import flash.display.Sprite;
	import flash.events.Event;
	import engine.geometry.Matrix2D;
	import engine.geometry.Vector2D;
	
	public class PhysicsSandbox extends Sprite {
		// Const
		
		// Var
		private var _iterations:int = 4;
		
		private var _dynamicBodies:Vector.<RigidBody> = new Vector.<RigidBody>();
		private var _staticBodies:Vector.<RigidBody> = new Vector.<RigidBody>();
		
		private var _lastUpdate:Number;
		
		// Constructor
		
		public function PhysicsSandbox() {
			super.mouseEnabled = false;
		}
		
		// Public
		
		public function run():void {
			this._lastUpdate = Time.time;
			super.addEventListener(Event.ENTER_FRAME, this.enterFrameEventListener);
		}
		
		public function stop():void {
			
		}
		
		public function addRigidBody(rigidBody:RigidBody):void {
			if (rigidBody.mass == Infinity) {
				this._staticBodies.push(rigidBody);
			} else {
				this._dynamicBodies.push(rigidBody);
			}
			super.addChild(rigidBody);
		}
		
		public function removeRigidBody(rigidBody:RigidBody):void {
			var index:int;
			if (rigidBody.mass == Infinity) {
				index = this._staticBodies.indexOf(rigidBody);
				if (index > -1) this._staticBodies.splice(index, 1, rigidBody);
			} else {
				index = this._dynamicBodies.indexOf(rigidBody);
				if (index > -1) this._dynamicBodies.splice(index, 1, rigidBody);
			}
			if (rigidBody.parent == super) super.removeChild(rigidBody);
		}
		
		// Private
		
		private function enterFrameEventListener(event:Event):void {
			super.graphics.clear();//clear debug graphics
			
			var dt:Number = Time.time - this._lastUpdate;
			this._lastUpdate = Time.time;
			
			//trace("frameRate: ", Math.round(1 / dt) );
			
			var dynamicsNum:int = this._dynamicBodies.length;
			var staticsNum:int = this._staticBodies.length;
			
			var ddt:Number = dt / this._iterations;
			for (var i:int = 0; i < this._iterations; i++) {
				//physics update
				
				for (var j:int = 0; j < dynamicsNum; j++) {
					var rigidBody:RigidBody = this._dynamicBodies[j];
					rigidBody.physicsUpdate(ddt);
				}
				//collisions
				for (j = 0; j < dynamicsNum; j++) {
					//other dynamics
					for (var q:int = j + 1; q < dynamicsNum; q++) {
						this.checkCollision(this._dynamicBodies[j], this._dynamicBodies[q]);
					}
					//all statics
					for (var q:int = 0; q < staticsNum; q++) {
						this.checkCollision(this._dynamicBodies[j], this._staticBodies[q]);
					}
					
				}
				//
			}
			
			//draw debug graphics
			for (j = 0; j < dynamicsNum; j++) {
					rigidBody = this._dynamicBodies[j];
					rigidBody.debug(super.graphics);
			}
			for (j = 0; j < staticsNum; j++) {
					rigidBody = this._staticBodies[j];
					rigidBody.debug(super.graphics);
			}
			
		}
		
		private function checkCollision(bodyA:RigidBody, bodyB:RigidBody):void {
			if(bodyA.bounds.collide(bodyB.bounds)) {
				bodyA.bounds.draw(super.graphics, 1.0, 0xFF0000, 0.1, 0x000000, 0.0);//draw debug graphics
				bodyB.bounds.draw(super.graphics, 1.0, 0xFF0000, 0.1, 0x000000, 0.0);//draw debug graphics
				
				
				
			}//
		}
		
		//polygon versus polygon
		/*private function pvpCollision(bodyA:RigidBody, bodyB:RigidBody):boolean {
			var collision:Boolean = false;
				
			var projectionDistanceMin:Number = Number.MAX_VALUE;
			
			//BODY A
			var matrix:Matrix2D = bodyA.matrix;
			
			var edges:Vector.<Vector2D> = bodyA.collisionGeometry.edges;
			var length:int = edges.length;
			for(var i:int = 0; i < length; i++) {
				var edge:Vector2D = matrix.transformVector2D(edges[i]);
				var axis:Vector2D = edge.normal;
				axis.normalize();
				
				/// project bodies and calc dist
				var projectionDistance:Number = 0.0;
				if(projectionDistance > 0) return false;
				
				projectionDistance = Math.abs(projectionDistance);
				if(projectionDistance < projectionDistanceMin) {
					projectionDistanceMin = projectionDistance;
					//save axis
				}
			}
			//BODY B
			
			if(collision) {
				
			}
		}*/
	}//class
}