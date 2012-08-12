package engine.geometry {
	import engine.physics.RigidBody;
	
	public class Projection {
		private var _min:Number;
		private var _max:Number;
		
		public function Projection(axis:Vector2D, body:RigidBody) {
			this.project(axis, body);
		}
		
		public function project(axis:Vector2D, body:RigidBody):void {
			this._min = Number.POSITIVE_INFINITY;
			this._max = Number.NEGATIVE_INFINITY;
			
			var vertices:Vector.<Vector2D> = body.collisionGeometry.vertices;
			var length:int = vertices.length;
			for (var i:int = 0; i < length; i++) {
				var dotProduct:Number = axis.dot( body.toGlobal(vertices[i]) );
				if (dotProduct < this._min) this._min = dotProduct;
				if (dotProduct > this._max) this._max = dotProduct;
			}
		}
		
		public function isFurther(projection:Projection):Boolean {
			return projection._min > this._min;
		}
		
		public function distance(projection:Projection):Number {
			if (projection._min > this._min) return projection._min - this._max;
			return this._min - projection._max;
		}
		
	}
}