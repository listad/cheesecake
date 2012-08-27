package engine.physics {
	import engine.geometry.Rectangle2D;
	import engine.geometry.Vector2D;
	import flash.display.Graphics;
	
	public class Cell extends Rectangle2D {
		private var _rigidBodyNum:int = 0;
		
		private var _successors:Vector.<Cell> = new Vector.<Cell>();
		private var _rigidBodies:Vector.<RigidBody> = new Vector.<RigidBody>();
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
			
			//if (graphics) super.draw(graphics, 1.0, 0x00FF00, 0.05, 0x000000, 0.0);
			
			if (depth > 0) {
				var halfWidth:Number = 0.5 * width;
				var halfHeight:Number = 0.5 * height;
				this._successors[0] = new Cell(depth - 1, x, y, halfWidth, halfHeight, this._root, this, graphics);								//UP-LEFT
				this._successors[1] = new Cell(depth - 1, x + halfWidth, y, halfWidth, halfHeight, this._root, this, graphics);					//UP-RIGHT
				this._successors[2] = new Cell(depth - 1, x + halfWidth, y + halfHeight, halfWidth, halfHeight, this._root, this, graphics);	//DOWN-RIGHT
				this._successors[3] = new Cell(depth - 1, x, y + halfHeight, halfWidth, halfHeight, this._root, this, graphics);				//DOWN-LEFT
			}
		}
		
		public function push(body:RigidBody):Cell {
			this._rigidBodyNum++;
			var parent:Cell = this._parent;
			while (parent != null) {
				parent.rigidBodyNum++;
				parent = parent.parent;
			}
				
			var successorsNum:int = this._successors.length;
			for (var i:int = 0; i < successorsNum; i++) {
				var successor:Cell = this._successors[i];
				if (successor.isContains(body)) return successor.push(body);
			}
			
			this._rigidBodies.push(body);//FIXME
			return this;
		}
		
		public function splice(body:RigidBody):void {
			
			
			var index:int = this._rigidBodies.indexOf(body);//FIXME
			if (index != -1) {
				this._rigidBodyNum--;
				this._rigidBodies.splice(index, 1);//FIXME
				
				
				var parent:Cell = body.quadcell.parent;
				while (parent != null) {
					parent.rigidBodyNum--;
					parent = parent.parent;
				}
			}
		}
		
		public function isContains(body:RigidBody):Boolean {
			var bounds:Rectangle2D = body.bounds;
			if (bounds.maxX > super._maxX) return false;
			if (bounds.minX < super._minX) return false;
			if (bounds.maxY > super._maxY) return false;
			if (bounds.minY < super._minY) return false;
			return true;
		}
		
		public function repush(body:RigidBody):Cell {
			if (this.isContains(body) == false) {
				this.splice(body);
				return this._root.push(body);
			}
			
			var successorsNum:int = this._successors.length;
			for (var i:int = 0; i < successorsNum; i++) {
				var successor:Cell = this._successors[i];
				if (successor.isContains(body)) {
					this.splice(body);
					return successor.push(body);
				}
			}
			
			return this;
		}
		
		public function getCellsUnderBody(body:RigidBody, cells:Vector.<Cell>):void {
			var successorsNum:int = this._successors.length;
			for (var i:int = 0; i < successorsNum; i++) {
				var successor:Cell = this._successors[i];
				if (successor.collide(body.bounds)) {
					var incount:int = successor._rigidBodies.length;
					if (incount > 0)//
						cells.push(successor);
						
					if(successor._rigidBodyNum - incount > 0) successor.getCellsUnderBody(body, cells);
				}
			}
		}
		
		public function get parent():Cell { return this._parent; }
		public function get rigidBodies():Vector.<RigidBody> { return this._rigidBodies; }
		
		public function get rigidBodyNum():int { return this._rigidBodyNum; }
		public function set rigidBodyNum(value:int):void { this._rigidBodyNum = value; }
		
	}
}