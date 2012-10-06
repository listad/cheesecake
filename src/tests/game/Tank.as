package tests.game {
	import engine.physics.CollisionGeometry;
	import engine.physics.IForce;
	import engine.physics.RigidBody;
	import flash.display.Bitmap;
	import flash.display.BlendMode;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.DropShadowFilter;
	import engine.GameObject;
	import engine.physics.Collider;
	import engine.geometry.Polygon;
	import engine.geometry.Vector2D;
	import engine.GameEngine;
	import flash.geom.ColorTransform;
	import tests.TankExperiment;
	import flash.display.BitmapData;
	
	public class Tank extends GameObject {
		
		private var _engine:Engine = new Engine(200000.0, 2000000.0);
		private var _gameEngine:TankExperiment;
		
		private var _lastShotTime:Number = 0.0;
		private var _bmp:Bitmap;
		public function Tank(x:Number, y:Number, angle:Number, gameEngine:TankExperiment, bmp:Bitmap) {
			_gameEngine = gameEngine;
			_bmp = bmp;
			rigidBody = new RigidBody();
			collider = new Collider();
			
			collider.polygon = Polygon.rect( 72.0, 34.0 );
			state.x = x;
			state.y = y;
			state.rotation = angle;
			 
			rigidBody.mass = 3000;
			rigidBody.inertiaTensor = 5000000;
			rigidBody.drag = 0.75;
			rigidBody.angularDrag = 0.9;
			
			var data:BitmapData = DataLoader.getData(DataLoader.TANK);
			data.colorTransform(data.rect, new ColorTransform(0.5, 0.5, 0.5) );
			var bitmap:Bitmap = new Bitmap( data, PixelSnapping.NEVER, true );
			super.addChild( bitmap );
			bitmap.y -= 0.5 * bitmap.height;
			bitmap.x -= 0.5 * bitmap.width - 8.0;
		
			rigidBody.addForce( this._engine );
			
			//super.addForce( new Friction(10.0) );
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:*) {
			var sprite:Sprite = new Sprite();
			sprite.graphics.lineStyle(2, 0x000000, 1);
			var cx:Number = state.x / 4 + state.right.x * 14 / 4 - state.forward.x * 32 / 4 ;
			var cy:Number =  state.y / 4  + state.right.y * 14 / 4 - state.forward.y * 32 / 4;
			sprite.graphics.moveTo(cx, cy);
			sprite.graphics.lineTo(cx + state.forward.x * 62 / 4  , cy + state.forward.y * 62 / 4 );
			
			var cx:Number = state.x / 4 - state.right.x * 14 / 4 - state.forward.x * 32 / 4 ;
			var cy:Number =  state.y / 4  - state.right.y * 14 / 4 - state.forward.y * 32 / 4;
			sprite.graphics.moveTo(cx, cy);
			sprite.graphics.lineTo(cx + state.forward.x * 62 / 4  , cy + state.forward.y * 62 / 4 );
			//sprite.graphics.drawCircle(cx, cy, 1)
			//sprite.graphics.lineTo(state.x / 4 + state.forward.x, state.y / 4  + state.forward.y);
			_bmp.bitmapData.draw(sprite);
		}
		
		public function get engine():Engine {
			return this._engine;
		}
		
		public function shot():void {
			
			if ( new Date() .time - this._lastShotTime < 500 ) return;
			//trace("BABAM!");
			var impulse:Vector2D = state.forward;
			impulse.negate().scale(75000);
			rigidBody.addImpulse(impulse);
			
			this._lastShotTime = new Date() .time;
			
			var bullet:Bullet = new Bullet(state.x + state.forward.x * 25, state.y + state.forward.y * 25, state.rotation, state.forward.x * 25, state.forward.y * 25, _gameEngine);
			this._gameEngine.addGameObject( bullet );
			
		}
		
		private var _lastMachinegunShotTime:Number = 0.0;
		public function machinegunShot():void {
			if ( new Date() .time - this._lastMachinegunShotTime < 100 ) return;
			this._lastMachinegunShotTime = new Date() .time;
			var bullet:MachinegunBullet = new MachinegunBullet(state.x + state.forward.x * 25, state.y + state.forward.y * 25, state.rotation, state.forward.x * 100, state.forward.y * 100, _gameEngine);
			this._gameEngine.addGameObject( bullet );
		}
	}
}