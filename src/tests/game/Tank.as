package tests.game {
	import engine.physics.CollisionGeometry;
	import engine.physics.IForce;
	import engine.physics.RigidBody;
	import flash.display.Bitmap;
	import engine.physics.Friction;
	import flash.display.PixelSnapping;
	import flash.filters.DropShadowFilter;
	
	public class Tank extends RigidBody {
		
		private var _engine:Engine = new Engine(40000.0, 200000.0);
		
		public function Tank(x:Number, y:Number, angle:Number = 0.0) {
			super(x, y, angle, 40.0, 20000.0, 0.0, 0.25, CollisionGeometry.rect( 72.0, 34.0 ) );
			
			//graphics.beginBitmapFill( DataLoader.getData(DataLoader.TANK) );
			//graphics.drawRect( -36.0, -17.0, 72.0, 34.0);
				
			var bitmap:Bitmap = new Bitmap( DataLoader.getData(DataLoader.TANK), PixelSnapping.NEVER, true );
			super.addChild( bitmap );
			bitmap.y -= 0.5 * bitmap.height;
			bitmap.x -= 0.5 * bitmap.width - 8.0;
		
			super.addForce( this._engine );
			
			super.addForce( new Friction(10.0) );
			
			//bitmap.filters = [ ( new DropShadowFilter(6, 0, 0, 0.5, 5, 5, 5, 3) )  ];
		}
		
		public function get engine():Engine {
			return this._engine;
		}
	}
}