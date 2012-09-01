package tests.game {
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

	public class PlayerController {
		private var _tank:Tank;
		
		private var _up:Boolean = false;
		private var _down:Boolean = false;
		private var _right:Boolean = false;
		private var _left:Boolean = false;
		
		public function PlayerController(stage:Stage, tank:Tank) {
			this._tank = tank;
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, this.onKeyUp);
			stage.addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
		}
		
		private function onKeyDown(event:KeyboardEvent):void {
			switch(event.keyCode) {
				case Keyboard.UP:
					this._up = true;
					break;
				case Keyboard.DOWN:
					this._down = true;
					break;
				case Keyboard.RIGHT:
					this._right = true;
					break;
				case Keyboard.LEFT:
					this._left = true;
					break;
		}}
		
		private function onKeyUp(event:KeyboardEvent):void {
			switch(event.keyCode) {
				case Keyboard.UP:
					this._up = false;
					break;
				case Keyboard.DOWN:
					this._down = false;
					break;
				case Keyboard.RIGHT:
					this._right = false;
					break;
				case Keyboard.LEFT:
					this._left = false;
					break;
			}
		}
		
			private function onEnterFrame(event:Event):void {
				if (this._up) this._tank.engine.acceleration = 1.0;
				if (this._down) this._tank.engine.acceleration = -1.0;
				if (!this._up && !this._down) this._tank.engine.acceleration = 0.0;
				if (this._right) this._tank.engine.steering = 1.0;
				if (this._left) this._tank.engine.steering = -1.0;
				if (!this._left && !this._right) this._tank.engine.steering = 0.0;
		}
	}
}