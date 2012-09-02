package engine {
	import flash.display.Sprite;
	import engine.physics.Collider;
	import engine.physics.RigidBody;
	import engine.physics.State;
	public class GameObject extends Sprite {//debug
		
		private var _tag:String;
		private var _layer:uint;
		
		private var _state:State = new State();// x y rotation // 
		private var _rigidBody:RigidBody;//req state
		//private var _renderer:Renderer = new Renderer(this);//req state
		private var _collider:Collider;//req state
		//audioSource
		//networksync
		//light
		//emmiter
		//
		
		public function GameObject(x:Number = 0.0, y:Number = 0.0, rotation:Number = 0.0, tag:String = "unknown") {
			this._state.gameObject = this;
			
			this.state.x = x;
			this.state.y = y;
			this.state.rotation = rotation;
			
			this._tag = tag;
		}
		
		public function get state():State { return this._state; }
		
		public function get rigidBody():RigidBody { return this._rigidBody; }
		
		public function set rigidBody(value:RigidBody):void {
			this._rigidBody = value;
			this._rigidBody.gameObject = this;
		}
		
		//public function get renderer():State { return this._renderer; }
		
		public function get collider():Collider { return this._collider; }
		
		public function set collider(value:Collider):void {
			this._collider = value;
			this._collider.gameObject = this;
		}
		
		//public function get state():State { return this._state; }
		
		//public function get state():State { return this._state; }
		
		//public function get state():State { return this._state; }
		
		//public function get state():State { return this._state; }
		
		public function get tag():String { return this._tag; }
	}
}