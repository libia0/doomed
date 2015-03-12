/**
 * @file BtnGroup.as
 *  

 var btngroup:BtnGroup = new BtnGroup([["×公历 ","√公历 "],["×农历 ","√农历 "]]);
 addChild(btngroup);
 btngroup.setBtnsPos([[0,0],[100,0]]);
 btngroup.select_by_index(0);
 trace(btngroup.values);

 * @author db0@qq.com
 * @version 1.0.1
 * @date 2014-04-11
 */
package
{
	import flash.display.Sprite;
	public class BtnGroup extends Sprite
	{
		private var txtArr:Array = null;
		private var btnArr:Array = null;
		private var fun:Function;
		private var multiSelect:Boolean = false;
		/**
		 * @file BtnGroup.as
		 *  _txtArr:按钮的文本二维数组,第一个下标表按钮的索引,第二个表按钮选中和没选中两种文本状态
_multiSelect:是否为多选题,
_fun:点击按钮相应的函数
		 * @author db0@qq.com
		 * @version 1.0.1
		 * @date 2014-04-11
		 */
		public function BtnGroup(_txtArr:Array,_multiSelect:Boolean=false,_fun:Function=null,verti:Boolean=false,_color:uint=0)
		{
			txtArr=_txtArr;
			fun=_fun;
			if(_fun==null)fun = clicked;
			multiSelect = _multiSelect;
			if(txtArr){
				btnArr = new Array();
				var i:int = 0;
				for each(var arr:Array in txtArr)
				{
					/*trace(arr[0]);*/
					var btn:TxtBtn = new TxtBtn(arr[0],fun);
					btn.set_fun(fun,btn);
					btn.setformat(25,35,"center",0xffffff,0xeeeeee,_color,_color,0x999999,verti);
					addChild(btn);
					btn.name = "b"+i;
					btnArr.push(btn);
					++i;
				}
			}
			if(!multiSelect)btnArr[0].text=txtArr[0][1];
		}
		private function clicked(btn:Object):void
		{
			selectBtn(TxtBtn(btn));
			trace(values);
		}
		/*
		   根据按钮的索引选中按钮
		 */
		public function select_by_index(i:int):void
		{
			if(uint(i)<btnArr.length)
				selectBtn(btnArr[i]);
		}
		/**
		  选中按钮
		 */
		public function selectBtn(btn:TxtBtn):void
		{
			if(contains(btn)){
				var index:int = int(btn.name.substr(1));
				var btntxt:String = btnArr[index].text;
				var changed:Boolean=false;
				if(Fanti.fan2jian(btntxt)==Fanti.fan2jian(txtArr[index][0])){
					btn.text = txtArr[index][1];
					changed = true;
				} else if(multiSelect){
					btn.text = txtArr[index][0];
				}
				if(!multiSelect && changed){
					var i:int = 0;
					while(i<txtArr.length){
						if(i!=index)btnArr[i].text = txtArr[i][0];
						++i;
					}
				}
			}
		}
		/**
		  获取当前的选中的按钮的值的数组
		 */
		public function get values():Array
		{
			var arr:Array=new Array();
			var i:int = 0;
			while(i<txtArr.length){
				if(Fanti.fan2jian(btnArr[i].text) != Fanti.fan2jian(txtArr[i][0]))arr.push(btnArr[i].text);
				++i;
			}
			return arr;
		}
		/**
		  设定按钮位置的二维数组,第一个下标表按钮的索引,第二的下标表x,y
		 */
		public function setBtnsPos(arr:Array):void
		{
			var i:int = 0;
			for each(var p:Array in arr)
			{
				if(i>=btnArr.length)return;
				var btn:TxtBtn = btnArr[i];
				btn.x = p[0];
				btn.y = p[1];
				++i;
			}
		}
	}
}

