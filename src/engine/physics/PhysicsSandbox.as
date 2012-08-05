package engine.physics {
	import engine.util.Time;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class PhysicsSandbox extends Sprite {
		// Const
		
		// Var
		private var _iterations:int = 4;
		
		private var _dynamicBodies:Vector.<RigidBody> = new Vector.<RigidBody>();
		private var _staticBodies:Vector.<RigidBody> = new Vector.<RigidBody>();
		
		private var _lastUpdate:Number;
		
		// Constructor
		
		public function PhysicsSandbox() {
			
		}
		
		// Public
		
		public function run():void {
			this._lastUpdate = Time.time;
			super.addEventListener(Event.ENTER_FRAME, this.enterFrameEventListener);
		}
		
		public function stop():void {
			
		}
		
		public function addRigidBody(rigidBody:RigidBody):void {
			rigidBody.debugGraphics = super.graphics;//DEBUG!!!
			if (rigidBody.mass == Infinity) {
				this._staticBodies.push(rigidBody);
			} else {
				this._dynamicBodies.push(rigidBody);
			}
			super.addChild(rigidBody);
		}
		
		public function removeRigidBody(rigidBody:RigidBody):void {
			var index:int;
			if (rigidBody.mass == Infinity) {
				index = this._staticBodies.indexOf(rigidBody);
				if (index > -1) this._staticBodies.splice(index, 1, rigidBody);
			} else {
				index = this._dynamicBodies.indexOf(rigidBody);
				if (index > -1) this._dynamicBodies.splice(index, 1, rigidBody);
			}
			if (rigidBody.parent == super) super.removeChild(rigidBody);
		}
		
		// Private
		
		private function enterFrameEventListener(event:Event):void {
			var dt:Number = Time.time - this._lastUpdate;
			this._lastUpdate = Time.time;
			
			var ddt:Number = dt / this._iterations;
			for (var i:int = 0; i < this._iterations; i++) {
				var length:int = this._dynamicBodies.length;
				for (var j:int = 0; j < length; j++) {
					var rigidBody:RigidBody = this._dynamicBodies[j];
					rigidBody.physicsUpdate(ddt);
				}
			}
		}
	}
}