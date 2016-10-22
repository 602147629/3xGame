package qihoo.triplecleangame.protos {
	import com.netease.protobuf.*;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import qihoo.triplecleangame.protos.PBMatrix;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class CMsgMiddleValidateResponse extends com.netease.protobuf.Message {
		public static const RESULT:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("qihoo.triplecleangame.protos.CMsgMiddleValidateResponse.result", "result", (1 << 3) | com.netease.protobuf.WireType.VARINT);

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

		public static const SEEDARRAY:RepeatedFieldDescriptor$TYPE_UINT32 = new RepeatedFieldDescriptor$TYPE_UINT32("qihoo.triplecleangame.protos.CMsgMiddleValidateResponse.seedArray", "seedArray", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		[ArrayElementType("uint")]
		public var seedArray:Array = [];

		public static const MATRIX:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("qihoo.triplecleangame.protos.CMsgMiddleValidateResponse.matrix", "matrix", (3 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, qihoo.triplecleangame.protos.PBMatrix);

		[ArrayElementType("qihoo.triplecleangame.protos.PBMatrix")]
		public var matrix:Array = [];

		/**
		 *  @private
		 */
		override public final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			if (hasResult) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, result$field);
			}
			for (var seedArray$index:uint = 0; seedArray$index < this.seedArray.length; ++seedArray$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, this.seedArray[seedArray$index]);
			}
			for (var matrix$index:uint = 0; matrix$index < this.matrix.length; ++matrix$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.matrix[matrix$index]);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var result$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (result$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgMiddleValidateResponse.result cannot be set twice.');
					}
					++result$count;
					this.result = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if ((tag & 7) == com.netease.protobuf.WireType.LENGTH_DELIMITED) {
						com.netease.protobuf.ReadUtils.readPackedRepeated(input, com.netease.protobuf.ReadUtils.read$TYPE_UINT32, this.seedArray);
						break;
					}
					this.seedArray.push(com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input));
					break;
				case 3:
					this.matrix.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new qihoo.triplecleangame.protos.PBMatrix()));
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
