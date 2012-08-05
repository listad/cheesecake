package engine.geometry {
	import flash.display.Graphics;
	public class Polygon {
		// static
		public static function rect(width:Number, height:Number):Polygon {
			return new Polygon(
			
				new <Vector2D>[
					new Vector2D( -0.5 * width, -0.5 * height),
					new Vector2D(  0.5 * width, -0.5 * height),
					new Vector2D(  0.5 * width,  0.5 * height),
					new Vector2D( -0.5 * width,  0.5 * height)
				]
			
			);
		}
		
		
		// m
		private var _vertices:Vector.<Vector2D>;
		
		public function Polygon(vertices:Vector.<Vector2D>) {
			this._vertices = vertices;
		}
		
		public function get vertices():Vector.<Vector2D> { return this._vertices;  }
		
		//DEBUG!!!
		
		public function draw(graphics:Graphics):void {
			graphics.lineStyle(2.0, 0xFFCCCC, 0.75);
			graphics.moveTo(this._vertices[0].x, this._vertices[0].y);
			for (var i:int = 1; i < this._vertices.length; i++) {
				graphics.lineTo(this._vertices[i].x, this._vertices[i].y);
			}
			graphics.lineTo(this._vertices[0].x, this._vertices[0].y);
		}
	}
}