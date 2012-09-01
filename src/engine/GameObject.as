package engine {
	import engine.physics.Collider;
	import engine.physics.RigidBody;
	import engine.physics.State;
	public class GameObject {
		
		private var _name:String;
		private var _layer:uint;
		
		private var _state:State = new State(this);// x y rotation // 
		private var _rigidBody:RigidBody = new RigidBody(this);//req state
		private var _renderer:Renderer = new Renderer(this);//req state
		private var _collider:Collider = new Collider(this);//req state
		//audioSource
		//networksync
		//light
		//emmiter
		//
		
		public function GameObject() {
			
		}
		
		public function get state():State { return this._state; }
		
		public function get rigidBody():State { return this._rigidBody; }
		
		public function get renderer():State { return this._renderer; }
		
		public function get collider():State { return this._collider; }
		
		//public function get state():State { return this._state; }
		
		//public function get state():State { return this._state; }
		
		//public function get state():State { return this._state; }
		
		//public function get state():State { return this._state; }
	}
}