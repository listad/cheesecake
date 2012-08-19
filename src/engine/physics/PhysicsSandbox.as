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
				var actives:Vector.<RigidBody> = new Vector.<RigidBody>();
				
				for (var j:int = 0; j < dynamicsNum; j++) {
					var rigidBody:RigidBody = this._dynamicBodies[j];
					rigidBody.quadtreeVisible = true;
					rigidBody.change = false;
					
					if(rigidBody.sleeps == false) {
						rigidBody.physicsUpdate(ddt);
						actives.push(rigidBody);
					}
				}
				////collisions, without quadtrees
				//for (j = 0; j < dynamicsNum; j++) {
				//	//other dynamics
				//	for (var q:int = j + 1; q < dynamicsNum; q++) {
				//		this.checkCollision(this._dynamicBodies[j], this._dynamicBodies[q]);
				//	}
				//	//all statics
				//	for (var q:int = 0; q < staticsNum; q++) {
				//		this.checkCollision(this._dynamicBodies[j], this._staticBodies[q]);
				//	}
				//	
				//}
				
				var activesNum:int = actives.length;
				for (j = 0; j < activesNum; j++) {
					rigidBody = actives[j];
					rigidBody.quadtreeVisible = false;
					
					var cells:Vector.<Cell> = _quadtrees.getCellsNearBody(rigidBody);
					for (var q:int = 0; q < cells.length; q++) {
						var cell:Cell = cells[q];
						//cell.draw(super.graphics);
						var bodies:Vector.<RigidBody> = cell.rigidBodies;
						var length:int = bodies.length;
						for (var p:int = 0; p < length; p++) {
							if(bodies[p].quadtreeVisible) this.checkCollision(rigidBody, bodies[p]);
						}
					}
				}
				
				for (j = 0; j < dynamicsNum; j++) {
					rigidBody = this._dynamicBodies[j];
					if(rigidBody.change) rigidBody.repush();
				}
				//for (j = 0; j < staticsNum; j++) {
				//	rigidBody = this._staticBodies[j];
				//	rigidBody.repush();
				//}
			
				
			}
			//
			//draw debug graphics
			for (j = 0; j < dynamicsNum; j++) {
					rigidBody = this._dynamicBodies[j];
					rigidBody.debug(this._dynamicGraphics);
			}
			//for (j = 0; j < staticsNum; j++) {
			//		rigidBody = this._staticBodies[j];
			//		rigidBody.debug(this._dynamicGraphics);
			//}
			
			//stop();
			
		}
		
		private function checkCollision(bodyA:RigidBody, bodyB:RigidBody):void {
			//_dynamicGraphics.lineStyle(1.0, 0xFF0000, 1);
			//_dynamicGraphics.moveTo(bodyA.xPosition, bodyA.yPosition);
			//_dynamicGraphics.lineTo(bodyB.xPosition, bodyB.yPosition);
			
			if (bodyA.bounds.collide(bodyB.bounds)) {
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
			
			var projA:Projection;//test
			var projB:Projection;//test
			var index:int;
			
			var collidingA:RigidBody;
			var collidingB:RigidBody;
			
			//BODY A
			var matrix:Matrix2D = bodyA.matrix;
			
			var edges:Vector.<Vector2D> = bodyA.collisionGeometry.globalEdges//edges;
			
			var length:int = edges.length;
			for(var i:int = 0; i < length; i++) {
				var edge:Vector2D = edges[i]////matrix.transformVector2D(edges[i]);
				var axis:Vector2D = edge.perp;
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
					projA = projectionA;//test
					projB = projectionB;//test
					index = 1;
					
					if (projectionA.isFurther(projectionB)) {
						projA = projectionB;//test
						projB = projectionA;//test
						collidingA = bodyB;
						collidingB = bodyA;
					} else {
						collidingA = bodyA;
						collidingB = bodyB;
						projA = projectionA;//test
						projB = projectionB;//test
					}
				}
			}
			
			//BODY B
			matrix = bodyB.matrix;
			
			edges = bodyB.collisionGeometry.globalEdges;
			
			var length = edges.length;
			for(var i = 0; i < length; i++) {
				edge = edges[i];//matrix.transformVector2D(edges[i]);
				axis = edge.perp;
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
					
					index = 2;
					
					if (projectionA.isFurther(projectionB)) {
						projA = projectionB;//test
						projB = projectionA;//test
						collidingA = bodyB;
						collidingB = bodyA;
					} else {
						collidingA = bodyA;
						collidingB = bodyB;
						projA = projectionA;//test
						projB = projectionB;//test
					}
				}
			}
			
			//collision = true
			
			//_dynamicGraphics.lineStyle(10.0, 0xFF0000, 1);
			//_dynamicGraphics.moveTo(bodyA.xPosition, bodyA.yPosition);
			//_dynamicGraphics.lineTo(bodyB.xPosition, bodyB.yPosition);
			
			
			//new Collision(mtv, projectionDistance, collidingA, collidingB);
			
			
			
			
			var points:Vector.<Vector2D> = projA.minVertices;
			//for (i = 0; i < points.length; i++) {
			//	points[i].drawGlobal(this._dynamicGraphics, 6, 1.0, 0xFF0000);
			//}
			
			//points = projB.maxVertices;
			//for (i = 0; i < points.length; i++) {
			//	points[i].drawGlobal(this._dynamicGraphics, 6, 1.0, 0x00FF00);
			//}
			
			
			var masssum:Number = collidingA.mass + collidingB.mass;
			
			
			var collidingARatio:Number = 2 * projectionDistance * (1.0 - collidingA.mass / masssum);
			var collidingBRatio:Number = 2 * projectionDistance * (1.0 - collidingB.mass / masssum);
			
			collidingA.position = collidingA.position.add( Vector2D.scale(mtv, collidingARatio)  );
			collidingB.position = collidingB.position.add( Vector2D.scale(mtv, -collidingBRatio)  );
			
			var vertex:Vector2D;
			
			if (projA.maxVertices.length == 1) {
				vertex = projA.minVertices[0];
			} else {
				vertex = projB.maxVertices[0];
			}
			
			vertex.drawGlobal(this._dynamicGraphics, 6, 1.0, 0xFF0000);
			
			var m1:Number = collidingA.mass;
			var m2:Number = collidingB.mass;
			var u1:Vector2D = collidingA.getVelocityAtPoint( Vector2D.subtract(vertex, collidingA.position) );
			var u2:Vector2D = collidingB.getVelocityAtPoint( Vector2D.subtract(vertex, collidingB.position) );
			
			var v1:Vector2D = Vector2D.scale(u1, m1 - m2).add( Vector2D.scale(u2, 2 * m2)  );
			v1.divide(m1 + m2);
			
			var v2:Vector2D = Vector2D.scale(u2, m2 - m1).add( Vector2D.scale(u1, 2 * m1)  );
			v2.divide(m1 + m2);
			
			collidingA.xVelocity = collidingA.yVelocity = collidingA.angularVelocity = 0;
			collidingA.addImpulseAtPoint(v1, Vector2D.subtract(vertex, collidingA.position));
			
			collidingB.xVelocity = collidingB.yVelocity = collidingB.angularVelocity = 0;
			collidingB.addImpulseAtPoint(v2, Vector2D.subtract(vertex, collidingB.position));
			
		}
	}//class
}