package tests.game 
{
	/**
	 * ...
	 * @author Listad
	 */
	public class Particle 
	{
		public var x:Number;
		public var y:Number;
		public var vx:Number;
		public var vy:Number;
		public var color:uint = 0xff8800;
		public var life:int = 25;
		var max_speed:Number;
		public var alpha:Number;
		public function Particle(x:Number, y:Number, alpha:Number = 1.0 ) 
		{
			this.alpha = alpha;
			color = ((200 + Math.random() * 55) << 16) |
			((50 + Math.random() * 100) << 8 )
			| ( Math.random() * 50 ) ;
			
				life = 1 + Math.random()*20;
				max_speed = 1 + Math.random()*Math.random()*6;
			this.x = x;
			this.y = y;
			vx = max_speed * (0.5 - Math.random());
			vy = max_speed * (0.5 - Math.random());
		}
		public function move(_value:uint):void {
			var r:uint = _value >> 16;
			var g:uint = _value >> 8 & 256;
			var b:uint = _value & 256;
			
			vx += (r - b) / 800;
			vy += (g - b) / 800;
			
			if (vx > max_speed) vx = max_speed;
			if (vx < -max_speed) vx = -max_speed;
			if (vy > max_speed) vy = max_speed;
			if (vy < -max_speed) vy = -max_speed;
			x += vx;
			y += vy;
		}
		
	}

}