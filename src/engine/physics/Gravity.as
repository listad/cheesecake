package engine.physics {
	import engine.geometry.Vector2D;
	public class Gravity implements IForce {
		private var _force:Number;
		public function Gravity(force:Number = 1.0) {
			this._force = force;
		}
		public function generate(rigidBody:RigidBody):void {
			rigidBody.applyForce(new Vector2D(0.0, this._force * rigidBody.mass));
		}
	}
}