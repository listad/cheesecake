package engine.physics {
	import engine.Component;
	import engine.GameObject;
	import engine.geometry.Polygon;
	import engine.geometry.Vector2D;
	public class Collider extends Component {
		
		private var _state:State;
		
		private var _isTrigger:Boolean = false;
		private var _type:int;
		private var _vertices:Vector.<Vector2D>;
		private var _globalVertices:Vector.<Vector2D>;
		private var _globalEdges:Vector.<Vector2D>;
		
		private var _globalVerticesActual:Boolean = false;
		private var _globalEdgesActual:Boolean = false;
		
		//TODO: globalVertices
		private var _radius:Number;
		private var _bounds:Bounds2D = new Bounds2D();
		
		public function Collider() {
			
		}
		
		public function set polygon(polygon:Polygon):void {
			this._vertices = polygon.vertices;
			var length:int = this._vertices;
			this._globalVertices = new Vector.<Vector2D>(length);
			this._globalEdges = new Vector.<Vector2D>(length);
			this._type = ColliderType.POLYGON;
		}
		
		public function set circle(radius:Number):void {
			this._radius = radius;
			this._type = ColliderType.CIRCLE;
		}
		
		public function updateBounds():void {
			switch(this._type) {
				case ColliderType.POLYGON:
					this._bounds.circumAroundPolygon(this.globalVertices);
					break;
				case ColliderType.CIRCLE:
					this._bounds.circumAroundCircle(this._state.x, this._state.y, this._radius);
					break;
				default:
					break;
			}
		}
		
		public function get isTrigger():Boolean {
			return this._isTrigger;
		}
		
		public function set isTrigger(value:Boolean):void {
			this._isTrigger = value;
		}
		
		public function get bounds():Bounds2D {
			return this._bounds;
		}
		
		// POLYGON
		
		public function get globalVertices():Vector.<Vector2D> {
			if (this._globalVerticesActual) {
				return this._globalVertices;
			} else {
				this._globalVerticesActual = true;
				
				var vertices:Vector.<Vector2D> = this._vertices;
				var length:int = vertices.length;
				for (var i:int = 0; i < length; i++)
					this._globalVertices[i] = this.state.toGlobal(vertices[i], this._globalVertices[i]);
					
				return this._globalVertices;
			}
		}
		
		public function get globalEdges():Vector.<Vector2D> {
			if (this._globalEdgesActual) {
				return this._globalEdges;
			} else {
				this._globalEdgesActual = true;
				
				var vertices:Vector.<Vector2D> = this.globalVertices;
				var length:int = vertices.length;
				for(var i:int = 0; i < length; i++) {
					var a:Vector2D = vertices[i];
					var b:Vector2D = (i + 1 == vertices.length) ? vertices[0] : vertices[int(i + 1)];
					this._globalEdges[i] = Vector2D.subtract(a, b);// WARNING !!! FIX ME !!!
				}
				
				return this._globalEdges;
			}
		}
		
		public function outdate():void {
			this._globalVerticesActual = false;
			this._globalEdgesActual = false;
		}
		
		
		
		
		
		
		
	}
}