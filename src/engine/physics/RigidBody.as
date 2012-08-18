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
		
		private var _sleeps:Boolean;
		private var _change:Boolean;
		
		private var _state:Vector.<Number> = new Vector.<Number>(STATE_LENGTH);
		private var _forces:Vector.<IForce> = new Vector.<IForce>;
		private var _force:Vector2D = new Vector2D(); //тёмная магия
		private var _mass:Number = 1.0;
		private var _torque:Number = 0.0;
		private var _inertiaTensor:Number = 5000.0;
		
		private var _collisionGeometry:CollisionGeometry;
		
		private var _boundsNeedToUpdate:Boolean = true;
		private var _bounds:Bounds2D = new Bounds2D();
		
		private var _matrix:Matrix2D = new Matrix2D();
		
		private var _quadtrees:Quadtrees;
		private var _quadcell:Cell;
		private var _quadtreeVisible:Boolean = false;
		
		//RK4
		private var __k1:Vector.<Number> = new Vector.<Number>(STATE_LENGTH);
		private var __k2:Vector.<Number> = new Vector.<Number>(STATE_LENGTH);
		private var __k3:Vector.<Number> = new Vector.<Number>(STATE_LENGTH);
		private var __k4:Vector.<Number> = new Vector.<Number>(STATE_LENGTH);
		
		// Constructor
		
		public function RigidBody(x:Number, y:Number, angle:Number, mass:Number = 1.0, inertiaTensor:Number = 100000.0, collisionGeometry:CollisionGeometry = null) {
			this.xPosition = x;
			this.yPosition = y;
			this.angle = angle;
			this._matrix.angle = this.angle;
			
			this._mass = mass;
			this._inertiaTensor = inertiaTensor;
			
			this._collisionGeometry = collisionGeometry;
			this._collisionGeometry.body = this;
			
			this._sleeps = true;//FIX IT
		}
		
		public function init(quadtrees:Quadtrees):void {
			this._quadtrees = quadtrees;
			
			this._quadcell = this._quadtrees.push(this);
			
			if (this._collisionGeometry) this._collisionGeometry.draw(super.graphics);
			this.position.draw(super.graphics);
			
			//test:
			super.cacheAsBitmap = true;
			
		}
		
		// Public
		
		public function wakeUp():void {
			this._sleeps = false;
		}
		
		private function outdate():void {//FIX IT
			this._boundsNeedToUpdate = true;
			this._change = true;
			if(this._collisionGeometry) this._collisionGeometry.outdate();
		}
		
		public function addImpulse(impulse:Vector2D):void {
			this.wakeUp();
			this.xVelocity += impulse.x / this._mass;
			this.yVelocity += impulse.y / this._mass;
		}
		
		public function addTorque(value:Number):void {
			this.wakeUp();
			this.angularVelocity += value / this._inertiaTensor;
		}
		
		public function addImpulseAtPoint(impulse:Vector2D, point:Vector2D):void {
			this.addImpulse(impulse);
			this.addTorque(point.normal.dot(impulse));
		}
		
		public function addForce(force:IForce):void {
			this.wakeUp();
			//TODO: if not exist
			this._forces.push(force);
		}
		
		//TODO: removeForce
		
		public function toLocal(vin:Vector2D, vout:Vector2D = null):Vector2D {
			return this._matrix.transponseVector2D(vin, vout, this.xPosition, this.yPosition);
		}
		
		public function toGlobal(vin:Vector2D, vout:Vector2D = null):Vector2D {
			return this._matrix.transformVector2D(vin, vout, this.xPosition, this.yPosition);
		}
		
		public function repush():void {
			this._quadcell = this._quadcell.repush(this);
		}
		
		// set & get
		
		public function get sleeps():Boolean { return this._sleeps; }
		
		public function get change():Boolean { return this._change; }
		public function set change(value:Boolean):void { this._change = value; }
		
		public function get position():Vector2D { return new Vector2D(this._state[POSITION_X_INDEX], this._state[POSITION_Y_INDEX]); }
		public function set position(value:Vector2D):void { 
			this.xPosition = value.x;
			this.yPosition = value.y;
		}
		
		public function get xPosition():Number { return this._state[POSITION_X_INDEX]; }
		public function set xPosition(value:Number):void {
			this._state[POSITION_X_INDEX] = value;
			this.outdate();
			this.wakeUp();
		}
			
		public function get yPosition():Number { return this._state[POSITION_Y_INDEX]; }
		public function set yPosition(value:Number):void {
			this._state[POSITION_Y_INDEX] = value;
			this.outdate();
			this.wakeUp();
		}
		
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
		public function set inertiaTensor(value:Number):void { this._inertiaTensor = value; }
		
		public function get matrix():Matrix2D { return this._matrix; }
		
		public function get collisionGeometry():CollisionGeometry { return this._collisionGeometry; }
		
		//quadtrees
		public function get quadcell():Cell { return this._quadcell; }
		public function get quadtreeVisible():Boolean { return this._quadtreeVisible; }
		public function set quadtreeVisible(value:Boolean):void { this._quadtreeVisible = value; }
		
		//TODO: set
		
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
			
			var change:Boolean = false;
			
			this.define(this.__k1);
			this.state = temp;
			for (var i:int = 0; i < 6; i++) temp[i] = origin[i] + this.__k1[i] * dt * 0.5;
			this.define(this.__k2);
			for (i = 0; i < 6; i++) temp[i] = origin[i] + this.__k2[i] * dt * 0.5;
			this.define(this.__k3);
			for (i = 0; i < 6; i++) temp[i] = origin[i] + this.__k3[i] * dt;
			this.define(this.__k4);
			for (i = 0; i < 6; i++) {
				//test:
				var value:Number = dt * (this.__k1[i] + 2.0 * this.__k2[i] + 2.0 * this.__k3[i] + this.__k4[i]) / 6.0;
				var abs:Number = value;
				if (value < 0) abs = -value;
				if (abs < 0.00001) value = 0.0;
				
				origin[i] += value;
				if (value != 0.0) change = true;
			}
			this.state = origin;
			
			
			
			
			
			if (change) {
				this._matrix.angle = this.angle;
				this._quadcell = this._quadcell.repush(this);
				this.outdate();
			} else {
				this._sleeps = true;
			}
		}
		
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
			if(this._boundsNeedToUpdate == true) {
				this._bounds.update(this);
				this._boundsNeedToUpdate = false;
			}
			return this._bounds;
		}
		
		// DEBUG
		
		public function debug(graphics:Graphics):void {
			//super.graphics.clear();
			
			super.x = xPosition;
			super.y = yPosition;
			super.rotation = this.angle * 180.0 / Math.PI;
			
			//var rect:Rectangle2D = this.bounds;
			//rect.draw(graphics);
			
			//this._collisionGeometry.draw(super.graphics, 1.5, 0x660000, 0.9, this._sleeps?0xFFFFFF:0xFF0000, 0.75)
			
			//this._quadcell.draw(graphics);//
			//this.bound();
		}
	}
}