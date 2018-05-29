using Lambda;

class Utils {

  public static function average<T:Float>(nums:Array<T>):Float {
    return nums.fold(function(n, t) return n + t, 0) / nums.length;
  }

  public static function sdev<T:Float>(nums:Array<T>):Float {
    var store = [];
    var avg = average(nums);
    for (n in nums) {
      store.push((n - avg) * (n - avg));
    }
    return Math.sqrt(average(store));
  }

  public static function median<T:Float>(nums:Array<T>):Float {
    nums.sort(function(x, y) {return (x == y) ? 0 : Std.int(x - y);});
    if(nums.length % 2 == 0) {
      return average([nums[Math.floor(nums.length / 2)], nums[Math.ceil(nums.length / 2)]]);
    } else {
      return nums[Std.int(nums.length / 2)];
    }
  }
}
