package engine.physics {
	import engine.Component;
	import engine.GameObject;
	import engine.geometry.Matrix2D;
	import engine.geometry.Vector2D;
	import engine.math.Mathsolver;
	public class State extends Component {
		
		public static const X_COORDINATE_INDEX:int = 0;
		public static const Y_COORDINATE_INDEX:int = 1;
		public static const ANGLE_INDEX:int = 4;
		
		private var _length:int;
		private var _vector:Vector.<Number> = new Vector.<Number>(6);
		private var _matrix:Matrix2D = new Matrix2D();
			
		public function State() {
			super();
		}
		
		public function get vector():Vector.<Number> {
			return this._vector;
		}
		
		public function set vector(value:Vector.<Number>):void {
			this._vector = value;
			rotation -= 2 * Math.PI * int(rotation / (2 * Math.PI)) ;//FIXME
			
			this._matrix.angle = this._vector[ANGLE_INDEX];
			
			

		
			
			super.gameObject.x = x;//DEBUG;
			super.gameObject.y = y;//DEBUG;
			super.gameObject.rotation = rotation * Mathsolver.RAD_TO_DEG;//DEBUG;

		}
		
	//	public function get length():int {
	//		return this._length;
	//	}
		
	//	public function set length(value:int):void {
	//		this._length = value;
	//	}
		
		public function get x():Number {
			return this._vector[X_COORDINATE_INDEX];
		}
		
		public function set x(value:Number):void {
			this._vector[X_COORDINATE_INDEX] = value;
			
			if (super.collider) super.collider.invalidate();
			
			super.gameObject.x = value;//DEBUG;
		}
		
		public function get y():Number {
			return this._vector[Y_COORDINATE_INDEX];
		}
		
		public function set y(value:Number):void {
			this._vector[Y_COORDINATE_INDEX] = value;
			
			if (super.collider) super.collider.invalidate();
			
			super.gameObject.y = value;//DEBUG;
		}
		
		public function get rotation():Number {
			return this._vector[ANGLE_INDEX];
		}
		
		public function set rotation(value:Number):void {
			this._vector[ANGLE_INDEX] = value;
			this._matrix.angle = value;
			
			if (super.collider) super.collider.invalidate();
			
			super.gameObject.rotation = value * Mathsolver.RAD_TO_DEG;//DEBUG;
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