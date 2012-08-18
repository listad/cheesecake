package engine.geometry {
	import engine.physics.RigidBody;
	import flash.display.Graphics;
	
	public class Projection {
		private var _min:Number;
		private var _max:Number;
		private var _minVertex:Vector2D;
		private var _maxVertex:Vector2D;
		
		public function Projection(axis:Vector2D, body:RigidBody) {
			this.project(axis, body);
		}
		
		public function project(axis:Vector2D, body:RigidBody):void {
			this._min = Number.POSITIVE_INFINITY;
			this._max = Number.NEGATIVE_INFINITY;
			
			var vertices:Vector.<Vector2D> = body.collisionGeometry.globalVertices;//vertices;
			var length:int = vertices.length;
			for (var i:int = 0; i < length; i++) {
				var vertex:Vector2D = vertices[i];// body.toGlobal(vertices[i]);
				var dotProduct:Number = axis.dot(vertex);
				
				if (dotProduct < this._min) {
					this._min = dotProduct;
					this._minVertex = vertex;
				}
				if (dotProduct > this._max) {
					this._max = dotProduct;
					this._maxVertex = vertex;
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
		
		public function draw(graphics:Graphics, lineThickness:Number = 1.0, lineColor:uint = 0x440000, lineAlpha:Number = 0.5):void {
			graphics.lineStyle(lineThickness, lineColor, lineAlpha);
			graphics.moveTo(this._minVertex.x, this._minVertex.y);
			graphics.lineTo(this._maxVertex.x, this._maxVertex.y);
			graphics.endFill();
		}
		
	}
}