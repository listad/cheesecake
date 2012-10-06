package tests.game {
	import engine.geometry.Vector2D;
	import engine.math.Mathsolver;
	import engine.physics.IForce;
	import engine.physics.RigidBody;
	
	public class Engine implements IForce {
		
		private var _acceleration:Number = 0.0;
		private var _steering:Number = 0.0;
		
		private var _force:Number;
		private var _torque:Number;
		
		public function Engine(force:Number, torque:Number) {
			this._force = force;
			this._torque = torque;
		}
		
		public function set acceleration(value:Number):void {
			this._acceleration = Mathsolver.clamp(value, -1.0, 1.0);
		}
		
		public function set steering(value:Number):void {
			this._steering = Mathsolver.clamp(value, -1.0, 1.0);
		}
		
		public function generate(rigidBody:RigidBody):void {
			var force:Vector2D = new Vector2D(this._force * this._acceleration, 0.0);
			rigidBody.applyForce( rigidBody.state.toGlobal(force, null, false) );
			rigidBody.applyTorque(this._torque * this._steering);
		}
	}
}