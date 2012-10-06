package engine.physics {
	import engine.geometry.Matrix2D;
	import engine.geometry.Rectangle2D;
	import engine.geometry.Vector2D;
	
	public class Bounds2D extends Rectangle2D {
		//private var _rigidBody:RigidBody;
		
		public function Bounds2D() {
			super();
		}
		
		public function circumAroundPolygon(globalVertices:Vector.<Vector2D>):void {
			super._min_x = Number.MAX_VALUE;
			super._min_y = Number.MAX_VALUE;
			super._max_x = Number.MIN_VALUE;
			super._max_y = Number.MIN_VALUE;
			var length:int = globalVertices.length;
			for (var i:int = 0; i < length; i++) {
				var vertex:Vector2D = globalVertices[i];
				if (vertex.x < super._min_x) super._min_x = vertex.x;
				if (vertex.x > super._max_x) super._max_x = vertex.x;
				if (vertex.y < super._min_y) super._min_y = vertex.y;
				if (vertex.y > super._max_y) super._max_y = vertex.y;
			}
		}
		
		public function circumAroundCircle(x:Number, y:Number, radius:Number):void {
			super._min_x = Number.MAX_VALUE;
			super._min_y = Number.MAX_VALUE;
			super._max_x = Number.MIN_VALUE;
			super._max_y = Number.MIN_VALUE;
			super._min_x = x - radius;
			super._max_x = x + radius;
			super._min_y = y - radius;
			super._max_y = y + radius;
		}
		
	}
}