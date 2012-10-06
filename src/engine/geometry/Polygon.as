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
					new Vector2D( -0.5 * width,  0.5 * height)	]
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
		
		public static function fromVertices(vertices:Vector.<Number>):Polygon {
			var verticesPoints:Vector.<Vector2D> = new Vector.<Vector2D>();
			var length:int = vertices.length / 2;
			for (var i:int = 0; i < length; i++) {
				verticesPoints[i] = new Vector2D(vertices[int(2 * i)], vertices[int(2 * i) | 1]);
			}
			return new Polygon(verticesPoints);
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// m
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		private var _vertices:Vector.<Vector2D>;
		private var _edges:Vector.<Vector2D> = new Vector.<Vector2D>();
		
		public function Polygon(vertices:Vector.<Vector2D>) {
			this._vertices = vertices;
			
			for(var i:int = 0; i < this._vertices.length; i++) {
				var a:Vector2D = vertices[i];
				var b:Vector2D = (i + 1 == vertices.length)?vertices[0]:vertices[i + 1];
				this._edges.push( Vector2D.subtract(a, b) );
			}
		}
		
		public function get vertices():Vector.<Vector2D> { return this._vertices;  }
		public function get edges():Vector.<Vector2D> { return this._edges;  }
		
		//DEBUG!!!
		
		public function draw(graphics:Graphics, lineThickness:Number = 1.0, lineColor:uint = 0x660000, lineAlpha:Number = 0.9, fillColor:uint = 0x003300, fillAlpha:Number = 0.1):void {
			graphics.lineStyle(lineThickness, lineColor, lineAlpha);
			graphics.beginFill(fillColor, fillAlpha);
			graphics.moveTo(this._vertices[0].x, this._vertices[0].y);
			for (var i:int = 1; i < this._vertices.length; i++) {
				graphics.lineTo(this._vertices[i].x, this._vertices[i].y);
				
			}
			graphics.lineTo(this._vertices[0].x, this._vertices[0].y);
			graphics.endFill();
			
		}
	}
}