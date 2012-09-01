package tests {
	import engine.physics.CollisionGeometry;
	import engine.physics.Friction;
	import engine.physics.PhysicsSandbox;
	import engine.physics.RigidBody;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.BevelFilter;
	import flash.filters.DropShadowFilter;
	import tests.game.DataLoader;
	import tests.game.PlayerController;
	import tests.game.Tank;
	public class TankExperiment extends Sprite {
		
		private var _dataLoader:DataLoader = new DataLoader();
		
		public function TankExperiment() {
			this._dataLoader.addEventListener( Event.COMPLETE, this.completeEventListener );
		}
		
		private function completeEventListener(event:Event):void {
			trace("all data loaded");
			super.graphics.beginBitmapFill( DataLoader.getData(DataLoader.GROUND) );
			super.graphics.drawRect(0.0, 0.0, 1000.0, 1000.0);
			
			
			var sandbox:PhysicsSandbox = new PhysicsSandbox();
			super.addChild( sandbox );
			
			
			for (var i:int = 0; i < 1; i++) {
				var block:RigidBody = new RigidBody(500 + Math.random()*200, 50 + Math.random()*200, 2.0 * Math.PI * Math.random(), 0.0001, 0.01, 1.0, 0.0, CollisionGeometry.rect(15, 15) );
				
				block.graphics.beginBitmapFill( DataLoader.getData(DataLoader.BOX) );
				block.graphics.drawRect(-7.5, -7.5, 15.0, 15.0);
				
				block.addForce(new Friction(3.0));
				//block.filters = [ ( new DropShadowFilter(4, 0, 0, 0.5, 3, 3, 3, 3) )  ];
				sandbox.addRigidBody(block);
			}
			
			sandbox. filters = [ ( new DropShadowFilter(4, 0, 0, 0.25, 5, 5, 2, 1) ) , new BevelFilter(8, 0, 0xfaebb1, 0.1, 0x000000, 0.4, 10, 10, 2, 3) ];
			
			var tank:Tank = new Tank(100.0, 100.0, 0.0);
			var playerController:PlayerController = new PlayerController(super.stage, tank);
			sandbox.addRigidBody( tank );
			
			tank = new Tank(400.0, 700.0, 0.0);
			sandbox.addRigidBody( tank );
			
			tank = new Tank(500.0, 700.0, 0.0);
			sandbox.addRigidBody( tank );
			
			tank = new Tank(400.0, 800.0, 0.0);
			sandbox.addRigidBody( tank );
			
			tank = new Tank(500.0, 800.0, 0.0);
			sandbox.addRigidBody( tank );
			
			tank = new Tank(600.0, 700.0, 0.0);
			sandbox.addRigidBody( tank );
			
			tank = new Tank(700.0, 700.0, 0.0);
			sandbox.addRigidBody( tank );
			
			tank = new Tank(600.0, 800.0, 0.0);
			sandbox.addRigidBody( tank );
			
			tank = new Tank(700.0, 800.0, 0.0);
			sandbox.addRigidBody( tank );
			
			
			
		}
	}
}
