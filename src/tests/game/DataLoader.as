package tests.game {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	public class DataLoader extends EventDispatcher {
		
		private static var _instance:DataLoader;
		
		public static var TANK:int = 0;
		public static var GROUND:int = 1;
		public static var BOX:int = 2;
		
		private var _files:Vector.<String> = new <String>[
			"https://dl.dropbox.com/u/29689693/tank.png",
			"https://dl.dropbox.com/u/29689693/ground.jpg",
			"https://dl.dropbox.com/u/29689693/box.jpg" ];
		
		private var _bitmaps:Vector.<BitmapData> = new Vector.<BitmapData>();
			
		private var _tank:Bitmap;
		
		private var _fileNum:int = 0;
		
		private var _loader:Loader = new Loader();
		
		public function DataLoader() {
			DataLoader._instance = this;
			
			var urlRequest:URLRequest = new URLRequest( this._files[this._fileNum] );
			this._loader.load(urlRequest);
			this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.completeEventListener);
			this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.ioErrorEventListener);
		}
		
		public static function getData(id:int):BitmapData {
			//fixme
			return DataLoader._instance._bitmaps[ id ];
		}
		
		private function completeEventListener(event:Event):void {
			var bitmap:Bitmap = this._loader.content as Bitmap;
			if(bitmap) this._bitmaps.push( bitmap.bitmapData );
			
			trace("completeEventListener");
			if ( ++this._fileNum < _files.length ) {
				var urlRequest:URLRequest = new URLRequest( this._files[ this._fileNum ] );
				this._loader.load(urlRequest);
			} else {
				super.dispatchEvent( new Event(Event.COMPLETE) );
			}
		}
		
		private function ioErrorEventListener(event:Event):void {
			trace("ioErrorEventListener");
		}
		
		
	}
}