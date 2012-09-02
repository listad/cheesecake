package engine.physics {
	import engine.geometry.Rectangle2D;
	import engine.geometry.Vector2D;
	import flash.display.Graphics;
	
	public class Cell extends Rectangle2D {
		private var _collidersNum:int = 0;
		
		private var _successors:Vector.<Cell> = new Vector.<Cell>();
		private var _colliders:Vector.<Collider> = new Vector.<Collider>();
		private var _root:Cell;
		private var _parent:Cell;
		
		public function Cell(depth:int, x:Number, y:Number, width:Number, height:Number, root:Cell, parent:Cell, graphics:Graphics = null) {
			if (root == null) {
				this._root = this;
			} else {
				this._root = root;
			}
			
			super._minX = x;
			super._minY = y;
			super._maxX = super._minX + width;
			super._maxY = super._minY + height;
			this._parent = parent;
			
			if (graphics) super.draw(graphics, 1.0, 0x00FF00, 0.05, 0x000000, 0.0);
			
			if (depth > 0) {
				var halfWidth:Number = 0.5 * width;
				var halfHeight:Number = 0.5 * height;
				this._successors[0] = new Cell(depth - 1, x, y, halfWidth, halfHeight, this._root, this, graphics);								//UP-LEFT
				this._successors[1] = new Cell(depth - 1, x + halfWidth, y, halfWidth, halfHeight, this._root, this, graphics);					//UP-RIGHT
				this._successors[2] = new Cell(depth - 1, x + halfWidth, y + halfHeight, halfWidth, halfHeight, this._root, this, graphics);	//DOWN-RIGHT
				this._successors[3] = new Cell(depth - 1, x, y + halfHeight, halfWidth, halfHeight, this._root, this, graphics);				//DOWN-LEFT
			}
		}
		
		public function push(collider:Collider):Cell {
			this._collidersNum++;
			var parent:Cell = this._parent;
			while (parent != null) {
				parent.collidersNum++;
				parent = parent.parent;
			}
				
			var successorsNum:int = this._successors.length;
			for (var i:int = 0; i < successorsNum; i++) {
				var successor:Cell = this._successors[i];
				if (successor.isContains(collider)) return successor.push(collider);
			}
			
			this._colliders.push(collider);//FIXME
			return this;
		}
		
		public function splice(collider:Collider):void {
			
			
			var index:int = this._colliders.indexOf(collider);//FIXME
			if (index != -1) {
				this._collidersNum--;
				this._colliders.splice(index, 1);//FIXME
				
				
				var parent:Cell = collider.quadcell.parent;
				while (parent != null) {
					parent.collidersNum--;
					parent = parent.parent;
				}
			}
		}
		
		public function isContains(collider:Collider):Boolean {
			var bounds:Rectangle2D = collider.bounds;
			if (bounds.maxX > super._maxX) return false;
			if (bounds.minX < super._minX) return false;
			if (bounds.maxY > super._maxY) return false;
			if (bounds.minY < super._minY) return false;
			return true;
		}
		
		public function repush(collider:Collider):Cell {
			if (this.isContains(collider) == false) {
				this.splice(collider);
				return this._root.push(collider);
			}
			
			var successorsNum:int = this._successors.length;
			for (var i:int = 0; i < successorsNum; i++) {
				var successor:Cell = this._successors[i];
				if (successor.isContains(collider)) {
					this.splice(collider);
					return successor.push(collider);
				}
			}
			
			return this;
		}
		
	//	public function getCellsUnderBody(body:RigidBody, cells:Vector.<Cell>):void {
	//		var successorsNum:int = this._successors.length;
	//		for (var i:int = 0; i < successorsNum; i++) {
	//			var successor:Cell = this._successors[i];
	//			if (successor.collide(body.bounds)) {
	//				var incount:int = successor._colliders.length;
	//				if (incount > 0)//
	//					cells.push(successor);
	//					
	//				if(successor._collidersNum - incount > 0) successor.getCellsUnderBody(body, cells);
	//			}
	//		}
	//	}
		public function getColliders(collider:Collider, colliders:Vector.<Collider>):void {
			var successorsNum:int = this._successors.length;
			for (var i:int = 0; i < successorsNum; i++) {
				var successor:Cell = this._successors[i];
				if (successor.collide(collider.bounds)) {
					
					var candidates:Vector.<Collider> = successor.colliders;
					var candidatesNum:int = candidates.length;
					for (var j:int = 0; j < candidatesNum; j++) {
						var candidate:Collider = candidates[j];
						colliders.push(candidate);
					}
						
					if(successor._collidersNum - candidatesNum > 0) successor.getColliders(collider, colliders);
				}
			}
		}
		
		public function get parent():Cell { return this._parent; }
		public function get colliders():Vector.<Collider> { return this._colliders; }
		
		public function get collidersNum():int { return this._collidersNum; }
		public function set collidersNum(value:int):void { this._collidersNum = value; }
		
	}
}