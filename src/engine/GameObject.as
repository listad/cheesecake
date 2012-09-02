package engine {
	import flash.display.Sprite;
	import engine.physics.Collider;
	import engine.physics.RigidBody;
	import engine.physics.State;
	public class GameObject extends Sprite {//debug
		
		private var _name:String;
		private var _layer:uint;
		
		private var _state:State = new State();// x y rotation // 
		private var _rigidBody:RigidBody = new RigidBody();//req state
		//private var _renderer:Renderer = new Renderer(this);//req state
		private var _collider:Collider = new Collider();//req state
		//audioSource
		//networksync
		//light
		//emmiter
		//
		
		public function GameObject() {
			this._state.gameObject = this;
			this._collider.gameObject = this;
			this._rigidBody.gameObject = this;
		}
		
		public function get state():State { return this._state; }
		
		public function get rigidBody():RigidBody { return this._rigidBody; }
		
		//public function get renderer():State { return this._renderer; }
		
		public function get collider():Collider { return this._collider; }
		
		//public function get state():State { return this._state; }
		
		//public function get state():State { return this._state; }
		
		//public function get state():State { return this._state; }
		
		//public function get state():State { return this._state; }
	}
}