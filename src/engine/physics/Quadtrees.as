package engine.physics {
	import engine.Raycast;
	import flash.display.Graphics;
	
	public class Quadtrees {
		public static const DEPTH:int = 6;
		
		public static const WIDTH:int = 1024;//только степерь двойки!!!
		public static const HEIGHT:int = 1024;
		
		//newL
		private var _successor:Cell;
		private var _graphics:Graphics;
		
		private var _grid:Vector.<Vector.<Vector.<Cell>>> = new Vector.<Vector.<Vector.<Cell>>>(DEPTH);
		
		public var raycast:Raycast;//debug
		
		public function Quadtrees(graphics:Graphics) {
			trace("quadtrees initializing...");
			this._graphics = graphics;
			//this._successor = new Cell(DEPTH, 0.0, 0.0, WIDTH, HEIGHT, null, null, graphics);
			
			this._successor = new Cell(0, 0, 0, 0, 0, WIDTH, HEIGHT, null, null, this._graphics);
			for (var depth:int = 0; depth < DEPTH; depth++) {
				
				
				var side:int = 1 << depth;
				
				var grid_depth:Vector.<Vector.<Cell>> = new Vector.<Vector.<Cell>>(side);
				this._grid[depth] = grid_depth;
				
				for (var x:int = 0; x < side; x++) {
					
					var grid_depth_x:Vector.<Cell> = new Vector.<Cell>(side);
					grid_depth[x] = grid_depth_x;
					
				}
			}
			
			quart(_successor);
			this._grid[0][0][0] = _successor;
			_successor.max_x = WIDTH - 1;//HACK!
			_successor.max_y = HEIGHT - 1;
			//debug:
			raycast = new Raycast(this, graphics);
		}
		
		public function get grid():Vector.<Vector.<Vector.<Cell>>> {
			return this._grid;
		}
	
		private function quart(predecessor:Cell):void {
				var parent_depth:int = predecessor.depth;
				var depth:int = parent_depth + 1;
				var parent_grid_x:int = predecessor.grid_x;
				var parent_grid_y:int = predecessor.grid_y;
				//depth, grid_x, grid_y, x, y, width, height, root, parent, graphics
				var successors:Vector.<Cell> = new Vector.<Cell>()
				 
				for (var x:int = 0; x < 2; x++) {
					for (var y:int = 0; y < 2; y++) {
						var grid_x:int = (parent_grid_x << 1) | x;
						var grid_y:int = (parent_grid_y << 1) | y;
						var width:int = WIDTH >> depth;
						var height:int = HEIGHT >> depth;
						var cell:Cell = new Cell(depth, grid_x, grid_y, width * grid_x, height * grid_y, width, height, this._successor, predecessor, this._graphics);
						successors.push(cell);
						this._grid[depth][grid_x][grid_y] = cell;
						if (depth + 1 < DEPTH) {
							quart(cell);
						}
					}
				}
				
				predecessor.successors = successors;
		}
		
		
		/////////////////////////////////////
		
		public function get root():Cell {
			return this._successor;
		}
		
		public function push(collider:Collider):Cell {
			return this._successor.push(collider);
		}
		
		public function getColliders(collider:Collider, vin:Vector.<Collider> = null):Vector.<Collider> {
			var i:int;
			var candidate:Collider;
			
			var colliders:Vector.<Collider> = vin;
			if (colliders == null) colliders = new Vector.<Collider>();
			
			//current cell
			var currentCell:Cell = collider.quadcell;
			var candidates:Vector.<Collider> = currentCell.colliders;
			var candidatesNum:int = candidates.length;
			for (i = 0; i < candidatesNum; i++) {
				candidate = candidates[i];
				if (candidate != collider) colliders.push(candidate);
			}
			
			//up
			var parent:Cell = collider.quadcell.parent;
			while (parent != null) {
				candidates = parent.colliders;
				candidatesNum = candidates.length;
				for (i = 0; i < candidatesNum; i++) {
					candidate = candidates[i];
					colliders.push(candidate);
				}
				parent = parent.parent;
			}
			
			//down
			currentCell.getColliders(collider, colliders);
			return colliders;
		}
		
		//public function raycast(s_x, s_y, dir_x, dir_y
		
		//getcell
	//	public function getCellsNearBody(collider:Collider):Vector.<Cell> {
	//		var cells:Vector.<Cell> = new Vector.<Cell>();
	//		if (body.quadcell.rigidBodies.length > 1)//
	//			cells.push(body.quadcell);
	//		
	//		var parent:Cell = body.quadcell.parent;
	//		while (parent != null) {
	//			if (parent.colliders.length > 0)//
	//				cells.push(parent);
	//			parent = parent.parent;
	//		}
	//		
	//		body.quadcell.getCellsUnderBody(body, cells);
	//		
	//		return cells;
	//	}
		
	}

}