package engine {
	import engine.physics.Collider;
	import engine.geometry.Projection;
	import engine.geometry.Vector2D;
	import engine.physics.RigidBody;
	import engine.physics.State;
	import flash.display.Graphics;
	import engine.physics.CollisionMatrix;
	import engine.physics.ColliderType;
	import engine.physics.PhysicsMaterial;
	
	
	public class Collision {
		public static const EPSILON:Number = 0.0001;
		
		public var _trigger:Boolean;
		
		// collision detection
		
		private var _colliderA:Collider;
		private var _colliderB:Collider;
		private var _stateA:State;
		private var _stateB:State;
		
		private var _minimumTranslationVector_x:Number;
		private var _minimumTranslationVector_y:Number;
		private var _projectionDistance:Number;
		
		// collision resolve
		
		private var _rigidbodyA:RigidBody;
		private var _rigidbodyB:RigidBody;
		private var _bodyAinverseMass:Number;
		private var _bodyBinverseMass:Number;
		private var _inverseMassSumm:Number;
			
			
		private var _penetration_x:Number;
		private var _penetration_y:Number;
		private var _contact_x:Number;
		private var _contact_y:Number;
		
		// collision response
		
		//__
		private var __projectionA:Projection = new Projection();
		private var __projectionB:Projection = new Projection();
		
		//debug:
		private var _staticGraphics:Graphics;
		private var _dynamicGraphics:Graphics;
		
		public function Collision(staticGraphics:Graphics, dynamicGraphics:Graphics) {
			this._staticGraphics = staticGraphics;
			this._dynamicGraphics = dynamicGraphics;
		}
		
		internal function collision(colliderA:Collider, colliderB:Collider):void {
			this._colliderA = colliderA;
			this._colliderB = colliderB;
			this._trigger = this._colliderA.isTrigger || this._colliderB.isTrigger;
			
			switch(colliderA.type | colliderB.type) {
				case CollisionMatrix.POLYGON_VS_POLYGON:
					this.pvpCollision();
					break;
				case CollisionMatrix.POLYGON_VS_CIRCLE:
					this.pvcCollision();
					break;
				case CollisionMatrix.CIRCLE_VS_CIRCLE:
					this.cvcCollision();
					break;
				default:
					break;
			}
		}
		
		
		internal function pvpCollision():void {
			this._projectionDistance = Number.MAX_VALUE;
			
			
			var edgesA:Vector.<Vector2D> = this._colliderA.globalEdges;
			var edgesB:Vector.<Vector2D> = this._colliderB.globalEdges;
			var edgesANum:int = edgesA.length;
			var edgesBNum:int = edgesB.length;
			var edgesNum:int = edgesANum + edgesBNum;
			var swap:Boolean = false;
			var contact_v:int = 0;//test
			for (var i:int = 0; i < edgesNum; i++) {
				if (i < edgesANum) {
					var edge:Vector2D = edgesA[i];
				} else {
					edge = edgesB[int(i - edgesANum)];
				}
				
				var axis_x:Number = -edge.y;
				var axis_y:Number = edge.x;
				var magnitude:Number = Math.sqrt(axis_x * axis_x + axis_y * axis_y);//fixit
				axis_x /= magnitude;
				axis_y /= magnitude;
				
				this.__projectionA.projectPolygon(axis_x, axis_y, this._colliderA.globalVertices)//fix
				this.__projectionB.projectPolygon(axis_x, axis_y, this._colliderB.globalVertices)
				var distance:Number = this.__projectionA.distance(this.__projectionB);
				if (distance > -0.001) {//epsilon
					return;
				} else {
					distance = -distance;
				}
				if(distance < this._projectionDistance) {
					this._projectionDistance = distance;
					this._minimumTranslationVector_x = axis_x;
					this._minimumTranslationVector_y = axis_y;
					
					if(!this._trigger) {
					//определяем точку контакта и направление MTV относительно двух тел
						if (this.__projectionA.isFurther(this.__projectionB)) {
							swap = true;
							if(this.__projectionB.maxContactsNum > 1) {
								this._contact_x = this.__projectionA.maxVertex_x;
								this._contact_y = this.__projectionA.maxVertex_y;
								contact_v = 1;//test
							} else {
								this._contact_x = this.__projectionB.minVertex_x;
								this._contact_y = this.__projectionB.minVertex_y;
								contact_v = 2;//test
							}
						} else {
							swap = false;
							if(this.__projectionA.maxContactsNum > 1) {
								this._contact_x = this.__projectionB.maxVertex_x;
								this._contact_y = this.__projectionB.maxVertex_y;
								contact_v = 2;//test
							} else {
								this._contact_x = this.__projectionA.minVertex_x;
								this._contact_y = this.__projectionA.minVertex_y;
								contact_v = 1;//test
							}
						}
					
					}
				}
			}
			
			if(this._trigger) {
				return;
			}
			
			if(swap) {
				if(contact_v == 2) contact_v = 1; else contact_v = 2;//fixme//test
				var temp:Collider = this._colliderA;
				this._colliderA = this._colliderB;
				this._colliderB = temp;
			}
			this._stateA = this._colliderA.state;
			this._stateB = this._colliderB.state;
			
			collisionResolve();
			
			if(contact_v == 1) {//fixme//test
				this._contact_x += this._penetration_x * this._bodyAinverseMass;
				this._contact_y += this._penetration_y * this._bodyAinverseMass;
			} else {
				this._contact_x -= this._penetration_x * this._bodyBinverseMass;
				this._contact_y -= this._penetration_y * this._bodyBinverseMass;
			}
			
			this.collisionResponse();
		}
		
		
		internal function pvcCollision():void {
			if(this._colliderA.type == ColliderType.CIRCLE) {
				var temp:Collider = this._colliderA;
				this._colliderA = this._colliderB;
				this._colliderB = temp;
			}
			
			this._projectionDistance = Number.MAX_VALUE;
			this._stateA = this._colliderA.state;
			this._stateB = this._colliderB.state;
			
			var centerB_x:Number = this._stateB.x;
			var centerB_y:Number = this._stateB.y;
			var radiusB:Number = _colliderB.radius;
			
			//
			
			var edgesA:Vector.<Vector2D> = this._colliderA.globalEdges;
			var edgesANum:int = edgesA.length;
			
			for (var i:int = 0; i < edgesANum; i++) {
				var edge:Vector2D = edgesA[i];
				
				var axis_x:Number = -edge.y;
				var axis_y:Number = edge.x;
				var imagnitude:Number = 1.0 / Math.sqrt(axis_x * axis_x + axis_y * axis_y);//FIXME
				axis_x *= imagnitude;
				axis_y *= imagnitude;
				
				this.__projectionA.projectPolygon(axis_x, axis_y, this._colliderA.globalVertices);
				this.__projectionB.projectCircle(axis_x, axis_y, centerB_x, centerB_y, radiusB);
				
				var distance:Number = this.__projectionB.distance(this.__projectionA);
				
				if (distance > 0) return;
				else distance = -distance;
				
				if(distance < this._projectionDistance) {
					this._projectionDistance = distance;
					this._minimumTranslationVector_x = axis_x;
					this._minimumTranslationVector_y = axis_y;
				}
				
			}
			
			//
			
			var nearest_x:Number;
			var nearest_y:Number;
			var distance_squared_min:Number = Number.MAX_VALUE;
			var verticesA:Vector.<Vector2D> = this._colliderA.globalVertices;
			var verticesANum:int = verticesA.length;
			for (i = 0; i < verticesANum; i++) {
				var vertex:Vector2D = verticesA[i];
				var diff_x:Number = vertex.x - centerB_x ;
				var diff_y:Number = vertex.y - centerB_y;
				var distance_squared:Number = diff_x * diff_x + diff_y * diff_y;
				if(distance_squared < distance_squared_min) {
					distance_squared_min = distance_squared;
					axis_x = diff_x;
					axis_y = diff_y;
				}
			}
			imagnitude = 1.0 / Math.sqrt(distance_squared_min);
			axis_x *= imagnitude;
			axis_y *= imagnitude;
			
			//
			
			this.__projectionA.projectPolygon(axis_x, axis_y, verticesA);
			this.__projectionB.projectCircle(axis_x, axis_y, centerB_x, centerB_y, radiusB);
			distance = this.__projectionA.distance(this.__projectionB);
			if (distance > 0) {
				return;
			} else {
				distance = - distance;
			}
			if(distance < this._projectionDistance) {
				this._projectionDistance = distance;
				this._minimumTranslationVector_x = axis_x;
				this._minimumTranslationVector_y = axis_y;
			}
			
			//
			
			
			var relativePosition_x:Number = _stateB.x - _stateA.x;
			var relativePosition_y:Number = _stateB.y - _stateA.y;
			if(relativePosition_x * this._minimumTranslationVector_x + relativePosition_y * this._minimumTranslationVector_y > 0.0) {
				this._minimumTranslationVector_x = - this._minimumTranslationVector_x;
				this._minimumTranslationVector_y = - this._minimumTranslationVector_y;
			} else {
				
			}
			
			this.collisionResolve();
			
			this._contact_x = this._stateB.x + this._minimumTranslationVector_x * radiusB;
			this._contact_y = this._stateB.y + this._minimumTranslationVector_y * radiusB;
			
			this.collisionResponse();
		}
		
		internal function cvcCollision():void {
			this._stateA = _colliderA.state;
			this._stateB = _colliderB.state;
			this._minimumTranslationVector_x = _stateA.x - _stateB.x;
			this._minimumTranslationVector_y = _stateA.y - _stateB.y;
			var distance_squared:Number = this._minimumTranslationVector_x * this._minimumTranslationVector_x + this._minimumTranslationVector_y * this._minimumTranslationVector_y;
			var contact_distance:Number = _colliderA.radius + _colliderB.radius;
			var contact_distance_squared:Number = contact_distance * contact_distance;
			
			if(distance_squared > contact_distance_squared) return;
			
			var distance:Number = Math.sqrt(distance_squared);
			this._minimumTranslationVector_x /= distance;
			this._minimumTranslationVector_y /= distance;
			
			this._projectionDistance = contact_distance - distance;
			
			this.collisionResolve();
			
			this._contact_x = _stateA.x - this._minimumTranslationVector_x * _colliderA.radius;
			this._contact_y = _stateA.y - this._minimumTranslationVector_y * _colliderA.radius;
			
			this.collisionResponse();
		}
		
		internal function collisionResolve():void {
			_rigidbodyA = _colliderA.rigidBody;
			_rigidbodyB = _colliderB.rigidBody;	
			if (_rigidbodyA) {
				_bodyAinverseMass = _rigidbodyA.inverseMass;
			} else {
				_bodyAinverseMass = 0.0;
			}
			if (_rigidbodyB) {
				_bodyBinverseMass = _rigidbodyB.inverseMass;
			} else {
				_bodyBinverseMass = 0.0;
			}
			_inverseMassSumm = _bodyAinverseMass + _bodyBinverseMass;
			_penetration_x = _minimumTranslationVector_x * _projectionDistance;
			_penetration_y = _minimumTranslationVector_y * _projectionDistance;
			_penetration_x /= _inverseMassSumm;
			_penetration_y /= _inverseMassSumm;
			_stateA.x += _penetration_x * _bodyAinverseMass;
			_stateA.y += _penetration_y * _bodyAinverseMass;
			_stateB.x -= _penetration_x * _bodyBinverseMass;
			_stateB.y -= _penetration_y * _bodyBinverseMass;
		}
		
		internal function collisionResponse():void {
			var bodyAinverseInertiaTensor:Number = 0.0;
			var bodyBinverseInertiaTensor:Number = 0.0;
			var bodyAangularVelocity:Number = 0.0;
			var bodyBangularVelocity:Number = 0.0;	
			var bodyAvelocityX:Number = 0.0;
			var bodyAvelocityY:Number = 0.0;
			var bodyBvelocityX:Number = 0.0;
			var bodyBvelocityY:Number = 0.0;
			var materialA:PhysicsMaterial = _colliderA.material;
			var materialB:PhysicsMaterial = _colliderB.material;
			if (_rigidbodyA) {
				bodyAinverseInertiaTensor = _rigidbodyA.inverseInertiaTensor;
				bodyAangularVelocity = _rigidbodyA.angularVelocity;			
				bodyAvelocityX = _rigidbodyA.xVelocity;
				bodyAvelocityY = _rigidbodyA.yVelocity;
			}
			if (_rigidbodyB) {
				bodyBinverseInertiaTensor = _rigidbodyB.inverseInertiaTensor;
				bodyBangularVelocity = _rigidbodyB.angularVelocity;			
				bodyBvelocityX = _rigidbodyB.xVelocity;
				bodyBvelocityY = _rigidbodyB.yVelocity;
			}
			var contactPerpindicularAx:Number = _stateA.y - _contact_y;
			var contactPerpindicularAy:Number = _contact_x - _stateA.x;
			var contactPerpindicularBx:Number = _stateB.y - _contact_y;
			var contactPerpindicularBy:Number = _contact_x - _stateB.x;			
			var contactPerpindicularDotA:Number = contactPerpindicularAx * _minimumTranslationVector_x + contactPerpindicularAy * _minimumTranslationVector_y;
			var contactPerpindicularDotB:Number = contactPerpindicularBx * _minimumTranslationVector_x + contactPerpindicularBy * _minimumTranslationVector_y;
			var denominator:Number = _inverseMassSumm * (_minimumTranslationVector_x * _minimumTranslationVector_x + _minimumTranslationVector_y * _minimumTranslationVector_y)
				+ contactPerpindicularDotA * contactPerpindicularDotA * bodyAinverseInertiaTensor
				+ contactPerpindicularDotB * contactPerpindicularDotB * bodyBinverseInertiaTensor;
			var velocityAtContactAx:Number = contactPerpindicularAx * bodyAangularVelocity + bodyAvelocityX;
			var velocityAtContactAy:Number = contactPerpindicularAy * bodyAangularVelocity + bodyAvelocityY;
			var velocityAtContactBx:Number = contactPerpindicularBx * bodyBangularVelocity + bodyBvelocityX;
			var velocityAtContactBy:Number = contactPerpindicularBy * bodyBangularVelocity + bodyBvelocityY;
			var relativeVelocityX:Number = velocityAtContactAx - velocityAtContactBx;
			var relativeVelocityY:Number = velocityAtContactAy - velocityAtContactBy;	
			var relativeVelocityNormDot:Number = relativeVelocityX * _minimumTranslationVector_x + relativeVelocityY * _minimumTranslationVector_y;
			var elasticity:Number = 1.0 + ( materialA.elasticity + materialB.elasticity ) * 0.5;
			var impulse:Number = elasticity * relativeVelocityNormDot / denominator;
			var k:Number = - impulse * _bodyAinverseMass;
			var dlvAx:Number = _minimumTranslationVector_x * k;
			var dlvAy:Number = _minimumTranslationVector_y * k;
			k = impulse * _bodyBinverseMass;
			var dlvBx:Number = _minimumTranslationVector_x * k;
			var dlvBy:Number = _minimumTranslationVector_y * k;
			var kx:Number = _minimumTranslationVector_x * impulse;
			var ky:Number = _minimumTranslationVector_y * impulse;
			var davA:Number = bodyAinverseInertiaTensor * (- contactPerpindicularAx * kx - contactPerpindicularAy * ky);
			var davB:Number = bodyBinverseInertiaTensor * (contactPerpindicularBx * kx + contactPerpindicularBy * ky);
			var friction:Number = ( materialA.friction + materialB.friction ) * 0.5;
			if(friction > 0.0) {
				var tangent_x:Number = - _minimumTranslationVector_y;
				var tangent_y:Number = _minimumTranslationVector_x;
				var contactPerpTangentDotA:Number = contactPerpindicularAx * tangent_x + contactPerpindicularAy * tangent_y;
				var contactPerpTangentDotB:Number = contactPerpindicularBx * tangent_x + contactPerpindicularBy * tangent_y;
				denominator = _inverseMassSumm * (tangent_x * tangent_x + tangent_y * tangent_y)
					+ contactPerpTangentDotA * contactPerpTangentDotA * bodyAinverseInertiaTensor
					+ contactPerpTangentDotB * contactPerpTangentDotB * bodyBinverseInertiaTensor;
				var rvTangent:Number = relativeVelocityX * tangent_x + relativeVelocityY * tangent_y;
				impulse = -rvTangent / denominator * friction;
				k = impulse * _bodyAinverseMass;
				dlvAx += tangent_x * k;
				dlvAy += tangent_y * k;
				k = - impulse * _bodyBinverseMass;
				dlvBx += tangent_x * k;
				dlvBy += tangent_y * k;
				kx = tangent_x * impulse;
				ky = tangent_y * impulse;
				davA += bodyAinverseInertiaTensor * (contactPerpindicularAx * kx + contactPerpindicularAy * ky);
				davB += bodyBinverseInertiaTensor * (- contactPerpindicularBx * kx - contactPerpindicularBy * ky);
			}
			if(_rigidbodyA) {
				_rigidbodyA.xVelocity += dlvAx;
				_rigidbodyA.yVelocity += dlvAy;
				_rigidbodyA.angularVelocity += davA;
			}
			if (_rigidbodyB) {
				_rigidbodyB.xVelocity += dlvBx;
				_rigidbodyB.yVelocity += dlvBy;
				_rigidbodyB.angularVelocity += davB;
			}
		}
		
	}
}