package engine.physics {
	import engine.Component;
	import engine.GameObject;
	import engine.geometry.Matrix2D;
	import engine.geometry.Polygon;
	import engine.geometry.Rectangle2D;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import engine.geometry.Vector2D;
	
	public class RigidBody extends Component {
		
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
		//private var _change:Boolean;
		
		private var _forces:Vector.<IForce> = new Vector.<IForce>;
		private var _force:Vector2D = new Vector2D();
		private var _mass:Number = 1.0;
		private var _inverseMass:Number = 1.0;
		private var _torque:Number = 0.0;
		private var _inertiaTensor:Number = 50.0;
		private var _inverseInertiaTensor:Number = 1.0 / 50.0;
		private var _drag:Number = 0.0;
		private var _angularDrag:Number = 0.0;
		private var _gravity:Vector2D;
		private var _collisionGeometry:CollisionGeometry;
		
		private var _boundsNeedToUpdate:Boolean = true;
		private var _bounds:Bounds2D = new Bounds2D();
		
		
		//RK4
		private var __temp:Vector.<Number> = new Vector.<Number>(STATE_LENGTH);
		private var __k1:Vector.<Number> = new Vector.<Number>(STATE_LENGTH);
		private var __k2:Vector.<Number> = new Vector.<Number>(STATE_LENGTH);
		private var __k3:Vector.<Number> = new Vector.<Number>(STATE_LENGTH);
		private var __k4:Vector.<Number> = new Vector.<Number>(STATE_LENGTH);
		
		//debug
		private var _debug:Boolean;
		
		// Constructor
		
		public function RigidBody() {
			super();
		}
		
		//public function init(quadtrees:Quadtrees):void {
			
		//}
		
		// Public
		
		public function wakeUp():void {
			this._sleeps = false;
		}
		
		public function addImpulse(impulse:Vector2D):void {
		//	this.wakeUp();
			this.xVelocity += impulse.x / this._mass;
			this.yVelocity += impulse.y / this._mass;
		}
		
		public function addTorque(value:Number):void {
		//	this.wakeUp();
			this.angularVelocity += value / this._inertiaTensor;
		}
		
		public function addImpulseAtPoint(impulse:Vector2D, point:Vector2D):void {
			this.addImpulse(impulse);
			this.addTorque(point.perp.dot(impulse));
		}
		
		public function addForce(force:IForce):void {
			//this.wakeUp();
			this._forces.push(force);
		}
		
		public function getVelocityAtPoint(point:Vector2D):Vector2D {
			var tangent:Vector2D = point.subtract(super.state.position).perp;
			tangent.normalize();
			return velocity.add(tangent.scale(this.angularVelocity));
		}
		
		
		// set & get
		
		public function get sleeps():Boolean { return this._sleeps; }
		
		public function get xVelocity():Number { return super.state.vector[VELOCITY_X_INDEX]; }
		public function set xVelocity(value:Number):void { super.state.vector[VELOCITY_X_INDEX] = value; }
		
		public function get yVelocity():Number { return super.state.vector[VELOCITY_Y_INDEX]; }
		public function set yVelocity(value:Number):void { super.state.vector[VELOCITY_Y_INDEX] = value; }
		
		public function get velocity():Vector2D { return new Vector2D(super.state.vector[VELOCITY_X_INDEX], super.state.vector[VELOCITY_Y_INDEX]); } 
		
		public function get angularVelocity():Number { return super.state.vector[ANGULAR_VELOCITY_INDEX]; }
		public function set angularVelocity(value:Number):void { super.state.vector[ANGULAR_VELOCITY_INDEX] = value; }
		
		//mass
		public function get mass():Number { return this._mass; }
		public function get inverseMass():Number { return this._inverseMass; }
		public function set mass(value:Number):void {
			this._mass = value;
			this._inverseMass = 1.0 / value;
		}
		
		//inertia tensor
		public function get inertiaTensor():Number { return this._inertiaTensor; }
		public function get inverseInertiaTensor():Number { return this._inverseInertiaTensor; }
		public function set inertiaTensor(value:Number):void {
			this._inertiaTensor = value;
			this._inverseInertiaTensor = 1.0 / value;
		}
		
		public function get drag():Number { return this._drag; }
		public function set drag(value:Number):void { this._drag = value; }
		public function get angularDrag():Number { return this._angularDrag; }
		public function set angularDrag(value:Number):void { this._angularDrag = value; }
		public function get gravity():Vector2D { return this._gravity; }
		public function set gravity(value:Vector2D):void { this._gravity = value; }
		
		
		
		public function applyForce(force:Vector2D):void {
			this._force.add(force);
		}
		
		public function applyTorque(torque:Number):void {
			this._torque += torque;
		}
		
		public function physicsUpdate(dt:Number):void {
			var i:int;
			var origin:Vector.<Number> = super.state.vector;
			
			this.define(this.__k1, origin);
			for (i = 0; i < 6; i++) this.__temp[i] = origin[i] + this.__k1[i] * dt * 0.5;
			this.define(this.__k2, this.__temp);
			for (i = 0; i < 6; i++) this.__temp[i] = origin[i] + this.__k2[i] * dt * 0.5;
			this.define(this.__k3, this.__temp);
			for (i = 0; i < 6; i++) this.__temp[i] = origin[i] + this.__k3[i] * dt;
			this.define(this.__k4, this.__temp);
			for (i = 0; i < 6; i++) origin[i] += dt * (this.__k1[i] + 2.0 * this.__k2[i] + 2.0 * this.__k3[i] + this.__k4[i]) / 6.0;;
			super.state.vector = origin;//fixit
		}
		
		private function define(derivative:Vector.<Number>, state:Vector.<Number>):void {
			this.accumulate();
			derivative[POSITION_X_DERIVATIVE_INDEX]			= state[VELOCITY_X_INDEX];
			derivative[POSITION_Y_DERIVATIVE_INDEX]			= state[VELOCITY_Y_INDEX];
			derivative[VELOCITY_X_DERIVATIVE_INDEX]			= this._force.x / this._mass;
			derivative[VELOCITY_Y_DERIVATIVE_INDEX]			= this._force.y / this._mass;
			derivative[ANGLE_DERIVATIVE_INDEX]				= state[ANGULAR_VELOCITY_INDEX];
			derivative[ANGULAR_VELOCITY_DERIVATIVE_INDEX]	= this._torque / this._inertiaTensor;
			this.clearForces();
		}
		
		private function accumulate():void {
			for (var i:int = 0; i < this._forces.length; i++) {
				this._forces[i].generate(this);
			}
			//debug: !// useGravity
			if(_gravity) {
				this._force.x += _gravity.x * this.mass;
				this._force.y += _gravity.y * this.mass;
			}
			//debug: !// drag // 0.5
			
			if(mass != Infinity)applyForce(new Vector2D(-xVelocity * _drag * mass, -yVelocity * _drag * mass));
			applyTorque(-angularVelocity * _angularDrag * inertiaTensor);
		}
		
		public function clearForces():void {
			this._force.setVector(0.0, 0.0);
			this._torque = 0.0;
		}
		
		// DEBUG
		
		//public function debug(graphics:Graphics):void {
			//super.x = xPosition;
			//super.y = yPosition;
			//super.rotation = this.angle * 180.0 / Math.PI;
			
			
			//this._quadcell.draw(graphics, 1.0, 0x003300, 0.25, 0x000000, 0.0);//
			//this.bound();
		//}
	}
}