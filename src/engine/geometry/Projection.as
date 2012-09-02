package engine.geometry {
	import engine.physics.Collider;
	import flash.display.Graphics;
	
	public class Projection {
		private static const EPSILON:Number = 0.0000001;
		
		private var _min:Number;
		private var _max:Number;
		private var _minVertices:Vector.<Vector2D> = new Vector.<Vector2D>;
		private var _maxVertices:Vector.<Vector2D> = new Vector.<Vector2D>;
		
		public function Projection(axis:Vector2D, collider:Collider) {
			this.project(axis, collider);
		}
		
		public function project(axis:Vector2D, collider:Collider):void {
			this._min = Number.POSITIVE_INFINITY;
			this._max = Number.NEGATIVE_INFINITY;
			
			var vertices:Vector.<Vector2D> = collider.globalVertices;//vertices;
			var length:int = vertices.length;
			for (var i:int = 0; i < length; i++) {
				var vertex:Vector2D = vertices[i];// body.toGlobal(vertices[i]);
				var dotProduct:Number = axis.dot(vertex);
				
				//fixit
				if (dotProduct < this._min - EPSILON) {
					this._min = dotProduct;
					this._minVertices.length = 0;
					this._minVertices[0] = vertex;
				} else if (Math.abs(dotProduct - this._min) < EPSILON) {
					this._minVertices.push(vertex);
				}
				
				if (dotProduct > this._max + EPSILON) {
					this._max = dotProduct;
					this._maxVertices.length = 0;
					this._maxVertices[0] = vertex;
				} else if (Math.abs(dotProduct - this._max) < EPSILON) {
					this._maxVertices.push(vertex);
				}
				
			}
		}
		
		public function isFurther(projection:Projection):Boolean {
			return projection._min > this._min;
		}
		
		public function distance(projection:Projection):Number {
			if (projection._min > this._min) return projection._min - this._max;
			return this._min - projection._max;
		}
		
		public function get minVertices():Vector.<Vector2D> {
			return this._minVertices;
		}
		
		public function get maxVertices():Vector.<Vector2D> {
			return this._maxVertices;
		}
		
	//	public function draw(graphics:Graphics, lineThickness:Number = 1.0, lineColor:uint = 0x440000, lineAlpha:Number = 0.5):void {
	//		graphics.lineStyle(lineThickness, lineColor, lineAlpha);
	//		graphics.moveTo(this._minVertex.x, this._minVertex.y);
	//		graphics.lineTo(this._maxVertex.x, this._maxVertex.y);
	//		graphics.endFill();
	//	}
		
	}
}