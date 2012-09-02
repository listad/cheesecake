package engine {
	import engine.physics.Collider;
	import engine.physics.RigidBody;
	import engine.physics.State;
	public class Component {
		
		private var _enabled:Boolean = true;
		private var _gameObject:GameObject;
		private var _state:State;
		private var _rigidBody:RigidBody;
		private var _collider:Collider;
		
		public function Component() {
		}
		
		public function set enabled(value:Boolean):void { this._enabled = value; }
		public function get enabled():Boolean { return this._enabled; }
		public function set gameObject(value:GameObject):void {
			this._gameObject = value;
			this._state = value.state;
			this._rigidBody = value.rigidBody;
			this._collider = value.collider;
		}
		public function get gameObject():GameObject { return this._gameObject; }
		public function get state():State { return this._state; }
		public function get rigidBody():RigidBody { return this._rigidBody; }
		public function get collider():Collider { return this._collider; }
		
	}
}