package framework.util
{
	import application.ConfigKeys;
	import coretech.platform.socialplatform.SocialPlatformUser;
	import coretech.platform.socialstats.FriendRecommendations;
	import fibre.core.Fibre;
	import analytics.GlobalErrorCode;
	import framework.controller.game.CommandOpenGetMaterialsPanel;
	import framework.controller.game.energy.CommandEnergyNotEnoughHint;
	import framework.core.coretech.CoreTechManager;
	import framework.core.rpc.RpcProxy;
	import framework.core.user.GetRewardAction;
	import framework.core.user.GetRewardActionManager;
	import framework.core.user.OweItem;
	import framework.core.user.RewardItem;
	import framework.core.user.User;
	import framework.core.user.UserManager;
	import framework.datagram.DatagramView;
	import framework.model.StaticResProxy;
	import framework.resource.IID;
	import framework.resource.modeldata.Material;
	import framework.staticdata.StaticGSCItem;
	import framework.staticdata.StaticMaterial;
	import framework.view.ConstantUI;
	import framework.view.base.MediatorBase;
	import rpc.share.NetworkUid;
	import rpc.simcity.bean.District;
	import rpc.simcity.bean.InventoryItem;
	import rpc.simcity.bean.InventoryItemInfo;
	import rpc.simcity.bean.NeighborVisit;
	import rpc.simcity.bean.RelationshipGift;
	import rpc.simcity.bean.StructureFriend;
	import rpc.simcity.bean.UserInfo;
	import types.helpers.JSONUtils;
	
	import flash.display.MovieClip;
	
	public class UserUtil
	{
		private static var _oweItems:Array = [];
		private static var getRewardActionManager:GetRewardActionManager = new GetRewardActionManager();
		
		public function UserUtil()
		{
			
		}
		
		// should move to command
		
		public static function energyPlusUI(energy:int, user:User):void
		{
		}
		
		public static function getCityName(id:String):String
		{
			var user:User = UserManager.instance.getUserByUid(id);
			if(user != null)
			{
				return user.getCityName();
			}
			else
			{
				var name:String = getFriendName(id);
				return name + "'s City";
			}
		}
		
		public static function noticeNoMaterial(typeId:int, count_uselsee:int, user:User):void
		{
			var material:StaticMaterial = StaticResProxy.inst.staticMaterialInfo.getStaticMaterialByIId(typeId);
			
			if(material != null)
			{
				
				if(typeId == StaticResProxy.inst.staticMaterialInfo.getStaticMaterial(StaticMaterial.STONE).iid)
				{
					if(getInventoryItemAndAddWhenNotExsit(user, typeId).number == 0)
					{
						CommandOpenGetMaterialsPanel.execute();
					}
					//CommandMaterialAnim.execute(material.id, count);
				}
			}
		}
		
		//user methods
		
		public static function hasEnoughMaterials(user:User, materials:Vector.<Material>):Boolean
		{
			var enough:Boolean = true;
			for each(var material:Material in materials)
			{
				var num:int = UserUtil.getMaterialById(user, material.id).number;
				if(num < material.number)
				{
					enough = false;
					break;
				}
			}
			
			return enough;
		}
		
		public static function updateInventoryItemNumber(user:User, typeId:int, amount:int):void
		{
			var item:InventoryItem = getInventoryItemAndAddWhenNotExsit(user, typeId);
			
			item.number = Math.min(item.number + amount, item.capacity);
		}
		
		public static function isAnyItemInInventory(user:User, serverTypeId:int):Boolean
		{
			for each(var item:InventoryItem in user.info.constructionInventory)
			{
				if(item.typeId == serverTypeId && item.number > 0)
				{
					return true;
				}
			}
			
			return false;
		}
		
		public static function getInventoryNumber(user:User, serverTypeId:int):int
		{
			var sum:int = 0;
			for each(var item:InventoryItem in user.info.constructionInventory)
			{
				if(item.typeId == serverTypeId)
				{
					sum += item.number;
				}
			}
			
			return sum;
		}
		
		public static function searchInventoryItem(user:User, serverTypeId:int, inventoryItemInfo:InventoryItemInfo = null):InventoryItem
		{
			if(inventoryItemInfo == null)
			{
				inventoryItemInfo = new InventoryItemInfo();
			}
			
			for each(var item:InventoryItem in user.info.constructionInventory)
			{
				if(item.isSame(serverTypeId, inventoryItemInfo))
				{
					return item;
				}
			}
			
			return null;
		}
		
		/**
		 * @param user
		 * @param typeId
		 * 
		 * @see searchInventoryItem
		 * @return InventoryItem -- will add default item if not exist
		 * 
		 */
		public static function getInventoryItemAndAddWhenNotExsit(user:User, typeId:int, inventoryItemInfo:InventoryItemInfo = null):InventoryItem
		{
			if(inventoryItemInfo == null)
			{
				inventoryItemInfo = new InventoryItemInfo();
			}
			
			var item:InventoryItem = searchInventoryItem(user, typeId, inventoryItemInfo);
			
			if(item == null)
			{
				if(user.info.constructionInventory == null)
				{
					user.info.constructionInventory = new Array();
				}
				item = new InventoryItem();
				item.typeId = typeId;
				item.number = 0;
				item.info.level = inventoryItemInfo.level;
				item.info.completed = inventoryItemInfo.completed;
				item.info.locked = inventoryItemInfo.locked;
				item.info.progress = inventoryItemInfo.progress;
				item.timestamp = RpcProxy.instance.serverTimeAsDate;
				
				var staticMaterial:StaticMaterial = StaticResProxy.inst.staticMaterialInfo.getStaticMaterialByIId(typeId);
				if(staticMaterial != null)
				{
					item.capacity = staticMaterial.maxNum;
				}
				else
				{
					var gscItem:StaticGSCItem = StaticResProxy.inst.staticGSCItemInfo.getStaticGSCItemByServerId(typeId);
					if(gscItem != null)
					{
						item.capacity = gscItem.maxNum;
					}
				}
				
				user.info.constructionInventory.push(item);
			}
			
			return item;
		}
		
		public static function getMaterialById(user:User, id:String) : InventoryItem
		{
			CONFIG::debug
			{
				ASSERT(StaticResProxy.inst.staticMaterialInfo.getStaticMaterial(id) != null || StaticResProxy.inst.staticGSCItemInfo.getStaticGSCItem(id) != null, "Can not find config for material:" + id);
			}
			
			return getInventoryItemAndAddWhenNotExsit(user, IID.getIID(id));
		}
		
		public static function getMaterialByTypeId(user:User, typeId:int):InventoryItem
		{
			CONFIG::debug
			{
				ASSERT(StaticResProxy.inst.staticMaterialInfo.getStaticMaterialByIId(typeId) != null || StaticResProxy.inst.staticGSCItemInfo.getStaticGSCItemByServerId(typeId) != null, "Can not find config for material:" + typeId);
			}
			
			return getInventoryItemAndAddWhenNotExsit(user, typeId);
		}
		
		/*
		public static function getDisplayMoney(user:User):int
		{
		var n:int = user.getDisplayPropertyValue(RewardItem.TYPE_MONEY);
		for(var i:int = 0 ; i < _oweItems.length ; i++)
		{
		var oweItem:OweItem = _oweItems[i];
		if(oweItem.type == RewardItem.TYPE_MONEY)
		{
		n -= oweItem.amount;
		}
		}
		
		n -= getRewardActionManager.getOwedPropertySum(RewardItem.TYPE_MONEY);
		
		ASSERT(n >= 0);
		return n;
		}
		
		public static function getDisplayHeart(user:User):int
		{
		var n:int = user.getDisplayPropertyValue(RewardItem.TYPE_HEART);
		for(var i:int = 0 ; i < _oweItems.length ; i++)
		{
		var oweItem:OweItem = _oweItems[i];
		if(oweItem.type == RewardItem.TYPE_HEART)
		n -= oweItem.amount;
		}
		n -= getRewardActionManager.getOwedPropertySum(RewardItem.TYPE_HEART);
		return n;
		}
		*/
		
		public static function getDisplayMaterialNumber(user:User, id:String):int
		{
			var n:int = UserUtil.getMaterialById(user, id).number;
			
			for(var i:int = 0 ; i < _oweItems.length ; i++)
			{
				var oweItem:OweItem = _oweItems[i];
				if(oweItem.type == RewardItem.TYPE_MATERIAL
					&& oweItem.contentId == id
				)
					n -= oweItem.amount;
			}
			
			n -= getRewardActionManager.getOwedPropertySum(RewardItem.TYPE_MATERIAL, id);
			
			return n;
		}
		
		/*
		public static function getDisplayExpNumber(user:User):int
		{
		var n:int = user.info.xp;
		for(var i:int = 0 ; i < _oweItems.length ; i++)
		{
		var oweItem:OweItem = _oweItems[i];
		if(oweItem.type == RewardItem.TYPE_XP)
		n -= oweItem.amount;
		}
		
		n -= getRewardActionManager.getOwedPropertySum(RewardItem.TYPE_XP);
		
		
		return n;
		}
		*/
		
		
		public static function addOweItem(oweItem:RewardItem):void
		{
			_oweItems.push(oweItem);
		}
		
		public static function recordGetRewardAction(getRewardAction:GetRewardAction):void
		{
			getRewardActionManager.recordGetRewardAction(getRewardAction)
		}
		
		public static function notifyGetRewardActionHasBeenHandled(action:GetRewardAction):void
		{
			getRewardActionManager.notifyGetRewardActionHasBeenHandled(action);
		}
		
		public static function removeOweItemWithAnim(anim:MovieClip):void
		{
			for(var i:int = 0 ; i < _oweItems.length ; i ++)
			{
				var oweItem:OweItem = _oweItems[i];
				if(oweItem.refObject == anim)
				{
					//					if(oweItem.type == RewardItem.TYPE_MONEY)
					//						CommandCoinAnim.execute(oweItem.amount);
					//					else if(oweItem.type == RewardItem.TYPE_XP)
					//						CommandXpAnim.execute(oweItem.amount);
					//					else if(oweItem.type == RewardItem.TYPE_MATERIAL)
					//						CommandMaterialAnim.execute(oweItem.materialId,oweItem.amount);
					
					_oweItems.splice(i,1);
					
					return;
				}
			}
		}
		
		public static function removeAllOweItemAndGetRewardActions():void
		{
			for(var i:int = 0; i < _oweItems.length ; i++)
			{
				var o:OweItem = _oweItems[i];
				
				var disObject:MovieClip = o.refObject as MovieClip;
				if(disObject)
				{
					DisplayUtil.removeFromParent(disObject);
					disObject._animDisabled = true;
				}
			}
			
			_oweItems = [];
			
			getRewardActionManager.clear();
		}
		
		//		public static function cloneInventory(inventory:Array):Array
		//		{
		//			var result:Array = [];
		//			for each(var item:InventoryItem in inventory)
		//			{
		//				if(item.number > 0)
		//					result.push(item.clone());
		//			}
		//			
		//			return result;
		//		}
		
		
		/**
		 * 
		 * @param uid string
		 * @param network int, default: NetworkUid.FACEBOOK
		 * @param playfishUid uint, default: 0
		 * @return NetworkUid
		 * 
		 * @see NetworkUtil.creatNetworkUid()
		 * @see NetworkUid
		 */
		public static function createNetworkUid(uid:String, network:int = NetworkUid.FACEBOOK, playfishUid:uint = 0):NetworkUid
		{
			return new NetworkUid(network, uid, playfishUid);
		}
		
		public static function getFriendName(uid:String):String
		{
			var ctUser:SocialPlatformUser = CoreTechManager.instance.getFriend(uid); 
			if(ctUser != null)
			{
				return ctUser.getFirstName();
			}
			
			return "";
		}
		
		public static function isRomanceWithOthers(targetUser:User):Boolean
		{
			var romanceId:NetworkUid = targetUser.getRomanceId();
			if(romanceId != null
				&& romanceId.networkUid != UserManager.instance.currentUser.info.id.networkUid)
			{
				return true;
			}
			
			return false;
		}
		
		public static function isInAnyRomance(user:User):Boolean
		{
			return user.getRomanceId() != null;
		}
		
		public static function isRomanceWithMe(targetUser:User):Boolean
		{
			var romanceId:NetworkUid = targetUser.getRomanceId();
			if(romanceId != null
				&& romanceId.networkUid == UserManager.instance.currentUser.info.id.networkUid)
			{
				return true;
			}
			
			return false;
		}
		
		public static function getSocialPlatformUserByNetworkUID(id:String):SocialPlatformUser
		{
			return CoreTechManager.instance.getFriend(id);
		}
		
		//like game and not install this app
		public static function getUserLikeGame():Array
		{
			if(FriendRecommendations.instance != null)
			{
				return FriendRecommendations.instance.getRecommendedUIDsForInvitations(-1);	 
			}
			else
			{
				return [];
			}
		}
		
		public static function getRecommendUser():Array
		{
			var noLogInOneWeekList:Array = UserManager.instance.getRecommendUserUidsByLogInTime();
			
			return noLogInOneWeekList.concat(getUserLikeGame());
		}
		
		//keep the oranginal order
		public static function transformUserVectorToUIDs(users:Vector.<User>):Array
		{
			var count:int = users.length;
			var uids:Array = new Array();
			for(var i:int = 0; i < count; ++i)
			{
				uids.push(users[i].info.id.networkUid);	
			}
			return uids;
		}
		
		public static function transformSocialPlatformUserToUIDs(arr:Array):Array
		{
			var uids:Array = new Array();
			for each(var user:SocialPlatformUser in arr)
			{
				if(user != null)
				{
					uids.push(user.getID())
				}
			}
			return uids;
		}
		
		public static function convertSocialPlatformUser(socialPlatformUser:SocialPlatformUser):User
		{
			var user : User = new User();
			user.info = new UserInfo();
			user.info.xp = 0;
			user.info.lastSave = new Date(0);
			user.info.id = socialPlatformUser.getNetworkID();
			user.platformInfo = socialPlatformUser;
			
			return user;
		}
		
		public static function sendLoadUserLog(currentUser:User):void
		{
			var o:Object = new Object();
			o.user_country = GameEngine.getInstance.getParameterString(ConfigKeys.PF_COUNTRY);
			
			if(o.user_country is String)
			{
				currentUser.country = String(o.user_country).toLocaleUpperCase();
			}
			
			if(currentUser.platformInfo.isGenderKnown())
			{
				if(currentUser.platformInfo.isGenderMale())
				{
					o.user_gender = "m";
				}
				else
				{
					o.user_gender = "f";
				}
			}
			else
			{
				o.user_gender = "u";
			}
			o.install_date = currentUser.info.userCreateTime.time;
			
			RpcProxy.instance.sendLogEvent(GlobalErrorCode.LOG_LOAD_USER_PROFILE, JSONUtils.encode(o));
		}
		
		public static function getDistrictById(userinfo:UserInfo,id : int) : District
		{
			for each(var district : District in userinfo.district)
			{
				if(district.id == id)
				{
					return district;
				}
			}
			
			return null;
		}
		
		public static function removeNeighborVisit(user:UserInfo, neighborId:String, cityId:int):void
		{
			for(var i:int = user.neighborActions.length - 1; i >= 0; i--)
			{
				var visit:NeighborVisit = user.neighborActions[i];
				if(visit.networkUid.networkUid == neighborId && visit.cityId == cityId)
				{
					user.neighborActions.splice(i, 1);
				}
			}
		}
		
		public static function removeRelationshipGift(user:UserInfo, id:int):void
		{
			for(var i:int = 0; i < user.relationshipGiftsSnapshot.length; i++)
			{
				if(RelationshipGift(user.relationshipGiftsSnapshot[i]).id == id)
				{
					user.relationshipGiftsSnapshot.splice(i, 1);
					break;
				}
			}
		}
		
	}
}