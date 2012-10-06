package tests {

	import engine.GameEngine;
	import engine.GameObject;
	import engine.geometry.Matrix2D;
	import engine.geometry.Polygon;
	import engine.physics.Collider;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import tests.game.Box;
	import tests.game.DataLoader;
	import tests.game.Particle;
	import tests.game.PlayerController;
	import tests.game.Tank;
	import flash.filters.DropShadowFilter;

	public class TankExperiment extends GameEngine {
		
		var bitmap:Bitmap ;
		
		private var _dataLoader:DataLoader = new DataLoader();
		private var _stage:Stage;
		
		private var bmpDataBack:BitmapData;
		private var bmpData:BitmapData;
		private var bmpBack:Bitmap;
		private var bmp:Bitmap;
		
		
		private var bmpLight:Bitmap;
		private var bmdDataLight:BitmapData;
		
		public var drawStage:Sprite = new Sprite();
		public var drawStage1:Sprite = new Sprite();
		public var drawStage2:Sprite = new Sprite();
		
		private var blur:BlurFilter = new BlurFilter(1.5, 1.5, 2);
		
		private var bmpPerlin:BitmapData;
		
		public function TankExperiment(stage:Stage) {
			this._stage = stage;
			this._dataLoader.addEventListener( Event.COMPLETE, this.completeEventListener );
			
			drawStage.addChild(drawStage1);
			drawStage.addChild(drawStage2);
		}
		
		private function completeEventListener(event:Event):void {
			trace("all data loaded");
			var data:BitmapData = DataLoader.getData(DataLoader.GROUND);
			data.colorTransform(data.rect, new ColorTransform(0.25, 0.25, 0.25) );
			super.graphics.beginBitmapFill( data );
			super.graphics.drawRect(0.0, 0.0, 1000.0, 1000.0);
			super.graphics.endFill();
			
			var bitmapdata:BitmapData = new BitmapData(256, 256, true, 0x00FFFFFF);

			bitmap = new  Bitmap(bitmapdata);
			bitmap.scaleX = bitmap.scaleY = 4;
			bitmap.alpha = 0.1;
			_staticContainer.addChild(bitmap);
			bitmap.blendMode = BlendMode.OVERLAY;
			
			bmpPerlin = new BitmapData(256, 256, false, 0x000000);
			bmpPerlin.perlinNoise(100, 100, 3, Math.random() * 100, false, true);
			
			
			 bmdDataLight = new BitmapData(256, 256, true, 0x00000000);
			 bmpLight = new Bitmap( bmdDataLight );
			 bmpLight.scaleX = bmpLight.scaleY = 4;
			 bmpLight.blendMode = BlendMode.OVERLAY;
			// _staticContainer.
			 addChild(bmpLight);
			 
			 
			 bmpDataBack = new BitmapData(256, 256, true, 0x00000000);
			 bmpBack = new Bitmap( bmpDataBack );
			 bmpBack.scaleX = bmpBack.scaleY = 4;
			// _staticContainer.
			 addChild(bmpBack);
			 
			 bmpData = new BitmapData(256, 256, true, 0x00000000);
			 bmp = new Bitmap( bmpData );
			 bmp.scaleX = bmp.scaleY = 4;
			 _staticContainer.addChild(bmp);
			  bmp.alpha = 0.5;
			  
			 bmpBack.blendMode = BlendMode.ADD;
			 bmp.blendMode = BlendMode.OVERLAY;
			
			//4 стенки
			var border:GameObject = new GameObject(500, 5);
			border.collider = new Collider();
			border.collider.polygon = Polygon.rect(1000, 10)
			super.addGameObject(border);
			
			var border:GameObject = new GameObject(500, 995);
			border.collider = new Collider();
			border.collider.polygon = Polygon.rect(1000, 10)
			super.addGameObject(border);
			
			var border:GameObject = new GameObject(5, 500);
			border.collider = new Collider();
			border.collider.polygon = Polygon.rect(10, 980)
			super.addGameObject(border);
			
			var border:GameObject = new GameObject(995, 500);
			border.collider = new Collider();
			border.collider.polygon = Polygon.rect(10, 980)
			super.addGameObject(border);
			
			var tank:Tank = new Tank(100, 100, 0, this, bitmap);
			
			super.addGameObject(tank);
			
			var pc:PlayerController = new PlayerController(this._stage, tank);
			
			
			for (var i:int = 0; i < 25; i++) {
				var box:Box = new Box(Math.random() * Math.random() * 900 + 50,Math.random() * Math.random() * 900 + 50, Math.random() * 6.28);
				super.addGameObject(box);
			}
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			
		}
		
		public var _particles:Vector.<Particle> = new Vector.<Particle>();
		
		public var light:Sprite = new Sprite();
		var ga:Array = [0xffffff, 0xffffff];
		var aa:Array = [0.1, 0];
		var ra:Array = [0, 255];
		var m:Matrix = new Matrix();
		
		private function onEnterFrame(e:*) {
			
			
			bmdDataLight.lock();
			bmpDataBack.lock();
			bmpData.lock();
			
			bmdDataLight.applyFilter(bmdDataLight, bmdDataLight.rect, new Point(0, 0), new BlurFilter(5, 5, 2) );
			bmpDataBack.applyFilter(bmpDataBack, bmpDataBack.rect, new Point(0, 0), blur);
			
			for (var i:int = 0; i < _particles.length; i++) {
				var p:Particle = _particles[i];
				var x:Number = p.x;
				var y:Number = p.y;
				p.move(bmpPerlin.getPixel(p.x, p.y));
				drawStage1.graphics.lineStyle(1, p.color, p.alpha);
				drawStage1.graphics.moveTo(x, y);
				drawStage1.graphics.lineTo(p.x, p.y);
				
				light.graphics.lineStyle(100, 0xffffff, 0.05 * p.alpha);
				light.graphics.moveTo(x, y);
				light.graphics.lineTo(p.x, p.y);
				//var r:int = 150;
				//
				//m.createGradientBox(r, r, 0, p.x - r/2, p.y - r/2);
				//light.graphics.lineStyle(0, 0, 0);
				//
				//light.graphics.beginGradientFill( GradientType.RADIAL, ga, aa, ra, m);
				//light.graphics.drawCircle(p.x, p.y, r);
				//light.graphics.endFill();
				
				p.life --;
				if (p.life <= 0) {
					_particles.splice(i, 1);
				}
			}
			
			
			//
			//bmpData.fillRect(bmpData.rect, 0x00000000);
			//bmpData.draw(drawStage, null, null, BlendMode.ADD);
			
			bmdDataLight.draw(light, null, new ColorTransform(1, 1, 1, 1), BlendMode.NORMAL);
			
			bmpDataBack.draw(drawStage, null, new ColorTransform(1, 1, 1, 1), BlendMode.ADD);
			
			bmpData.draw(drawStage1, null, new ColorTransform(0, 0, 0, 0.1), BlendMode.ADD);
			
			bmdDataLight.unlock();
			bmpDataBack.unlock();
			bmpData.unlock();
			//
			drawStage1.graphics.clear();
			drawStage2.graphics.clear();
			drawStage.graphics.clear();
			light.graphics.clear();
		}
	}
}
