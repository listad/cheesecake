package engine.physics {
	import engine.geometry.Polygon;
	import engine.geometry.Vector2D;
	
	public class CollisionGeometry extends Polygon {
		public static function rect(width:Number, height:Number):CollisionGeometry {
			return new CollisionGeometry(Polygon.rect(width, height));
		}
		
		public static function convexRegular(sides:int, radius:int):CollisionGeometry {
			return new CollisionGeometry(Polygon.convexRegular(sides, radius));
		}
		
		///////////////////////////////////////////////////////////////////////////////////////////////////
		//
		///////////////////////////////////////////////////////////////////////////////////////////////////
		
		private var _globalVerticesActual:Boolean = false;
		private var _globalEdgesActual:Boolean = false;
		private var _globalVertices:Vector.<Vector2D>;
		private var _globalEdges:Vector.<Vector2D>;
		private var _body:RigidBody;
		
		public function CollisionGeometry(vertices:Vector.<Vector2D>) {
			var length:int = vertices.length;
			this._globalVertices = new Vector.<Vector2D>(length);
			this._globalEdges = new Vector.<Vector2D>(length);
			super(vertices);
		}
		
		public function set body(value:RigidBody):void {
			this._body = value;
		}
		
		public function get globalVertices():Vector.<Vector2D> {
			if (this._globalVerticesActual) {
				return this._globalVertices;
			} else {
				this._globalVerticesActual = true;
				
				var vertices:Vector.<Vector2D> = super.vertices;
				var length:int = vertices.length;
				for (var i:int = 0; i < length; i++)
					this._globalVertices[i] = this._body.toGlobal(vertices[i], this._globalVertices[i]);
					
				return this._globalVertices;
			}
		}
		
		public function get globalEdges():Vector.<Vector2D> {
			if (this._globalEdgesActual) {
				return this._globalEdges;
			} else {
				this._globalEdgesActual = true;
				
				
				////
				var vertices:Vector.<Vector2D> = this.globalVertices;
				var length:int = vertices.length;
				for(var i:int = 0; i < length; i++) {
					var a:Vector2D = vertices[i];
					var b:Vector2D = (i + 1 == vertices.length) ? vertices[0] : vertices[int(i + 1)];
					this._globalEdges[i] = Vector2D.subtract(a, b);
				}
				
				////
				return this._globalEdges;
			}
		}
		
		public function outdate():void {
			this._globalVerticesActual = false;
			this._globalEdgesActual = false;
		}
		
	}
}