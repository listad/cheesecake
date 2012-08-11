package engine.physics {
	import flash.display.Graphics;
	
	public class Quadtrees {
		public static const DEPTH:int = 4;
		
		public static const WIDTH:Number = 600.0;
		public static const HEIGHT:Number = 600.0;
		
		private var _successor:Cell;
		
		public function Quadtrees(graphics:Graphics) {
			this._successor = new Cell(DEPTH, 0.0, 0.0, WIDTH, HEIGHT, null, null, graphics);
		}
		
		public function push(body:RigidBody):Cell {
			return this._successor.push(body);
		}
		
		//getcell
		public function getCellsNearBody(body:RigidBody):Vector.<Cell> {
			var cells:Vector.<Cell> = new Vector.<Cell>();
			cells.push(body.quadcell);
			
			var parent:Cell = body.quadcell.parent;
			while (parent != null) {
				cells.push(parent);
				parent = parent.parent;
			}
			
			body.quadcell.getCellsUnderBody(body, cells);
			
			return cells;
		}
		
	}

}