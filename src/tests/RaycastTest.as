package tests {
	import engine.GameEngine;
	import engine.GameObject;
	import engine.geometry.Polygon;
	import engine.physics.Collider;
	import engine.Raycast;
	import flash.events.Event;
	
	public class RaycastTest extends GameEngine {
		var j = 0;
		
		public function RaycastTest() {
			
			var gameObject:GameObject;
			
			//gameObject = new GameObject(500, 500, Math.random() * 6.28);
			//gameObject.collider = new Collider();
			//gameObject.collider.circle = 150;
			//super.addGameObject( gameObject );
				
			//gameObject = new GameObject(500, 500, Math.random() * 6.28);
			//gameObject.collider = new Collider();
			//gameObject.collider.polygon = Polygon.rect(250, 50);
			//super.addGameObject( gameObject );
			
			for (var i:int = 0; i < 60; i++) {
				gameObject = new GameObject(Math.random() * 900 + 50, Math.random() * 900 + 50, Math.random() * 6.28);
				gameObject.collider = new Collider();
				gameObject.collider.polygon = Polygon.rect(Math.random()*150.0, 5 + Math.random()*150.0);
				super.addGameObject( gameObject );
			}
		
			for (var i:int = 0; i < 40; i++) {
				gameObject = new GameObject(Math.random() * 900 + 50, Math.random() * 900 + 50, Math.random() * 6.28);
				gameObject.collider = new Collider();
				gameObject.collider.circle = 100;
				super.addGameObject( gameObject );
			}
			
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:*) {
			if(j >= Math.PI * 2) removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			
			
			
			
			j += 0.05;
			
			
			
			
			
			//for (var j:Number = 0; j < Math.PI * 2.0; j += 0.1) {
				var raycaster:Raycast = super.physics.quadtrees.raycast;
				raycaster.raycast(500, 500, Math.sin(j) * 1000, Math.cos(j) *  1000);
				if (raycaster._contact) {
					_staticGraphics.lineStyle(0.1, 0xff0000);
					_staticGraphics.moveTo(500, 500);
					_staticGraphics.lineTo(raycaster._contact_x, raycaster._contact_y);
					
					_staticGraphics.lineStyle(1, 0x00FF00);
					_staticGraphics.moveTo(raycaster._contact_x, raycaster._contact_y);
					_staticGraphics.lineTo(raycaster._contact_x + 10 * raycaster._normal_x, raycaster._contact_y + 10 * raycaster._normal_y);
				} else {
					//_staticGraphics.lineStyle(0.1, 0xff0000);
					//_staticGraphics.moveTo(500, 500);
					//_staticGraphics.lineTo(raycaster._start_x + raycaster._distance_x, raycaster._start_y + raycaster._distance_y);
				}
				
				_staticGraphics.lineStyle(1, 0x00FF00);
				
					_staticGraphics.drawCircle(500, 500, 3);
				
			//}
		}
		
	}

}