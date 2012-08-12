package engine.physics {
	import engine.geometry.Projection;
	import engine.util.Time;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import engine.geometry.Matrix2D;
	import engine.geometry.Vector2D;
	import flash.text.TextField;
	
	public class PhysicsSandbox extends Sprite {
		// Const
		
		// Var
		private var _iterations:int = 4;
		
		private var _dynamicBodies:Vector.<RigidBody> = new Vector.<RigidBody>();
		private var _staticBodies:Vector.<RigidBody> = new Vector.<RigidBody>();
		
		private var _lastUpdate:Number;
		
		private var _quadtrees:Quadtrees;
		
		private var _staticGraphics:Graphics;
		private var _dynamicGraphics:Graphics;
		
		private var _textField:TextField = new TextField();
		// Constructor
		
		public function PhysicsSandbox() {
			super.addChild(_textField);
			_textField.text = "test";
			
			var temp:Sprite = new Sprite();
			super.addChild(temp);
			temp.cacheAsBitmap = true;
			temp.mouseEnabled = temp.mouseChildren = false;
			_staticGraphics = temp.graphics;
			
			temp = new Sprite();
			super.addChild(temp);
			
			_dynamicGraphics = temp.graphics;
			
			
			
			_quadtrees = new Quadtrees(_staticGraphics);
			super.mouseEnabled = false;
		}
		
		// Public
		
		public function run():void {
			this._lastUpdate = Time.time;
			super.addEventListener(Event.ENTER_FRAME, this.enterFrameEventListener);
		}
		
		public function stop():void {
			super.removeEventListener(Event.ENTER_FRAME, this.enterFrameEventListener);
		}
		
		public function addRigidBody(rigidBody:RigidBody):void {
			rigidBody.init(this._quadtrees);
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
			this._dynamicGraphics.clear();//clear debug graphics
			super.graphics.clear();
			
			var dt:Number = Time.time - this._lastUpdate;
			this._lastUpdate = Time.time;
			
			_textField.text = "fps: " + Math.round(1 / dt);
			
			var dynamicsNum:int = this._dynamicBodies.length;
			var staticsNum:int = this._staticBodies.length;
			//
			var ddt:Number = dt / this._iterations;
			for (var i:int = 0; i < this._iterations; i++) {
				//physics update
				//
				for (var j:int = 0; j < dynamicsNum; j++) {
					var rigidBody:RigidBody = this._dynamicBodies[j];
					rigidBody.physicsUpdate(ddt);
					//rigidBody.quadtreeVisible = true;
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
				
				for (j = 0; j < dynamicsNum; j++) {
					rigidBody = this._dynamicBodies[j];
					rigidBody.quadtreeVisible = false;
					
					var cells:Vector.<Cell> = _quadtrees.getCellsNearBody(rigidBody);
					for (var q:int = 0; q < cells.length; q++) {
						var cell:Cell = cells[q];
						//cell.draw(super.graphics);
						var bodies:Vector.<RigidBody> = cell.rigidBodies;
						var length:int = bodies.length;
						for (var p:int = 0; p < length; p++) {
							if(rigidBody != bodies[p]) this.checkCollision(rigidBody, bodies[p]);
						}
					}
				}
				
				for (j = 0; j < dynamicsNum; j++) {
					rigidBody = this._dynamicBodies[j];
					rigidBody.repush();
				}
				for (var j:int = 0; j < staticsNum; j++) {
					rigidBody = this._staticBodies[j];
					rigidBody.repush();
				}
			
				
			}
			//
			//draw debug graphics
			for (j = 0; j < dynamicsNum; j++) {
					rigidBody = this._dynamicBodies[j];
					rigidBody.debug(this._dynamicGraphics);
			}
			for (j = 0; j < staticsNum; j++) {
					rigidBody = this._staticBodies[j];
					rigidBody.debug(this._dynamicGraphics);
			}
			
			//stop();
			
		}
		
		private function checkCollision(bodyA:RigidBody, bodyB:RigidBody):void {
			//_dynamicGraphics.lineStyle(1.0, 0xFF0000, 1);
			//_dynamicGraphics.moveTo(bodyA.xPosition, bodyA.yPosition);
			//_dynamicGraphics.lineTo(bodyB.xPosition, bodyB.yPosition);
			
			if (bodyA.bounds.collide(bodyB.bounds)) {
				trace("WTF");
				//_dynamicGraphics.lineStyle(4.0, 0xFF0000, 1);
				//_dynamicGraphics.moveTo(bodyA.xPosition, bodyA.yPosition);
				//_dynamicGraphics.lineTo(bodyB.xPosition, bodyB.yPosition);
				
				//bodyA.bounds.draw(super.graphics, 2.0, 0xFF0000, 0.5, 0xFF0000, 0.1);//draw debug graphics
				//bodyB.bounds.draw(super.graphics, 2.0, 0xFF0000, 0.5, 0xFF0000, 0.1);//draw debug graphics
				
				
				//step2
				
				//SAT
				pvpCollision(bodyA, bodyB);
				
				
				
			}//
		}
		
		//polygon versus polygon
		private function pvpCollision(bodyA:RigidBody, bodyB:RigidBody):void {
			
				
			var projectionDistance:Number = Number.MAX_VALUE;
			var mtv:Vector2D;
			
			var collidingA:RigidBody;
			var collidingB:RigidBody;
			
			//BODY A
			var matrix:Matrix2D = bodyA.matrix;
			
			var edges:Vector.<Vector2D> = bodyA.collisionGeometry.edges;
			
			var length:int = edges.length;
			for(var i:int = 0; i < length; i++) {
				var edge:Vector2D = matrix.transformVector2D(edges[i]);
				var axis:Vector2D = edge.normal;
				axis.normalize();
				
				
				var projectionA:Projection = new Projection(axis, bodyA)
				var projectionB:Projection = new Projection(axis, bodyB)
				
				var distance:Number = projectionA.distance(projectionB);
				
				if (distance > 0) {
					return;
				} else {
					distance = -distance;
				}
				
				
				if(distance < projectionDistance) {
					projectionDistance = distance;
					mtv = axis;
					
					if (projectionA.isFurther(projectionB)) {
						collidingA = bodyB;
						collidingB = bodyA;
					} else {
						collidingA = bodyA;
						collidingB = bodyB;
					}
				}
			}
			
			//BODY B
			matrix = bodyB.matrix;
			
			edges = bodyB.collisionGeometry.edges;
			
			var length = edges.length;
			for(var i = 0; i < length; i++) {
				edge = matrix.transformVector2D(edges[i]);
				axis = edge.normal;
				axis.normalize();
				
				
				projectionA = new Projection(axis, bodyA)
				projectionB = new Projection(axis, bodyB)
				
				distance = projectionA.distance(projectionB);
				
				if (distance > 0) {
					return;
				} else {
					distance = -distance;
				}
				
				
				if(distance < projectionDistance) {
					projectionDistance = distance;
					mtv = axis;
					
					if (projectionA.isFurther(projectionB)) {
						collidingA = bodyB;
						collidingB = bodyA;
					} else {
						collidingA = bodyA;
						collidingB = bodyB;
					}
				}
			}
			
			//collision = true
			
			//_dynamicGraphics.lineStyle(10.0, 0xFF0000, 1);
			//_dynamicGraphics.moveTo(bodyA.xPosition, bodyA.yPosition);
			//_dynamicGraphics.lineTo(bodyB.xPosition, bodyB.yPosition);
			
			
			new Collision(mtv, projectionDistance, collidingA, collidingB);
			
			
			
		}
	}//class
}