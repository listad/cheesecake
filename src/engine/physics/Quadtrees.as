package engine.physics {
	import flash.display.Graphics;
	
	public class Quadtrees {
		public static const DEPTH:int = 6;
		
		public static const WIDTH:Number = 2000.0;
		public static const HEIGHT:Number = 2000.0;
		
		private var _successor:Cell;
		
		public function Quadtrees(graphics:Graphics) {
			trace("quadtrees initializing...");
			this._successor = new Cell(DEPTH, 0.0, 0.0, WIDTH, HEIGHT, null, null, graphics);
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