module crypto.gcd;

import std.typecons : Tuple, tuple;
import std.traits : isIntegral;


T gcd(T)(T a, T b) if (isIntegral!T) {
    if (b == 0) return a;
    return gcd(b, a % b);
}


Tuple!(T, T, T) gcdExtended(T)(T a, T b) if (isIntegral!T) {
    if (a == 0) {
        return tuple(b, cast(T)0, cast(T)1);
    }
    auto temp = gcdExtended(b % a, a);
    return tuple(temp[0], temp[2] - (b / a) * temp[1], temp[1]);
}
