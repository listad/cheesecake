package tests.game 
{
	import engine.GameObject;
	import engine.geometry.Polygon;
	import engine.physics.Collider;
	import engine.physics.RigidBody;
	import flash.display.Bitmap;
import flash.display.PixelSnapping;
import flash.display.BitmapData;
import flash.geom.ColorTransform;

	/**
	 * ...
	 * @author Listad
	 */
	public class Box extends GameObject
	{
		
		public function Box(x:Number, y:Number, rotation:Number) 
		{
			state.x = x;
			state.y = y;
			state.rotation = rotation;
			
			collider = new Collider();
			
			collider.polygon = Polygon.rect(20, 20);
			rigidBody = new RigidBody();
			rigidBody.drag = 0.5;
			rigidBody.angularDrag = 0.75;
			
			var data:BitmapData = DataLoader.getData(DataLoader.BOX);
			data.colorTransform(data.rect, new ColorTransform(0.5, 0.5, 0.5) );
			
			var bitmap:Bitmap = new Bitmap( data, PixelSnapping.NEVER, true );
			super.addChild( bitmap );
			bitmap.scaleX = bitmap.scaleY = 0.15;
			bitmap.y -= 0.5 * bitmap.height;
			bitmap.x -= 0.5 * bitmap.width;
		}
		
	}

}