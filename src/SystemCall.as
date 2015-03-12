package
{
	import flash.system.Capabilities;
	public class SystemCall
	{
		public function SystemCall()
		{

		}

		public static function get os():String
		{
			return Capabilities.version.split(/[\r\n\t ]/)[0];
			/*trace("system:",Capabilities.version.split(/[\r\n\t ]/)[0]);*/
		}
		public static function get flashplayer_version():Array
		{
			return String(Capabilities.version.split(/[\r\n\t ]/)[1]).split(",");
		}
	}
}
