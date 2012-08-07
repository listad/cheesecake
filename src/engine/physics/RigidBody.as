package engine.physics {
	import engine.geometry.Polygon;
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
		private var _inertiaTensor:Number = 1.0;
		
		private var k1:Vector.<Number> = new Vector.<Number>(6);
		private var k2:Vector.<Number> = new Vector.<Number>(6);
		private var k3:Vector.<Number> = new Vector.<Number>(6);
		private var k4:Vector.<Number> = new Vector.<Number>(6);
		
		private var _collisionGeometry:Polygon;
		
		//DEBUG!!!
		public var debugGraphics:Graphics;
		
		public function RigidBody(x:Number, y:Number, angle:Number, mass:Number = 1.0, collisionGeometry:Polygon = null) {
			super.addEventListener(Event.ENTER_FRAME, this.enterFrameEventListener);//DEBUG!!!
			this.xPosition = x;
			this.yPosition = y;
			this._collisionGeometry = collisionGeometry;
		}
		
		// Public
		
		//addImpulse
		public function addImpulse(impulse:Vector2D):void {
			this.xVelocity += impulse.x / this._mass;
			this.yVelocity += impulse.y / this._mass;
		}
		
		//addImpulseAtPoint
		public function addImpulseAtPoint(impulse:Vector2D, point:Vector2D):void {
			
		}
		
		public function addTorque(value:Number):void {
			this.angularVelocity += value / this._inertiaTensor;
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
			
			define(k1);
			for (i = 0; i < 6; i++) temp[i] = origin[i] + k1[i] * dt * 0.5;
			state = temp;
			define(k2);
			for (i = 0; i < 6; i++) temp[i] = origin[i] + k2[i] * dt * 0.5;
			state = temp;
			define(k3);
			for (i = 0; i < 6; i++) temp[i] = origin[i] + k3[i] * dt;
			state = temp;
			define(k4);
			for (i = 0; i < 6; i++) origin[i] += dt * (k1[i] + 2.0 * k2[i] + 2.0 * k3[i] + k4[i]) / 6.0;
			state = origin;
			trace(state[VELOCITY_Y_INDEX] , "  DY " , dt * (k1[1] + 2.0 * k2[1] + 2.0 * k3[1] + k4[1]) / 6.0);
		}
		
		
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
			this.clear();
		}
		
		private function accumulate():void {
			for (var i:int = 0; i < this._forces.length; i++) {
				this._forces[i].generate(this);
			}
		}
		
		public function clear():void {//DEBUG;
			this._force.setVector(0.0, 0.0);
			this._torque = 0.0;
		}
		
		//DEBUG!!!
		
		private function bound():void {
			var minX:Number = x;
			var maxX:Number = x;
			var minY:Number = y;
			var maxY:Number = y;
			var matrix:Matrix = new Matrix();//TODO: написать свою матрицу
			matrix.rotate(this.angle);
			matrix.translate(x, y);
			
			for (var i:int = 0; i < this._collisionGeometry.vertices.length; i++) {
				var vertex:Point = this._collisionGeometry.vertices[i].toPoint();
				vertex = matrix.transformPoint(vertex);
				if (vertex.x < minX) minX = vertex.x;
				if (vertex.x > maxX) maxX = vertex.x;
				if (vertex.y < minY) minY = vertex.y;
				if (vertex.y > maxY) maxY = vertex.y;
			}
			
			debugGraphics.clear();
			debugGraphics.lineStyle(1.0, 0xCCAAAA, 0.5);
			debugGraphics.drawRect(minX, minY, maxX - minX, maxY - minY);
			
		}
		
		private function enterFrameEventListener(event:Event):void {
			super.x = xPosition;
			super.y = yPosition;
			super.rotation = this.angle * 180.0 / Math.PI;
			this.draw();
		}
		
		private function draw():void {
			super.graphics.clear();
			super.graphics.lineStyle(1.0, 0xCCAAAA, 0.5);
			super.graphics.drawCircle(0.0, 0.0, 5.0);
			super.graphics.moveTo( -15.0, 0.0);
			super.graphics.lineTo(15.0, 0.0);
			super.graphics.moveTo(0.0, -15.0);
			super.graphics.lineTo(0.0, 15.0);
			if (this._collisionGeometry) this._collisionGeometry.draw(super.graphics);
			this.bound();
		}
	}
}