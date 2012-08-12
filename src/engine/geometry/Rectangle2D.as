package engine.geometry {
	import flash.display.Graphics;
	
	public class Rectangle2D {
		protected var _minX:Number;
		protected var _minY:Number;
		protected var _maxX:Number;
		protected var _maxY:Number;
		
		public function Rectangle2D() {
			
		}
		
		public function collide(rectange:Rectangle2D):Boolean {
			if (	this._maxX < rectange.minX ||
					this._maxY < rectange.minY ||
					rectange.maxX < this._minX ||
					rectange.maxY < this._minY	) return false;
			return true;
		}
		
		public function get minX():Number { return this._minX; }
		public function set minX(value:Number):void { this._minX = value; }
		
		public function get minY():Number { return this._minY; }
		public function set minY(value:Number):void { this._minY = value; }
		
		public function get maxX():Number { return this._maxX; }
		public function set maxX(value:Number):void { this._maxX = value; }
		
		public function get maxY():Number { return this._maxY; }
		public function set maxY(value:Number):void { this._maxY = value; }
		
		// Debug
		
		public function draw(graphics:Graphics, lineThickness:Number = 2.0, lineColor:uint = 0xFF0000, lineAlpha:Number = 0.25, fillColor:uint = 0xFF0000, fillAlpha = 0.015):void {
			graphics.lineStyle(lineThickness, lineColor, lineAlpha);
			graphics.beginFill(fillColor, fillAlpha);
			graphics.drawRect(this._minX, this._minY, this._maxX - this._minX, this._maxY - this._minY);
			graphics.endFill();
		}
	}
}