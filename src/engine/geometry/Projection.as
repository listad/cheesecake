package engine.geometry {
	import engine.physics.Collider;
	import flash.display.Graphics;
	
	public class Projection {
		private static const EPSILON:Number = 0.0000001;
		private static const MAX:Number = -Number.MAX_VALUE;
		private static const MIN:Number = Number.MAX_VALUE;
		
		public var _min:Number;
		public var _max:Number;
		private var _minVertex_x:Number;
		private var _minVertex_y:Number;
		private var _maxVertex_x:Number;
		private var _maxVertex_y:Number;
		private var _minContactsNum:int = 0;
		private var _maxContactsNum:int = 0;
		
		public function Projection() {
		}
		
		public function projectPolygon(axis_x:Number, axis_y:Number, vertices:Vector.<Vector2D>):void {
			this._min = MIN;
			this._max = MAX;
			_minContactsNum = 0;
			_maxContactsNum = 0;
			
			var length:int = vertices.length;
			for (var i:int = 0; i < length; i++) {
				var vertex:Vector2D = vertices[i];
				var dotProduct:Number = axis_x * vertex.x + axis_y * vertex.y;
				
				var diff:Number = this._min - dotProduct;
				if (diff > EPSILON) {
					this._min = dotProduct;
					this._minVertex_x = vertex.x;
					this._minVertex_y = vertex.y;
					this._minContactsNum = 1;
				} else {
					if (diff < 0.0) diff = -diff;
					if (diff < EPSILON) {
						this._minContactsNum++;
					}
				}
				
				diff = dotProduct - this._max;
				if (diff > EPSILON) {
					this._max = dotProduct;
					this._maxVertex_x = vertex.x;
					this._maxVertex_y = vertex.y;
					this._maxContactsNum = 1;
				} else {
					if (diff < 0.0) diff = -diff;
					if (diff < EPSILON) {
						this._maxContactsNum++;
					}
				}
			}
		}
		
		public function projectCircle(axis_x:Number, axis_y:Number, center_x:Number, center_y:Number, radius:Number):void {
			var dotProduct:Number = axis_x * center_x + axis_y * center_y;
			this._min = dotProduct - radius;
			//this._minVertex_x = center_x - axis_x * dotProduct;
			//this._minVertex_y = center_y - axis_y * dotProduct;
			
			this._max = dotProduct + radius;
			//this._maxVertex_x = center_x + axis_x * dotProduct;
			//this._maxVertex_y = center_y + axis_y * dotProduct;
			
			//this._minContactsNum = 1;
			//this._maxContactsNum = 1;
		}
		
		public function isFurther(projection:Projection):Boolean {
			return projection._min > this._min;
		}
		
		public function distance(projection:Projection):Number {
			if (projection._min > this._min) return projection._min - this._max;
			return this._min - projection._max;
		}
		
		public function get minVertex_x():Number {
			return this._minVertex_x;
		}
		
		public function get minVertex_y():Number {
			return this._minVertex_y;
		}
		
		public function get maxVertex_x():Number {
			return this._maxVertex_x;
		}
		
		public function get maxVertex_y():Number {
			return this._maxVertex_y;
		}
		
		public function get minContactsNum():int {
			return this._minContactsNum;
		}
		
		public function get maxContactsNum():int {
			return this._maxContactsNum;
		}
		
	//	public function draw(graphics:Graphics, lineThickness:Number = 1.0, lineColor:uint = 0x440000, lineAlpha:Number = 0.5):void {
	//		graphics.lineStyle(lineThickness, lineColor, lineAlpha);
	//		graphics.moveTo(this._minVertex.x, this._minVertex.y);
	//		graphics.lineTo(this._maxVertex.x, this._maxVertex.y);
	//		graphics.endFill();
	//	}
		
	}
}

/* old:
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
*/