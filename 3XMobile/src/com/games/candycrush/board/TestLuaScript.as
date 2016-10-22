package com.games.candycrush.board
{
	import framework.util.rsv.Rsv;
	import framework.util.rsv.RsvFile;
	
	import luaAlchemy.LuaAlchemy;

	public class TestLuaScript
	{
		private var _board:Board;
		private var _lua:LuaAlchemy;
		private var _script:String;
		public function TestLuaScript(board:Board)
		{
			_board = board;
			_lua = new LuaAlchemy();
			
			_lua.setGlobal("this", this);
			
			var rsv:RsvFile = Rsv.inst.getFile("file_lua");
			
			_script = rsv.xml.toString();
			
			trace(_script);
			
//			run(_script);
		}
		
		public function startCaculate():void
		{
			
		}
		
		public function getResult(score:int, result:Object):void
		{
			
		}
		
		private var _score:int;
		public function result(score:int):void
		{
			_score = score;
			trace(_score);
		}
		
		public function run(scriptText:String):void
		{
			runLuaScript(scriptText);
		}
		
		public function runLuaScript(scriptText:String):void
		{			
			var arr:Array = _lua.doString(scriptText);
			
			CONFIG::debug
			{
				ASSERT(arr[0], "execute lua script error !");
			}
			
			trace("运行状态：\n"+arr.join("\n"));
			trace(1);
		}	
	}
}