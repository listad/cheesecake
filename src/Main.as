package {
	
	
	import engine.geometry.Vector2D;
	import flash.display.Sprite;
	import flash.events.Event;
	import tests.CoarseCollisionExperiment;
	import tests.TankExperiment;
	import tests.ProjectileMotionExperiment;
	
	[SWF(width = "1080", height = "1080", frameRate = "60", backgroundColor = "#FFFFFF")]
	
	public class Main extends Sprite {
		
		public function Main():void {
			if (super.stage) this.init();
			else super.addEventListener(Event.ADDED_TO_STAGE, this.init);
		}
		
		private function init(e:Event = null):void {
			super.removeEventListener(Event.ADDED_TO_STAGE, this.init);
			//super.addChild( new TankExperiment() );
			super.addChild( new CoarseCollisionExperiment(super.stage) );
			
			
		}
	}
}