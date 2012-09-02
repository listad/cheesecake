package engine {
	import engine.physics.Collider;
	import engine.physics.RigidBody;
	import engine.physics.State;
	public class Component {
		
		private var _enabled:Boolean = true;
		private var _gameObject:GameObject;
		
		public function Component() {
		}
		
		public function set enabled(value:Boolean):void { this._enabled = value; }
		public function get enabled():Boolean { return this._enabled; }
		public function set gameObject(value:GameObject):void {
			this._gameObject = value;
		}
		public function get gameObject():GameObject { return this._gameObject; }
		public function get state():State { return this._gameObject.state; }
		public function get rigidBody():RigidBody { return this._gameObject.rigidBody; }
		public function get collider():Collider { return this._gameObject.collider; }
		
	}
}