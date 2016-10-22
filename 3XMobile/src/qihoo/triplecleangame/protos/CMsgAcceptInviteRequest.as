package qihoo.triplecleangame.protos {
	import com.netease.protobuf.*;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import qihoo.triplecleangame.protos.PBFriendList;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class CMsgAcceptInviteRequest extends com.netease.protobuf.Message {
		public static const USERQID:FieldDescriptor$TYPE_UINT64 = new FieldDescriptor$TYPE_UINT64("qihoo.triplecleangame.protos.CMsgAcceptInviteRequest.userQID", "userQID", (1 << 3) | com.netease.protobuf.WireType.VARINT);

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

		public static const FRIENDLIST:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("qihoo.triplecleangame.protos.CMsgAcceptInviteRequest.friendList", "friendList", (2 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, qihoo.triplecleangame.protos.PBFriendList);

		[ArrayElementType("qihoo.triplecleangame.protos.PBFriendList")]
		public var friendList:Array = [];

		/**
		 *  @private
		 */
		override public final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			if (hasUserQID) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT64(output, userQID$field);
			}
			for (var friendList$index:uint = 0; friendList$index < this.friendList.length; ++friendList$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.friendList[friendList$index]);
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
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (userQID$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgAcceptInviteRequest.userQID cannot be set twice.');
					}
					++userQID$count;
					this.userQID = com.netease.protobuf.ReadUtils.read$TYPE_UINT64(input);
					break;
				case 2:
					this.friendList.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new qihoo.triplecleangame.protos.PBFriendList()));
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
