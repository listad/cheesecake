package engine.physics {
	import engine.Component;
	import engine.GameObject;
	import engine.geometry.Polygon;
	import engine.geometry.Vector2D;
	public class Collider extends Component {
		private var _material:PhysicsMaterial = PhysicsMaterial.DEFAULT_MATERIAL;
		
		private var _isTrigger:Boolean = false;
		private var _type:int = 0;
		private var _vertices:Vector.<Vector2D>;
		private var _globalVertices:Vector.<Vector2D>;
		private var _globalEdges:Vector.<Vector2D>;
		
		private var _isValid:Boolean = false;
		private var _boundsActual:Boolean = false;
		private var _globalVerticesActual:Boolean = false;
		private var _globalEdgesActual:Boolean = false;
		
		//TODO: globalVertices
		private var _radius:Number;
		private var _bounds:Bounds2D = new Bounds2D();
		
		//quadtrees
		private var _quadcell:Cell;
		private var _quadtreeVisible:Boolean = false;
		
		
		//debug:
		private var _polygon:Polygon;
		
		public function Collider() {
			super();
		}
		
		public function invalidate():void {
			this._isValid = false;
			this._boundsActual = false;
			this._globalVerticesActual = false;
			this._globalEdgesActual = false;
		}
		
		public function validate():void {
			this._isValid = true;
		}
		
		public function set polygon(polygon:Polygon):void {
			this._polygon = polygon;//debug
		
			this._vertices = polygon.vertices;
			var length:int = this._vertices.length;
			this._globalVertices = new Vector.<Vector2D>(length);
			this._globalEdges = new Vector.<Vector2D>(length);
			this._type = ColliderType.POLYGON;
			
			this.updateBounds();
			
			//debug:
			//var color:uint = super.gameObject.rigidBody ? 0xFFAAAA : 0xAAAAAA;
			
			//polygon.draw(super.gameObject.graphics, 1, 0, 1, color, 0.01);
		}
		
		public function set circle(radius:Number):void {
			this._radius = radius;
			this._type = ColliderType.CIRCLE;
			
			this.updateBounds();
			
			if(super.rigidBody) super.rigidBody.inertiaTensor = radius * radius * super.rigidBody.mass;
			//debug:
			//var color:uint = super.gameObject.rigidBody ? 0xFFAAAA : 0xAAAAAA;
			//
			//super.gameObject.graphics.lineStyle(1, 0, 1);
			//
			//super.gameObject.graphics.beginFill(color, 0.01);
			//super.gameObject.graphics.drawCircle(0, 0, radius);
			//super.gameObject.graphics.endFill();
			//super.gameObject.graphics.lineTo(0, 0);
		}
		
		public function updateBounds():void {
			switch(this._type) {
				case CollisionMatrix.POLYGON:
					this._bounds.circumAroundPolygon(this.globalVertices);
					break;
				case CollisionMatrix.CIRCLE:
					this._bounds.circumAroundCircle(super.state.x, super.state.y, this._radius);
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
			if (this._boundsActual == false) {
				this.updateBounds();
				this._boundsActual = true;
			}
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
					this._globalVertices[i] = this.gameObject.state.toGlobal(vertices[i], this._globalVertices[i]);
				
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
		
		//public function outdate():void {
		//	this._globalVerticesActual = false;
		//	this._globalEdgesActual = false;
		//}
		
		public function get quadcell():Cell { return this._quadcell; }
		public function set quadcell(value:Cell):void { this._quadcell = value; }
		public function get quadtreeVisible():Boolean { return this._quadtreeVisible; }
		public function set quadtreeVisible(value:Boolean):void { this._quadtreeVisible = value; }
		public function get type():int { return this._type; }
		
		public function get material():PhysicsMaterial { return this._material; }
		public function set material(value:PhysicsMaterial):void { this._material = value; }
		
		public function get polygon():Polygon { return this._polygon; }
		public function get radius():Number { return this._radius; }
		
		
	}
}