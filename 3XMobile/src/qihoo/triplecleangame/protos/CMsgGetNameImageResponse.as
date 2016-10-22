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
	public dynamic final class CMsgGetNameImageResponse extends com.netease.protobuf.Message {
		public static const NAME:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("qihoo.triplecleangame.protos.CMsgGetNameImageResponse.name", "name", (1 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		private var name$field:String;

		public function clearName():void {
			name$field = null;
		}

		public function get hasName():Boolean {
			return name$field != null;
		}

		public function set name(value:String):void {
			name$field = value;
		}

		public function get name():String {
			return name$field;
		}

		public static const IMAGE20:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("qihoo.triplecleangame.protos.CMsgGetNameImageResponse.image20", "image20", (2 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		private var image20$field:String;

		public function clearImage20():void {
			image20$field = null;
		}

		public function get hasImage20():Boolean {
			return image20$field != null;
		}

		public function set image20(value:String):void {
			image20$field = value;
		}

		public function get image20():String {
			return image20$field;
		}

		public static const IMAGE48:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("qihoo.triplecleangame.protos.CMsgGetNameImageResponse.image48", "image48", (3 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		private var image48$field:String;

		public function clearImage48():void {
			image48$field = null;
		}

		public function get hasImage48():Boolean {
			return image48$field != null;
		}

		public function set image48(value:String):void {
			image48$field = value;
		}

		public function get image48():String {
			return image48$field;
		}

		public static const IMAGE80:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("qihoo.triplecleangame.protos.CMsgGetNameImageResponse.image80", "image80", (4 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		private var image80$field:String;

		public function clearImage80():void {
			image80$field = null;
		}

		public function get hasImage80():Boolean {
			return image80$field != null;
		}

		public function set image80(value:String):void {
			image80$field = value;
		}

		public function get image80():String {
			return image80$field;
		}

		public static const IMAGE150:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("qihoo.triplecleangame.protos.CMsgGetNameImageResponse.image150", "image150", (5 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		private var image150$field:String;

		public function clearImage150():void {
			image150$field = null;
		}

		public function get hasImage150():Boolean {
			return image150$field != null;
		}

		public function set image150(value:String):void {
			image150$field = value;
		}

		public function get image150():String {
			return image150$field;
		}

		public static const USERQID:FieldDescriptor$TYPE_UINT64 = new FieldDescriptor$TYPE_UINT64("qihoo.triplecleangame.protos.CMsgGetNameImageResponse.userQID", "userQID", (6 << 3) | com.netease.protobuf.WireType.VARINT);

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

		/**
		 *  @private
		 */
		override public final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			if (hasName) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 1);
				com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, name$field);
			}
			if (hasImage20) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, image20$field);
			}
			if (hasImage48) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, image48$field);
			}
			if (hasImage80) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 4);
				com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, image80$field);
			}
			if (hasImage150) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 5);
				com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, image150$field);
			}
			if (hasUserQID) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 6);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT64(output, userQID$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var name$count:uint = 0;
			var image20$count:uint = 0;
			var image48$count:uint = 0;
			var image80$count:uint = 0;
			var image150$count:uint = 0;
			var userQID$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (name$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgGetNameImageResponse.name cannot be set twice.');
					}
					++name$count;
					this.name = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 2:
					if (image20$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgGetNameImageResponse.image20 cannot be set twice.');
					}
					++image20$count;
					this.image20 = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 3:
					if (image48$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgGetNameImageResponse.image48 cannot be set twice.');
					}
					++image48$count;
					this.image48 = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 4:
					if (image80$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgGetNameImageResponse.image80 cannot be set twice.');
					}
					++image80$count;
					this.image80 = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 5:
					if (image150$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgGetNameImageResponse.image150 cannot be set twice.');
					}
					++image150$count;
					this.image150 = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 6:
					if (userQID$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgGetNameImageResponse.userQID cannot be set twice.');
					}
					++userQID$count;
					this.userQID = com.netease.protobuf.ReadUtils.read$TYPE_UINT64(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
