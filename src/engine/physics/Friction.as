package engine.physics {
	import engine.geometry.Vector2D;
	public class Friction implements IForce {
		private var _force:Number;
		public function Friction(force:Number = 0.1) {
			this._force = force;
		}
		public function generate(rigidBody:RigidBody):void {
			rigidBody.applyForce(new Vector2D(-rigidBody.xVelocity * _force * rigidBody.mass, -rigidBody.yVelocity * _force * rigidBody.mass));
			rigidBody.applyTorque(-rigidBody.angularVelocity * _force * rigidBody.inertiaTensor);
		}
	}
}