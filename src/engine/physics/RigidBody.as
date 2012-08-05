package engine.physics {
	import flash.display.Sprite;
	import flash.events.Event;
	
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
		private var _forces:Vector.<Force> = new Vector.<Force>;
		private var _force:Vector2D = new Vector2D();
		private var _mass:Number = 1.0;
		private var _torque:Number = 0.0;
		private var _inertiaTensor:Number = 1.0;
		
		private var k1:Vector.<Number> = new Vector.<Number>(6);
		private var k2:Vector.<Number> = new Vector.<Number>(6);
		private var k3:Vector.<Number> = new Vector.<Number>(6);
		private var k4:Vector.<Number> = new Vector.<Number>(6);
		
		public function RigidBody(x:Number, y:Number, angle:Number, mass:Number = 1.0, collisionMesh) {
			super.addEventListener(Event.ENTER_FRAME, this.enterFrameEventListener);//DEBUG!!!
		}
		
		// Public
		
		public function addForce(force:Vector2D):void {
			this._force.add(force);
		}
		
		// Internal
		
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
		}
		
		public function get xPosition():Number { return this._state[POSITION_X_INDEX]; }
		public function set xPosition(value:Number):void { this._state[POSITION_X_INDEX] = value; }
		public function get yPosition():Number { return this._state[POSITION_Y_INDEX]; }
		public function set yPosition(value:Number):void { this._state[POSITION_Y_INDEX] = value; }
		
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
			addForce(new Vector2D(10, 10));
		}
		
		public function clear():void {//DEBUG;
			this._force.setVector(0.0, 0.0);
			this._torque = 0.0;
		}
		
		//DEBUG!!!
		
		private function enterFrameEventListener(event:Event):void {
			super.x = xPosition;
			super.y = yPosition;
			this.draw();
		}
		
		private function draw():void {
			super.graphics.clear();
			super.graphics.lineStyle(2.0, 0xCCAAAA, 0.75);
			super.graphics.drawCircle(0.0, 0.0, 5.0);
			super.graphics.moveTo( -15.0, 0.0);
			super.graphics.lineTo(15.0, 0.0);
			super.graphics.moveTo(0.0, -15.0);
			super.graphics.lineTo(0.0, 15.0);
		}
	}
}