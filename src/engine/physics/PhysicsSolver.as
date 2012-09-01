package engine.physics {
	import engine.geometry.Projection;
	import engine.util.Time;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import engine.geometry.Matrix2D;
	import engine.geometry.Vector2D;
	import flash.text.TextField;
	
	public class PhysicsSolver extends Sprite {
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
		
		public function PhysicsSolver() {
			super.addChild(_textField);
			//_textField.text = "test";
			
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
			
			this.run();
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
			//dt = 1 / 60;
			if (dt == 0) return;
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
			if (bodyA.bounds.collide(bodyB.bounds)) {
				//bodyA.bounds.draw(super.graphics, 1.0, 0x330000, 0.02, 0xFF0000, 0.0);//draw debug graphics
				//bodyB.bounds.draw(super.graphics, 1.0, 0x330000, 0.02, 0xFF0000, 0.0);//draw debug graphics
				this.pvpCollision(bodyA, bodyB);
			}
		}
		
		//polygon versus polygon
		private function pvpCollision(bodyA:RigidBody, bodyB:RigidBody):void {
			
			var projectionDistance:Number = Number.MAX_VALUE;
			var mtv:Vector2D;
			
			var projA:Projection;//test
			var projB:Projection;//test
			
			var collidingA:RigidBody;
			var collidingB:RigidBody;
			
			//
			
			var edgesA:Vector.<Vector2D> = bodyA.collisionGeometry.globalEdges;
			var edgesB:Vector.<Vector2D> = bodyB.collisionGeometry.globalEdges;
			var edgesANum:int = edgesA.length;
			var edgesBNum:int = edgesB.length;
			var edgesNum:int = edgesANum + edgesBNum;
			
			
			
			//var length:int = edgesA.length;
			for (var i:int = 0; i < edgesNum; i++) {
				if (i < edgesANum) {
					var edge:Vector2D = edgesA[i];
				} else {
					edge = edgesB[i - edgesANum];
				}
				
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
					
					
					if (projectionA.isFurther(projectionB)) {
						collidingA = bodyB;
						collidingB = bodyA;
						projA = projectionB;//test
						projB = projectionA;//test
					} else {
						collidingA = bodyA;
						collidingB = bodyB;
						projA = projectionA;//test
						projB = projectionB;//test
					}
				}
			}
			
			
			
			//var points:Vector.<Vector2D> = projA.minVertices;
			//for (i = 0; i < points.length; i++) {
			//	points[i].drawGlobal(this._dynamicGraphics, 6, 1.0, 0xFF0000);
			//}
			
			//points = projB.maxVertices;
			//for (i = 0; i < points.length; i++) {
			//	points[i].drawGlobal(this._dynamicGraphics, 6, 1.0, 0x00FF00);
			//}
			
			
			var masssum:Number = collidingA.mass + collidingB.mass;
			
			
			var collidingARatio:Number = projectionDistance * (1.0 - collidingA.mass / masssum);
			var collidingBRatio:Number = projectionDistance * (1.0 - collidingB.mass / masssum);
			
			collidingA.position = collidingA.position.add( Vector2D.scale(mtv, collidingARatio) );
			collidingB.position = collidingB.position.add( Vector2D.scale(mtv, -collidingBRatio) );
			
			//fixme. contact += mtv * collidingARatio
			
			var contact:Vector2D;
			
			if (projA.maxVertices.length > 1) contact = projB.maxVertices[0];
			else contact = projA.minVertices[0];
			
			//contact.drawGlobal(this._dynamicGraphics, 6, 1.0, 0xFF0000);
			
			var normal:Vector2D = mtv;
			
			
				var inverseMassSum:Number = bodyA.inverseMass + bodyB.inverseMass;
			///*
			var contactA:Vector2D = Vector2D.subtract( contact, bodyA.position );
			var contactB:Vector2D = Vector2D.subtract( contact, bodyB.position );
			
			var contactPerpindicularA:Vector2D = contactA.perp;
			var contactPerpindicularB:Vector2D = contactB.perp;
			
			var contactPerpindicularDotA:Number = contactPerpindicularA .dot( normal );
			var contactPerpindicularDotB:Number = contactPerpindicularB .dot( normal );
			
			var denominator:Number = normal.dot( Vector2D.scale( normal , inverseMassSum) );
			denominator += contactPerpindicularDotA * contactPerpindicularDotA * bodyA.inverseInertiaTensor;
			denominator += contactPerpindicularDotB * contactPerpindicularDotB * bodyB.inverseInertiaTensor;
			
			var velocityAtContactA:Vector2D = Vector2D.scale( contactPerpindicularA , bodyA.angularVelocity ) .add( bodyA.velocity );
			var velocityAtContactB:Vector2D = Vector2D.scale( contactPerpindicularB , bodyB.angularVelocity ) .add( bodyB.velocity );
			var relativeVelocity:Vector2D = velocityAtContactA .subtract( velocityAtContactB );
			
			var relativeVelocityNormDot:Number = relativeVelocity .dot( normal );
			
			var elasticity:Number = 1.0 + ( bodyA.elasticity + bodyB.elasticity ) * 0.5;
			
			var impulse:Number = elasticity * relativeVelocityNormDot / denominator;
			
			var dlvA:Vector2D = Vector2D.scale( normal , -impulse * bodyA.inverseMass );
			var davA:Number = contactPerpindicularA .dot ( Vector2D.scale( normal, -impulse ) ) * bodyA.inverseInertiaTensor;
			var dlvB:Vector2D = Vector2D.scale( normal , impulse * bodyB.inverseMass );
			var davB:Number = contactPerpindicularB .dot ( Vector2D.scale( normal, impulse ) ) * bodyB.inverseInertiaTensor;
			//*/

			//FRICTION:
			///*
			var friction:Number = ( bodyA.friction + bodyB.friction ) * 0.5;
			if(friction > 0.0) {
				var tangent:Vector2D = mtv.perp;
				
				var contactPerpTangentDotA:Number = contactPerpindicularA .dot( tangent );
				var contactPerpTangentDotB:Number = contactPerpindicularB .dot( tangent );
				
				denominator = tangent.dot( Vector2D.scale( tangent, inverseMassSum ) ); 
				denominator += contactPerpTangentDotA * contactPerpTangentDotA * bodyA.inverseInertiaTensor + contactPerpTangentDotB * contactPerpTangentDotB * bodyB.inverseInertiaTensor;
				
				var rvTangent:Number = relativeVelocity.dot( tangent );
				
				impulse = -rvTangent / denominator * friction;
				
				dlvA.add(Vector2D.scale( tangent, impulse * bodyA.inverseMass ));
				davA += contactPerpindicularA .dot( Vector2D.scale( tangent, impulse ) ) * bodyA.inverseInertiaTensor;
				dlvB.add(Vector2D.scale( tangent, -impulse * bodyB.inverseMass ));
				davB += contactPerpindicularB .dot( Vector2D.scale( tangent, -impulse ) ) * bodyB.inverseInertiaTensor;
			}
			
			//APPLY:
			
			bodyA.xVelocity += dlvA.x;
			bodyA.yVelocity += dlvA.y;
			bodyA.angularVelocity += davA;
			
			bodyB.xVelocity += dlvB.x;
			bodyB.yVelocity += dlvB.y;
			bodyB.angularVelocity += davB;

			
		}
	}//class
}