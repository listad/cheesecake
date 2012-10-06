package {
	
	
	import engine.physics.Quadtrees;
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;	
	import flash.geom.Matrix;
	import tests.RaycastTest;
	import tests.TankExperiment;
	//import tests.CoarseCollisionExperiment;
	//import tests.pool.Pool;
	
	[SWF(width = "1000", height = "1000", frameRate = "60", backgroundColor = "#FFFFFF")]
	
	public class Main extends Sprite {
		
		public function Main():void {
			//super.mouseChildren = false;
			//super.mouseEnabled = false;
			//.//super.tabChildren = false;
			//..super.tabEnabled = false;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			
			if (super.stage) this.init();
			else super.addEventListener(Event.ADDED_TO_STAGE, this.init);
		}
		
		private function init(e:Event = null):void {
			super.removeEventListener(Event.ADDED_TO_STAGE, this.init);
			
			////stage.quality = StageQuality.MEDIUM;
			//super.addChild( new CoarseCollisionExperiment() );
			//super.addChild( new Pool(stage) );
			//super.addChild( new TankExperiment(stage) );
		
			//super.addChild( new RaycastTest() );
			
		
			//var m:Matrix = new Matrix();
			//m.createGradientBox(100, 100, 0, 0, 0);
			//graphics.beginGradientFill( GradientType.RADIAL, [0xff0000, 0xff0000], [0.1, 0], [0, 255], m);
			//graphics.drawCircle(50, 50, 50);
		}
	}
}