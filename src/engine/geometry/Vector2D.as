package engine.geometry {
	import flash.geom.Point;
	public class Vector2D {
		private var _x:Number;
		private var _y:Number;
		
		public function Vector2D(x:Number = 0.0, y:Number = 0.0) {
			this._x = x;
			this._y = y;
		}
		
		public function add(vector:Vector2D):void {
			this._x += vector.x;
			this._y += vector.y;
		}
		
		public function dot(vector:Vector2D):Number {
			return this._x * vector.x + this._y * vector.y;
		}
		
		public function setVector(x:Number = 0.0, y:Number = 0.0):void {
			this._x = x;
			this._y = y;
		}
		
		public function toPoint():Point {
			return new Point(this._x, this._y);
		}
		
		public function get x():Number { return this._x; }
		public function set x(value:Number):void { this._x = value; }
		public function get y():Number { return this._y; }
		public function set y(value:Number):void { this._y = value; }
	}
}