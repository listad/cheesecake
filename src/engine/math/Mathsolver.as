package engine.math {
	public class Mathsolver {
		public function Mathsolver() {
			
		}
		
		public static const DEG_TO_RAD:Number = Math.PI / 180.0;
		public static const RAD_TO_DEG:Number = 180 / Math.PI;
		public static const EPSILON:Number = 1.0E-6;
		
		public static function clamp(value:Number, from:Number = 0.0, to:Number = 1.0):Number {
			if(value < from) return from;
			if(value > to) return to;
			return value;
		}
		
		public static function approximately(a:Number, b:Number):Boolean {
			var diff:Number = a - b;
			if(diff < 0) diff = -diff;
			if(diff < EPSILON) return true;
			return false;
		}
			
		public static function lerp(from:Number, to:Number, t:Number):Number {
			if(t <= 0.0) return from;
			if(t >= 1.0) return to;
			var min:Number = to - from;
			return from + min * t;
		}
		
		public static function nextPowerOfTwo(value:int):int {
			var result:int = 1;
			while(result < value) result = result << 1;
			return result;
		}
		
		public static function loop(i:int, min:int = 0, max:int = 3):int {
			while(i >= max) i -= max;
			while(i < min) i += max;
			return i;
		}
	}
}