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
	public dynamic final class CMsgGetNameImageRequest extends com.netease.protobuf.Message {
		public static const FRIENDLIST:FieldDescriptor$TYPE_UINT64 = new FieldDescriptor$TYPE_UINT64("qihoo.triplecleangame.protos.CMsgGetNameImageRequest.friendList", "friendList", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		private var friendList$field:UInt64;

		public function clearFriendList():void {
			friendList$field = null;
		}

		public function get hasFriendList():Boolean {
			return friendList$field != null;
		}

		public function set friendList(value:UInt64):void {
			friendList$field = value;
		}

		public function get friendList():UInt64 {
			return friendList$field;
		}

		/**
		 *  @private
		 */
		override public final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			if (hasFriendList) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT64(output, friendList$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var friendList$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 2:
					if (friendList$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgGetNameImageRequest.friendList cannot be set twice.');
					}
					++friendList$count;
					this.friendList = com.netease.protobuf.ReadUtils.read$TYPE_UINT64(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
