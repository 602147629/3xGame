package qihoo.triplecleangame.protos {
	import com.netease.protobuf.*;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import qihoo.triplecleangame.protos.PBStarArray;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class CMsgGetUserInfoResponse extends com.netease.protobuf.Message {
		public static const RESULT:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("qihoo.triplecleangame.protos.CMsgGetUserInfoResponse.result", "result", (1 << 3) | com.netease.protobuf.WireType.VARINT);

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

		public static const CURLEVEL:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("qihoo.triplecleangame.protos.CMsgGetUserInfoResponse.curLevel", "curLevel", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		private var curLevel$field:int;

		public function clearCurLevel():void {
			hasField$0 &= 0xfffffffd;
			curLevel$field = new int();
		}

		public function get hasCurLevel():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set curLevel(value:int):void {
			hasField$0 |= 0x2;
			curLevel$field = value;
		}

		public function get curLevel():int {
			return curLevel$field;
		}

		public static const CURTIMES:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("qihoo.triplecleangame.protos.CMsgGetUserInfoResponse.curTimes", "curTimes", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		private var curTimes$field:int;

		public function clearCurTimes():void {
			hasField$0 &= 0xfffffffb;
			curTimes$field = new int();
		}

		public function get hasCurTimes():Boolean {
			return (hasField$0 & 0x4) != 0;
		}

		public function set curTimes(value:int):void {
			hasField$0 |= 0x4;
			curTimes$field = value;
		}

		public function get curTimes():int {
			return curTimes$field;
		}

		public static const CURENERGY:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("qihoo.triplecleangame.protos.CMsgGetUserInfoResponse.curEnergy", "curEnergy", (4 << 3) | com.netease.protobuf.WireType.VARINT);

		private var curEnergy$field:int;

		public function clearCurEnergy():void {
			hasField$0 &= 0xfffffff7;
			curEnergy$field = new int();
		}

		public function get hasCurEnergy():Boolean {
			return (hasField$0 & 0x8) != 0;
		}

		public function set curEnergy(value:int):void {
			hasField$0 |= 0x8;
			curEnergy$field = value;
		}

		public function get curEnergy():int {
			return curEnergy$field;
		}

		public static const MAXENERGY:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("qihoo.triplecleangame.protos.CMsgGetUserInfoResponse.maxEnergy", "maxEnergy", (5 << 3) | com.netease.protobuf.WireType.VARINT);

		private var maxEnergy$field:int;

		public function clearMaxEnergy():void {
			hasField$0 &= 0xffffffef;
			maxEnergy$field = new int();
		}

		public function get hasMaxEnergy():Boolean {
			return (hasField$0 & 0x10) != 0;
		}

		public function set maxEnergy(value:int):void {
			hasField$0 |= 0x10;
			maxEnergy$field = value;
		}

		public function get maxEnergy():int {
			return maxEnergy$field;
		}

		public static const CUREXP:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("qihoo.triplecleangame.protos.CMsgGetUserInfoResponse.curExp", "curExp", (6 << 3) | com.netease.protobuf.WireType.VARINT);

		private var curExp$field:int;

		public function clearCurExp():void {
			hasField$0 &= 0xffffffdf;
			curExp$field = new int();
		}

		public function get hasCurExp():Boolean {
			return (hasField$0 & 0x20) != 0;
		}

		public function set curExp(value:int):void {
			hasField$0 |= 0x20;
			curExp$field = value;
		}

		public function get curExp():int {
			return curExp$field;
		}

		public static const TOTALEXP:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("qihoo.triplecleangame.protos.CMsgGetUserInfoResponse.totalExp", "totalExp", (7 << 3) | com.netease.protobuf.WireType.VARINT);

		private var totalExp$field:int;

		public function clearTotalExp():void {
			hasField$0 &= 0xffffffbf;
			totalExp$field = new int();
		}

		public function get hasTotalExp():Boolean {
			return (hasField$0 & 0x40) != 0;
		}

		public function set totalExp(value:int):void {
			hasField$0 |= 0x40;
			totalExp$field = value;
		}

		public function get totalExp():int {
			return totalExp$field;
		}

		public static const TOTALSTAR:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("qihoo.triplecleangame.protos.CMsgGetUserInfoResponse.totalStar", "totalStar", (8 << 3) | com.netease.protobuf.WireType.VARINT);

		private var totalStar$field:int;

		public function clearTotalStar():void {
			hasField$0 &= 0xffffff7f;
			totalStar$field = new int();
		}

		public function get hasTotalStar():Boolean {
			return (hasField$0 & 0x80) != 0;
		}

		public function set totalStar(value:int):void {
			hasField$0 |= 0x80;
			totalStar$field = value;
		}

		public function get totalStar():int {
			return totalStar$field;
		}

		public static const COIN:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("qihoo.triplecleangame.protos.CMsgGetUserInfoResponse.coin", "coin", (9 << 3) | com.netease.protobuf.WireType.VARINT);

		private var coin$field:int;

		public function clearCoin():void {
			hasField$0 &= 0xfffffeff;
			coin$field = new int();
		}

		public function get hasCoin():Boolean {
			return (hasField$0 & 0x100) != 0;
		}

		public function set coin(value:int):void {
			hasField$0 |= 0x100;
			coin$field = value;
		}

		public function get coin():int {
			return coin$field;
		}

		public static const SEATID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("qihoo.triplecleangame.protos.CMsgGetUserInfoResponse.seatID", "seatID", (10 << 3) | com.netease.protobuf.WireType.VARINT);

		private var seatID$field:int;

		public function clearSeatID():void {
			hasField$0 &= 0xfffffdff;
			seatID$field = new int();
		}

		public function get hasSeatID():Boolean {
			return (hasField$0 & 0x200) != 0;
		}

		public function set seatID(value:int):void {
			hasField$0 |= 0x200;
			seatID$field = value;
		}

		public function get seatID():int {
			return seatID$field;
		}

		public static const LEVELGROUP:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("qihoo.triplecleangame.protos.CMsgGetUserInfoResponse.levelGroup", "levelGroup", (11 << 3) | com.netease.protobuf.WireType.VARINT);

		private var levelGroup$field:int;

		public function clearLevelGroup():void {
			hasField$0 &= 0xfffffbff;
			levelGroup$field = new int();
		}

		public function get hasLevelGroup():Boolean {
			return (hasField$0 & 0x400) != 0;
		}

		public function set levelGroup(value:int):void {
			hasField$0 |= 0x400;
			levelGroup$field = value;
		}

		public function get levelGroup():int {
			return levelGroup$field;
		}

		public static const MAXLEVEL:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("qihoo.triplecleangame.protos.CMsgGetUserInfoResponse.maxLevel", "maxLevel", (12 << 3) | com.netease.protobuf.WireType.VARINT);

		private var maxLevel$field:int;

		public function clearMaxLevel():void {
			hasField$0 &= 0xfffff7ff;
			maxLevel$field = new int();
		}

		public function get hasMaxLevel():Boolean {
			return (hasField$0 & 0x800) != 0;
		}

		public function set maxLevel(value:int):void {
			hasField$0 |= 0x800;
			maxLevel$field = value;
		}

		public function get maxLevel():int {
			return maxLevel$field;
		}

		public static const ISLOGIN:FieldDescriptor$TYPE_BOOL = new FieldDescriptor$TYPE_BOOL("qihoo.triplecleangame.protos.CMsgGetUserInfoResponse.isLogin", "isLogin", (13 << 3) | com.netease.protobuf.WireType.VARINT);

		private var isLogin$field:Boolean;

		public function clearIsLogin():void {
			hasField$0 &= 0xffffefff;
			isLogin$field = new Boolean();
		}

		public function get hasIsLogin():Boolean {
			return (hasField$0 & 0x1000) != 0;
		}

		public function set isLogin(value:Boolean):void {
			hasField$0 |= 0x1000;
			isLogin$field = value;
		}

		public function get isLogin():Boolean {
			return isLogin$field;
		}

		public static const STARREWARDLEVEL:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("qihoo.triplecleangame.protos.CMsgGetUserInfoResponse.starRewardLevel", "starRewardLevel", (14 << 3) | com.netease.protobuf.WireType.VARINT);

		private var starRewardLevel$field:int;

		public function clearStarRewardLevel():void {
			hasField$0 &= 0xffffdfff;
			starRewardLevel$field = new int();
		}

		public function get hasStarRewardLevel():Boolean {
			return (hasField$0 & 0x2000) != 0;
		}

		public function set starRewardLevel(value:int):void {
			hasField$0 |= 0x2000;
			starRewardLevel$field = value;
		}

		public function get starRewardLevel():int {
			return starRewardLevel$field;
		}

		public static const STARINFO:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("qihoo.triplecleangame.protos.CMsgGetUserInfoResponse.starInfo", "starInfo", (15 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, qihoo.triplecleangame.protos.PBStarArray);

		[ArrayElementType("qihoo.triplecleangame.protos.PBStarArray")]
		public var starInfo:Array = [];

		/**
		 *  @private
		 */
		override public final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			if (hasResult) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, result$field);
			}
			if (hasCurLevel) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, curLevel$field);
			}
			if (hasCurTimes) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, curTimes$field);
			}
			if (hasCurEnergy) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 4);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, curEnergy$field);
			}
			if (hasMaxEnergy) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 5);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, maxEnergy$field);
			}
			if (hasCurExp) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 6);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, curExp$field);
			}
			if (hasTotalExp) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 7);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, totalExp$field);
			}
			if (hasTotalStar) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 8);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, totalStar$field);
			}
			if (hasCoin) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 9);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, coin$field);
			}
			if (hasSeatID) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 10);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, seatID$field);
			}
			if (hasLevelGroup) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 11);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, levelGroup$field);
			}
			if (hasMaxLevel) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 12);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, maxLevel$field);
			}
			if (hasIsLogin) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 13);
				com.netease.protobuf.WriteUtils.write$TYPE_BOOL(output, isLogin$field);
			}
			if (hasStarRewardLevel) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 14);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, starRewardLevel$field);
			}
			for (var starInfo$index:uint = 0; starInfo$index < this.starInfo.length; ++starInfo$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 15);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.starInfo[starInfo$index]);
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
			var curLevel$count:uint = 0;
			var curTimes$count:uint = 0;
			var curEnergy$count:uint = 0;
			var maxEnergy$count:uint = 0;
			var curExp$count:uint = 0;
			var totalExp$count:uint = 0;
			var totalStar$count:uint = 0;
			var coin$count:uint = 0;
			var seatID$count:uint = 0;
			var levelGroup$count:uint = 0;
			var maxLevel$count:uint = 0;
			var isLogin$count:uint = 0;
			var starRewardLevel$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (result$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgGetUserInfoResponse.result cannot be set twice.');
					}
					++result$count;
					this.result = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (curLevel$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgGetUserInfoResponse.curLevel cannot be set twice.');
					}
					++curLevel$count;
					this.curLevel = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 3:
					if (curTimes$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgGetUserInfoResponse.curTimes cannot be set twice.');
					}
					++curTimes$count;
					this.curTimes = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 4:
					if (curEnergy$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgGetUserInfoResponse.curEnergy cannot be set twice.');
					}
					++curEnergy$count;
					this.curEnergy = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 5:
					if (maxEnergy$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgGetUserInfoResponse.maxEnergy cannot be set twice.');
					}
					++maxEnergy$count;
					this.maxEnergy = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 6:
					if (curExp$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgGetUserInfoResponse.curExp cannot be set twice.');
					}
					++curExp$count;
					this.curExp = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 7:
					if (totalExp$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgGetUserInfoResponse.totalExp cannot be set twice.');
					}
					++totalExp$count;
					this.totalExp = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 8:
					if (totalStar$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgGetUserInfoResponse.totalStar cannot be set twice.');
					}
					++totalStar$count;
					this.totalStar = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 9:
					if (coin$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgGetUserInfoResponse.coin cannot be set twice.');
					}
					++coin$count;
					this.coin = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 10:
					if (seatID$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgGetUserInfoResponse.seatID cannot be set twice.');
					}
					++seatID$count;
					this.seatID = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 11:
					if (levelGroup$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgGetUserInfoResponse.levelGroup cannot be set twice.');
					}
					++levelGroup$count;
					this.levelGroup = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 12:
					if (maxLevel$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgGetUserInfoResponse.maxLevel cannot be set twice.');
					}
					++maxLevel$count;
					this.maxLevel = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 13:
					if (isLogin$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgGetUserInfoResponse.isLogin cannot be set twice.');
					}
					++isLogin$count;
					this.isLogin = com.netease.protobuf.ReadUtils.read$TYPE_BOOL(input);
					break;
				case 14:
					if (starRewardLevel$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgGetUserInfoResponse.starRewardLevel cannot be set twice.');
					}
					++starRewardLevel$count;
					this.starRewardLevel = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 15:
					this.starInfo.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new qihoo.triplecleangame.protos.PBStarArray()));
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
