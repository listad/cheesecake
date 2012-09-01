package engine.physics {
	import engine.Component;
	import engine.GameObject;
	public class State extends Component {
		
		public static const X_COORDINATE_INDEX:int = 0;
		public static const Y_COORDINATE_INDEX:int = 1;
		public static const ANGLE_INDEX:int = 3;
		
		private var _length:int;
		private var _state:Vector.<Number> = new Vector.<Number>();
		
		public function State(gameObject:GameObject) {
			super(gameObject);
		}
		
		public function get state():Vector.<Number> {
			return this._state;
		}
		
	//	public function set state(value:Vector.<Number>):void {
	//		this._state = value;
	//	}
		
	//	public function get length():int {
	//		return this._length;
	//	}
		
	//	public function set length(value:int):void {
	//		this._length = value;
	//	}
		
		public function get x():Number {
			return this._state[X_COORDINATE_INDEX];
		}
		
		public function set x(value:Number):void {
			this._state[X_COORDINATE_INDEX] = value;
		}
		
		public function get y():Number {
			return this._state[Y_COORDINATE_INDEX];
		}
		
		public function set y(value:Number):void {
			this._state[Y_COORDINATE_INDEX] = value;
		}
		
		public function get rotation():Number {
			return this._state[ANGLE_INDEX];
		}
		
		public function set rotation(value:Number):void {
			this._state[ANGLE_INDEX] = value;
		}
	}
}