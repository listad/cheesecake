package tests.game {
	import engine.GameEngine;
	import engine.GameObject;
	import engine.physics.Collider;
	import engine.Raycast;
	import flash.display.GradientType;
	import flash.events.Event;
	import flash.geom.Matrix;
	import tests.TankExperiment;


	import flash.display.Bitmap;
import flash.display.PixelSnapping;
	import engine.GameObject;

	import engine.geometry.Vector2D;

	
	public class Bullet extends GameObject {
		private var _direction_x:Number;
		private var _direction_y:Number;
		var _ge:TankExperiment;
		public function Bullet(x:Number, y:Number, angle:Number, direction_x:Number, direction_y:Number, ge:TankExperiment) {
			_ge = ge;
			state.x = x;
			state.y = y;
			state.rotation = angle;
			_direction_x = direction_x;
			_direction_y = direction_y;
			var bitmap:Bitmap = new Bitmap( DataLoader.getData(DataLoader.MISSILE), PixelSnapping.NEVER, true );
			super.addChild( bitmap );
			bitmap.scaleX = bitmap.scaleY = 0.1;
			bitmap.y -= 0.5 * bitmap.height;
			bitmap.x -= 0.5 * bitmap.width;
			
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
		}
		
		private function onEnterFrame(e:*) {
			_ge.drawStage.graphics.lineStyle(1, 0xff8800);
			_ge.drawStage.graphics.moveTo(state.x / 4, state.y / 4);
			_ge.drawStage.graphics.lineTo(state.x / 4 + _direction_x / 4, state.y / 4 + _direction_y / 4);
			
				
			
			_ge.light.graphics.lineStyle(25, 0xffffff, 0.25);
			_ge.light.graphics.moveTo(state.x / 4, state.y / 4);
			_ge.light.graphics.lineTo(state.x / 4 + _direction_x / 4, state.y / 4 + _direction_y / 4);
			
			var raycaster:Raycast = _ge.physics.quadtrees.raycast;
			raycaster.raycast(state.x, state.y, _direction_x, _direction_y);
			if (raycaster._contact) {
				trace("HITTEST");
				var collider:Collider = raycaster._collider;
				if (collider.rigidBody) {
					collider.rigidBody.addImpulseAtPoint(new Vector2D(_direction_x * 0.5, _direction_y * 0.5), new Vector2D( raycaster._contact_x - collider.state.x, raycaster._contact_y - collider.state.y ) );
				}
				for (var i:int = 0; i < 50; i++) {
					_ge._particles.push( new Particle(raycaster._contact_x / 4, raycaster._contact_y / 4) );
				}
				destroy();
			} else {
				state.x += _direction_x;
				state.y += _direction_y;
			}
			
			if (state.x < -100 || state.y < -100 || state.x > 1100 || state.y > 1100 ) {
				destroy();
			}
		}
		
		private function destroy() {
			
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			visible = false;
			//_ge.remo
		}
		
	}

}