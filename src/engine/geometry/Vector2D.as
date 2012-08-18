package engine.geometry {
	import flash.display.Graphics;
	import flash.geom.Point;
	public class Vector2D {
		public static function add(a:Vector2D, b:Vector2D):Vector2D {
			return new Vector2D(a.x + b.x, a.y + b.y);
		}
		public static function subtract(a:Vector2D, b:Vector2D):Vector2D {
			return new Vector2D(a.x - b.x, a.y - b.y);
		}
		public static function negate(vector:Vector2D):Vector2D {
			return new Vector2D( -vector.x, -vector.y);
		}
		public static function scale(vector:Vector2D, value:Number):Vector2D {
			return new Vector2D(vector.x * value, vector.y * value);
		}
		
		// // //
		
		private var _x:Number;
		private var _y:Number;
		
		public function Vector2D(x:Number = 0.0, y:Number = 0.0) {
			this._x = x;
			this._y = y;
		}
		
		public function add(vector:Vector2D):Vector2D {
			this._x += vector.x;
			this._y += vector.y;
			return this;
		}
		
		public function subtract(vector:Vector2D):Vector2D {
			this._x -= vector.x;
			this._y -= vector.y;
			return this;
		}
		
		public function dot(vector:Vector2D):Number {
			return this._x * vector.x + this._y * vector.y;
		}
		
		public function divide(scalar:Number):void {
			this._x /= scalar;
			this._y /= scalar;
		}
		
		public function scale(scalar:Number):void {
			this._x *= scalar;
			this._y *= scalar;
		}
		
		public function normalize():void {
			this.divide(this.length);
		}
		
		public function setVector(x:Number = 0.0, y:Number = 0.0):void {
			this._x = x;
			this._y = y;
		}
		
		public function toPoint():Point {
			return new Point(this._x, this._y);
		}
		
		public function get length():Number {
			return Math.sqrt(this.lengthSquared);
		}
		
		public function get lengthSquared():Number {
			return this._x * this._x + this._y * this._y;
		}
		
		public function get normal():Vector2D {
			return new Vector2D( -this._y, this._x);
		}
		
		public function get x():Number { return this._x; }
		public function set x(value:Number):void { this._x = value; }
		public function get y():Number { return this._y; }
		public function set y(value:Number):void { this._y = value; }
		
		public function draw(graphics:Graphics, width:Number = 2.0, height:Number = 2.0, lineThickness:Number = 0.5, lineColor:uint = 0x440000, lineAlpha:Number = 0.5, fillColor:uint = 0xFFAAAA, fillAlpha:Number = 0.25):void {
			graphics.lineStyle(lineThickness, lineColor, lineAlpha);
			graphics.beginFill(fillColor, fillAlpha);
			graphics.drawRect(-0.5 * width, -0.5 * height, width, height);
			graphics.moveTo(0.5 * width, 0.0); graphics.lineTo(2.0 * width, 0.0); 
			graphics.moveTo(-0.5 * width, 0.0); graphics.lineTo(-2.0 * width, 0.0); 
			graphics.moveTo(0.0, 0.5 * height); graphics.lineTo(0.0, 2.0 * height);
			graphics.moveTo(0.0, -0.5 * height); graphics.lineTo(0.0, -2.0 * height);
			graphics.endFill();
		}
		
		public function drawGlobal(graphics:Graphics, radius:Number = 4.0, lineThickness:Number = 1.0, lineColor:uint = 0x440000, lineAlpha:Number = 0.5, fillColor:uint = 0xFFAAAA, fillAlpha:Number = 0.25):void {
			graphics.lineStyle(lineThickness, lineColor, lineAlpha);
			graphics.beginFill(fillColor, fillAlpha);
			graphics.drawCircle(this._x, this._y, radius);
			graphics.endFill();
		}
		
		public function toString():String {
			return this._x + ", " + this._y;
		}
		
	}
}