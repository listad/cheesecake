package engine.physics {
	import engine.geometry.Matrix2D;
	import engine.geometry.Polygon;
	import engine.geometry.Rectangle2D;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import engine.geometry.Vector2D;
	
	public class RigidBody extends Sprite {
		
		public static const STATE_LENGTH:int			= 6;
		
		public static const POSITION_X_INDEX:int		= 0;
		public static const POSITION_Y_INDEX:int		= 1;
		public static const VELOCITY_X_INDEX:int		= 2;
		public static const VELOCITY_Y_INDEX:int		= 3;
		public static const ANGLE_INDEX:int				= 4;
		public static const ANGULAR_VELOCITY_INDEX:int	= 5;
		
		public static const POSITION_X_DERIVATIVE_INDEX:int			= 0;
		public static const POSITION_Y_DERIVATIVE_INDEX:int			= 1;
		public static const VELOCITY_X_DERIVATIVE_INDEX:int			= 2;
		public static const VELOCITY_Y_DERIVATIVE_INDEX:int			= 3;
		public static const ANGLE_DERIVATIVE_INDEX:int				= 4;
		public static const ANGULAR_VELOCITY_DERIVATIVE_INDEX:int	= 5;
		
		
		
		// Private
		
		private var _state:Vector.<Number> = new Vector.<Number>(STATE_LENGTH);
		private var _forces:Vector.<IForce> = new Vector.<IForce>;//массив сил
		private var _force:Vector2D = new Vector2D(); //тёмная магия
		private var _mass:Number = 1.0;
		private var _torque:Number = 0.0;
		private var _inertiaTensor:Number = 5000.0;
		
		private var _k1:Vector.<Number> = new Vector.<Number>(6);
		private var _k2:Vector.<Number> = new Vector.<Number>(6);
		private var _k3:Vector.<Number> = new Vector.<Number>(6);
		private var _k4:Vector.<Number> = new Vector.<Number>(6);
		
		private var _collisionGeometry:Polygon;
		private var _bounds:Rectangle2D = new Rectangle2D();
		
		private var _matrix:Matrix2D = new Matrix2D();
		
		public function RigidBody(x:Number, y:Number, angle:Number, mass:Number = 1.0, inertiaTensor:Number = 100000.0, collisionGeometry:Polygon = null) {
			this.xPosition = x;
			this.yPosition = y;
			this.angle = angle; this._matrix.angle = this.angle;
			this._mass = mass;
			this._inertiaTensor = inertiaTensor;
			this._collisionGeometry = collisionGeometry;
		}
		
		// Public
		
		//addImpulse
		public function addImpulse(impulse:Vector2D):void {
			this.xVelocity += impulse.x / this._mass;
			this.yVelocity += impulse.y / this._mass;
		}
		public function addTorque(value:Number):void {
			this.angularVelocity += value / this._inertiaTensor;
		}
		//addImpulseAtPoint
		public function addImpulseAtPoint(impulse:Vector2D, point:Vector2D):void {
			this.addImpulse(impulse);
			this.addTorque(point.normal.dot(impulse));
		}
		
		
		public function addForceAtPoint(impulse:Vector2D, point:Vector2D):void {
			this.applyForce(impulse);
			this.applyTorque(point.normal.dot(impulse));
		}
		
		
		
		public function addForce(force:IForce):void {
			//todo: if not exist
			this._forces.push(force);
		}
		
		//todo: removeForce
		
		// Internal
		
		internal function applyForce(force:Vector2D):void {
			this._force.add(force);
		}
		
		internal function applyTorque(torque:Number):void {
			this._torque += torque;
		}
		
		internal function physicsUpdate(dt:Number):void {
			var temp:Vector.<Number> = new Vector.<Number>(STATE_LENGTH);
			var origin:Vector.<Number> = state;
			var i:int;
			
			this.define(this._k1);
			this.state = temp;
			for (i = 0; i < 6; i++) temp[i] = origin[i] + this._k1[i] * dt * 0.5;
			this.define(this._k2);
			for (i = 0; i < 6; i++) temp[i] = origin[i] + this._k2[i] * dt * 0.5;
			this.define(this._k3);
			for (i = 0; i < 6; i++) temp[i] = origin[i] + this._k3[i] * dt;
			this.define(this._k4);
			for (i = 0; i < 6; i++) origin[i] += dt * (this._k1[i] + 2.0 * this._k2[i] + 2.0 * this._k3[i] + this._k4[i]) / 6.0;
			this.state = origin;
			
			this._matrix.angle = this.angle;
		}
		
		public function get positon():Vector2D { return new Vector2D(this._state[POSITION_X_INDEX], this._state[POSITION_Y_INDEX]); }
		
		public function get xPosition():Number { return this._state[POSITION_X_INDEX]; }
		public function set xPosition(value:Number):void { this._state[POSITION_X_INDEX] = value; }
		public function get yPosition():Number { return this._state[POSITION_Y_INDEX]; }
		public function set yPosition(value:Number):void { this._state[POSITION_Y_INDEX] = value; }
		
		public function get xVelocity():Number { return this._state[VELOCITY_X_INDEX]; }
		public function set xVelocity(value:Number):void { this._state[VELOCITY_X_INDEX] = value; }
		public function get yVelocity():Number { return this._state[VELOCITY_Y_INDEX]; }
		public function set yVelocity(value:Number):void { this._state[VELOCITY_Y_INDEX] = value; }
		
		public function get angularVelocity():Number { return this._state[ANGULAR_VELOCITY_INDEX]; }
		public function set angularVelocity(value:Number):void { this._state[ANGULAR_VELOCITY_INDEX] = value; }
		
		public function get angle():Number { return this._state[ANGLE_INDEX]; }
		public function set angle(value:Number):void { this._state[ANGLE_INDEX] = value; }
		
		public function get mass():Number { return this._mass; }
		public function set mass(value:Number):void { this._mass = value; }
		public function get inertiaTensor():Number { return this._inertiaTensor; }
		//TODO: set itertiaTensor
		
		public function get matrix():Matrix2D { return this._matrix; }
		
		public function get collisionGeometry():Polygon { return this._collisionGeometry; }
		// Private
		
		private function get state():Vector.<Number> { return this._state; }
		private function set state(value:Vector.<Number>):void { this._state = value; }
		
		private function define(derivative:Vector.<Number>):void {
			this.accumulate();
			derivative[POSITION_X_DERIVATIVE_INDEX]			= this._state[VELOCITY_X_INDEX];
			derivative[POSITION_Y_DERIVATIVE_INDEX]			= this._state[VELOCITY_Y_INDEX];
			derivative[VELOCITY_X_DERIVATIVE_INDEX]			= this._force.x / this._mass;
			derivative[VELOCITY_Y_DERIVATIVE_INDEX]			= this._force.y / this._mass;
			derivative[ANGLE_DERIVATIVE_INDEX]				= this._state[ANGULAR_VELOCITY_INDEX];
			derivative[ANGULAR_VELOCITY_DERIVATIVE_INDEX]	= this._torque / this._inertiaTensor;
			this.clearForces();
		}
		
		private function accumulate():void {
			for (var i:int = 0; i < this._forces.length; i++) {
				this._forces[i].generate(this);
			}
		}
		
		public function clearForces():void {
			this._force.setVector(0.0, 0.0);
			this._torque = 0.0;
		}
		
		public function get bounds():Rectangle2D {
			this._bounds.update(this);
			return this._bounds;
		}
		
		public function debug(graphics:Graphics):void {
			super.graphics.clear();
			
			super.x = xPosition;
			super.y = yPosition;
			super.rotation = this.angle * 180.0 / Math.PI;
			
			var rect:Rectangle2D = this.bounds;
			rect.draw(graphics);
			
			
			if (this._collisionGeometry) this._collisionGeometry.draw(super.graphics);
			this.positon.draw(super.graphics);
			//this.bound();
		}
	}
}