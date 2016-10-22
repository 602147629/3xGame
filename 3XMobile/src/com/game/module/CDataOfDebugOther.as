package com.game.module
{
	import com.netease.protobuf.UInt64;
	
	import framework.rpc.NetworkManager;
	import framework.rpc.WebJSManager;
	
	import qihoo.gamelobby.protos.UserOrigin;

	/**
	 * @author caihua
	 * @comment 调试其他玩家
	 * 创建时间：2014-8-22  上午10:51:14 
	 */
	public class CDataOfDebugOther extends CDataBase
	{
		private var _q:String = "";
		private var _t:String = "";
		//小强
//		private var _qt:String = "Q=u%3D%25Q0%25N1%25P7%25OS%25O8%25R7___%26n%3D%25Q0%25N1%25P7%25OS%25O8%25R7___%26le%3D%26m%3DZGZ4WGWOWGWOWGWOWGWOWGWOZmZj%26qid%3D838328961%26im%3D1_t012bc80ce8f2a41c11%26src%3Dpcc_gamehall%26t%3D1; T=s%3D23f06d216492c49d1277b1aa4379f17d%26t%3D1408504420%26lm%3D%26lf%3D2%26sk%3Db9ad92fe40f70fb3e93f9ae0f01f1f5b%26mt%3D1408504420%26rc%3D%26v%3D2.0%26a%3D1; S=;";
		//自己
		private var _qt:String = "Q=u%3Dunjxlhmuh%26n%3D%25O2%25PO%25OO%25N8%25Q7%25QS%25O1%25R9%25PP%25RP%25PS%25P2%26le%3D%26m%3D%26qid%3D1006120583%26im%3D1_t01289cd21506b35ffa%26src%3Dpcc_gamehall%26t%3D1; T=s%3D0a509fdb085ac9c67648b741ac322a95%26t%3D1408605264%26lm%3D%26lf%3D4%26sk%3D42ac2498b5f8cce62153dd69a34a2146%26mt%3D1408605264%26rc%3D%26v%3D2.0%26a%3D1; S=; ";
		//依群
//		private var _qt:String = "Q=u%3Dnfq18233156365%26n%3D%25PO%25RS%25Q2%25P0%25P8%25ON%26le%3D%26m%3DZGtlWGWOWGWOWGWOWGWOWGWOZmL1%26qid%3D791251749%26im%3D1_t03c70f9866c0c65482%26src%3Dpcc_gamehall%26t%3D1; T=s%3D213f1018b3d41661e1f4933a2b41725c%26t%3D1409047414%26lm%3D%26lf%3D4%26sk%3D5ab3c6baeb482ad04ae15e9abc5613ae%26mt%3D1409047414%26rc%3D%26v%3D2.0%26a%3D1; S=;";
		//test
//		private var _qt:String = "Q=u%3Dqbatovatlbh%26n%3D%25P9%25O1%25P6%25S8%25PR%25QR%25P7%25R9%26le%3D%26m%3DZGZ1WGWOWGWOWGWOWGWOWGWOAmR0%26qid%3D269424343%26im%3D1_t03fe0647dc99c9116d%26src%3Dpcc_gamehall%26t%3D1; T=s%3D9bc577ade5d77d743977cea1d3e3d2f7%26t%3D1411119936%26lm%3D%26lf%3D4%26sk%3D9d05c90c6501abe41cf2042459f7df4f%26mt%3D1411119936%26rc%3D%26v%3D2.0%26a%3D1; S=;";
		private var _userType:int;
		private var _visiteID:UInt64;
		private var _macUrl:UInt64;
		
		public function CDataOfDebugOther()
		{
			super("CDataOfDebugOther");
		}
		
		//拆分数据
		public function decode():void
		{	
			_q = "";
			
			_t = "";
			
			__splitQT(); 
			
			_userType = UserOrigin.UserOrigin_Qihoo;
			WebJSManager.originType = _userType;
			
			_visiteID = new UInt64();
			
			_macUrl = new UInt64();
		}
		
		private function __splitQT():void
		{
			var strs:Array = _qt.split(";");
			for each(var str:String in strs)
			{
				if(str.indexOf("Q=") != -1)
				{
					_q = str.replace("Q=", "");
					_q = _q.replace(/\s/g,"");
				}else if(str.indexOf("T=") != -1)
				{
					_t = str.replace("T=", "");
					_t = _t.replace(/\s/g,"");
				}
			}
		}
	
		public function startLogin():void
		{
			TRACE("DEBUG USE OTHER " , "flow");
			
			
			decode();
			NetworkManager.instance.sendLobbyUserLogin(_userType, _macUrl, _q, _t, _visiteID);
		}
	}
}