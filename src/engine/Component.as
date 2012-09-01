package engine {
	public class Component {
		
		private var _enabled:Boolean = true;
		private var _gameObject:GameObject;
		
		public function Component(gameObject:GameObject) {
			this._gameObject = gameObject;
		}
		
		public function set enabled(value:Boolean):void { this._enabled = value; }
		public function get enabled():Boolean { return this._enabled; }
		public function get gameObject():GameObject { return this._gameObject; }
		
	}
}