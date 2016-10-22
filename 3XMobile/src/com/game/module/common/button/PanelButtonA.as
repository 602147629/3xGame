package com.game.module.common.button
{
	import com.game.consts.ResourceConst;
	import com.game.manager.AssetManage;
	import com.game.manager.LoaderManager;
	import com.game.utils.Gutils;

	/** 
	 * 游戏ui上的主要按钮
	 * @author melody
	 */
	public class PanelButtonA extends BaseButton
	{
		protected var path:String;
		protected var upid:String;
		private var imgId:String;
		public function PanelButtonA(_label:String,_path:String="/native/ui/1118002.icsx",_upid:String="u0")
		{
			defaultSize = 18;
			defaultBold = true;
			defaultColor = 0xFFE78A;

			path = _path;
			upid = _upid;

			super(_label);
			this.initLabel();

			if (! AssetManage.getInstance().getCutImg(path,upid))
			{
				LoaderManager.getInstance().load(path,ResourceConst.TYPE_XML,onXmlComPlete);
			}
			else
			{
				this.show();
			}
		}
		private function onXmlComPlete():void
		{
			imgId = AssetManage.getInstance().getXml(path).resourceIdentityList.resource[0]. @ identity;
			LoaderManager.getInstance().load(imgId,ResourceConst.TYPE_IMG,onImgComPlete);
		}
		private function onImgComPlete():void
		{
			var xmlList:XMLList = AssetManage.getInstance().getXml(path).clips.clip.(@uid == upid);
			var w:Number = xmlList. @ r - xmlList. @ l;
			var h:Number = xmlList. @ b - xmlList. @ t;
			AssetManage.getInstance().addCutImg(path,upid,Gutils.cutImge(AssetManage.getInstance().getImg(imgId),xmlList. @ l,xmlList. @ t,w,h));
			this.show();
		}
		private function show():void
		{
			upState = AssetManage.getInstance().getCutImg(path,upid);
			super.initStatus();
			super.initLabelXY();
		}
	}
}