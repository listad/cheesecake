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
			super._minX = Number.MAX_VALUE;
			super._minY = Number.MAX_VALUE;
			super._maxX = Number.MIN_VALUE;
			super._maxY = Number.MIN_VALUE;
			var length:int = globalVertices.length;
			for (var i:int = 0; i < length; i++) {
				var vertex:Vector2D = globalVertices[i];
				if (vertex.x < super._minX) super._minX = vertex.x;
				if (vertex.x > super._maxX) super._maxX = vertex.x;
				if (vertex.y < super._minY) super._minY = vertex.y;
				if (vertex.y > super._maxY) super._maxY = vertex.y;
			}
		}
		
		public function circumAroundCircle(x:Number, y:Number, radius:Number):void {
			super._minX = Number.MAX_VALUE;
			super._minY = Number.MAX_VALUE;
			super._maxX = Number.MIN_VALUE;
			super._maxY = Number.MIN_VALUE;
			super._minX = x - radius;
			super._maxX = x + radius;
			super._minY = y - radius;
			super._maxY = y + radius;
		}
		
	}
}