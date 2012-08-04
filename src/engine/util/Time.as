package engine.util {
	public class Time {
		public static const MILLISECONDS_TO_SECONDS:Number = 0.001;
		
		public static function get time():Number { return new Date() .time * MILLISECONDS_TO_SECONDS; }
	}
}