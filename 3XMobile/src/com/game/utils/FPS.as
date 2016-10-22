package com.game.utils
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.getTimer;

    public class FPS extends Sprite
    {
        private var currentY:int;
        private var diagramTimer:int;
        private var tfTimer:int;
        private var mem:TextField;
        private var diagram:BitmapData;
        private var skins:int = -1;
        private var fps:TextField;
        private var tfDelay:int = 0;
        private var skinsChanged:int = 0;
        
        private var bgSp:Sprite;
        
        static private const maxMemory:uint = 4.1943e+007;
        static private const diagramWidth:uint = 60;
        static private const tfDelayMax:int = 10;
        static private var instance:FPS;
        static private const diagramHeight:uint = 40;
        

        public function FPS()
        {
            this.addEventListener(Event.ADDED_TO_STAGE,run);
        }

		private function run(ev:Event):void{
			var _loc_2:Bitmap;
            fps = new TextField();
            mem = new TextField();
            if (instance == null)
            {
                this.bgSp=new Sprite;
                this.bgSp.graphics.beginFill(0x000000,.5);
                this.bgSp.graphics.drawRect(0,0,diagramWidth,25);
                this.bgSp.graphics.endFill();
                this.bgSp.x=-diagramWidth;
                addChild(this.bgSp);
				
                mouseEnabled = false;
                mouseChildren = false;
                fps.defaultTextFormat = new TextFormat("Tahoma", 10, 13421772);
                fps.autoSize = TextFieldAutoSize.LEFT;
                fps.text = "FPS: " + Number(stage.frameRate).toFixed(2);
                fps.selectable = false;
                fps.x = -diagramWidth - 2;
                addChild(fps);
				
                mem.defaultTextFormat = new TextFormat("Tahoma", 10, 13421568);
                mem.autoSize = TextFieldAutoSize.LEFT;
                mem.text = "MEM: " + bytesToString(System.totalMemory);
                mem.selectable = false;
                mem.x = -diagramWidth - 2;
                mem.y = 10;
                addChild(mem);
				
                currentY = 20;
                diagram = new BitmapData(diagramWidth, diagramHeight, true, 553648127);
                _loc_2 = new Bitmap(diagram);
                _loc_2.y = currentY + 4;
                _loc_2.x = -diagramWidth;
                addChildAt(_loc_2, 0);
                addEventListener(Event.ENTER_FRAME, onEnterFrame);
                this.stage.addEventListener(Event.RESIZE, onResize);
                onResize();
                diagramTimer = getTimer();
                tfTimer = getTimer();
            }
            else
            {
            }// end else if
            return;
		}
        private function bytesToString(param1:uint) : String
        {
            var memo:String;
            if (param1 < 1024)
            {
                memo = String(param1) + "b";
            }
            else if (param1 < 10240)
            {
                memo = Number(param1 / 1024).toFixed(2) + "kb";
            }
            else if (param1 < 102400)
            {
                memo = Number(param1 / 1024).toFixed(1) + "kb";
            }
            else if (param1 < 1048576)
            {
                memo = Math.round(param1 / 1024) + "kb";
            }
            else if (param1 < 10485760)
            {
                memo = Number(param1 / 1048576).toFixed(2) + "mb";
            }
            else if (param1 < 104857600)
            {
                memo = Number(param1 / 1048576).toFixed(1) + "mb";
            }
            else
            {
                memo = Math.round(param1 / 1048576) + "mb";
            }// end else if
            return memo;
        }

        private function onEnterFrame(param1:Event) : void
        {
            tfDelay++;
            if (tfDelay >= tfDelayMax)
            {
                tfDelay = 0;
                fps.text = "FPS: " + Number(1000 * tfDelayMax / (getTimer() - tfTimer)).toFixed(2);
                tfTimer = getTimer();
            }// end if
            var _loc_2:* = 1000 / (getTimer() - diagramTimer);
            var _loc_3:* = _loc_2 > stage.frameRate ? (1) : (_loc_2 / stage.frameRate);
            diagramTimer = getTimer();
            //diagram.scroll(1, 0);
            //diagram.fillRect(new Rectangle(0, 0, 1, diagram.height), 553648127);
            //diagram.setPixel32(0, diagramHeight * (1 - _loc_3), 4291611852);
            mem.text = "MEM: " + bytesToString(System.totalMemory);
            //var _loc_4:* = skins == 0 ? (0) : (skinsChanged / skins);
            //diagram.setPixel32(0, diagramHeight * (1 - _loc_4), 4294927872);
            //var _loc_5:* = System.totalMemory / maxMemory;
            //diagram.setPixel32(0, diagramHeight * (1 - _loc_5), 4291611648);
            return;
        }

        private function onResize(param1:Event = null) : void
        {
            var _loc_2:* = parent.globalToLocal(new Point(stage.stageWidth - 2, -3));
            x = _loc_2.x;
            y = _loc_2.y;
            return;
        }
    }
}
