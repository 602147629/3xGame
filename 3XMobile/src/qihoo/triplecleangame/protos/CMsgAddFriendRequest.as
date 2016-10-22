package qihoo.triplecleangame.protos {
	import com.netease.protobuf.*;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class CMsgAddFriendRequest extends com.netease.protobuf.Message {
		public static const USERQID:FieldDescriptor$TYPE_UINT64 = new FieldDescriptor$TYPE_UINT64("qihoo.triplecleangame.protos.CMsgAddFriendRequest.userQID", "userQID", (1 << 3) | com.netease.protobuf.WireType.VARINT);

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

		public static const FRIENDQID:FieldDescriptor$TYPE_UINT64 = new FieldDescriptor$TYPE_UINT64("qihoo.triplecleangame.protos.CMsgAddFriendRequest.friendQID", "friendQID", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		private var friendQID$field:UInt64;

		public function clearFriendQID():void {
			friendQID$field = null;
		}

		public function get hasFriendQID():Boolean {
			return friendQID$field != null;
		}

		public function set friendQID(value:UInt64):void {
			friendQID$field = value;
		}

		public function get friendQID():UInt64 {
			return friendQID$field;
		}

		/**
		 *  @private
		 */
		override public final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			if (hasUserQID) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT64(output, userQID$field);
			}
			if (hasFriendQID) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT64(output, friendQID$field);
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
			var friendQID$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (userQID$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgAddFriendRequest.userQID cannot be set twice.');
					}
					++userQID$count;
					this.userQID = com.netease.protobuf.ReadUtils.read$TYPE_UINT64(input);
					break;
				case 2:
					if (friendQID$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgAddFriendRequest.friendQID cannot be set twice.');
					}
					++friendQID$count;
					this.friendQID = com.netease.protobuf.ReadUtils.read$TYPE_UINT64(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
