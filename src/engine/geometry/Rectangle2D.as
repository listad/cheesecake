package engine.geometry {
	import flash.display.Graphics;
	
	public class Rectangle2D {
		protected var _min_x:Number;
		protected var _min_y:Number;
		protected var _max_x:Number;
		protected var _max_y:Number;
		
		private var __enter:Number;
		private var __exit:Number;
		private var __enterPoint_x:Number;
		private var __enterPoint_y:Number;
		private var __exitPoint_x:Number;
		private var __exitPoint_y:Number;

		public function Rectangle2D() {
			
		}
		
		public function collide(rectange:Rectangle2D):Boolean {
			if (	this._max_x < rectange.min_x ||
					this._max_y < rectange.min_y ||
					rectange.max_x < this._min_x ||
					rectange.max_y < this._min_y	) return false;
			return true;
		}
		
		public function get min_x():Number { return this._min_x; }
		public function set min_x(value:Number):void { this._min_x = value; }
		
		public function get min_y():Number { return this._min_y; }
		public function set min_y(value:Number):void { this._min_y = value; }
		
		public function get max_x():Number { return this._max_x; }
		public function set max_x(value:Number):void { this._max_x = value; }
		
		public function get max_y():Number { return this._max_y; }
		public function set max_y(value:Number):void { this._max_y = value; }
		
		public function get enterPoint_x():Number { return this.__enterPoint_x; }
		public function get enterPoint_y():Number { return this.__enterPoint_y; }
		public function get exitPoint_x():Number { return this.__exitPoint_x; }
		public function get exitPoint_y():Number { return this.__exitPoint_y; }
		
		private function Line_AABB_1d(line_start:Number, line_dir:Number, AABB_min:Number, AABB_max:Number):Boolean { 
			//If the line segment is more of a point, just check if it's within the segment 
			if(line_dir == 0)
			return (line_start >= AABB_min && line_start <= AABB_max); 
			
			//Find if the lines overlap 
			var ooDir:Number = 1 / line_dir; 
			var t0:Number = (AABB_min - line_start) * ooDir; 
			var t1:Number = (AABB_max - line_start) * ooDir; 
			
			//Make sure t0 is the "first" of the intersections 
			if(t0 > t1) {
				var temp:Number = t0;
				t0 = t1
				t1 = temp;
			}
			
			//Check if intervals are disjoint 
			if(t0 > this.__exit || t1 < this.__enter) return false; 
			
			//Reduce interval based on intersection 
			if(t0 > this.__enter) this.__enter = t0; 
			if(t1 < this.__exit) this.__exit = t1; 
			
			return true;
		}

		public function Line_AABB(s_x, s_y,  dir_x, dir_y):Boolean { 
			this.__enter = 0;
			this.__exit = 1;
		 
			//Check each dimension of Line/AABB for intersection 
			if(!Line_AABB_1d(s_x, dir_x, this._min_x, this._max_x)) return false; 
			if(!Line_AABB_1d(s_y, dir_y, this._min_y, this._max_y)) return false; 
		 
			//If there is intersection on all dimensions, report that point 
			 __enterPoint_x = s_x + dir_x * __enter;
			 __enterPoint_y = s_y + dir_y * __enter;
			 
			 __exitPoint_x = s_x + dir_x * __exit;
			 __exitPoint_y = s_y + dir_y * __exit;
			return true;
		} 
	
		// Debug
		
		public function draw(graphics:Graphics, lineThickness:Number = 2.0, lineColor:uint = 0xFF0000, lineAlpha:Number = 0.25, fillColor:uint = 0xFF0000, fillAlpha = 0.015):void {
			graphics.lineStyle(lineThickness, lineColor, lineAlpha);
			graphics.beginFill(fillColor, fillAlpha);
			graphics.drawRect(this._min_x, this._min_y, this._max_x - this._min_x, this._max_y - this._min_y);
			graphics.endFill();
		}
		
		public function toString():String {
			return "[object Rectangle2D (minX: " + _min_x + ", minY: " + _min_y + ", maxX: " + _max_x + ", maxY: " + _max_x + ")]";
		}
	}
}