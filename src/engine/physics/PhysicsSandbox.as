package engine.physics {
	import engine.util.Time;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class PhysicsSandbox extends Sprite {
		// Const
		
		// Var
		private var _physicsIterationsNum:int = 1;
		private var _rigidBodies:Vector.<RigidBody> = new Vector.<RigidBody>();
		private var _lastUpdateTimestamp:Number;
		
		// Constructor
		
		public function PhysicsSandbox() {
			
		}
		
		// Public
		
		public function run():void {
			this._lastUpdateTimestamp = Time.time;
			super.addEventListener(Event.ENTER_FRAME, this.enterFrameEventListener);
		}
		
		public function stop():void {
			
		}
		
		public function addRigidBody(rigidBody:RigidBody):void {
			this._rigidBodies.push(rigidBody);
			super.addChild(rigidBody);
		}
		
		public function removeRigidBody(rigidBody:RigidBody):void {
			var index:int = this._rigidBodies.indexOf(rigidBody);
			if (index > -1) this._rigidBodies.splice(index, 1, rigidBody);
			if (rigidBody.parent == super) super.removeChild(rigidBody);
		}
		
		// Private
		
		private function enterFrameEventListener(event:Event):void {
			trace("physicsUpdates...");
			var dt:Number = Time.time - this._lastUpdateTimestamp;
			this._lastUpdateTimestamp = Time.time;
			
			var iteration:int = 0;
			var ddt:Number = dt / this._physicsIterationsNum;
			do {
				trace("iteration", iteration);
				var length:int = this._rigidBodies.length;
				for (var i:int = 0; i < length; i++) {
					var rigidBody:RigidBody = this._rigidBodies[i];
					rigidBody.physicsUpdate(ddt);
					if (iteration + 1 == this._physicsIterationsNum) rigidBody.clear();
				}
			} while (++iteration < this._physicsIterationsNum);
		}
	}
}