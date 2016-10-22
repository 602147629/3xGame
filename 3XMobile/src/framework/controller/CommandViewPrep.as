package framework.controller
{
	import com.ui.panel.CPanelBarrierFail;
	import com.ui.panel.CPanelBarrierStart;
	import com.ui.panel.CPanelBarrierSucc;
	import com.ui.panel.CPanelBuy;
	import com.ui.panel.CPanelCommonConfirm;
	import com.ui.panel.CPanelEnergyLack;
	import com.ui.panel.CPanelFriendInvite;
	import com.ui.panel.CPanelFriendMessage;
	import com.ui.panel.CPanelFriendSendGift;
	import com.ui.panel.CPanelFunctionOpen;
	import com.ui.panel.CPanelLevelLogo;
	import com.ui.panel.CPanelLoading;
	import com.ui.panel.CPanelLoadingSamll;
	import com.ui.panel.CPanelMatchDiploma;
	import com.ui.panel.CPanelMatchRank;
	import com.ui.panel.CPanelMatchResult;
	import com.ui.panel.CPanelMessage;
	import com.ui.panel.CPanelNewGift;
	import com.ui.panel.CPanelNotice;
	import com.ui.panel.CPanelOnlineAward;
	import com.ui.panel.CPanelRedGift;
	import com.ui.panel.CPanelRedGiftResult;
	import com.ui.panel.CPanelSeriesLogin;
	import com.ui.panel.CPanelSignUp;
	import com.ui.panel.CPanelStarReward;
	import com.ui.panel.CPanelTip;
	import com.ui.panel.CPanelUnlock;
	import com.ui.panel.CPanelUnlockAskFriend;
	import com.ui.panel.CPanelUpdateNotice;
	import com.ui.panel.CpanelMatchRule;
	
	import framework.fibre.core.Fibre;
	import framework.sound.MediatorAudio;
	import framework.tutorial.MediatorPanelTutorial;
	import framework.ui.MediatorPanelMainUI;
	import framework.ui.MediatorPanelUserInfo;
	import framework.ui.MediatorWorldMainScene;
	import framework.view.mediator.ApplicationMediator;
	import framework.view.mediator.MediatorRpc;
	
	
	public class CommandViewPrep// extends Command
	{
		public function CommandViewPrep()
		{
			
		}
		
		public static function execute():void
		{
			var app:GameEngine = GameEngine.getInstance();
			Fibre.getInstance().registerMediator( new ApplicationMediator(app) );
			
			app.showAllLayer();
			//all sub mediator
			
			Fibre.getInstance().registerMediator(new MediatorRpc());
			
			Fibre.getInstance().registerMediator(new MediatorAudio());
			
			Fibre.getInstance().registerMediator(new MediatorPanelMainUI());
			
			Fibre.getInstance().registerMediator(new MediatorWorldMainScene());
			
			Fibre.getInstance().registerMediator(new MediatorPanelUserInfo());
			
			Fibre.getInstance().registerMediator(new CPanelBarrierStart());
			
			Fibre.getInstance().registerMediator(new CPanelBarrierSucc());
			
			Fibre.getInstance().registerMediator(new CPanelBarrierFail());
			
			Fibre.getInstance().registerMediator(new CPanelUnlock());
			
			Fibre.getInstance().registerMediator(new CPanelMessage());
			
			Fibre.getInstance().registerMediator(new CPanelNewGift());
			
			Fibre.getInstance().registerMediator(new CPanelRedGift());
			
			Fibre.getInstance().registerMediator(new CPanelRedGiftResult());
			
			Fibre.getInstance().registerMediator(new CPanelFriendInvite());
			
			Fibre.getInstance().registerMediator(new CPanelUnlockAskFriend());
			Fibre.getInstance().registerMediator(new CPanelEnergyLack());
			
			Fibre.getInstance().registerMediator(new CPanelSignUp());
			
			Fibre.getInstance().registerMediator(new CPanelOnlineAward());
			
			Fibre.getInstance().registerMediator(new CPanelMatchResult());
			
			Fibre.getInstance().registerMediator(new CpanelMatchRule());
			
			Fibre.getInstance().registerMediator(new CPanelMatchDiploma());
			
			Fibre.getInstance().registerMediator(new CPanelFriendMessage());
			Fibre.getInstance().registerMediator(new CPanelLoadingSamll());
			Fibre.getInstance().registerMediator(new CPanelFriendSendGift());
			Fibre.getInstance().registerMediator(new CPanelCommonConfirm());
			Fibre.getInstance().registerMediator(new CPanelBuy());
			Fibre.getInstance().registerMediator(new CPanelTip());
			Fibre.getInstance().registerMediator(new MediatorPanelTutorial());
			Fibre.getInstance().registerMediator(new CPanelLoading());
			Fibre.getInstance().registerMediator(new CPanelLevelLogo());
			Fibre.getInstance().registerMediator(new CPanelNotice());
			Fibre.getInstance().registerMediator(new CPanelStarReward());
			Fibre.getInstance().registerMediator(new CPanelUpdateNotice());
			Fibre.getInstance().registerMediator(new CPanelSeriesLogin());
			Fibre.getInstance().registerMediator(new CPanelFunctionOpen());
			
			Fibre.getInstance().registerMediator(new CPanelMatchRank());
		}
	}
}