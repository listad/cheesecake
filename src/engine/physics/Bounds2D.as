package engine.physics {
	import engine.geometry.Matrix2D;
	import engine.geometry.Rectangle2D;
	import engine.geometry.Vector2D;
	
	public class Bounds2D extends Rectangle2D {
		private var _rigidBody:RigidBody;
		
		public function Bounds2D() {
			super();
		}
		
		public function update(rigidBody:RigidBody):void {
			this._rigidBody = rigidBody;
			super._minX = rigidBody.xPosition;
			super._maxX = rigidBody.xPosition;
			super._minY = rigidBody.yPosition;
			super._maxY = rigidBody.yPosition;
			
			var matrix:Matrix2D = rigidBody.matrix;
			
			for (var i:int = 0; i < rigidBody.collisionGeometry.vertices.length; i++) {//FIXME
				var vertex:Vector2D = rigidBody.collisionGeometry.vertices[i];
				vertex = matrix.transformVector2D(vertex, null, rigidBody.xPosition, rigidBody.yPosition);
				if (vertex.x < super._minX) super._minX = vertex.x;
				if (vertex.x > super._maxX) super._maxX = vertex.x;
				if (vertex.y < super._minY) super._minY = vertex.y;
				if (vertex.y > super._maxY) super._maxY = vertex.y;
			}
		}
		
	}
}