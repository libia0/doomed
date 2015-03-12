package
{
	/**
	 * 时间工具集
	 * ...
	 * @author db0@qq.com
	 */
	public class TimeCode 
	{
		/**
		 * 本地时间与标准时间的差
		 */
		public static var diffWithStdTime:Number=0;
		 
		public function TimeCode() 
		{
			
		}
		
		
		
		/**
		 * 网络json时间转为as 的时间
		 * @param	dateStr
		 * @return
		 */
		public static function fromWebJson(dateStr:String):Date
		{
			return new Date(Number(dateStr.replace(/\/Date\((\d+)\)\//, "$1")));
		}
		
		/**
		 * 网络时间转为as 的时间
		 * @param	dateStr
		 * @return
		 */
		public static function fromWeb(dateStr:String):Date
		{
				var arrs:Array = dateStr.split("T");
				
				var dateArr:Array = String(arrs[0]).split("-");
				var year:Number = Number(dateArr[0]);
				var month:Number = Number(dateArr[1]);
				var day:Number = Number(dateArr[2]);
				
				var timeArr:Array = String(arrs[1]).split(":");
				var hour:Number = Number(timeArr[0]);
				var min:Number = Number(timeArr[1]);
				var second:Number = Number(timeArr[2]);
				
				
				//logs.adds("timeNumber:", Number(date));
				//logs.adds("timeStr:", new Date(Number(date)+60*60*1000));
				//logs.adds("timeStr:", dateStr);
				return new Date(year, month-1, day, hour, min, second);
		}
		/**
		 * php网络时间转为as 的时间
		 * @param	dateStr
		 * @return
		 */
		public static function fromPHP(dateStr:String):Date
		{
				var arrs:Array = dateStr.split(" ");
				
				var dateArr:Array = String(arrs[0]).split("-");
				var year:Number = Number(dateArr[0]);
				var month:Number = Number(dateArr[1]);
				var day:Number = Number(dateArr[2]);
				
				var timeArr:Array = String(arrs[1]).split(":");
				var hour:Number = Number(timeArr[0]);
				var min:Number = Number(timeArr[1]);
				var second:Number = Number(timeArr[2]);
				
				
				//logs.adds("timeNumber:", Number(date));
				//logs.adds("timeStr:", new Date(Number(date)+60*60*1000));
				//logs.adds("timeStr:", dateStr);
				return new Date(year, month-1, day, hour, min, second);
		}
		
		
		
		/**
		 * 当前的标准时间
		 * @return
		 */
		public static function curStdTime():Date
		{
			return (new Date(afterSecond(new Date(),diffWithStdTime)));
		}
		
		
		/**
		 * 将as3时间转为 中文串
		 * @param	date
		 * @return 2013年12月1日17：23
		 */
		public static function date2string(date:Date):String
		{
			//AAAA于2013年12月1日17：23分献上BBBB
			return date.fullYear + "年" + (date.month + 1) + "月" + date.date + "日" + date.hours + ":" + (date.minutes>=10?date.minutes:("0"+date.minutes)) + "";
		}
		
		/**
		 * 将as3时间转为 中文串精确到秒
		 * @param	date
		 * @return 2013年12月1日17：23
		 */
		public static function date2TimeString(date:Date):String
		{
			//AAAA于2013年12月1日17：23分献上BBBB
			return date.fullYear + "年" + (date.month + 1) + "月" + date.date + "日" + date.hours + ":" + (date.minutes>=10?date.minutes:("0"+date.minutes))+ ":" + (date.seconds>=10?date.seconds:("0"+date.seconds)) + "";
		}
		
		/**
		 * as 的时间转为网络时间
		 * @param	date
		 * @return
		 */
		public static function toWeb(date:Date):String
		{
			var str:String = date.fullYear + "-" + ((date.month + 1 < 10)?("0" + (date.month + 1)):(date.month + 1)) + "-" + ((date.date < 10)?("0"+date.date):date.date) + "T" + (date.hours < 10?("0" + date.hours):date.hours) +":" + (date.minutes < 10?("0" + date.minutes):date.minutes) + ":" + (date.seconds < 10?("0" + date.seconds):date.seconds);
			//logs.adds(str);
			return str;
			//(date.seconds < 10?("0" + date.seconds):date.seconds);
		}
		
		/**
		 * 返回当前时间 多少秒后的时间
		 * @param	date
		 * @param	seconds
		 * @return
		 */
		public static function afterSecond(date:Date,seconds:int):Date
		{
			return (new Date(Number(date) + 1000 * seconds));
		}
		
		/**
		 * 返回两个时间差的秒数
		 * @param	date1
		 * @param	date2
		 * @return
		 */
		public static function diff(date1:Date, date2:Date):int {
			if(date1 && date2)
				return ((Number(date1) - Number(date2)) / 1000);
			else
				return 0;
		}
		
		/**
		 * 时间是否已经过去
		 * @param	date
		 * @return
		 */
		public static function ispassed(date:Date):Boolean
		{
			//logs.adds(curStdTime());
			return Boolean(Number(date) - Number(curStdTime()) <= 0);
		}
	}

}
