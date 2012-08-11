package engine.physics {
	import engine.geometry.Rectangle2D;
	import engine.geometry.Vector2D;
	import flash.display.Graphics;
	
	public class Cell {
		
		private var _successors:Vector.<Cell> = new Vector.<Cell>();
		private var _rigidBodies:Vector.<RigidBody> = new Vector.<RigidBody>();
		private var _root:Cell;
		private var _parent:Cell;
		private var _x:Number;
		private var _y:Number;
		private var _maxx:Number;
		private var _maxy:Number;
		
		
		public function Cell(depth:int, x:Number, y:Number, width:Number, height:Number, root:Cell, parent:Cell, graphics:Graphics = null) {
			if (root == null) {
				this._root = this;
			} else {
				this._root = root;
			}
			
			this._x = x;
			this._y = y;
			this._maxx = this._x + width;
			this._maxy = this._y + height;
			this._parent = parent;
			
			if (graphics) {
					graphics.lineStyle(1+depth/2, 0x000000, 1.0);
					graphics.drawRect(x, y, width, height);
			}
			//trace("СОЗДАНА ЯЧЕЙКА НА ГЛУБИНЕ -", depth );
			if (depth > 0) {
				var halfWidth:Number = 0.5 * width;
				var halfHeight:Number = 0.5 * height;
					this._successors[0] = new Cell(depth - 1, x, y, halfWidth, halfHeight, this._root, this, graphics);//UP-LEFT
					this._successors[1] = new Cell(depth - 1, x + halfWidth, y, halfWidth, halfHeight, this._root, this, graphics);//UP-RIGHT
					this._successors[2] = new Cell(depth - 1, x + halfWidth, y + halfHeight, halfWidth, halfHeight, this._root, this, graphics);//DOWN-RIGHT
					this._successors[3] = new Cell(depth - 1, x, y + halfHeight, halfWidth, halfHeight, this._root, this, graphics);//DOWN-LEFT
			}
		}
		
		public function push(body:RigidBody):Cell {
			//trace("PUSH");
			
			if (_successors.length > 0) {
				for (var i:int = 0; i < _successors.length; i++) {
					if (_successors[i].isContains(body)) {//false
						return _successors[i].push(body);
					}
				}
			}
			_rigidBodies.push(body);
			return this;
			
		}
		
		public function splice(body:RigidBody):void {
			_rigidBodies.splice(_rigidBodies.indexOf(body), 1);
		}
		
		public function isContains(body:RigidBody):Boolean {
			//trace(body.bounds.minX, body.bounds.minY, body.bounds.maxX, body.bounds.maxY);
			if (body.bounds.maxX > _maxx) return  false;
			if (body.bounds.minX < _x) return  false;
			if (body.bounds.maxY > _maxy) return  false;
			if (body.bounds.minY < _y) return  false;
			return true;
			
		}
		
		//если эта функция возвращает TRUE то мы не должны перерегистрировать боди
		//если фалс то должны
		// если мы уже не влазеем в эту ячейку
		// или если мы УЖЕ влазеем в любого из саццесоров
		public function repush(body:RigidBody):Cell {
			if (this.isContains(body) == false) {
				trace("CHANGE");
				return this._root.push(body);
			}
			for (var i:int = 0; i < _successors.length; i++) {
				if (_successors[i].isContains(body)) {
					return this._successors[i].push(body);
				}
			}
			return this;
		}
		
		public function getCellsUnderBody(body:RigidBody, cells:Vector.<Cell>):void {
			for (var i:int = 0; i < _successors.length; i++) {
				if (_successors[i].isCross(body.bounds)) {
					cells.push(_successors[i]);
					_successors[i].getCellsUnderBody(body, cells);
				}
			}
			
		}
		
		public function isCross(rectange:Rectangle2D):Boolean {
			if (_maxx < rectange.minX || _maxy < rectange.minY || rectange.maxX < _x || rectange.maxY < _y) return false;
			return true;
		}
		
		//isCross
		
		public function get parent():Cell { return this._parent; }
		
		//DEBUG
		
		public function draw(graphics:Graphics):void {
			graphics.lineStyle(0, 0x000000, 1.0);
			graphics.beginFill(0xFF0000, 0.2);
			graphics.drawRect(_x, _y, _maxx-_x, _maxy-_y);
			graphics.endFill();
		}
		
		public function toString():String {
			return _x + " " + _y + " " + _maxx + " " + _maxy;
		}
		
		
		
	}

}