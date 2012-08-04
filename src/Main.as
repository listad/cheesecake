package {
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class Main extends Sprite {
		
		public function Main():void {
			if (super.stage) this.init();
			else super.addEventListener(Event.ADDED_TO_STAGE, this.init);
		}
		
		private function init(e:Event = null):void {
			super.removeEventListener(Event.ADDED_TO_STAGE, this.init);
		}
	}
}