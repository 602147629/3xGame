package qihoo.triplecleangame.protos {
	import com.netease.protobuf.*;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import qihoo.triplecleangame.protos.PBFriendList;
	import qihoo.triplecleangame.protos.PBInviteInfo;
	import qihoo.triplecleangame.protos.PBRequestInfo;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class CMsgGetFriendListResponse extends com.netease.protobuf.Message {
		public static const USERQID:FieldDescriptor$TYPE_UINT64 = new FieldDescriptor$TYPE_UINT64("qihoo.triplecleangame.protos.CMsgGetFriendListResponse.userQID", "userQID", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		private var userQID$field:UInt64;

		public function clearUserQID():void {
			userQID$field = null;
		}

		public function get hasUserQID():Boolean {
			return userQID$field != null;
		}

		public function set userQID(value:UInt64):void {
			userQID$field = value;
		}

		public function get userQID():UInt64 {
			return userQID$field;
		}

		public static const RESULT:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("qihoo.triplecleangame.protos.CMsgGetFriendListResponse.result", "result", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		private var result$field:int;

		private var hasField$0:uint = 0;

		public function clearResult():void {
			hasField$0 &= 0xfffffffe;
			result$field = new int();
		}

		public function get hasResult():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set result(value:int):void {
			hasField$0 |= 0x1;
			result$field = value;
		}

		public function get result():int {
			return result$field;
		}

		public static const INVITEQID:FieldDescriptor$TYPE_UINT64 = new FieldDescriptor$TYPE_UINT64("qihoo.triplecleangame.protos.CMsgGetFriendListResponse.inviteQID", "inviteQID", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		private var inviteQID$field:UInt64;

		public function clearInviteQID():void {
			inviteQID$field = null;
		}

		public function get hasInviteQID():Boolean {
			return inviteQID$field != null;
		}

		public function set inviteQID(value:UInt64):void {
			inviteQID$field = value;
		}

		public function get inviteQID():UInt64 {
			return inviteQID$field;
		}

		public static const FRIENDLIST:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("qihoo.triplecleangame.protos.CMsgGetFriendListResponse.friendList", "friendList", (4 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, qihoo.triplecleangame.protos.PBFriendList);

		[ArrayElementType("qihoo.triplecleangame.protos.PBFriendList")]
		public var friendList:Array = [];

		public static const INVITELIST:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("qihoo.triplecleangame.protos.CMsgGetFriendListResponse.inviteList", "inviteList", (5 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, qihoo.triplecleangame.protos.PBInviteInfo);

		[ArrayElementType("qihoo.triplecleangame.protos.PBInviteInfo")]
		public var inviteList:Array = [];

		public static const INVITEDLIST:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("qihoo.triplecleangame.protos.CMsgGetFriendListResponse.invitedList", "invitedList", (6 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, qihoo.triplecleangame.protos.PBFriendList);

		[ArrayElementType("qihoo.triplecleangame.protos.PBFriendList")]
		public var invitedList:Array = [];

		public static const REQUESTADDLIST:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("qihoo.triplecleangame.protos.CMsgGetFriendListResponse.requestAddList", "requestAddList", (7 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, qihoo.triplecleangame.protos.PBFriendList);

		[ArrayElementType("qihoo.triplecleangame.protos.PBFriendList")]
		public var requestAddList:Array = [];

		public static const DAYRECEIVEDLIST:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("qihoo.triplecleangame.protos.CMsgGetFriendListResponse.dayReceivedList", "dayReceivedList", (8 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, qihoo.triplecleangame.protos.PBRequestInfo);

		[ArrayElementType("qihoo.triplecleangame.protos.PBRequestInfo")]
		public var dayReceivedList:Array = [];

		public static const DAYSENDLIST:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("qihoo.triplecleangame.protos.CMsgGetFriendListResponse.daySendList", "daySendList", (9 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, qihoo.triplecleangame.protos.PBFriendList);

		[ArrayElementType("qihoo.triplecleangame.protos.PBFriendList")]
		public var daySendList:Array = [];

		public static const DAYREQUESTINFOLIST:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("qihoo.triplecleangame.protos.CMsgGetFriendListResponse.dayRequestInfoList", "dayRequestInfoList", (10 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, qihoo.triplecleangame.protos.PBRequestInfo);

		[ArrayElementType("qihoo.triplecleangame.protos.PBRequestInfo")]
		public var dayRequestInfoList:Array = [];

		public static const DAYGETCOUNT:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("qihoo.triplecleangame.protos.CMsgGetFriendListResponse.dayGetCount", "dayGetCount", (11 << 3) | com.netease.protobuf.WireType.VARINT);

		private var dayGetCount$field:int;

		public function clearDayGetCount():void {
			hasField$0 &= 0xfffffffd;
			dayGetCount$field = new int();
		}

		public function get hasDayGetCount():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set dayGetCount(value:int):void {
			hasField$0 |= 0x2;
			dayGetCount$field = value;
		}

		public function get dayGetCount():int {
			return dayGetCount$field;
		}

		public static const DAYSENDCOUNT:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("qihoo.triplecleangame.protos.CMsgGetFriendListResponse.daySendCount", "daySendCount", (12 << 3) | com.netease.protobuf.WireType.VARINT);

		private var daySendCount$field:int;

		public function clearDaySendCount():void {
			hasField$0 &= 0xfffffffb;
			daySendCount$field = new int();
		}

		public function get hasDaySendCount():Boolean {
			return (hasField$0 & 0x4) != 0;
		}

		public function set daySendCount(value:int):void {
			hasField$0 |= 0x4;
			daySendCount$field = value;
		}

		public function get daySendCount():int {
			return daySendCount$field;
		}

		/**
		 *  @private
		 */
		override public final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			if (hasUserQID) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT64(output, userQID$field);
			}
			if (hasResult) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, result$field);
			}
			if (hasInviteQID) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT64(output, inviteQID$field);
			}
			for (var friendList$index:uint = 0; friendList$index < this.friendList.length; ++friendList$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 4);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.friendList[friendList$index]);
			}
			for (var inviteList$index:uint = 0; inviteList$index < this.inviteList.length; ++inviteList$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 5);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.inviteList[inviteList$index]);
			}
			for (var invitedList$index:uint = 0; invitedList$index < this.invitedList.length; ++invitedList$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 6);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.invitedList[invitedList$index]);
			}
			for (var requestAddList$index:uint = 0; requestAddList$index < this.requestAddList.length; ++requestAddList$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 7);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.requestAddList[requestAddList$index]);
			}
			for (var dayReceivedList$index:uint = 0; dayReceivedList$index < this.dayReceivedList.length; ++dayReceivedList$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 8);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.dayReceivedList[dayReceivedList$index]);
			}
			for (var daySendList$index:uint = 0; daySendList$index < this.daySendList.length; ++daySendList$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 9);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.daySendList[daySendList$index]);
			}
			for (var dayRequestInfoList$index:uint = 0; dayRequestInfoList$index < this.dayRequestInfoList.length; ++dayRequestInfoList$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 10);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.dayRequestInfoList[dayRequestInfoList$index]);
			}
			if (hasDayGetCount) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 11);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, dayGetCount$field);
			}
			if (hasDaySendCount) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 12);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, daySendCount$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var userQID$count:uint = 0;
			var result$count:uint = 0;
			var inviteQID$count:uint = 0;
			var dayGetCount$count:uint = 0;
			var daySendCount$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (userQID$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgGetFriendListResponse.userQID cannot be set twice.');
					}
					++userQID$count;
					this.userQID = com.netease.protobuf.ReadUtils.read$TYPE_UINT64(input);
					break;
				case 2:
					if (result$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgGetFriendListResponse.result cannot be set twice.');
					}
					++result$count;
					this.result = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 3:
					if (inviteQID$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgGetFriendListResponse.inviteQID cannot be set twice.');
					}
					++inviteQID$count;
					this.inviteQID = com.netease.protobuf.ReadUtils.read$TYPE_UINT64(input);
					break;
				case 4:
					this.friendList.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new qihoo.triplecleangame.protos.PBFriendList()));
					break;
				case 5:
					this.inviteList.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new qihoo.triplecleangame.protos.PBInviteInfo()));
					break;
				case 6:
					this.invitedList.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new qihoo.triplecleangame.protos.PBFriendList()));
					break;
				case 7:
					this.requestAddList.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new qihoo.triplecleangame.protos.PBFriendList()));
					break;
				case 8:
					this.dayReceivedList.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new qihoo.triplecleangame.protos.PBRequestInfo()));
					break;
				case 9:
					this.daySendList.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new qihoo.triplecleangame.protos.PBFriendList()));
					break;
				case 10:
					this.dayRequestInfoList.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new qihoo.triplecleangame.protos.PBRequestInfo()));
					break;
				case 11:
					if (dayGetCount$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgGetFriendListResponse.dayGetCount cannot be set twice.');
					}
					++dayGetCount$count;
					this.dayGetCount = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 12:
					if (daySendCount$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgGetFriendListResponse.daySendCount cannot be set twice.');
					}
					++daySendCount$count;
					this.daySendCount = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
