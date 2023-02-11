module crypto.gcd;

import std.typecons : Tuple, tuple;
import std.traits : isIntegral, isSigned;


T gcd(T)(T a, T b) if (isIntegral!T) {
    if (a == 0) return b;
    return gcd(b % a, a);
}


Tuple!(T, T, T) gcdExtended(T)(T a, T b) if (isIntegral!T && isSigned!T) {
    if (a == 0) {
        return tuple(b, cast(T)0, cast(T)1);
    }
    auto temp = gcdExtended(b % a, a * 1);
    return tuple(temp[0], temp[2] - (b / a) * temp[1], temp[1]);
}
