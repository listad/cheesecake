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
		
		public static function convexRegular(sides:int, radius:int):Polygon {
			var corner:Number = 2.0 * Math.PI / sides;
			var verticesCoords:Vector.<Vector2D> = new Vector.<Vector2D>();
			
			for (var i:int = 0; i < sides; i++) {
				var x:Number = radius * Math.cos(corner * i);
				var y:Number = radius * Math.sin(corner * i);
				verticesCoords[i] = new Vector2D(x, y);
			}
			
			return new Polygon(verticesCoords);
		}
		
		
		// m
		private var _vertices:Vector.<Vector2D>;
		
		public function Polygon(vertices:Vector.<Vector2D>) {
			this._vertices = vertices;
		}
		
		public function get vertices():Vector.<Vector2D> { return this._vertices;  }
		
		//DEBUG!!!
		
		public function draw(graphics:Graphics, lineThickness:Number = 2.0, lineColor:uint = 0x440000, lineAlpha:Number = 0.45, fillColor:uint = 0x440000, fillAlpha = 0.15):void {
			graphics.lineStyle(lineThickness, lineColor, lineAlpha);
			graphics.beginFill(fillColor, fillAlpha);
			graphics.moveTo(this._vertices[0].x, this._vertices[0].y);
			for (var i:int = 1; i < this._vertices.length; i++) {
				graphics.lineTo(this._vertices[i].x, this._vertices[i].y);
				
			}
			graphics.lineTo(this._vertices[0].x, this._vertices[0].y);
			
			
		}
	}
}