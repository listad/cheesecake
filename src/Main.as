package {
	import flash.display.Sprite;
	import flash.events.Event;
	import tests.CoarseCollisionExperiment;
	import tests.MikaTest;
	import tests.ProjectileMotionExperiment;
	
	public class Main extends Sprite {
		
		public function Main():void {
			if (super.stage) this.init();
			else super.addEventListener(Event.ADDED_TO_STAGE, this.init);
		}
		
		private function init(e:Event = null):void {
			super.removeEventListener(Event.ADDED_TO_STAGE, this.init);
			//new MikaTest();
			this.runProjectileMotionExperiment();
		}
		
		private function runProjectileMotionExperiment():void {
			super.addChild(new CoarseCollisionExperiment(super.stage));
		}
	}
	
}