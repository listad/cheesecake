package engine {
	import engine.physics.Collider;
	import engine.physics.RigidBody;
	import engine.physics.State;
	public class GameObject {
		
		private var _name:String;
		private var _layer:uint;
		private var _state:State = new State(this);
		private var _rigidBody:RigidBody = new RigidBody(this);
		private var _renderer:Renderer = new Renderer(this);
		private var _collider:Collider = new Collider(this);
		
		public function GameObject() {
			
		}
	}
}