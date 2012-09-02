package engine {
	
	import engine.geometry.Projection;
	import engine.geometry.Vector2D;
	import engine.physics.Collider;
	import engine.physics.CollisionMatrix;
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
						if (rigidbody.collider) {
							rigidbody.collider.invalidate();// -> invalidate collider
							rigidbody.collider.quadcell = rigidbody.collider.quadcell.repush(rigidbody.collider);//обернуть в нормальную ф-цию
							//debug:
							rigidbody.collider.quadcell.draw(this._dynamicGraphics, 2.0, 0x005500, 0.05, 0x005500, 0.01);
						}
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
			//trace("resolveCollisions");
			// -> unhide all colliders
			var dynamicsNum:int = this._dynamicColliders.length;
			for (var i:int = 0; i < dynamicsNum; i++) {
				var colliderA:Collider = this._dynamicColliders[i];
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
			
			for (var i:int = 0; i < dynamicsNum; i++) {//fixme
				colliderA = this._dynamicColliders[i];
				colliderA.quadtreeVisible = true;
			}
		}
		
		public function coarseCollision(colliderA:Collider, colliderB:Collider):void {//COARSE
			if (colliderA.bounds.collide(colliderB.bounds)) {		
				switch(colliderA.type | colliderB.type) {
					case CollisionMatrix.POLYGON_VS_POLYGON:
						pvpCollision(colliderA, colliderB);
						break;
					case CollisionMatrix.POLYGON_VS_CIRCLE:
						break;
					case CollisionMatrix.CIRCLE_VS_CIRCLE:
						break;
					default:
						break;
				}
				
			}
			//bounds VS bounds
				//1. polygon VS polygon
				//2. circle VS polygon || polygon VS circle
				//3. circle VS circle
		}
		
		private function pvpCollision(colliderA:Collider, colliderB:Collider):void {//REAL
			var projectionDistance:Number = Number.MAX_VALUE;
			
			var minimumTranslationVector:Vector2D;
			
			var projA:Projection;//test
			var projB:Projection;//test
			
			var collidingA:Collider;
			var collidingB:Collider;
			
			
			
			var edgesA:Vector.<Vector2D> = colliderA.globalEdges;
			var edgesB:Vector.<Vector2D> = colliderB.globalEdges;
			var edgesANum:int = edgesA.length;
			var edgesBNum:int = edgesB.length;
			var edgesNum:int = edgesANum + edgesBNum;
			
			
			
			
			for (var i:int = 0; i < edgesNum; i++) {
				if (i < edgesANum) {
					var edge:Vector2D = edgesA[i];
				} else {
					edge = edgesB[int(i - edgesANum)];
				}
				
				var axis:Vector2D = edge.perp;
				axis.normalize();
				
				
				var projectionA:Projection = new Projection(axis, colliderA)
				var projectionB:Projection = new Projection(axis, colliderB)
				
				var distance:Number = projectionA.distance(projectionB);
				
				if (distance > 0) {
					return;
				} else {
					distance = -distance;
				}
				
				
				if(distance < projectionDistance) {
					projectionDistance = distance;
					minimumTranslationVector = axis;
					
					
					if (projectionA.isFurther(projectionB)) {
						collidingA = colliderB;//?
						collidingB = colliderA;//?
						projA = projectionB;//test
						projB = projectionA;//test
					} else {
						collidingA = colliderA;//?
						collidingB = colliderB;//?
						projA = projectionA;//test
						projB = projectionB;//test
					}
				}
			}
			
			
					
			var masssum:Number = Infinity;
			if(collidingA.rigidBody && collidingB.rigidBody) masssum = collidingA.rigidBody.mass + collidingB.rigidBody.mass;
			
			
			var collidingARatio:Number = 0.0;
			var collidingBRatio:Number = 0.0;
			if (collidingA.rigidBody) collidingARatio = projectionDistance * (1.0 - collidingA.rigidBody.mass / masssum);
			if (collidingB.rigidBody) collidingBRatio = projectionDistance * (1.0 - collidingB.rigidBody.mass / masssum);
			
			collidingA.state.x += minimumTranslationVector.x * collidingARatio;
			collidingA.state.y += minimumTranslationVector.y * collidingARatio;
			collidingB.state.x -= minimumTranslationVector.x * collidingBRatio;
			collidingB.state.y -= minimumTranslationVector.y * collidingBRatio;
			
			var contact:Vector2D;
			if (projA.maxVertices.length > 1) contact = projB.maxVertices[0];
			else contact = projA.minVertices[0];
			
			
			
			
			this.collisionResponse(collidingA, collidingB, minimumTranslationVector, contact);
			
		}
		
		public function collisionResponse(colliderA:Collider, colliderB:Collider, normal:Vector2D, contact:Vector2D):void {//RESPONSE
			var bodyAinverseMass:Number = 0.0;
			var bodyBinverseMass:Number = 0.0;
			var bodyAinverseInertiaTensor:Number = 0.0;
			var bodyBinverseInertiaTensor:Number = 0.0;
			var bodyAangularVelocity:Number = 0.0;
			var bodyBangularVelocity:Number = 0.0;
			var bodyAvelocity:Vector2D = new Vector2D();
			var bodyBvelocity:Vector2D = new Vector2D();
			if (colliderA.rigidBody) {
				bodyAinverseMass = colliderA.rigidBody.inverseMass;
				bodyAinverseInertiaTensor = colliderA.rigidBody.inverseInertiaTensor;
				bodyAangularVelocity = colliderA.rigidBody.angularVelocity;
				bodyAvelocity = colliderA.rigidBody.velocity;
			}
			if (colliderB.rigidBody) {
				bodyBinverseMass = colliderB.rigidBody.inverseMass;
				bodyBinverseInertiaTensor = colliderB.rigidBody.inverseInertiaTensor;
				bodyBangularVelocity = colliderB.rigidBody.angularVelocity;
				bodyBvelocity = colliderB.rigidBody.velocity;
			}
			
			var inverseMassSum:Number = bodyAinverseMass + bodyBinverseMass;
			
			var contactA:Vector2D = Vector2D.subtract( contact, colliderA.state.position );
			var contactB:Vector2D = Vector2D.subtract( contact, colliderB.state.position );
			
			var contactPerpindicularA:Vector2D = contactA.perp;
			var contactPerpindicularB:Vector2D = contactB.perp;
			
			var contactPerpindicularDotA:Number = contactPerpindicularA .dot( normal );
			var contactPerpindicularDotB:Number = contactPerpindicularB .dot( normal );
			
			var denominator:Number = normal.dot( Vector2D.scale( normal , inverseMassSum) );
			denominator += contactPerpindicularDotA * contactPerpindicularDotA * bodyAinverseInertiaTensor;
			denominator += contactPerpindicularDotB * contactPerpindicularDotB * bodyBinverseInertiaTensor;
			
			var velocityAtContactA:Vector2D = Vector2D.scale( contactPerpindicularA , bodyAangularVelocity ) .add( bodyAvelocity );
			var velocityAtContactB:Vector2D = Vector2D.scale( contactPerpindicularB , bodyBangularVelocity ) .add( bodyBvelocity );
			var relativeVelocity:Vector2D = velocityAtContactA .subtract( velocityAtContactB );
			
			var relativeVelocityNormDot:Number = relativeVelocity .dot( normal );
			
			var elasticity:Number = 1.0 + ( colliderA.material.elasticity + colliderB.material.elasticity ) * 0.5;
			
			var impulse:Number = elasticity * relativeVelocityNormDot / denominator;
			
			var dlvA:Vector2D = Vector2D.scale( normal , -impulse * bodyAinverseMass );
			var davA:Number = contactPerpindicularA .dot ( Vector2D.scale( normal, -impulse ) ) * bodyAinverseInertiaTensor;
			var dlvB:Vector2D = Vector2D.scale( normal , impulse * bodyBinverseMass );
			var davB:Number = contactPerpindicularB .dot ( Vector2D.scale( normal, impulse ) ) * bodyBinverseInertiaTensor;
			

			//FRICTION:
			var friction:Number = ( colliderA.material.friction + colliderB.material.friction ) * 0.5;
			if(friction > 0.0) {
				var tangent:Vector2D = normal.perp;
				
				var contactPerpTangentDotA:Number = contactPerpindicularA .dot( tangent );
				var contactPerpTangentDotB:Number = contactPerpindicularB .dot( tangent );
				
				denominator = tangent.dot( Vector2D.scale( tangent, inverseMassSum ) ); 
				denominator += contactPerpTangentDotA * contactPerpTangentDotA * bodyAinverseInertiaTensor + contactPerpTangentDotB * contactPerpTangentDotB * bodyBinverseInertiaTensor;
				
				var rvTangent:Number = relativeVelocity.dot( tangent );
				
				impulse = -rvTangent / denominator * friction;
				
				dlvA.add(Vector2D.scale( tangent, impulse * bodyAinverseMass ));
				davA += contactPerpindicularA .dot( Vector2D.scale( tangent, impulse ) ) * bodyAinverseInertiaTensor;
				dlvB.add(Vector2D.scale( tangent, -impulse * bodyBinverseMass ));
				davB += contactPerpindicularB .dot( Vector2D.scale( tangent, -impulse ) ) * bodyBinverseInertiaTensor;
			}
			
			//APPLY:  
			if(colliderA.rigidBody) {
				colliderA.rigidBody.xVelocity += dlvA.x;
				colliderA.rigidBody.yVelocity += dlvA.y;
				colliderA.rigidBody.angularVelocity += davA;
			}
			if (colliderB.rigidBody) {
				colliderB.rigidBody.xVelocity += dlvB.x;
				colliderB.rigidBody.yVelocity += dlvB.y;
				colliderB.rigidBody.angularVelocity += davB;
			}
			
		}
	}
}