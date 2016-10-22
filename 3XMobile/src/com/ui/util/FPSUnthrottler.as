package com.ui.util
{
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.SampleDataEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.utils.getTimer;
	
	/**
	 * 利用 Sound SampleData 事件
	 * 迫使 Flash Player 背景執行時，仍以指定 FPS 運作
	 *
	 * 使用方式
	 *
	 * 1. 建立 FPSUnthrottler 實體，直接呼叫 activate 啟動
	 *
	 * 或是
	 *
	 * 2. 將 FPSUnthrottler 實體加入到 DisplayList
	 *   它會自動偵測目標 FPS 與實際 FPS，決定啟動或是停止
	 *
	 * @author Ticore Shih
	 */
	public class FPSUnthrottler extends Shape 
	{
		
		public function FPSUnthrottler() 
		{
			snd.addEventListener(SampleDataEvent.SAMPLE_DATA, onSameplDataHandler, false, 0, true);
			
			addEventListener(Event.ADDED_TO_STAGE, onAddStageHandler, false, 0, true);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemoveStageHandler, false, 0, true);
		}
		
		protected function onAddStageHandler(e:Event):void
		{
			addEventListener(Event.ENTER_FRAME, onEnterFrameHandler, false, 0, true);
		}
		
		protected function onRemoveStageHandler(e:Event):void
		{
			removeEventListener(Event.ENTER_FRAME, onEnterFrameHandler, false);
		}
		
		protected var recentFrameTimes:Array = [];
		
		protected function onEnterFrameHandler(e:Event):void
		{
			var throttleFrameTime:int = 100;
			var targetFrameTime:int = 1000 / stage.frameRate;
			
			// 原本設定的 FPS 就已經低於 Throttle FPS 了
			if (targetFrameTime > throttleFrameTime - 20) 
			{
				deactivate();
				return;
			}
			
			var currTime:int = getTimer();
			var lastFrameTime:int = currTime - recentFrameTimes[0];
			
			recentFrameTimes.unshift(currTime);
			var maxSampleLen:int = 300;
			var sampleLen:int = recentFrameTimes.length = Math.min(recentFrameTimes.length, maxSampleLen);
			var avgFrameTimeTotal:int = (recentFrameTimes[0] - recentFrameTimes[sampleLen - 1]) / sampleLen;
			
			// trace("FrameTimes:", targetFrameTime, lastFrameTime, avgFrameTimeTotal);
			
			if (lastFrameTime > throttleFrameTime) 
			{
				// 最後一次影格事件突然小於 2 FPS
				activate();
			} else if (avgFrameTimeTotal <= targetFrameTime) 
			{
				// 連續平均影格事件 FPS 小於等於目標 FPS
				deactivate();
			}
		}
		
		// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		
		protected var snd:Sound = new Sound();
		protected var sndCh:SoundChannel;
		
		protected function onSameplDataHandler(e:SampleDataEvent):void
		{
			e.data.position = e.data.length = 4096 * 4;
		}
		
		// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		
		public function activate():void
		{
			if (sndCh) return;
			CONFIG::debug
			{
				TRACE_HEART("FPSUnthrottler.activate();");
			}
			sndCh = snd.play();
		}
		
		public function deactivate():void
		{
			if (!sndCh) return;
			CONFIG::debug
			{
				TRACE_HEART("FPSUnthrottler.deactivate();");
			}
			sndCh.stop();
			sndCh = null;
		}
		
		// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	}
}