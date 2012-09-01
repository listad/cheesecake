package engine.physics {
	import engine.Component;
	import engine.GameObject;
	import engine.geometry.Vector2D;
	public class State extends Component {
		
		public static const X_COORDINATE_INDEX:int = 0;
		public static const Y_COORDINATE_INDEX:int = 1;
		public static const ANGLE_INDEX:int = 2;
		
		private var _length:int;
		private var _state:Vector.<Number> = new Vector.<Number>();
		private var _matrix:Matrix2D = new Matrix2D();
			
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
			this._matrix.angle = this.angle;
		}
		
		public function get position():Vector2D {
			return new Vector2D(this.x, this.y);
		}
		
		public function set position(value:Vector2D):void { 
			this.x = value.x;
			this.y = value.y;
		}
		
		public function get matrix():Matrix2D { 
			return this._matrix; 
		}
		
		public function toLocal(vin:Vector2D, vout:Vector2D = null, translate:Boolean = true):Vector2D {
			if (translate) {
				return this._matrix.toLocal(vin, vout, this.x, this.y);
			} else {
				return this._matrix.toLocal(vin, vout);
			}
		}
		
		public function toGlobal(vin:Vector2D, vout:Vector2D = null, translate:Boolean = true):Vector2D {
			if (translate) {
				return this._matrix.toGlobal(vin, vout, this.x, this.y);
			} else {
				return this._matrix.toGlobal(vin, vout);
			}
		}
		
		public function get forward():Vector2D {
			return this.toGlobal(Vector2D.forward, null, false);
		}
		
		public function get right():Vector2D {
			return this.toGlobal(Vector2D.right, null, false);
		}
		
	}
}