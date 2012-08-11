package engine.geometry {
	import engine.physics.RigidBody;
	import flash.display.Graphics;
	import flash.geom.Point;
	
	public class Rectangle2D {
		private var _rigidBody:RigidBody;
		private var _minX:Number;
		private var _minY:Number;
		private var _maxX:Number;
		private var _maxY:Number;
		private var _radius:Number = 0.0;
		public function Rectangle2D() {
			
		}
		public function collide(rectange:Rectangle2D):Boolean {
			if (maxX < rectange.minX || maxY < rectange.minY || rectange.maxX < minX || rectange.maxY < minY) return false;
			return true;
		}
		public function update(rigidBody:RigidBody):void {
			this._rigidBody = rigidBody;
			this._minX = rigidBody.xPosition;
			this._maxX = rigidBody.xPosition;
			this._minY = rigidBody.yPosition;
			this._maxY = rigidBody.yPosition;
			
			var matrix:Matrix2D = rigidBody.matrix;
			
			for (var i:int = 0; i < rigidBody.collisionGeometry.vertices.length; i++) {
				var vertex:Vector2D = rigidBody.collisionGeometry.vertices[i];
				var distance:Number = vertex.length;
				if(distance > this._radius) this._radius = distance;
				vertex = matrix.transformVector2D(vertex, null, rigidBody.xPosition, rigidBody.yPosition);
				if (vertex.x < _minX) _minX = vertex.x;
				if (vertex.x > _maxX) _maxX = vertex.x;
				if (vertex.y < _minY) _minY = vertex.y;
				if (vertex.y > _maxY) _maxY = vertex.y;
			}
		}
		public function get minX():Number { return this._minX; }
		public function get minY():Number { return this._minY; }
		public function get maxX():Number { return this._maxX; }
		public function get maxY():Number { return this._maxY; }
		
		public function draw(graphics:Graphics, lineThickness:Number = 2.0, lineColor:uint = 0xFF0000, lineAlpha:Number = 0.1, fillColor:uint = 0xFF0000, fillAlpha = 0.015):void {
			graphics.lineStyle(lineThickness, lineColor, lineAlpha);
			graphics.beginFill(fillColor, fillAlpha);
			graphics.drawRect(this._minX, this._minY, this._maxX - this._minX, this._maxY - this._minY);
			//graphics.drawCircle(this._rigidBody.x, this._rigidBody.y, this._radius);
			graphics.endFill();
		}
	}
}