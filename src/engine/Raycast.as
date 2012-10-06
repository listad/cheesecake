package engine {
	import engine.geometry.Line2D;
	import engine.geometry.Vector2D;
	import engine.math.Mathsolver;
	import engine.physics.Cell;
	import engine.physics.Collider;
	import engine.physics.ColliderType;
	import engine.physics.Quadtrees;
	import flash.display.Graphics;
	public class Raycast {
		
		private var _quadtrees:Quadtrees;
		private var _graphics:Graphics;
		public function Raycast(quadtrees:Quadtrees, graphics:Graphics) {
			this._quadtrees = quadtrees;
			this._graphics = graphics;
		}
		
		//contact_point
		//normal_vec
		//distance(?)
		//collider
		
		public var _start_x:Number;
		public var _start_y:Number;
		public var _distance_x:Number;
		public var _distance_y:Number;
		private var _normalized_x:Number;
		private var _normalized_y:Number;
		private var _perp_x:Number;//normalized
		private var _perp_y:Number;
		public var _distance:Number;//
		public var _collider:Collider;
		
		public var _contact:Boolean;
		public var _contact_x:Number;
		public var _contact_y:Number;
		public var _normal_x:Number;
		public var _normal_y:Number;
		
		public function raycast(start_x:Number, start_y:Number, distance_x:Number, distance_y:Number, mask:int = 0):void {
			_contact = false;
			var overlap:Boolean = _quadtrees.root.Line_AABB(start_x, start_y, distance_x, distance_y);
			if(overlap) {
				_start_x = _quadtrees.root.enterPoint_x;
				_start_y = _quadtrees.root.enterPoint_y;
				_distance_x = _quadtrees.root.exitPoint_x - start_x;
				_distance_y = _quadtrees.root.exitPoint_y - start_y;
				
				_distance = Math.sqrt( _distance_x * _distance_x + _distance_y * _distance_y);
				_normalized_x = _distance_x / _distance;
				_normalized_y = _distance_y / _distance;
				_perp_x = -_normalized_y;
				_perp_y = _normalized_x;
				this.quadtreeRaycast(_start_x, _start_y, _distance_x, _distance_y);
			}
			
			//debug
			//if (_contact) {
			//	drawPoint(_contact_x, _contact_y, 2);
			//}
		}
		
		//, grid_width:Number = 1024.0, grid_height:Number = 1024.0, depth:int = 6
		public function quadtreeRaycast(start_x:Number, start_y:Number, distance_x:Number, distance_y:Number):void {
			var grid_width:Number = Quadtrees.WIDTH;
			var grid_height:Number = Quadtrees.HEIGHT;
			var depth:int = Quadtrees.DEPTH;
			
			//this._graphics.lineStyle(0.1, 0xFF0000);
			//this._graphics.moveTo(start_x, start_y);
			//this._graphics.lineTo(start_x + distance_x, start_y + distance_y);
			
			//находим start_grid_index на всех QT depth
			for (var i:int = 0; i < depth; i++) {
				if (i != 0) {
					grid_width *= 0.5;
					grid_height *= 0.5;
				}
				
				var grid_x:int = int(start_x / grid_width);
				var grid_y:int = int(start_y / grid_height);
				
				drawCell(grid_width, grid_height, grid_x, grid_y, 0x00ff00, i);//проверка на пересечение с AABB's collider'ов внутри grid(i, start_grid_x, start_grid_y);
				//после полной проверки на контакт модифицируем distance и ограничиваем дальнейший рейкаст
				//
				
			}
			i--;
			
			var local_x:Number = start_x - grid_width * grid_x;//в локальной системе координат совпадающей с верним левым углом текущей ячейки QT (самого нижнего уровня)
			var local_y:Number = start_y - grid_height * grid_y;
			//trace("start position (local) ", local_x, local_y);
			
			//ПЕРВЫЙ ШАГ
			//по пути определим grig direction
			
			var grid_direction_x:int = 0;
			var grid_direction_y:int = 0;
			
			var current_step_x:Number;//координата х первого пересечения с гранью x текущей ячейки QT в локальной системе координат
			if(distance_x == 0) distance_x += 0.000001;//ПИПЕЦ
			if (distance_x > 0) {
				current_step_x = grid_width - local_x;
				grid_direction_x = 1;
			} else if (distance_x < 0) {
				current_step_x = - local_x;
				grid_direction_x = -1;
			}
			
			var current_step_y:Number;//координата y первого пересечения с гранью y текущей ячейки QT в локальной системе координат
			if(distance_y == 0) distance_y += 0.000001;//ПИПЕЦ
			if (distance_y > 0) {
				current_step_y = grid_height - local_y;
				grid_direction_y = 1;
			} else if (distance_y < 0) {
				current_step_y = - local_y;
				grid_direction_y = -1;
			}
			
			//trace("step_zero", current_step_x, current_step_y);
			//внимание! step0_(x/y) может так и остаться == NaN в случае если raycast || axis(x/y)
			
			//если raycast !|| axis_x/y
			
			var k:Number = distance_y / distance_x;//внимание! k может быть равно нулю или бесконечности
			
			var current_step_x_offset_y:Number = current_step_x * k;
			
			var current_step_y_offset_x:Number = current_step_y / k;
			
			//trace("delta01 ", current_step_x, current_step_x_offset_y, "delta02", current_step_y_offset_x, current_step_y);
			
			//ПОСЛЕДУЮЩИЕ ШАГИ
			//последующие шаги по x или y идут на расстояние grid_width или grid_height соотв.
			var step_x:Number;
			if (distance_x > 0) step_x = grid_width;
			if (distance_x < 0) step_x = - grid_width;
			
			var step_y:Number;
			if (distance_y > 0) step_y = grid_height;
			if (distance_y < 0) step_y = - grid_height;
			
			var step_x_offset_y:Number = step_x * k;	
			
			var step_y_offset_x:Number = step_y / k;
			
			//trace("deltaN1 ", step_x, step_x_offset_y, "deltaN2", step_y_offset_x, step_y);
			
			
			var current_x:Number = 0.0; //в локальной системе координат
			var current_y:Number = 0.0; //в локальной системе координат
			
			var last_grid_x:int;
			var last_grid_y:int;
			
			//тёмная магия
			do {
				var d1:Number = current_step_x * current_step_x + current_step_x_offset_y * current_step_x_offset_y;//TODO: manhattan distance
				var d2:Number = current_step_y_offset_x * current_step_y_offset_x + current_step_y * current_step_y;
				
				last_grid_x = grid_x;
				last_grid_y = grid_y;
				
				if(d1 < d2) {
					
					
					current_x += current_step_x;
					current_y += current_step_x_offset_y;
					//drawPoint(start_x + current_x, start_y + current_y);//debug;
					
					current_step_y -= current_step_x_offset_y;
					current_step_y_offset_x -= current_step_x;
					current_step_x = step_x;
					current_step_x_offset_y = step_x_offset_y;
					
					
					if( (current_x < 0 ? -current_x : current_x) < (distance_x < 0 ? -distance_x : distance_x) ) {
						grid_x += grid_direction_x;
					}
					
				} else {
					
					
					current_x += current_step_y_offset_x;
					current_y += current_step_y;
					//drawPoint(start_x + current_x, start_y + current_y);//debug;
					
					current_step_x -= current_step_y_offset_x;
					current_step_x_offset_y -= current_step_y;
					current_step_y = step_y;
					current_step_y_offset_x = step_y_offset_x;
					
					
					if( (current_y < 0 ? -current_y : current_y) < (distance_y < 0 ? -distance_y : distance_y) ) {
						grid_y += grid_direction_y;
					}
					
				}
				
				var or_product:int = (last_grid_x ^ grid_x) | (last_grid_y ^ grid_y);
				var d:int = 0;
				while (or_product > 0 && d < depth) {
					or_product = or_product >> 1;
					drawCell(grid_width << d, grid_height << d, grid_x >> d, grid_y >> d, 0x00ff00, (depth - 1) - d );//debug;
					d++;
				}
				
			} while (current_x * current_x + current_y * current_y < distance_x * distance_x + distance_y * distance_y);//можно оптимизировать или даже перевести на MANHATTEN DISTANCE (для сравнения вдоль одной прямой достаточно)
			
		}//qtrc
		
		function drawCell(width:Number, height:Number, index_x:Number, index_y:Number, color:uint, depth:int):void {
			var cell:Cell = _quadtrees.grid[depth][index_x][index_y];
			//trace(depth,index_x,index_y);
		//	cell.draw(this._graphics, 2, 0xff0000, 0.25, 0xff0000, 0.1);
			
			var collides:Vector.<Collider> = cell.colliders;
			var length:int = collides.length;
			for (var i:int = 0; i < length; i++) {
				var collider:Collider = collides[i];
				coarseIntersection(collider);
			}
			
			
			//перебираем все COLLIDER's этого cell'a
			// если RAY VS AABB == true (просто)
			//  если реальное пересечение то запоминаем всю инфу и модифицируем distance_x distance_y для qtraycast
			//     реальное песечение с полигоном + точка контакта + нормаль
			//     с окружностью + таже хрень
			//  raycast = true
			
			
			
			
		}
		
		private function coarseIntersection(collider:Collider):void {
			if (collider.bounds.Line_AABB( _start_x, _start_y, _distance_x, _distance_y ) == true) {
				if (collider.type == ColliderType.CIRCLE) circleIntersection( collider );
				else polygonIntersection( collider );
			}
		}
		
		private function circleIntersection(collider:Collider):void {
			//trace("CIR");
			
			var center_x:Number = collider.state.x;
			var center_y:Number = collider.state.y;
								//drawPoint(center_x, center_y, 24);
								
			var start_to_circle_direction_x:Number = center_x - _start_x;
			var start_to_circle_direction_y:Number = center_y - _start_y;
			
				var R:Number = collider.radius;
			if (start_to_circle_direction_x * start_to_circle_direction_x + start_to_circle_direction_y * start_to_circle_direction_y <= R * R ) return;
			
			var dot_product:Number = _normalized_x * start_to_circle_direction_x + _normalized_y * start_to_circle_direction_y;
			
			var nearest_x:Number;
			var nearest_y:Number;
			
				nearest_x = _start_x + _normalized_x * dot_product;
				nearest_y = _start_y + _normalized_y * dot_product;
			
			
			//drawPoint(nearest_x, nearest_y);
			
		
			
			var dx:Number = nearest_x - center_x;
			var dy:Number = nearest_y - center_y;
			var L:Number = Math.sqrt( dx * dx + dy * dy );
			if (L >= R) {
				return;
			}
			
			//drawPoint(center_x, center_y, R);
			
			var S:Number = Math.sqrt( R * R - L * L );
			
			nearest_x -= _normalized_x * S;
			nearest_y -= _normalized_y * S;
			
			var distance_x:Number = nearest_x - _start_x;
			var distance_y:Number = nearest_y - _start_y;
			var distance:Number = Math.sqrt( distance_x * distance_x + distance_y * distance_y );
			if (distance < _distance && distance_x * _distance_x >= 0 && distance_y * _distance_y >= 0) {
				_distance = distance;
				_distance_x = distance_x;
				_distance_y = distance_y;
				_contact = true;
				_contact_x = nearest_x;
				_contact_y = nearest_y;
				_collider = collider;
				_normal_x = (nearest_x - center_x) / R;
				_normal_y = (nearest_y - center_y) / R;
				
			} else {
				return;
			}
			
			//drawPoint(nearest_x, nearest_y, 2);
			
		}
		var temp:Vector2D = new Vector2D();
		private function polygonIntersection(collider:Collider):void {
			//trace("POLY");
			
			var vertices:Vector.<Vector2D> = collider.globalVertices;
			var length:int = vertices.length;
			var vertexA:Vector2D = vertices[ int( length - 1 ) ];
			
			var dx:Number = vertexA.x - _start_x;
			var dy:Number = vertexA.y - _start_y;
			var dotA:Number = dx * _perp_x +dy * _perp_y;
			
			
			for (var i:int = 0; i < length; i++) {
				
			
				var vertexB:Vector2D = vertices[ i ];
				var dx:Number = vertexB.x - _start_x;
				var dy:Number = vertexB.y - _start_y;
				var dotB:Number =  dx * _perp_x + dy * _perp_y;
					
				if(dotA > 0) {
					
					if(dotB < 0) {
						var intersect:Boolean = Line2D.isIntersection(_start_x, _start_y, _start_x + _distance_x, _start_y + _distance_y, vertexA.x, vertexA.y, vertexB.x, vertexB.y, temp);
						if (intersect) {
							var contact_x = temp.x;
							var contact_y = temp.y;
							var distance_x:Number = contact_x - _start_x;
							var distance_y:Number = contact_y - _start_y;
							var distance:Number = Math.sqrt( distance_x * distance_x + distance_y * distance_y );
							if (distance < _distance) {
								_distance = distance;
								_distance_x = distance_x;
								_distance_y = distance_y;
								_contact = true;
								_contact_x = contact_x;
								_contact_y = contact_y;
								_collider = collider;
								
								var abx:Number = vertexB.x - vertexA.x;
								var aby:Number = vertexB.y - vertexA.y;
								var dst:Number = Math.sqrt( abx * abx + aby * aby );
								_normal_x = aby / dst;
								_normal_y = - abx / dst;
							}
						}
					}
				
				}
				//
				vertexA = vertexB;
				dotA = dotB;
				
			}
		}
		
		
		function drawPoint(index_x:Number, index_y:Number, r:Number = 1):void {
			//this._graphics.beginFill(0xFF0000, 2);
			this._graphics.lineStyle(2, 0xff0000);
			this._graphics.drawCircle(index_x, index_y, r);
			//this._graphics.endFill();
		}
		
	}
}