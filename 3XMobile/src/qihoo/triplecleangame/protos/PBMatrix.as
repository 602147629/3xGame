package qihoo.triplecleangame.protos {
	import com.netease.protobuf.*;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import qihoo.triplecleangame.protos.PBBaseObj;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class PBMatrix extends com.netease.protobuf.Message {
		public static const X:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("qihoo.triplecleangame.protos.PBMatrix.x", "x", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		private var x$field:int;

		private var hasField$0:uint = 0;

		public function clearX():void {
			hasField$0 &= 0xfffffffe;
			x$field = new int();
		}

		public function get hasX():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set x(value:int):void {
			hasField$0 |= 0x1;
			x$field = value;
		}

		public function get x():int {
			return x$field;
		}

		public static const Y:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("qihoo.triplecleangame.protos.PBMatrix.y", "y", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		private var y$field:int;

		public function clearY():void {
			hasField$0 &= 0xfffffffd;
			y$field = new int();
		}

		public function get hasY():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set y(value:int):void {
			hasField$0 |= 0x2;
			y$field = value;
		}

		public function get y():int {
			return y$field;
		}

		public static const BASEOBJ:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("qihoo.triplecleangame.protos.PBMatrix.baseObj", "baseObj", (3 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, qihoo.triplecleangame.protos.PBBaseObj);

		[ArrayElementType("qihoo.triplecleangame.protos.PBBaseObj")]
		public var baseObj:Array = [];

		/**
		 *  @private
		 */
		override public final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			if (hasX) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, x$field);
			}
			if (hasY) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, y$field);
			}
			for (var baseObj$index:uint = 0; baseObj$index < this.baseObj.length; ++baseObj$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.baseObj[baseObj$index]);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var x$count:uint = 0;
			var y$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (x$count != 0) {
						throw new flash.errors.IOError('Bad data format: PBMatrix.x cannot be set twice.');
					}
					++x$count;
					this.x = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (y$count != 0) {
						throw new flash.errors.IOError('Bad data format: PBMatrix.y cannot be set twice.');
					}
					++y$count;
					this.y = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 3:
					this.baseObj.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new qihoo.triplecleangame.protos.PBBaseObj()));
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
